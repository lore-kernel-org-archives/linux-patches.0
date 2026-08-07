Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44C847D452;
	Fri,  7 Aug 2026 15:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117399; cv=none; b=M1jmdGAYvqM2UoyFgmVEJw9FnlCzWo2EiDoVmFTr35jp7sM9/WTEuEWy3XCGAIRq5VddQJ/WcYQr8H48A1nxByDsdqbz7385VskQ7+bPF3Ld44GEo6CSRKBmxKj3FjnTQmJl+OocY3s0FOPLU3GEuKBV/wwL7L3aco72YHjiNsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117399; c=relaxed/simple;
	bh=7979kYr1ELifGVbrj7NsNcXvgXx+uOnqJ+dZqSddeiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoCDS+RXcHQY1hv85KiZ62w6YBiJLIhFPPn8cqCQ6Iqha4/YIFj65v7qszH2SWIUSRgWyOjGo1L2cLmGxM5xLlXv2PQEneISQ1tFv2w3a/FTPSTy3M3P1wIc8HDqj+FTTWN4FHYaH6malJlGxtA2KL+pNurT2j51cZALFDY6ml8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QssjA22g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QssjA22g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1671E1F000E9;
	Fri,  7 Aug 2026 15:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117398;
	bh=UPAqNqlo9qUpuN7Vzliuq2mABYx5l3noncyo5pKHQCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QssjA22g8N3LMonrDGvmbOMIJJ/0dC6BEYg2fhb/T8Xno/CS0X1BPJMPyErM6gD1P
	 HDl2Y3uqjsavXzyQcmFAA9BrfK9E6nxo8IzMKulnmosdVmQU7cDR671m+Nr1sp7pr1
	 ije24vIUvpoNbs/G8Ict6uqtkd4C8472vMsz8F0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 7.1 303/438] um: vector: fix use-after-free in vector_mmsg_rx()
Date: Fri,  7 Aug 2026 16:38:19 +0200
Message-ID: <20260807143434.431566839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit af421e9aed3920c7ac88c24daa48606c7112feca upstream.

When vector_mmsg_rx() discards a packet whose overlay header fails
verify_header(), it frees the skb and continues the loop:

	if (header_check < 0) {
		dev_kfree_skb_irq(skb);
		vp->estats.rx_encaps_errors++;
		continue;
	}

The normal and short-packet paths fall through to the bottom of the
loop body, which clears the consumed slot and advances the cursors:

	(*skbuff_vector) = NULL;
	mmsg_vector++;
	skbuff_vector++;

The verify_header() < 0 path skips that via continue, so the freed skb
is left in skbuff_vector[] and the cursors do not advance. The next
iteration reads the same slot, gets the freed skb, and frees it again,
producing a refcount underflow / use-after-free in the RX path.

Discard the slot the same way the other paths do before continuing.

Only transports whose verify_header() can return negative are affected:
GRE and L2TPv3 do so on a cookie/session-id mismatch (raw/tap do not),
so any peer on such a transport can trigger it without authentication.

Fixes: 49da7e64f33e ("High Performance UML Vector Network Driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/drivers/vector_kern.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -995,6 +995,9 @@ static int vector_mmsg_rx(struct vector_
 				 */
 					dev_kfree_skb_irq(skb);
 					vp->estats.rx_encaps_errors++;
+					(*skbuff_vector) = NULL;
+					mmsg_vector++;
+					skbuff_vector++;
 					continue;
 				}
 				if (header_check > 0) {


