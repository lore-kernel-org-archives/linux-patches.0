Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CE7260583;
	Tue, 12 Aug 2025 19:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025486; cv=none; b=Rpe+Yn8AxihbRbecy6pNabRbu4I9eaf7lERvEkyV3tbSK22C7+UcZR767WcK30pLlr2FuGc1TxZpeY4CLwoduIYWh0dQvhOSBj+10DGlJXtiCqVgIw+cngqcvyqjIBzOFQqOZvU4Yb3rDLTZTvTh+i8+h4A8iTVgX5fy/Bfd21I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025486; c=relaxed/simple;
	bh=2blicBxsBnEgLCC4fRuB8Go3oHgYTrl/c9GtrPvGutk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYSoGp3k/PfdB08UCmfDbpZ7JRJ+uyUzKORIofHx2HAH8KouWVmKGDVFJ5eJ74roMV0+QJlfDSiLMeFGqTr7zd3zh9f1MabTBxL/koUSP76T1mFJPXXDR3j4XOxt188CHx/sTyrHtYA9y3SqeHYDawuDo6wd/ZlHDMnYZ56wMbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7Kp+jy2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7Kp+jy2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0735BC4CEF0;
	Tue, 12 Aug 2025 19:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025486;
	bh=2blicBxsBnEgLCC4fRuB8Go3oHgYTrl/c9GtrPvGutk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7Kp+jy20evqNP34ezzpCZsYzXjWjC169T314KzxST7WGg1S3qK4vtqxGGfeW9tYC
	 0GUCO0Nk8LDwNozIWkOHr7SahHKwpHxrkl2EB5XR7Ogt063cmUFqrQiBgIm29J/A69
	 /eQFjNY/uJw5teMOofL165NvcEGzKhntGEsfCf0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 056/480] mei: vsc: Event notifier fixes
Date: Tue, 12 Aug 2025 19:44:24 +0200
Message-ID: <20250812174359.729840255@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 18f14b2e7f73c7ec272d833d570b632286467c7d ]

vsc_tp_register_event_cb() can race with vsc_tp_thread_isr(), add a mutex
to protect against this.

Fixes: 566f5ca97680 ("mei: Add transport driver for IVSC device")
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250623085052.12347-7-hansg@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/vsc-tp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/vsc-tp.c b/drivers/misc/mei/vsc-tp.c
index 66b41b86ea7d..97df3077175d 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -79,9 +79,8 @@ struct vsc_tp {
 
 	vsc_tp_event_cb_t event_notify;
 	void *event_notify_context;
-
-	/* used to protect command download */
-	struct mutex mutex;
+	struct mutex event_notify_mutex;	/* protects event_notify + context */
+	struct mutex mutex;			/* protects command download */
 };
 
 /* GPIO resources */
@@ -113,6 +112,8 @@ static irqreturn_t vsc_tp_thread_isr(int irq, void *data)
 {
 	struct vsc_tp *tp = data;
 
+	guard(mutex)(&tp->event_notify_mutex);
+
 	if (tp->event_notify)
 		tp->event_notify(tp->event_notify_context);
 
@@ -399,6 +400,8 @@ EXPORT_SYMBOL_NS_GPL(vsc_tp_need_read, "VSC_TP");
 int vsc_tp_register_event_cb(struct vsc_tp *tp, vsc_tp_event_cb_t event_cb,
 			    void *context)
 {
+	guard(mutex)(&tp->event_notify_mutex);
+
 	tp->event_notify = event_cb;
 	tp->event_notify_context = context;
 
@@ -530,6 +533,7 @@ static int vsc_tp_probe(struct spi_device *spi)
 		return ret;
 
 	mutex_init(&tp->mutex);
+	mutex_init(&tp->event_notify_mutex);
 
 	/* only one child acpi device */
 	ret = acpi_dev_for_each_child(ACPI_COMPANION(dev),
@@ -554,6 +558,7 @@ static int vsc_tp_probe(struct spi_device *spi)
 err_destroy_lock:
 	free_irq(spi->irq, tp);
 
+	mutex_destroy(&tp->event_notify_mutex);
 	mutex_destroy(&tp->mutex);
 
 	return ret;
@@ -567,6 +572,7 @@ static void vsc_tp_remove(struct spi_device *spi)
 
 	free_irq(spi->irq, tp);
 
+	mutex_destroy(&tp->event_notify_mutex);
 	mutex_destroy(&tp->mutex);
 }
 
-- 
2.39.5



