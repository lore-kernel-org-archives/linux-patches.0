Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94873F3281;
	Mon, 17 Aug 2026 13:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974869; cv=none; b=F3YjLz/9HGDYKbc0nH1PdBEH779gLksuFzbN1aIdQEl+xb7Ho1F37n5xJExzHfuUHLyC2VfFL8u9NBYty4DziKtLgRpTeWxYqXlpMVEjYqVhr78BbWzBomXG5MR/bL8YVzs1/gS+vHR4tjZUHbEXPkqqxEeR4jdc1bAXmH3XaGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974869; c=relaxed/simple;
	bh=A63c9FJrimhdu7SOaFMsVTV3d9Mi8MqxzQ05JYTluOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfYnJXt1X8IMrokXrGTB0reOzcvIef4bsXM6OsP9+36quXkjPx3a6LwJfDfaNohX3ix6uZ26kdD0urS61I66YMzs7lYBGM/jbN/CY7M7Kh3qVaGRkHzxKYQNu24YB+XXfz1jPomcleLlxU15lKRZkzxyeqTdC3DNSTObmCChka4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wO7GSR8S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wO7GSR8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6221C1F000E9;
	Mon, 17 Aug 2026 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974864;
	bh=/o5SiRDZAurF4V/uh3VNR+E8cMED7tBi4IxCB5H9/2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wO7GSR8SGXm7mAxKGOFEKjkJQ3oIrXmwkHPsAcgxxQeA4ZBW5f2wyV/MBWTf8VMCl
	 oC1nyM6sb/NOs7xiMbHgyUK9M6DL3Ehx47uhu0nLMOhXM/pu95d46ECSh8mvcPHhxu
	 R7D0BsohuXi0599OjxjdcZnB+OUoYhev0JT0MxLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Bhargava Marreddy <bhargava.marreddy@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/250] bnge: use int for bnge_fix_rings_count() return value
Date: Mon, 17 Aug 2026 15:30:43 +0200
Message-ID: <20260817132539.796092177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 2cbd8a4e5e09aa232a1f8d56ce3d070b18ab2b10 ]

bnge_fix_rings_count() returns 0 on success or a negative errno on failure
However, bnge_adjust_rings() stores its return value in a u16 variable,
causing negative error codes such as -ENOMEM to be converted to a large
positive value.

Use an int for the return code variable so that error values are
preserved and propagated correctly.

Fixes: 627c67f038d2 ("bng_en: Add resource management support")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Bhargava Marreddy <bhargava.marreddy@broadcom.com>
Link: https://patch.msgid.link/20260801100923.1498570-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_resc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
index 62ebe03a0dcf3..39cc392bd8c4b 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_resc.c
@@ -151,7 +151,8 @@ static int bnge_adjust_rings(struct bnge_dev *bd, u16 *rx,
 	u16 tx_chunks = bnge_num_tx_to_cp(bd, *tx);
 
 	if (tx_chunks != *tx) {
-		u16 tx_saved = tx_chunks, rc;
+		u16 tx_saved = tx_chunks;
+		int rc;
 
 		rc = bnge_fix_rings_count(rx, &tx_chunks, max_nq, sh);
 		if (rc)
-- 
2.53.0



