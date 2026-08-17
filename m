Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E760442FC0;
	Mon, 17 Aug 2026 15:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979991; cv=none; b=a/E06+9z28B8Sbl6AKdTLZZakUkobwKj/yf3La7pK0Ly8uJRdlJSag1K/DFlNQBtY7VYDOdpUdC+KK/VXFUxjdq0WjVUWyaLJIzEjRSPH7bYuOKWYx7RVSAyy8Uwwo68Slx86Qhd15fY9TWykglNGsP+XEkxEVWmZFm7O1KSyyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979991; c=relaxed/simple;
	bh=69R/iWUOhXMA4OMWVOrxQnKMFtju7WoIxH+WeLS3sPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxEQZxL3fKQhWBWYA/Sff7DOA1EWkjpN/L29qhmLOIcvikTacLGWds2IdPJoPumAbdOU2bY3b5amS942g6wRmuuLWQTY7GA0zgDUSTCCS/mgyD0rWfqFgY4jsgUx4g/o+eFx5P129V/lNFRve6lWI2NXzd98zfFv8XV/u9TqSQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNJfU3p5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNJfU3p5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0F01F00A3A;
	Mon, 17 Aug 2026 15:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979988;
	bh=PfsJsXI0OMxV5/IPQ5197bdX0SDEvGb9VaLenRQ1PVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNJfU3p5bVtlbFK5E788BjvBLAZ21ODSsCAwSLsq/217GsusFrSO9urmaF4yQKd4T
	 6SP9UKNL5ylIp1y8/m2GLzPblEEo9lmej5J6OBsF10x2Ff1kUXTE44yLy9UUxglDKa
	 aQXpnJgUQsVIIngOHTrROAaYsKu6Mqj9AxZkHViM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.1 418/609] um: vector: fix use-after-free in vector_mmsg_rx()
Date: Mon, 17 Aug 2026 15:31:54 +0200
Message-ID: <20260817132558.113629997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1007,6 +1007,9 @@ static int vector_mmsg_rx(struct vector_
 				 */
 					dev_kfree_skb_irq(skb);
 					vp->estats.rx_encaps_errors++;
+					(*skbuff_vector) = NULL;
+					mmsg_vector++;
+					skbuff_vector++;
 					continue;
 				}
 				if (header_check > 0) {


