Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE931A6803;
	Tue, 16 Jun 2026 17:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630409; cv=none; b=PCp6gwQJl6aqUO3toaEMc+p1ZWycANAAlLxV1XqRVZ8DRzurXReP0NuKufJTpz/S0uNi7c/83U5fQ23EReiPGer6db3w3DhqXssQyfn7Ahufq9fGCH99zU+RFsxIcZILdUBg736WVt5V0cPR/If98+JvyMz06eQRF2LVr/3v11s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630409; c=relaxed/simple;
	bh=Pnh86aQwUvfWwju0qJcsYh83VU0/CvAwTl85BfGfCTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAhlRDXZ5GPxtTlYeAd9tjXs+OZzTr7e/V+MKpmZdP+yrkhlGE+mCbuxRqcXeBtn85cQWqZoZEGHlIXdx75CvlWRPcEo0PMnrNk5cIA7GvQt27mEEEM50eO14ANb3ab/efSH7zv+XvnlxTIEz6BDv+eodi7UkaShjs9Fy4EtVYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4xqOM6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4xqOM6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8A51F000E9;
	Tue, 16 Jun 2026 17:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630408;
	bh=7bVdzUy++Kh09KOm0r/hCtUGk0U/RpPIh07l8AwgRi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4xqOM6EENQaPtJoDbYH1X1SWroJ7ixN1Rm20xpxdHO9jke83KLy3qtXKMEM3nEzU
	 fMEo0sGtOCUT96fegRwig+aEsvE4hqczDL4GZ78mcPYAqdJHMilpvY8fILUlcL1gs/
	 mYiMwxD96zDyB9UbdXLF2K1Av/P26sfwObu17qP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/522] net: hsr: fix potential OOB access in supervision frame handling
Date: Tue, 16 Jun 2026 20:22:51 +0530
Message-ID: <20260616145126.740024135@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Luka Gejak <luka.gejak@linux.dev>

[ Upstream commit f229426072fc865654a60978bb7fda790a051ff3 ]

Ensure the entire TLV header is linearized before access by adding
sizeof(struct hsr_sup_tlv) to the pskb_may_pull() calls. Without this,
a truncated frame could cause an out-of-bounds access.

Fixes: eafaa88b3eb7 ("net: hsr: Add support for redbox supervision frames")
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260523130330.61880-1-luka.gejak@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 3852fd99509f04..7a596c4f603e2d 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -84,7 +84,7 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 
 	/* Get next tlv */
 	total_length += hsr_sup_tag->tlv.HSR_TLV_length;
-	if (!pskb_may_pull(skb, total_length))
+	if (!pskb_may_pull(skb, total_length + sizeof(struct hsr_sup_tlv)))
 		return false;
 	skb_pull(skb, total_length);
 	hsr_sup_tlv = (struct hsr_sup_tlv *)skb->data;
@@ -100,7 +100,7 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 
 		/* make sure another tlv follows */
 		total_length += sizeof(struct hsr_sup_tlv) + hsr_sup_tlv->HSR_TLV_length;
-		if (!pskb_may_pull(skb, total_length))
+		if (!pskb_may_pull(skb, total_length + sizeof(struct hsr_sup_tlv)))
 			return false;
 
 		/* get next tlv */
-- 
2.53.0



