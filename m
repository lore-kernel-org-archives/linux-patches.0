Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD7F1C6FF9;
	Wed,  5 Mar 2025 18:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197645; cv=none; b=i70O+PPSwMeQXCJjGbmc5ZVkVlFfCTp9BTnRLzcqTGzo9Jaz0szCgkvO/9ix8FYMYrFZD13i1SO/Kwl55V3MxIurVOAOwcyhHr+s2m9N2dk8MaZVfrTqH3nta/M82XJV6eM9t7hd3mgW68psjIEjxIosbF96qWoVDm4hE6UqJe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197645; c=relaxed/simple;
	bh=uAmPkXbfWvSbv5R6RuQXHnUNtr4VRWk5DbLWi1+Jai8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nX0iAjKEsmIRSFkIva9yyYHWyfZ8LoVmveygw9afnvOIY0N4A/jdSkCR9vgmzaKnxBquRG6ewKYoIJnt4IRIWkrEh+4+NdldeE9wRDi4J66ynTOXFxKqKnOVrKIokruaU7VbayT1oXP5/Ku4lo0YhqWvPwHjFsmTWMLR29VQv18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUIs3xpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUIs3xpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487A1C4CED1;
	Wed,  5 Mar 2025 18:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197644;
	bh=uAmPkXbfWvSbv5R6RuQXHnUNtr4VRWk5DbLWi1+Jai8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUIs3xpL51epAoMDa4wbhPUtjl46GiGG7pnA1GaZtD/z1DXvUMHCBtObUZKcPZC2K
	 UuLj59SvSXy+yai7ipXXTzE7EHlmloQEItlFDo0ahAzG0X2OCxLJ8mAVvpnEt3WTYC
	 Rx5EIgT4TKL3u3jrmwsySvYTYPxoUSsXmAxRK6Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/142] net: ti: icss-iep: Reject perout generation request
Date: Wed,  5 Mar 2025 18:47:50 +0100
Message-ID: <20250305174502.388950296@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b491d89de8fb2..3f9a030471fe2 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -544,26 +544,7 @@ static int icss_iep_perout_enable_hw(struct icss_iep *iep,
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
 
 static int icss_iep_pps_enable(struct icss_iep *iep, int on)
-- 
2.39.5



