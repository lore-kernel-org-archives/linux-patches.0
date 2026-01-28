Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FD72DB791;
	Wed, 28 Jan 2026 16:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616059; cv=none; b=YseEir3IsTQ5bKDVX0gzAu7jc6iUKPdKVy2yrgRSJSQ8SUmkFGOrNzMcN1V0QTTYUprJddCCkjY6Uy5k87Ltsw17essRxhydKUvqhicjUe2gUPYNRn1Eq+oaKyQngwm0WpG9ZQNJ5OD5JguRk0FGi61hNq3M1A3kMUvnmL+jT5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616059; c=relaxed/simple;
	bh=yYffhX3I2oeHHt6tUTU58/YRziHVT3x0wVpnmTmz89g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toBJ4Fe6WA4jlMMthaEEjDvZcyUNtHCbALMDrmKvnAJtFIpO9v14sSU6q3Ny+9gJRz+bNYkXKpoeK3U8m08Jf+F7Fgxep9DvJ/JlwEIKdNakHgBK+8H4YOcmncL/p5II/8XN9wky5E0oMDw7+V3+OVRivm7Vt5W/6nNubeW3yhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AWoFJRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AWoFJRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 015A3C4CEF1;
	Wed, 28 Jan 2026 16:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616059;
	bh=yYffhX3I2oeHHt6tUTU58/YRziHVT3x0wVpnmTmz89g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0AWoFJRKFLaH5/2qMEVLjroIpobVSkJx8Qmk3Tq3jRA8qLpcj7RC1WijgGQA9WOBC
	 edv3EYuL/NitfXFXZ2pYtCKyDLyuTGksoG9kq5Zc0xeQUBY4vS47Llv6uJdEkBAxaz
	 Py6Pi1rCvdMdrNaokkuzRIXswhigaS/u2YukYkzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Yang Shen <shenyang39@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 6.18 194/227] uacce: ensure safe queue release with state management
Date: Wed, 28 Jan 2026 16:23:59 +0100
Message-ID: <20260128145351.426980967@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghai Huang <huangchenghai2@huawei.com>

commit 26c08dabe5475d99a13f353d8dd70e518de45663 upstream.

Directly calling `put_queue` carries risks since it cannot
guarantee that resources of `uacce_queue` have been fully released
beforehand. So adding a `stop_queue` operation for the
UACCE_CMD_PUT_Q command and leaving the `put_queue` operation to
the final resource release ensures safety.

Queue states are defined as follows:
- UACCE_Q_ZOMBIE: Initial state
- UACCE_Q_INIT: After opening `uacce`
- UACCE_Q_STARTED: After `start` is issued via `ioctl`

When executing `poweroff -f` in virt while accelerator are still
working, `uacce_fops_release` and `uacce_remove` may execute
concurrently. This can cause `uacce_put_queue` within
`uacce_fops_release` to access a NULL `ops` pointer. Therefore, add
state checks to prevent accessing freed pointers.

Fixes: 015d239ac014 ("uacce: add uacce driver")
Cc: stable@vger.kernel.org
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Link: https://patch.msgid.link/20251202061256.4158641-5-huangchenghai2@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/uacce/uacce.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -40,20 +40,34 @@ static int uacce_start_queue(struct uacc
 	return 0;
 }
 
-static int uacce_put_queue(struct uacce_queue *q)
+static int uacce_stop_queue(struct uacce_queue *q)
 {
 	struct uacce_device *uacce = q->uacce;
 
-	if ((q->state == UACCE_Q_STARTED) && uacce->ops->stop_queue)
+	if (q->state != UACCE_Q_STARTED)
+		return 0;
+
+	if (uacce->ops->stop_queue)
 		uacce->ops->stop_queue(q);
 
-	if ((q->state == UACCE_Q_INIT || q->state == UACCE_Q_STARTED) &&
-	     uacce->ops->put_queue)
+	q->state = UACCE_Q_INIT;
+
+	return 0;
+}
+
+static void uacce_put_queue(struct uacce_queue *q)
+{
+	struct uacce_device *uacce = q->uacce;
+
+	uacce_stop_queue(q);
+
+	if (q->state != UACCE_Q_INIT)
+		return;
+
+	if (uacce->ops->put_queue)
 		uacce->ops->put_queue(q);
 
 	q->state = UACCE_Q_ZOMBIE;
-
-	return 0;
 }
 
 static long uacce_fops_unl_ioctl(struct file *filep,
@@ -80,7 +94,7 @@ static long uacce_fops_unl_ioctl(struct
 		ret = uacce_start_queue(q);
 		break;
 	case UACCE_CMD_PUT_Q:
-		ret = uacce_put_queue(q);
+		ret = uacce_stop_queue(q);
 		break;
 	default:
 		if (uacce->ops->ioctl)


