Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531751863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB37C433EF;
	Wed, 28 Dec 2022 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242488;
	bh=n5oSDoJMl6ToX6z7RUTJkH1joAmDLXczJ1jnjU7Fk/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfGOR5Vy3vrbNt1BsVjaz+/+gzSoAbCEiYrUPhoyl/f+Ax8fENSlJYPJJfPdqh2OL
	 efltTxfJFmF/RjGm1chIg9f8YPTxgHUyTiKNnDHIo2giLjKMKwVe2cZYokkPGcP+zX
	 CaPSvrWSJ3ZaLQLoOmGUvQGgp2Jez2w+ystg7IDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Jassi Brar <jaswinder.singh@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 609/731] mailbox: zynq-ipi: fix error handling while device_register() fails
Date: Wed, 28 Dec 2022 15:41:56 +0100
Message-Id: <20221228144314.190254517@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a6792a0cdef0b1c2d77920246283a72537e60e94 ]

If device_register() fails, it has two issues:
1. The name allocated by dev_set_name() is leaked.
2. The parent of device is not NULL, device_unregister() is called
   in zynqmp_ipi_free_mboxes(), it will lead a kernel crash because
   of removing not added device.

Call put_device() to give up the reference, so the name is freed in
kobject_cleanup(). Add device registered check in zynqmp_ipi_free_mboxes()
to avoid null-ptr-deref.

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index f44079d62b1a..527204c6d5cd 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -493,6 +493,7 @@ static int zynqmp_ipi_mbox_probe(struct zynqmp_ipi_mbox *ipi_mbox,
 	ret = device_register(&ipi_mbox->dev);
 	if (ret) {
 		dev_err(dev, "Failed to register ipi mbox dev.\n");
+		put_device(&ipi_mbox->dev);
 		return ret;
 	}
 	mdev = &ipi_mbox->dev;
@@ -619,7 +620,8 @@ static void zynqmp_ipi_free_mboxes(struct zynqmp_ipi_pdata *pdata)
 		ipi_mbox = &pdata->ipi_mboxes[i];
 		if (ipi_mbox->dev.parent) {
 			mbox_controller_unregister(&ipi_mbox->mbox);
-			device_unregister(&ipi_mbox->dev);
+			if (device_is_registered(&ipi_mbox->dev))
+				device_unregister(&ipi_mbox->dev);
 		}
 	}
 }
-- 
2.35.1



