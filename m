Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE04938C421;
	Fri,  7 Aug 2026 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114062; cv=none; b=XjY3P6nL/iqTUzSwKQZ4KZRWVJjHjBCuJFs7bRzSvWag9NLL0tN+zBY8vpowr81qg6iUP5RWOCswyqRqdOnn88SbJINQwVnU/jtEs6V7jimRdYD5vN1H2HCv+wuw4wVgSN4ebGNUVu1ykqUrSduQ0r58iILJrMJ5c/JJSRtVnyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114062; c=relaxed/simple;
	bh=eDMF7Dprbqq+bYbv1pLZsxmTmDdKkttMEqNHuiKdAwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2cqAhxGBD/4kqdAU2yP2jbLQF/roLB5mGFJ8iUohz9dnNKaJjDT2zjwQDEEQDDPTH6thrfCumhhS4GJh8xnuwGks0TUr8i/k9sPk9bF/9FTVENs0LbDTS1cPRMNpZDIUKs5AzHnB1czN+lJc4fKduIbk/0Jcua3iDmS6JLA5Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6EqrJLe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6EqrJLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD61E1F00A3A;
	Fri,  7 Aug 2026 14:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114057;
	bh=/4Z49GDU0z4am73E+wXtosnQhXL1w7TzVjXrAm8dhf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6EqrJLegtVH30cmQsJZVNv/5bVvnrWRF284mggbBmmBUYZyK/UQrg4eIVSTOf25N
	 /wodEqmbALEaEjoN5Brn6/JgRXwdXHXc1JSQlbUejNGK0IT7EWRa+U98BnE7EXET0L
	 IxlTzyWdRXr4P44rwEm3c0gf6fcg1JBMRXyCJX5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Corvaglia <david@corvaglia.dev>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/337] net: bridge: mrp: fix Option TLV length in MRP_Test frames
Date: Fri,  7 Aug 2026 16:34:37 +0200
Message-ID: <20260807143420.116412923@linuxfoundation.org>
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



