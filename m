Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE08375AC3;
	Thu, 30 Jul 2026 14:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422718; cv=none; b=QovC48ITga/PbaIIulqCcF/fPviiBMy5+oV4JDu1wVUYESwrbDHrQZCWwXptibT5SqkJZMwtelnAMI8EhvUDCyxmWMDSW8hLJSugFxCoOZSQgnfIIvhVyg0vNSAms2cvdpCt9/MNBnHdBDIw3hHRYCIRpmDQ5ds3VvChXCWYetA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422718; c=relaxed/simple;
	bh=04eKJ2MaXtEi51vfOr6KKqrca1WSLGOv1vEiqKQzRK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AV79CtaYLS4+v9Rxahv0D2IPBk0hGmLdxPDYl0Dla3cgucZS+P+uRuP1u6xcqobDrv7o6pwnq2NvPmsCm/ZdNhl6cGYY0fH82IPC12QnWPK8mxU8wsob/ImXBDPDBPbsm0b3KSgC0tY17mQ3z/QYGZ2slKVn5YnqMr1U173pW2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyCyy7o0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyCyy7o0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58B01F000E9;
	Thu, 30 Jul 2026 14:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422717;
	bh=RgyQ7p6cEJfDNupGxgq/iQ0Cw9i4IUjV0lQVTVCWn8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dyCyy7o0NFlaxIyCoLoZBr6ght+memq2sk9vEBYXzriR/sMCg0k70YH6S3wfnhNV3
	 L+uCZyG2eCic2ni+Qdw7jeUSWoh0KFK9j9Psi8lsrD/Z5WcYlaG3sq1scV+uy4wGrR
	 KDOn96x3+EdSNH/HFgivLjKhjuux3ztIsbBRvM3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 533/744] media: vimc: fix reference leak on failed device registration
Date: Thu, 30 Jul 2026 16:13:26 +0200
Message-ID: <20260730141455.600663986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -421,6 +421,7 @@ static int __init vimc_init(void)
 	if (ret) {
 		dev_err(&vimc_pdev.dev,
 			"platform device registration failed (err=%d)\n", ret);
+		platform_device_put(&vimc_pdev);
 		return ret;
 	}
 


