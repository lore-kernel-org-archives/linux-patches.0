Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6392B6BB5B;
	Tue, 12 Aug 2025 18:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023511; cv=none; b=dwQxMaRa8RvZaQRcp0R+RQv1T4iQFO/NLrpoSiS5pYN5QS+JHrXBSYArpntJxslH6s3w6NuJJrn3f5C5DqrIXAXMsbXDF6naNT0chNRsFLmXVsJVw8iqhhU6QZ8GBa3X+FMuU/t06mk0RCohNscZxWCq1SWFVxIbji94OEp/aHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023511; c=relaxed/simple;
	bh=Rd81Hh35qAMGElIysi2X9ATpOlFDU/1pcjhIz5sihZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTw1SkhDal5R+KiAzXzw4dKGrPORR2kMLpnOnvaE/+AOZIyaXp5xiiKCtQeU9fSOgco5qvTC0snhrGxY6kak7nQTPZm7zzMnOdwCFy7uuVf2EIdAjndcOHFn7Ks9jBIhRSLtoa8dIeBD0yLgAb5FtdePjzxv+tA0+re4dXjIiHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGB2vQBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGB2vQBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EB3C4CEF0;
	Tue, 12 Aug 2025 18:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023511;
	bh=Rd81Hh35qAMGElIysi2X9ATpOlFDU/1pcjhIz5sihZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGB2vQByQdaPdW5nG59PNP4QQrJdQaSttJcNFTZ1rYQ07kWo6JRKW1FY0f1gDZLjJ
	 ed29H2tNW+ZT+IE59cmzc8FfvV3oqdVwgE1H+A8Z84yEYj8TCk2X5JKyPd62JsGtOn
	 hF00ZW3IB0BSjWVPTWsv2w2i05KZssdfVw4osVTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 068/627] mei: vsc: Event notifier fixes
Date: Tue, 12 Aug 2025 19:26:03 +0200
Message-ID: <20250812173421.905776157@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



