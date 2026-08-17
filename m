Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2344442365;
	Mon, 17 Aug 2026 15:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979405; cv=none; b=u7MDDE+Zc4BPopXHPrjpoUbA39T+G2+vR/NzQ0mgQOODOb1Vy65gSN9Gsfr+B5av87pNDvfoUeCHx4IVYoG7kJ7LQkW9n5xMPXyWdRH5rhstzxZB2WmYpJvUPkfQr9WhH81DWx4Ws5hBztc6hvSM186OSj5XFqY+nYJn7HSj7RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979405; c=relaxed/simple;
	bh=dcOtyVzKnGDRkolO44k2XGVpKcZ6cgOXCZshl5hYb74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzOGw7ZQ2BL4wngDBJ4d6GiUUHqtwZ/loJUR9gZVu+FROfu6PHj/nLu8+2ZlybmfmDfadj82DAXaFkqmnDW1iX/8Gmw5+p41RkzbPNsw05R0gdCYw8GJpZ3ajCn5toHF5OnxB5fAioS12T3+nHx8Irw5Mqtd/NiLtKbJj0iQsFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYX+teXf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYX+teXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737821F000E9;
	Mon, 17 Aug 2026 15:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979403;
	bh=9LKTSqgteaB3OyIFYwBjMG3X8RDe6Yo0R6HAgxUPLxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cYX+teXfm6rLrD/Ek+XN7Ja2axM3JATy5p7E+SwNqb488Rv7OAKcmKwMgMHkPc6F6
	 Xz4BOP2nCbRRK1diRbHpxT9dViY075HWpwCdkyVCmUb8UYNPgja17AicPgnAggBT05
	 lKHUfvh3dYBul/KzmxJ2mI9ef6ni49715b+lRnoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 214/609] media: vimc: fix reference leak on failed device registration
Date: Mon, 17 Aug 2026 15:28:30 +0200
Message-ID: <20260817132551.250550224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 33e2b833c66b890a0d71c4fa82d4c97143f7f75f upstream.

When platform_device_register() fails in vimc_init(), the embedded
struct device in vimc_pdev has already been initialized by
device_initialize(), but the failure path returns the error without
dropping the device reference for the current platform device:

  vimc_init()
    -> platform_device_register(&vimc_pdev)
       -> device_initialize(&vimc_pdev.dev)
       -> setup_pdev_dma_masks(&vimc_pdev)
       -> platform_device_add(&vimc_pdev)

This leads to a reference leak when platform_device_register() fails.
Fix this by calling platform_device_put() before returning the error.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 4babf057c143f ("media: vimc: allocate vimc_device dynamically")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vimc/vimc-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/test-drivers/vimc/vimc-core.c
+++ b/drivers/media/test-drivers/vimc/vimc-core.c
@@ -426,6 +426,7 @@ static int __init vimc_init(void)
 	if (ret) {
 		dev_err(&vimc_pdev.dev,
 			"platform device registration failed (err=%d)\n", ret);
+		platform_device_put(&vimc_pdev);
 		return ret;
 	}
 


