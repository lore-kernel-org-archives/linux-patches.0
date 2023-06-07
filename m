Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413AA39234
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3114C433D2;
	Wed,  7 Jun 2023 20:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169135;
	bh=rDBsBfUDYAlno5PU2UyKATVQtqlS35qV+l0vqdkbj6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyZLtm5xiWb2hNniHCoB5G8ykeeEg6ot+sqdIyK7MSRuH01b4ZD7/7SyRNqHNWbSj
	 BT+igt0wnkDFJpJyHvkTg8yiX71V2g7ojq9wuZuCdwy+lx8w+nrmvUKLF3KnNk70r7
	 D7RJDHENpVb2JYY+k0d0/KsYJDlk/ctS+obChozc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 27/61] media: dvb-core: Fix use-after-free due to race condition at dvb_ca_en50221
Date: Wed,  7 Jun 2023 22:15:41 +0200
Message-ID: <20230607200844.696814634@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200835.310274198@linuxfoundation.org>
References: <20230607200835.310274198@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hyunwoo Kim <v4bel@theori.io>

[ Upstream commit 280a8ab81733da8bc442253c700a52c4c0886ffd ]

If the device node of dvb_ca_en50221 is open() and the
device is disconnected, a UAF may occur when calling
close() on the device node.

The root cause is that wake_up() and wait_event() for
dvbdev->wait_queue are not implemented.

So implement wait_event() function in dvb_ca_en50221_release()
and add 'remove_mutex' which prevents race condition
for 'ca->exit'.

[mchehab: fix a checkpatch warning]

Link: https://lore.kernel.org/linux-media/20221121063308.GA33821@ubuntu
Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 37 ++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 56114d85510f5..5dc8b2d143520 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -161,6 +161,12 @@ struct dvb_ca_private {
 
 	/* mutex serializing ioctls */
 	struct mutex ioctl_mutex;
+
+	/* A mutex used when a device is disconnected */
+	struct mutex remove_mutex;
+
+	/* Whether the device is disconnected */
+	int exit;
 };
 
 static void dvb_ca_private_free(struct dvb_ca_private *ca)
@@ -1713,12 +1719,22 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 
 	dprintk("%s\n", __func__);
 
-	if (!try_module_get(ca->pub->owner))
+	mutex_lock(&ca->remove_mutex);
+
+	if (ca->exit) {
+		mutex_unlock(&ca->remove_mutex);
+		return -ENODEV;
+	}
+
+	if (!try_module_get(ca->pub->owner)) {
+		mutex_unlock(&ca->remove_mutex);
 		return -EIO;
+	}
 
 	err = dvb_generic_open(inode, file);
 	if (err < 0) {
 		module_put(ca->pub->owner);
+		mutex_unlock(&ca->remove_mutex);
 		return err;
 	}
 
@@ -1743,6 +1759,7 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 
 	dvb_ca_private_get(ca);
 
+	mutex_unlock(&ca->remove_mutex);
 	return 0;
 }
 
@@ -1762,6 +1779,8 @@ static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
 
 	dprintk("%s\n", __func__);
 
+	mutex_lock(&ca->remove_mutex);
+
 	/* mark the CA device as closed */
 	ca->open = 0;
 	dvb_ca_en50221_thread_update_delay(ca);
@@ -1772,6 +1791,13 @@ static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
 
 	dvb_ca_private_put(ca);
 
+	if (dvbdev->users == 1 && ca->exit == 1) {
+		mutex_unlock(&ca->remove_mutex);
+		wake_up(&dvbdev->wait_queue);
+	} else {
+		mutex_unlock(&ca->remove_mutex);
+	}
+
 	return err;
 }
 
@@ -1896,6 +1922,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	}
 
 	mutex_init(&ca->ioctl_mutex);
+	mutex_init(&ca->remove_mutex);
 
 	if (signal_pending(current)) {
 		ret = -EINTR;
@@ -1939,6 +1966,14 @@ void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
 
 	dprintk("%s\n", __func__);
 
+	mutex_lock(&ca->remove_mutex);
+	ca->exit = 1;
+	mutex_unlock(&ca->remove_mutex);
+
+	if (ca->dvbdev->users < 1)
+		wait_event(ca->dvbdev->wait_queue,
+				ca->dvbdev->users == 1);
+
 	/* shutdown the thread if there was one */
 	kthread_stop(ca->thread);
 
-- 
2.39.2



