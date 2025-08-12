Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A291282E1;
	Tue, 12 Aug 2025 18:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022155; cv=none; b=lDDx7/7Hz/6Tt4k+Y1JQMTByPv2fO4okdRyYLTGdvl9TEMv7gPxnwCuaQh0S1SFCq6aUVArpx/zy4KnTdrRWhb3ORzFK9KPbOs20ZkQzw35M4bwburFkxlgpxU+hiE+piz07AjFo3HJJQYVtv+aI2wuxO5AOhV5pEZ2UfKq18c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022155; c=relaxed/simple;
	bh=d2e+aCRBA6MKXeoDlZwqUIR0yk1EWeNxrAkqKSKFXhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bef21GYpJGVLihimiGFsJd9I0NUJmj8Df76sfXu0xuWLTX7w1GLgIhC5ah7u5rtW2bS8es8XsYOuD8Kn9VFlWbB8MsPcuMO+SNPgNleVzif0b9OI77K2q9M4J9semOGz7Ybw1dFMQ1J12L0F+1XzNNZxhAWJsLiYjdR2GbJsvOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOe3ZRSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOe3ZRSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626BCC4CEF6;
	Tue, 12 Aug 2025 18:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022154;
	bh=d2e+aCRBA6MKXeoDlZwqUIR0yk1EWeNxrAkqKSKFXhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOe3ZRSAVoZXJF+fF6nrkNGTDmurLckRP29mUwLJdmJRK3P215+8sPl2kVFcFJ0R2
	 UBuVQcKhURKypibKRR93SVJygjIXezt/3Mryao4GLMlCtAKTgnqXmW/LKv6gqI064Q
	 kBr3oZFYRYbcq7pmNdmkDbxlnFMkvhgHCSO8xT9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/369] mei: vsc: Event notifier fixes
Date: Tue, 12 Aug 2025 19:25:35 +0200
Message-ID: <20250812173016.194875860@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f8e622caec34..27c921c752e9 100644
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
 
@@ -401,6 +402,8 @@ EXPORT_SYMBOL_NS_GPL(vsc_tp_need_read, VSC_TP);
 int vsc_tp_register_event_cb(struct vsc_tp *tp, vsc_tp_event_cb_t event_cb,
 			    void *context)
 {
+	guard(mutex)(&tp->event_notify_mutex);
+
 	tp->event_notify = event_cb;
 	tp->event_notify_context = context;
 
@@ -532,6 +535,7 @@ static int vsc_tp_probe(struct spi_device *spi)
 		return ret;
 
 	mutex_init(&tp->mutex);
+	mutex_init(&tp->event_notify_mutex);
 
 	/* only one child acpi device */
 	ret = acpi_dev_for_each_child(ACPI_COMPANION(dev),
@@ -556,6 +560,7 @@ static int vsc_tp_probe(struct spi_device *spi)
 err_destroy_lock:
 	free_irq(spi->irq, tp);
 
+	mutex_destroy(&tp->event_notify_mutex);
 	mutex_destroy(&tp->mutex);
 
 	return ret;
@@ -569,6 +574,7 @@ static void vsc_tp_remove(struct spi_device *spi)
 
 	free_irq(spi->irq, tp);
 
+	mutex_destroy(&tp->event_notify_mutex);
 	mutex_destroy(&tp->mutex);
 }
 
-- 
2.39.5



