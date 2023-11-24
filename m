Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9906A39FEA;
	Fri, 24 Nov 2023 18:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAShc26i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDFDC433C8;
	Fri, 24 Nov 2023 18:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849753;
	bh=z0tIe70DQcj/c0QevsCLPrJ76QhZdU8cUSPXBVQC7fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cAShc26iJ6AR/EVtkL6M6qetbgzz0SaKEYg7BapafKTi6RsAMkDnMCm7Zpi+tDsbB
	 DXTmpsJylQl0BGe+e1fXUvtISx9WjyDLEk/wh0rllr/KKoyiWndJWEAL+E5Dwup/eq
	 h/dVN0RiUCLNM5nc6WRI4bLLDIUeYibv1NkbsL1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Li <pengfei.li_1@nxp.com>,
	Emil Kronborg <emil.kronborg@protonmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 307/530] pmdomain: imx: Make imx pgc power domain also set the fwnode
Date: Fri, 24 Nov 2023 17:47:53 +0000
Message-ID: <20231124172037.378894276@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Pengfei Li <pengfei.li_1@nxp.com>

commit 374de39d38f97b0e58cfee88da590b2d056ccf7f upstream.

Currently, The imx pgc power domain doesn't set the fwnode
pointer, which results in supply regulator device can't get
consumer imx pgc power domain device from fwnode when creating
a link.

This causes the driver core to instead try to create a link
between the parent gpc device of imx pgc power domain device and
supply regulator device. However, at this point, the gpc device
has already been bound, and the link creation will fail. So adding
the fwnode pointer to the imx pgc power domain device will fix
this issue.

Signed-off-by: Pengfei Li <pengfei.li_1@nxp.com>
Tested-by: Emil Kronborg <emil.kronborg@protonmail.com>
Fixes: 3fb16866b51d ("driver core: fw_devlink: Make cycle detection more robust")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231020185949.537083-1-pengfei.li_1@nxp.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pmdomain/imx/gpc.c
+++ b/drivers/pmdomain/imx/gpc.c
@@ -498,6 +498,7 @@ static int imx_gpc_probe(struct platform
 
 			pd_pdev->dev.parent = &pdev->dev;
 			pd_pdev->dev.of_node = np;
+			pd_pdev->dev.fwnode = of_fwnode_handle(np);
 
 			ret = platform_device_add(pd_pdev);
 			if (ret) {


