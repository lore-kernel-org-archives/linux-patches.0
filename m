Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28020442B06;
	Mon, 17 Aug 2026 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979807; cv=none; b=hfRpLrzlW9w2cJNTtav1FdZAdpYvFl6u2O1y7MYg8QwHHsp7oB3h8trIT7AOdu2jdN2OrFjT0m0tXIWhad4DVLTiokjZ3koVwOG3mT+JRMkuZQflICUM9cg/3rwEs+b+20lgDWehV0Qf8y+839PNuNKsIhiTmVk4Zq20MP17ct4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979807; c=relaxed/simple;
	bh=JkHABZiGy88wSWnGFZ6cATRwK6p4RcxxPw7AqkdVLug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXTh3W1exGzPo+B6mkXXiV/jhZ5PALgzNHa1dLorTQ3eucoHiw4EkHUvOXYKYmKBEMrrliKye1wHlFZbMz9/DYGZ1UgyV6trhNnMSO2zYsEwzs2pFbEjIs/0B74obS35HYmFjzT0spM4kxZWeGexOJWYJMrn6ge8zwQraRcOHA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olBqf/Up; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olBqf/Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148F41F000E9;
	Mon, 17 Aug 2026 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979804;
	bh=JA14e/Ej3ceZjvgyZKquRPgFNDQ7HAJfd8oiIvOgvXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=olBqf/UpKj6TEcVMFBBxDuQx3sUhRrBYe0+95AlplzaPZ2z45PR9/L2fSWJ1q03co
	 IoL5vlvIsiIi69N904TCdvt9AX5WfBrSzzWnaYGMlynq74XFDGXOEM529q9CxporXU
	 5b65S8Za2rWeQ6Cb0owqSrYYeBH37jDjuXBtyMGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Corvaglia <david@corvaglia.dev>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 352/609] net: bridge: mrp: fix Option TLV length in MRP_Test frames
Date: Mon, 17 Aug 2026 15:30:48 +0200
Message-ID: <20260817132556.053185770@linuxfoundation.org>
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

From: David Corvaglia <david@corvaglia.dev>

[ Upstream commit 5546da86894d5906f131b05890705a7abf949d84 ]

oui is a pointer, so sizeof(oui) is the pointer size. The MRA
Option TLV thus advertises a wrong length (15 vs 10 on x86_64),
causing misparsing of the frame on peers. Fix is to replace
with sizeof(*oui).

Fixes: f7458934b079 ("net: bridge: mrp: Update the Test frames for MRA")
Signed-off-by: David Corvaglia <david@corvaglia.dev>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260726062605.2746-1-david@corvaglia.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mrp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index fd2de35ffb3cf..5fd22bb4f5b60 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -215,7 +215,7 @@ static struct sk_buff *br_mrp_alloc_test_skb(struct br_mrp *mrp,
 		struct br_mrp_oui_hdr *oui = NULL;
 		u8 length;
 
-		length = sizeof(*sub_opt) + sizeof(*sub_tlv) + sizeof(oui) +
+		length = sizeof(*sub_opt) + sizeof(*sub_tlv) + sizeof(*oui) +
 			MRP_OPT_PADDING;
 		br_mrp_skb_tlv(skb, BR_MRP_TLV_HEADER_OPTION, length);
 
-- 
2.53.0



