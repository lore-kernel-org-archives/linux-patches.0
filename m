Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A52D212564;
	Sun,  7 Jun 2026 10:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828749; cv=none; b=J8k8LNXbS/60fNi4Y+h3gLH+khEbxpXwUicRM5uFxEHXBQLZhT7lbWEMK8XH+1mBL62Fvy92bgMf9tsVk4mWKfmeBo5/fy20sJEsohjdDeX2zaLvbm2REMj58uBlckMOEO5SStf+/JBgQkEdwrDDJfp8xww0oKDM7emthOZt3ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828749; c=relaxed/simple;
	bh=skaGysZZnfpAZSjfMjX5vda+Zd0q7/nZXzI1D9GO+hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHi4TmSR1bBwn4lKux3SyGiNDOFcMF4O40PWRpWw4ASd0BKODdga3JPCtJNoQqZhYjfBJtVH4Fam1avwHKG7czvrbYkx4O1W00ojDsfKWRsdstrSraTFBn1SupTH8ToJloSVf03ewNp8Mupy7t3BVDJ6rXp7a0vSohlJM7agXWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOyS9Lm1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOyS9Lm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F90F1F00893;
	Sun,  7 Jun 2026 10:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828748;
	bh=Jv7h/WAphqF+0OOHO1UA3JYQsUl4WqwgUyFfEMN4iC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOyS9Lm1NaiVpcAGDgNCaru9/D0lAhufAnaqnZG/1InvJMTQ87xbs62cJ0/DBLeWR
	 iB1fbaBJxvUc4sa0yD6oqjTDyVr+xqpmPpS7XwIbIvvdJkraQ8v49PIBDSSQR/sNyV
	 VjfgMmTgcbC0LUGdAaYLywZWcaeEYG8/RvMzUt14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 208/332] wireguard: send: append trailer after expanding head
Date: Sun,  7 Jun 2026 11:59:37 +0200
Message-ID: <20260607095735.707285042@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit f75e3eb08fe31d30a9af6ed80cdd22e6772837e2 upstream.

With how this is currently written, we add the trailer, zero it out, and
then add the header space on. If that header space requires a
reallocation + copy, the zeros in the trailer aren't copied, because the
skb len hasn't actually been yet expanded to cover that. Instead add the
padding at the end of the process rather than at the beginning.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20260529173134.3080773-2-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/send.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -177,16 +177,6 @@ static bool encrypt_packet(struct sk_buf
 	trailer_len = padding_len + noise_encrypted_len(0);
 	plaintext_len = skb->len + padding_len;
 
-	/* Expand data section to have room for padding and auth tag. */
-	num_frags = skb_cow_data(skb, trailer_len, &trailer);
-	if (unlikely(num_frags < 0 || num_frags > ARRAY_SIZE(sg)))
-		return false;
-
-	/* Set the padding to zeros, and make sure it and the auth tag are part
-	 * of the skb.
-	 */
-	memset(skb_tail_pointer(trailer), 0, padding_len);
-
 	/* Expand head section to have room for our header and the network
 	 * stack's headers.
 	 */
@@ -198,6 +188,16 @@ static bool encrypt_packet(struct sk_buf
 		     skb_checksum_help(skb)))
 		return false;
 
+	/* Expand data section to have room for padding and auth tag. */
+	num_frags = skb_cow_data(skb, trailer_len, &trailer);
+	if (unlikely(num_frags < 0 || num_frags > ARRAY_SIZE(sg)))
+		return false;
+
+	/* Set the padding to zeros, and make sure it and the auth tag are part
+	 * of the skb.
+	 */
+	memset(skb_tail_pointer(trailer), 0, padding_len);
+
 	/* Only after checksumming can we safely add on the padding at the end
 	 * and the header.
 	 */


