Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD3F509F0B;
	Wed, 30 Sep 2026 15:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783548; cv=none; b=Cn6LPXXwB6UH/63BVpXqovIjW6ShESM3YPuvhwY7ojTP9Hgjss508eOBjWQ1PPab8eeOUc8RIJ176Ocxy13njqwgXzqFVh6CX8Ce4wmmJ9kRfaF1clL5ty4IMzq1Csn+5FUl98oQTqXXtiTQ6pD+6FLEkiy/tkrDqA7wdAQf7/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783548; c=relaxed/simple;
	bh=Z1tZ4C6vImqfyf8fbBtB/+wDRwtDuWISG657LvcmW94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqP5o0DveJDBFbOhOSSTB1xlB0Uaq4H781HFma2M9hVVYKDsITKBweNEdZKxDCQILLsnoKc3p/1iQMe67WSreI5+8PM9Dh8N/wFPpFh2fYqbAlHxlvZ8h3ek4/c8fQF4ys8Udnqb5sCpk8lxMLtjlNKtTlJslAY9+QyocCeADZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMYnqv2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMYnqv2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12BE1F000FF;
	Wed, 30 Sep 2026 15:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783543;
	bh=qrQm5PFzREdkl6deu+RW0p1XXsvfEVguaDsOjgVgMrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMYnqv2vDOBo6LhdJMuwHoWA5SS6EaEy/uWSWmgZipzffEubaHNmTzr0vT4dY37S0
	 qh26ZX6mklCxGwsJjMehkwBncOhPiMTqY8zo3Bi8AFTZGdrOTEKQhplqZtvX+o432B
	 PLTmmerYxgj2bUuPHDtNQRO0p+lPCnFdt9B1O8hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 435/595] net/packet: avoid truncating TPACKET_V3 private size
Date: Wed, 30 Sep 2026 17:25:28 +0200
Message-ID: <20260930152357.037575398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Mark Amirkan <markdamirkan@gmail.com>

commit 37213e61120297920ae4c937fcb326a360da5084 upstream.

tpacket_req3.tp_sizeof_priv is an unsigned int, and packet_set_ring()
validates the full value against the block size.  init_prb_bdqc() then
stores it in the unsigned short blk_sizeof_priv field.

Commit 2b6867c2ce76 ("net/packet: fix overflow in check for priv area
size") fixed the validation arithmetic, but an accepted value above
USHRT_MAX still narrows when it is stored.

For a 131072-byte block, tp_sizeof_priv=65536 is valid.  The narrowing
makes offset_to_first_pkt 48 instead of 65584, so packet records can be
placed in the private area that userspace asked the kernel to preserve.

blk_sizeof_priv is internal state, so widen it to hold the validated
UAPI value.

Fixes: f6fb8f100b80 ("af-packet: TPACKET_V3 flexible buffer implementation.")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260913-b4-send-packet-private-v1-1-925eab2cd388@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -21,7 +21,7 @@ struct tpacket_kbdq_core {
 	unsigned char	reset_pending_on_curr_blk;
 	unsigned char   delete_blk_timer;
 	unsigned short	kactive_blk_num;
-	unsigned short	blk_sizeof_priv;
+	unsigned int	blk_sizeof_priv;
 
 	/* last_kactive_blk_num:
 	 * trick to see if user-space has caught up


