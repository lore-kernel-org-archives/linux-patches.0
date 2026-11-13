Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591093;
	b=NzviLIozIQ2ZMFrkldoglUnExqXbYjsPDbXprkOBzhPebITxZ+/H0o32+yolx5U3caYQ
	 +xIceegTV6yZCO5BgdWDfTviLRwXS85yivKDtOD02VehQmKNmyNGOay/r1PUO24sJzkK+
	 dpyrXSSSRThqyzEv40Zr+kEwghPy/y+e1xjy4/VGSaOq2ylNJPPnj7ozUaHVJIeI6eDe/
	 u339PguySICNFkGtIs0qk5uqmg17MGVISlZJY8csmOG6snJtGEx1D7pO1X3dGWkXvjA9u
	 gtXNoOY0ppCSIt+ny/n+ucK8FP+ZPwVd5qbnPpKqI7Rc699imtf8uM6D3+XbD7gLJwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YsgVosuv/oB79/fuzBRqf3g3OqX7vDsNfJ+CDNCW1a0=;
	b=Nlaylef73mALDEtHQEYinTCoSevNrUkGrzMRcb0XrKclAzEYUGcwS09YI1MTx54Oexdf
	 xTcmIvPV3kW/SyjSjtVhEEuHreJOBk1DdeJcdfgBqWfjd3F6RoLHHHHkkeIWCauJMAHBx
	 IkFonJDEdT2M+9/2tPzDwmANTt6Vd2svwoqY9ueYPr9qsd5gP6+Zx6ogRgOCkOwpPNaT5
	 4c7rq33+MfKeIyTzdDV8Qy5sqW0SFW2jAldk6PpVhKNURwMko527kywuY48TuzLbfwfYG
	 AJiJrf1qF8M0ye/LHfHLqMf3nQj5LcaD8GWJgjR0TNBiGNzREsiT+KERDyAQEutOJZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CcI/04GT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF72D606A880;
	Fri, 13 Nov 2026 17:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcI/04GT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B70A1F000C4;
	Fri, 13 Nov 2026 17:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591093;
	bh=YsgVosuv/oB79/fuzBRqf3g3OqX7vDsNfJ+CDNCW1a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcI/04GTcFc7TRZWB613CQKBtOeUVrjLj7lqsGX1SYHqHMnrCcKhPBywbyU7bBGul
	 /BLVUsUNStsiFToax1ZtZXdHbv1Dba09QrbVrUxLi8NFoRI3vOeu/XGRiM+81K3TRE
	 Y0eABI8+/ps3XNnfC/ThpGQxmpk7DFifl8daVMGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/670] batman-adv: fix skb leak when hard_iface is being released
Date: Fri, 13 Nov 2026 10:46:01 -0500
Message-ID: <20261113153818.660546586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 522e4aece2e96cacbb8a6ae1eec0d4c0dd6f4fed ]

batadv_batman_skb_recv() owns the skb it is given. When the hard_iface
refcount already dropped to zero, the function jumped to err_out, which
only returned NET_RX_DROP and skipped the kfree_skb() under err_free.

To avoid a leak, free the skb before returning in this case.

Cc: stable@vger.kernel.org
Fixes: 4fe56e60ac1b ("batman-adv: Check hard_iface refcnt when receiving skb")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 8091619981c0d..55055d3290e74 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -449,8 +449,10 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 	 * shut down otherwise the packet may trigger de-reference errors
 	 * further down in the receive path.
 	 */
-	if (!kref_get_unless_zero(&hard_iface->refcount))
-		goto err_out;
+	if (!kref_get_unless_zero(&hard_iface->refcount)) {
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
 
@@ -509,7 +511,6 @@ int batadv_batman_skb_recv(struct sk_buff *skb, struct net_device *dev,
 	kfree_skb(skb);
 err_put:
 	batadv_hardif_put(hard_iface);
-err_out:
 	return NET_RX_DROP;
 }
 
-- 
2.53.0



