Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70F72E736D;
	Tue, 21 Jul 2026 17:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654292; cv=none; b=W6a0RD8aREervo3wA844y6AMMJmeEkzUvpYOZ/MHYSDEOmPkkIJJ/3uSvwLrAc9Drl36F7USZBwbxnIf4HqFKiGD8rmY02Ky+/OeZ8dI21y9mfoZXzMNci7d9KHSpSR3RmL8yxiDgCpjxtExfiXiUrcFX4Dwy7PBClL1zSYWfNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654292; c=relaxed/simple;
	bh=+Ri7m7Cm9dkSoeU8lJ+yW59Ck7eIAqutYPGC+LiRl/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHRQ6YBvwu2PYETD9qzf8qg6Wi1XGAv4A6VnbmdHuY04fs/PmEqL+VoSwGPVrLF4sg/fLWu9EzMivDK3+tJrlHL+hBks6UIh8mBn1MXOVmO3mdEgqD4IlpGCX1unnk3iSkt0Up/rvi63Aa8OPrOKIT1cG9VBSSABEzK/aVWzNrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNwYOmGa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNwYOmGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4CE1F00A3A;
	Tue, 21 Jul 2026 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654290;
	bh=efK7/56WTTsh5D1h1RTeFExoISX6ZKhfFvlCsMj2+l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNwYOmGa5z2xcOrEjhVm3nLfnw3IluehTx7bcZ2wH83grBefwDFXwr0erdMTaXC9I
	 zD4wVUbuoE3j30BJssAsdZA5h5JIlfBG4z1Usf8bLNArVjtp0EfnwlVVdKeEm/QYr3
	 LrY3m4uaHuEDV0xbeNa3UpNyXdH2dd58n946K0SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1648/2077] batman-adv: frag: free unfragmentable packet
Date: Tue, 21 Jul 2026 17:22:01 +0200
Message-ID: <20260721152631.620494103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 6b628425aed49a1c7a4ffc997583840fc582d32b upstream.

The caller of batadv_frag_send_packet() assume that the skb provided to the
function are always consumed. But the pre-check for an empty payload or the
zero fragment size returned an error without any further actions.

A failed pre-check must use the same error handling code as the rest of the
function.

Cc: stable@vger.kernel.org
Fixes: ee75ed88879a ("batman-adv: Fragment and send skbs larger than mtu")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -516,8 +516,10 @@ int batadv_frag_send_packet(struct sk_bu
 	mtu = min_t(unsigned int, mtu, BATADV_FRAG_MAX_FRAG_SIZE);
 	max_fragment_size = mtu - header_size;
 
-	if (skb->len == 0 || max_fragment_size == 0)
-		return -EINVAL;
+	if (skb->len == 0 || max_fragment_size == 0) {
+		ret = -EINVAL;
+		goto free_skb;
+	}
 
 	num_fragments = (skb->len - 1) / max_fragment_size + 1;
 	max_fragment_size = (skb->len - 1) / num_fragments + 1;


