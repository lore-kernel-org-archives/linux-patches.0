Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736D22206BD;
	Mon, 10 Mar 2025 18:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630499; cv=none; b=GWVj6NNQMe2hM9whL3FF2/ZpaoKABarWFyuMdtlGq4F3MBgqxQy+vgj8s3V4rpXrAOGiaAyIB/+b7cXsVo1GPDAQ1M+Px9nirsokkVVk2ZeDmnyUW9VKO0H991FOUu4YWbU1XtGGd7Mg4VdmXE4LIG45BjmyxdtFq3IjnLXEd4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630499; c=relaxed/simple;
	bh=8iLeWn/ubdTvnUxs3J13xQwgT/5CiMqkkcomABR204A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwZhK89pWV74BbI3LkH0qaYYCLQeflr+5pkukXKlx/N7QzX9DO2YhS6cvKmxP2apDVyaWESmikxhL/2c+8pBx1AjGsy3LVYTKwIBVwNJ7d2bzNKncFiQN5DDlAqywKPvatb++G/tYb+aNU9FgCWkVLuMLCahaC/0YuIT86AOOBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODP5tZRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODP5tZRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED944C4CEED;
	Mon, 10 Mar 2025 18:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630499;
	bh=8iLeWn/ubdTvnUxs3J13xQwgT/5CiMqkkcomABR204A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODP5tZRc0lh7Txlz3fNIbR4AMlgyAdB3o8dm9YlwrMD9ZUNucU35p3/CO8QQbVwMI
	 8bi0h+9RmBL9x75sWLZJYDYrWkai+MYA58RlMxg5AL3elOSbilQASuIqBQCWIypNvG
	 37pCvApfZvWFlYuvhfhdd33Knwdi0tCfGP2MiAbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 436/620] media: imx-jpeg: Fix potential error pointer dereference in detach_pm()
Date: Mon, 10 Mar 2025 18:04:42 +0100
Message-ID: <20250310170602.808373718@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 1378ffec30367233152b7dbf4fa6a25ee98585d1 ]

The proble is on the first line:

	if (jpeg->pd_dev[i] && !pm_runtime_suspended(jpeg->pd_dev[i]))

If jpeg->pd_dev[i] is an error pointer, then passing it to
pm_runtime_suspended() will lead to an Oops.  The other conditions
check for both error pointers and NULL, but it would be more clear to
use the IS_ERR_OR_NULL() check for that.

Fixes: fd0af4cd35da ("media: imx-jpeg: Ensure power suppliers be suspended before detach them")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 8ac844db0e833..059e45aa03b7f 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -1997,11 +1997,12 @@ static void mxc_jpeg_detach_pm_domains(struct mxc_jpeg_dev *jpeg)
 	int i;
 
 	for (i = 0; i < jpeg->num_domains; i++) {
-		if (jpeg->pd_dev[i] && !pm_runtime_suspended(jpeg->pd_dev[i]))
+		if (!IS_ERR_OR_NULL(jpeg->pd_dev[i]) &&
+		    !pm_runtime_suspended(jpeg->pd_dev[i]))
 			pm_runtime_force_suspend(jpeg->pd_dev[i]);
-		if (jpeg->pd_link[i] && !IS_ERR(jpeg->pd_link[i]))
+		if (!IS_ERR_OR_NULL(jpeg->pd_link[i]))
 			device_link_del(jpeg->pd_link[i]);
-		if (jpeg->pd_dev[i] && !IS_ERR(jpeg->pd_dev[i]))
+		if (!IS_ERR_OR_NULL(jpeg->pd_dev[i]))
 			dev_pm_domain_detach(jpeg->pd_dev[i], true);
 		jpeg->pd_dev[i] = NULL;
 		jpeg->pd_link[i] = NULL;
-- 
2.39.5



