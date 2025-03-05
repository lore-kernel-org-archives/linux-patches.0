Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2764250BFB;
	Wed,  5 Mar 2025 18:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198106; cv=none; b=ttPJgT0XicsyMSzkbLbCJkNug5P3LT+wq7x04OkR8vlvcNmnEprml4kVpP/cjW3ZrbB/kx8WqEezzUZSm550lnKSMOOdYXG0GQYsNGv5TNzTHcQPmSZ8H/UaXYyCUfBB+RpYlS+sQGCXnBlGMSFZyHKGOfT/2E9o/QWZpsSSQdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198106; c=relaxed/simple;
	bh=osUHHao6t5RW77CGrTBfXlE/01adrUc3J59eXagFNKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgbpF9HUIBGrkPF0UuiMB/MMlGHLqDEhCV2NMdL41hzDtD0b+sLodhOQHv1zQ8sVXCHREysHK7Bzg1ADdSkcHT0FxsIMxJPyuklaO4UvKEE8Y0jiXS28Zgf0tvcqj3eIuicu/KBItr68fFymwNiXfN5ANbr0rUuourlfDpRVJyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PR6pyxcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PR6pyxcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABEEC4CED1;
	Wed,  5 Mar 2025 18:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198105;
	bh=osUHHao6t5RW77CGrTBfXlE/01adrUc3J59eXagFNKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PR6pyxcLrAoZyqEd2zOXfwH3zK1zozD3Rv1CbbjGDLuYc0TSClksIUCJWpvrCSWug
	 QisGfyCMSaHEShB6MVo63us6fxw83mu3UN7pRX0jZ+v6FJ3qFZsslR/iVvnQTgB/I6
	 ZN2fJjigGP/TKNEeQ+w0vN4xwt3DJ2hOi7u6zrj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/150] net: ti: icss-iep: Reject perout generation request
Date: Wed,  5 Mar 2025 18:48:15 +0100
Message-ID: <20250305174506.471521842@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit 54e1b4becf5e220be03db4e1be773c1310e8cbbd ]

IEP driver supports both perout and pps signal generation
but perout feature is faulty with half-cooked support
due to some missing configuration. Remove perout
support from the driver and reject perout requests with
"not supported" error code.

Fixes: c1e0230eeaab2 ("net: ti: icss-iep: Add IEP driver")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250227092441.1848419-1-m-malladi@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icss_iep.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/ti/icssg/icss_iep.c b/drivers/net/ethernet/ti/icssg/icss_iep.c
index 768578c0d9587..d59c1744840af 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -474,26 +474,7 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
 static int icss_iep_perout_enable(struct icss_iep *iep,
 				  struct ptp_perout_request *req, int on)
 {
-	int ret = 0;
-
-	mutex_lock(&iep->ptp_clk_mutex);
-
-	if (iep->pps_enabled) {
-		ret = -EBUSY;
-		goto exit;
-	}
-
-	if (iep->perout_enabled == !!on)
-		goto exit;
-
-	ret = icss_iep_perout_enable_hw(iep, req, on);
-	if (!ret)
-		iep->perout_enabled = !!on;
-
-exit:
-	mutex_unlock(&iep->ptp_clk_mutex);
-
-	return ret;
+	return -EOPNOTSUPP;
 }
 
 static void icss_iep_cap_cmp_work(struct work_struct *work)
-- 
2.39.5



