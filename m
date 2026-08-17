Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA15431E6D;
	Mon, 17 Aug 2026 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976143; cv=none; b=gNC5K6Mw60Jw2GU1TKjldLDu/PAflIoUPu/g7jxzOdle240dAgIdJnD1Ivw5fmfHQjQft5uhmy/Qc2mEObZ6eI4Qifup5j3nbRioCLuw4J+ZIX53h3F7R6m5Kbl2AYgOo89EXdLA1+k1Rh5qmsW924hOFT6O7Qw5cN1lMY50OWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976143; c=relaxed/simple;
	bh=XspQxSQtwYr4t3bEWPYl8ZtclQdUwmTjX20G1Owgff8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBM8ULL8I2NKwP/VL/nZEP6TK+ERDy6rMvp+oc0MDeGlfg2ORjnnIm5Rs18myPOcQOS+jaQcvUkmwYiPsvQY1PAyDvUe7RgAlRE/ZP6vbg0EQQeDVR9zZelKA9Q3HDih9cp/Cdo/wOgbBXMksEz9QcL5KaoVJb/85/xpyjRstyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlfqqUQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlfqqUQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164651F000E9;
	Mon, 17 Aug 2026 14:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976141;
	bh=AizbD6JxdjmdvsxCXXmDUXmhC6GRevgt+hEcnwXiPnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WlfqqUQwIl2MWG46IEkJNTKY1nzB+uoV42jklUZay5LYB2UkQyKzIRQqp5+dOXNTp
	 eEx/4Ks8FIPbOwiWclfo47t6C+yg5caaTKiCAdJFoJzJlmnznRZj0L2/3+GR9NxFNa
	 p6o2BkypohHhxtEaHIaAnTGvCl7B7/Zjo6xYvRis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.10 270/389] um: vector: fix use-after-free in vector_mmsg_rx()
Date: Mon, 17 Aug 2026 15:31:49 +0200
Message-ID: <20260817132549.702474895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1008,6 +1008,9 @@ static int vector_mmsg_rx(struct vector_
 				 */
 					dev_kfree_skb_irq(skb);
 					vp->estats.rx_encaps_errors++;
+					(*skbuff_vector) = NULL;
+					mmsg_vector++;
+					skbuff_vector++;
 					continue;
 				}
 				if (header_check > 0) {


