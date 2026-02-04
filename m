Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB6741325F;
	Wed,  4 Feb 2026 14:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216608; cv=none; b=Jhfz0wxNI3L88gykjP5DAuzDIjJ5y6cQw/aFYErObLqAmQkSZefmpmidpluLJmJPw9Am5KgB68+viQuOO+NmY+enQerZ0a8rmtQclEFs1sXe5jnknwL8kTO2wMcoQgnKNqSXRN0AgUI+7df8eEOjBlvJKYT91+utJ5EFKALGYHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216608; c=relaxed/simple;
	bh=fUvnXsfuPPzgExvHIDqGlcY75WIrkm9p15qvoZmB8Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cv18QA2LBYZ044s4M79Dgoo28LYtfW/xxvaKbwwSAqP7PZ8gKoNl0nikyto33EIqBrUyVW3QJCEopHsLVsketgSZEkmqCULxC1blFPn6/XWN99UFISg7G5a5FHzGe0SXAagF8fvE/E1NKT0h20xCW4UCQuaNxbWjnk73lNU4zMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWLXW7z+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWLXW7z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EC1C4CEF7;
	Wed,  4 Feb 2026 14:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216607;
	bh=fUvnXsfuPPzgExvHIDqGlcY75WIrkm9p15qvoZmB8Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWLXW7z+ehNM/rZ5I73mzMi0bbWLdK3BBgX4/1/txDmRFQQVKrSOFomkrp8HiTx1j
	 11Egl+4t69X3SJgL6j/PHgT5HgvBPjouc/yhDtk7CHKX0IBk0kCqUpYr/EFIMHh4sz
	 /AYij0dk35G6Z92LN1UnWEYbhoHy7iQJ+PC6TKvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Yang Shen <shenyang39@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH 5.10 104/161] uacce: ensure safe queue release with state management
Date: Wed,  4 Feb 2026 15:39:27 +0100
Message-ID: <20260204143855.488999316@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -37,20 +37,34 @@ static int uacce_start_queue(struct uacc
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
@@ -77,7 +91,7 @@ static long uacce_fops_unl_ioctl(struct
 		ret = uacce_start_queue(q);
 		break;
 	case UACCE_CMD_PUT_Q:
-		ret = uacce_put_queue(q);
+		ret = uacce_stop_queue(q);
 		break;
 	default:
 		if (uacce->ops->ioctl)


