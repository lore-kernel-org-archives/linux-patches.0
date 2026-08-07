Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508843438B9;
	Fri,  7 Aug 2026 15:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114889; cv=none; b=tS/6xkcCUAC3kenfrMG3mUBOqs1LN1f8vcboimzeyBYr9fPHXstNReSewX1EMfoe3RvC0BH/TN7tvE06tu3Mdt2lBrFG4BV0OMFO3TV46/pyVgdu78zWffdGE7gJClZf0T9x3CalgLjCsQhKET3FmSc0hqpKqzi0gUhaHgLa3q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114889; c=relaxed/simple;
	bh=HDXOeCvF9GP6ysizcfoSFbJ7qXDM9ehLPQaw2zJlEoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0wfD0LCqQIgbxgTrVcMYKoG28X3CpbB9mANMY3tThTatspBIMqEN3jc7NK3IBRr9tOcoM516koppbDEhbM5XPTSkcfV4PDhZw3eH5ixyBmBKQDJ2kzDVBn046yeilZFJBALqUK4KFul0xUYlwXnyINHwvi/hW7qafo37Pn7rSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQz2htwd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQz2htwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EA51F000E9;
	Fri,  7 Aug 2026 15:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114888;
	bh=YHWugtp8PXnkZypw93O6JJKGM9L/2GnnoWo/lVu52jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQz2htwd13vLAnM6zOr330C2Yutwomj3k0rtjaK+2r+vdxxeI85ikmoEWRRJ1sX9B
	 THgpQovFzMD76AFG/e4QWR5BP6DUn08lTC+dnK2ibf0JRURaNr/WYZar08fSWeno6f
	 EnU0K951rmUCX+G/3f7/Kap5dIFsjfPxA6oMEtJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Corvaglia <david@corvaglia.dev>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/396] net: bridge: mrp: fix Option TLV length in MRP_Test frames
Date: Fri,  7 Aug 2026 16:34:02 +0200
Message-ID: <20260807143426.041896027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3c36fa24bc05a..92a0debf4a4a6 100644
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



