Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50009236FA0;
	Thu, 12 Dec 2024 16:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020540; cv=none; b=KJged3eZ23cdWNjhuess1YULPcmXTt37jgc+/wJ60taLHxam/LL0nt5VSh+iMfIF2RGz658DHpaB6OYrZYWG5GT2dho1VMm7TuUls+JdnkYCJQyGwP3ZkvAspeBuLe+t4tZV8Vo2pbKdMOS2zowb8bCtPwmVaHz1D5w10//rTIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020540; c=relaxed/simple;
	bh=L73TAyedVcOCE0Q0a11g/9+FHabz/zbWMBjpwivDTTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVoA3Uu40su7s3kS5ViGJSb9t1vuR51dLDWXLVn5iZv8M4zT7pwemwHrOzqiOHiCfK3NhpMIqOaO+NxYFG1ywWfbdv5hDEumD+DqPi+7B85U5lODkDnFxWEjQaUsoZVovEHzENBpmzZQjgPkv9fAXxBqC7aAvHx65T1K5qiC2dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=um6yLWFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="um6yLWFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2416C4CECE;
	Thu, 12 Dec 2024 16:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020540;
	bh=L73TAyedVcOCE0Q0a11g/9+FHabz/zbWMBjpwivDTTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=um6yLWFCx+CIX5VO5rVJmQgZWMf81nYv431JefOI9t6G16GHtyE9XkMMtfxBrI2o/
	 lSuA6V9mhyyCIPzRo27FoUFHyoghExznA2NI/y+MCSdHZARMjiRd55yq3shRz3dskW
	 +/sOO0oxt0T00e+T3ofpG/EwzYPLBc3aYn+wEy0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 486/772] i3c: master: svc: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Thu, 12 Dec 2024 15:57:11 +0100
Message-ID: <20241212144410.023185017@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 18599e93e4e814ce146186026c6abf83c14d5798 upstream.

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Cc: stable@vger.kernel.org # v5.17
Fixes: 05be23ef78f7 ("i3c: master: svc: add runtime pm support")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20240930091913.2545510-1-ruanjinjie@huawei.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1639,8 +1639,8 @@ static int svc_i3c_master_probe(struct p
 rpm_disable:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 err_disable_clks:
 	svc_i3c_master_unprepare_clks(master);


