Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B820C3AB26D;
	Fri,  7 Aug 2026 14:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114213; cv=none; b=KSew0uKKAgMsUcGPp7XOAZwFADF9Xf+WgVqFuFhFf0p4gCYTjObugHXc2rvEgm3H6l4qJ0Oju0wn7bNCbPemMs4iMGXug4+2b+SX0JHfP59sN80C1bJ6zutPoPUgZVlZTwKClNVeqrP6nCDvNT0JPccirUB1qXugRwCFILR+qa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114213; c=relaxed/simple;
	bh=Gq0KxuzWTrv4C9oqNMndZcNV52j+nHT3hObEmHcj4fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfZt9LJtPsGIx5SrnUqrleWWAsaXfj3/mgJJBwnE/+PlgaSIDXA8kuQP3gRiuY/qKeaMY0NfWPpsO5btm5xIItPdsH/NhfNTF+6E7JiavQ/wPDKEtQWHag084GRrmqcAlCXqHCabdphFY5xK4KWAJgxzyep1kkE1IWrp1rxQ7uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuPAcYpf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuPAcYpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB9D1F000E9;
	Fri,  7 Aug 2026 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114212;
	bh=z1Rc6Ybad4eSW6s3IxbPgVzTIpTuSFBlQOtOH94/l2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JuPAcYpfZDeBu5wJFxBU0deodIUhjRrggwbzYdJ0ZXvmGSZ4DNy7uAUmz5jak29gk
	 TDPyBsinS6wySx491m7fgCj16b4n6JWzKIOvhEy31rH5Q7GJed182K4gXNnwd0Wdvj
	 WOZOLnfZsyDTVDV7pGSOfyZ608LBD6rV1shce6G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.12 185/337] um: vector: fix use-after-free in vector_mmsg_rx()
Date: Fri,  7 Aug 2026 16:36:28 +0200
Message-ID: <20260807143422.567974754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -999,6 +999,9 @@ static int vector_mmsg_rx(struct vector_
 				 */
 					dev_kfree_skb_irq(skb);
 					vp->estats.rx_encaps_errors++;
+					(*skbuff_vector) = NULL;
+					mmsg_vector++;
+					skbuff_vector++;
 					continue;
 				}
 				if (header_check > 0) {


