Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3105A37BE93;
	Mon,  9 Feb 2026 14:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648120; cv=none; b=YzQ9XnoEhvv9IZjHXHBypbPkkA+xHn4Rg6ZZN6QdeAjVUVsucvAFlxWS+KnXjNCcuzcONCqf7vHpXGNs08p6bqZFgLMWlILSZngP5rQ89Po9MN3UPKG6LKcK48tuppBtddz5L9i/ienoHRXwPdP/221RIHHcIr59WeH/yk8thCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648120; c=relaxed/simple;
	bh=2v7vF8LfsWA3+l7riOmS4i3VdR/IsAVy1RqpWAt7N/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmSr7UzTwex1s45JMoU+tDgC4oQ+Ml+Bn59WtnnuMMGWvDU1Oki5r+H8Xdy/KWVemTqIA82xDC5yi7QCjHROT/htDUAielI63qccHuFDCutWHd85nQ0daROSHd2yWY/0CybcftpEAlJ1JS9CDBLjk7duJV29fIP68yBkQ6uFpcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sx44d9y4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sx44d9y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64724C19424;
	Mon,  9 Feb 2026 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648120;
	bh=2v7vF8LfsWA3+l7riOmS4i3VdR/IsAVy1RqpWAt7N/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sx44d9y4eKIxsI44F4NY0ocso+7IpHen2v+8YXY4xbUGnDa/ZzRtI7QxQmCtn4Wx2
	 O2BVDDIqZGkk19d8zb+XEABshHWnDqvoUWRMOQeYpo6YxsCMSV5AOqfXGJFS/TTl37
	 JwYFD8onn6sLT3epVNhQqEA2DBzcE2yAsYq5EYHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xu Yang <xu.yang_2@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/69] pmdomain: imx8m-blk-ctrl: fix out-of-range access of bc->domains
Date: Mon,  9 Feb 2026 15:23:41 +0100
Message-ID: <20260209142302.397816892@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 6bd8b4a92a901fae1a422e6f914801063c345e8d ]

Fix out-of-range access of bc->domains in imx8m_blk_ctrl_remove().

Fixes: 2684ac05a8c4 ("soc: imx: add i.MX8M blk-ctrl driver")
Cc: stable@kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/imx/imx8m-blk-ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/imx/imx8m-blk-ctrl.c
+++ b/drivers/soc/imx/imx8m-blk-ctrl.c
@@ -326,7 +326,7 @@ static int imx8m_blk_ctrl_remove(struct
 
 	of_genpd_del_provider(pdev->dev.of_node);
 
-	for (i = 0; bc->onecell_data.num_domains; i++) {
+	for (i = 0; i < bc->onecell_data.num_domains; i++) {
 		struct imx8m_blk_ctrl_domain *domain = &bc->domains[i];
 
 		pm_genpd_remove(&domain->genpd);


