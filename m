Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685C5146A6F;
	Mon, 24 Feb 2025 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408685; cv=none; b=FEiXdymVe9skoF3Co8QL/EUvnsXfvruq3wIa3njuv5+5vPfwxh7ktp1nGFbS3w2leYIy8L989zYI1mseLLrU++mcVXD6BHYHH7iCeV9S+RgIsCtakjFUxECHV5lU1wRUpCjoBwDBwlFReDqOJ9YddqWpMecEvbkzsHdMpX1vDpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408685; c=relaxed/simple;
	bh=7kOPKIQWKUZamooIiYtin/6vbtsakGLuZ5fSCEO7l6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEykyaGRUMLcArxu0h+T/lwsmP3MFXxq67INxD1Aux97QJ76aIi1J5bh+EZBJmmlXVBJiMfIwdqo8Ez0Ha0F3kGYuO2zsOKBUSGumIkT6wn+1lPf11XsOZMKzTVCj9K3X0+jUG/TWJO7sWBlS6/Qqn4Dss4Ej32R/KRVLiA7UCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pca0dhJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pca0dhJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772FCC4CED6;
	Mon, 24 Feb 2025 14:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408685;
	bh=7kOPKIQWKUZamooIiYtin/6vbtsakGLuZ5fSCEO7l6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pca0dhJI3FzyQwoRrmNGMMa5XFAByHjIoenudRPdCgBCNaA5xZSUc1SfrGZt00yiZ
	 J3aFdeKQRU+acm4VzSYk0OQxcLxtmW2+EdQ29ZEaYEBIOlhLMJGrK6+ZPWsq6waZvo
	 A0qE8IUzwM+t+juFFas8PWcgDz+eQPI2F3RFRI1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Jason Liu <jason.hui.liu@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/154] firmware: arm_scmi: imx: Correct tx size of scmi_imx_misc_ctrl_set
Date: Mon, 24 Feb 2025 15:34:47 +0100
Message-ID: <20250224142610.519452070@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit ab027c488fc4a1fff0a5b712d4bdb2d2d324e8f8 ]

'struct scmi_imx_misc_ctrl_set_in' has a zero length array in the end,
The sizeof will not count 'value[]', and hence Tx size will be smaller
than actual size for Tx,and SCMI firmware will flag this as protocol
error.

Fix this by enlarge the Tx size with 'num * sizeof(__le32)' to count in
the size of data.

Fixes: 61c9f03e22fc ("firmware: arm_scmi: Add initial support for i.MX MISC protocol")
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Tested-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Jason Liu <jason.hui.liu@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Message-Id: <20250123063441.392555-1-peng.fan@oss.nxp.com>
(sudeep.holla: Commit rewording and replace hardcoded sizeof(__le32) value)
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/vendors/imx/imx-sm-misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/vendors/imx/imx-sm-misc.c b/drivers/firmware/arm_scmi/vendors/imx/imx-sm-misc.c
index a86ab9b35953f..2641faa329cdd 100644
--- a/drivers/firmware/arm_scmi/vendors/imx/imx-sm-misc.c
+++ b/drivers/firmware/arm_scmi/vendors/imx/imx-sm-misc.c
@@ -254,8 +254,8 @@ static int scmi_imx_misc_ctrl_set(const struct scmi_protocol_handle *ph,
 	if (num > max_num)
 		return -EINVAL;
 
-	ret = ph->xops->xfer_get_init(ph, SCMI_IMX_MISC_CTRL_SET, sizeof(*in),
-				      0, &t);
+	ret = ph->xops->xfer_get_init(ph, SCMI_IMX_MISC_CTRL_SET,
+				      sizeof(*in) + num * sizeof(__le32), 0, &t);
 	if (ret)
 		return ret;
 
-- 
2.39.5



