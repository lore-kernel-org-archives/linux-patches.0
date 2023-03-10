Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA608481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8F2C433EF;
	Fri, 10 Mar 2023 14:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457191;
	bh=S0HDVV2yvJt7Ovmtzuum2uB4opbL+9YuYuODPViDJqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isPX78mpekjXpkw3+FjJ0M/Pm5bTptUB4k1JlurDCM9U80QHxQIKgTd4YqTAKQZMR
	 DOc53nq/fL0nkrFg9ZwWKuPvwDxS6GkdPdY9y357Vg6AyOw2pVy+a8ZWwFzGybdWe5
	 bA/hI7cC8fbsZ0puKHekdlWpdORQtpPcUPaCPY68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/200] um: virtio_uml: move device breaking into workqueue
Date: Fri, 10 Mar 2023 14:37:38 +0100
Message-Id: <20230310133718.677403564@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit abdeb4fa5e1b5b4918034f02236fd886f40c20c1 ]

We should not be calling virtio_break_device from an IRQ context.
Move breaking the device into the workqueue so that it is done from
a reasonable context.

Fixes: af9fb41ed315 ("um: virtio_uml: Fix broken device handling in time-travel")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index dcfd0ca534eef..ddd080f6dd82e 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -170,7 +170,6 @@ static void vhost_user_check_reset(struct virtio_uml_device *vu_dev,
 
 	vu_dev->registered = 0;
 
-	virtio_break_device(&vu_dev->vdev);
 	schedule_work(&pdata->conn_broken_wk);
 }
 
@@ -1138,6 +1137,15 @@ void virtio_uml_set_no_vq_suspend(struct virtio_device *vdev,
 
 static void vu_of_conn_broken(struct work_struct *wk)
 {
+	struct virtio_uml_platform_data *pdata;
+	struct virtio_uml_device *vu_dev;
+
+	pdata = container_of(wk, struct virtio_uml_platform_data, conn_broken_wk);
+
+	vu_dev = platform_get_drvdata(pdata->pdev);
+
+	virtio_break_device(&vu_dev->vdev);
+
 	/*
 	 * We can't remove the device from the devicetree so the only thing we
 	 * can do is warn.
@@ -1268,8 +1276,14 @@ static int vu_unregister_cmdline_device(struct device *dev, void *data)
 static void vu_conn_broken(struct work_struct *wk)
 {
 	struct virtio_uml_platform_data *pdata;
+	struct virtio_uml_device *vu_dev;
 
 	pdata = container_of(wk, struct virtio_uml_platform_data, conn_broken_wk);
+
+	vu_dev = platform_get_drvdata(pdata->pdev);
+
+	virtio_break_device(&vu_dev->vdev);
+
 	vu_unregister_cmdline_device(&pdata->pdev->dev, NULL);
 }
 
-- 
2.39.2



