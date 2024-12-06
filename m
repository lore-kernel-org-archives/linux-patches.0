Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4542614F9F4;
	Fri,  6 Dec 2024 15:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498637; cv=none; b=XnnvbuP+pL3YTSahAqN49EMH9IMvphEeK1c0ZXpGcwirq1l2FA3u+011EgQLlJRCFq7iiUuvqd91lVyVvrtl6iTJG9GY0UD5E+xG+wubo4sXb1EAr6YcC2RAlZrcgURX6WQIXEGEUsC5pXMHSRKJ2wA8IrAX5/XL4KirghI3XZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498637; c=relaxed/simple;
	bh=nhQZkmgzkBX1EZYiTmI4eLDcxkAqexRRPQT0Mk8DNRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hg7ikQ85gRPpQWoiufrXK3av6YwQrXXqb0IrK78TyTZ9XnmIgu2iQuESCKdAc7tU9i6SiZIndxdsBpyLvAjWvSYg2FzdzB2h/MW+bIay9rt3JAwDMXzrVfU12Nxzb0bzkWMxkVFQhQqW0CigAzuGNqTAzcP5VNiIH28qeT+KsC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAg1efzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAg1efzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DA5C4CED1;
	Fri,  6 Dec 2024 15:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498637;
	bh=nhQZkmgzkBX1EZYiTmI4eLDcxkAqexRRPQT0Mk8DNRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAg1efzI5PIvu+SHv3Mju49zJux3cd0Dvlb5J6XMxXN+6Sdg10pQ5WfujEioblDE2
	 m0K2aUGht5Zi1Zf26XhSx689j4OdswpZl8kWSBDCXibOgA0XoRjZQ0DAblTbYbbsDr
	 ctT2HQJgY427bG+sfZK2gIG4MYT+1YjoB/NMWrCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 643/676] i3c: master: svc: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Fri,  6 Dec 2024 15:37:42 +0100
Message-ID: <20241206143718.485356319@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
@@ -1684,8 +1684,8 @@ static int svc_i3c_master_probe(struct p
 rpm_disable:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 err_disable_clks:
 	svc_i3c_master_unprepare_clks(master);


