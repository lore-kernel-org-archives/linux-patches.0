Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261452BE62B;
	Wed,  4 Feb 2026 14:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216295; cv=none; b=YBPRmxwMCFQ5Hyg0K17d9eW53X42nV5Ypei323EyAT3TMAiKzBmNBgolxqWmZP45FZTD1yGEdqCrJwEbvMSpuVDuCSdKIjiQIBlxL8T/yljmqRYoFThqyPVBwcGpvGPR/MFjbTd4qszmK5Qs67gcuKyxHBaHGV3JDvN9s5T67ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216295; c=relaxed/simple;
	bh=9gR4qAThj5M1VzSew8vX+SV0jHDt807p5BtHax1LhOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdgR7skwF+yfBDDavn0IW2cR2GX+Bw/5v9+kvfoHEX7EVtrNJgQ0P8rgXkq1hdjMGXIrIvnUaMtIXMjrWFsxEo+srd3Ip6155TWrciDeXj1Q6efaFF8Xp27iSKmOzw5X7vWR0TvNr4d9G1aiCz0e1oBHiYhDFZJobdbqV8KakgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTLntQmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTLntQmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B831C4CEF7;
	Wed,  4 Feb 2026 14:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216294;
	bh=9gR4qAThj5M1VzSew8vX+SV0jHDt807p5BtHax1LhOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTLntQmZa3Hyvt+BcX1ekkzJN2OGbKGlywwalCXVzWE3BJ5Quuaz/f8KaCqspqu5b
	 p+nO9uupptTMrhlYliBG+eyhDbGrn01wEZ4E0TeHE70cqHOZR0N7/VLXL9NpF6kLfF
	 8Kdf9Z+oTOHrzyGB41dZJiIVxsMBLbueAnkzexL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xabier Marquiegui <reibax@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/161] posix-clock: introduce posix_clock_context concept
Date: Wed,  4 Feb 2026 15:38:28 +0100
Message-ID: <20260204143853.385005546@linuxfoundation.org>
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

From: Xabier Marquiegui <reibax@gmail.com>

[ Upstream commit 60c6946675fc06dd2fd2b7a4b6fd1c1f046f1056 ]

Add the necessary structure to support custom private-data per
posix-clock user.

The previous implementation of posix-clock assumed all file open
instances need access to the same clock structure on private_data.

The need for individual data structures per file open instance has been
identified when developing support for multiple timestamp event queue
users for ptp_clock.

Signed-off-by: Xabier Marquiegui <reibax@gmail.com>
Suggested-by: Richard Cochran <richardcochran@gmail.com>
Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e859d375d169 ("posix-clock: Store file pointer in struct posix_clock_context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_chardev.c   | 21 +++++++++++++--------
 drivers/ptp/ptp_private.h   | 16 +++++++++-------
 include/linux/posix-clock.h | 35 +++++++++++++++++++++++++++--------
 kernel/time/posix-clock.c   | 36 +++++++++++++++++++++++++++---------
 4 files changed, 76 insertions(+), 32 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 8eb902fe73a98..2776f37713123 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -102,14 +102,16 @@ int ptp_set_pinfunc(struct ptp_clock *ptp, unsigned int pin,
 	return 0;
 }
 
-int ptp_open(struct posix_clock *pc, fmode_t fmode)
+int ptp_open(struct posix_clock_context *pccontext, fmode_t fmode)
 {
 	return 0;
 }
 
-long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
+long ptp_ioctl(struct posix_clock_context *pccontext, unsigned int cmd,
+	       unsigned long arg)
 {
-	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
+	struct ptp_clock *ptp =
+		container_of(pccontext->clk, struct ptp_clock, clock);
 	struct ptp_sys_offset_extended *extoff = NULL;
 	struct ptp_sys_offset_precise precise_offset;
 	struct system_device_crosststamp xtstamp;
@@ -430,9 +432,11 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 	return err;
 }
 
-__poll_t ptp_poll(struct posix_clock *pc, struct file *fp, poll_table *wait)
+__poll_t ptp_poll(struct posix_clock_context *pccontext, struct file *fp,
+		  poll_table *wait)
 {
-	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
+	struct ptp_clock *ptp =
+		container_of(pccontext->clk, struct ptp_clock, clock);
 
 	poll_wait(fp, &ptp->tsev_wq, wait);
 
@@ -441,10 +445,11 @@ __poll_t ptp_poll(struct posix_clock *pc, struct file *fp, poll_table *wait)
 
 #define EXTTS_BUFSIZE (PTP_BUF_TIMESTAMPS * sizeof(struct ptp_extts_event))
 
-ssize_t ptp_read(struct posix_clock *pc,
-		 uint rdflags, char __user *buf, size_t cnt)
+ssize_t ptp_read(struct posix_clock_context *pccontext, uint rdflags,
+		 char __user *buf, size_t cnt)
 {
-	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
+	struct ptp_clock *ptp =
+		container_of(pccontext->clk, struct ptp_clock, clock);
 	struct timestamp_event_queue *queue = &ptp->tsevq;
 	struct ptp_extts_event *event;
 	unsigned long flags;
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index d2cb956706763..ba3a1a29a288a 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -73,16 +73,18 @@ static inline int queue_cnt(const struct timestamp_event_queue *q)
 int ptp_set_pinfunc(struct ptp_clock *ptp, unsigned int pin,
 		    enum ptp_pin_function func, unsigned int chan);
 
-long ptp_ioctl(struct posix_clock *pc,
-	       unsigned int cmd, unsigned long arg);
+long ptp_ioctl(struct posix_clock_context *pccontext, unsigned int cmd,
+	       unsigned long arg);
 
-int ptp_open(struct posix_clock *pc, fmode_t fmode);
+int ptp_open(struct posix_clock_context *pccontext, fmode_t fmode);
 
-ssize_t ptp_read(struct posix_clock *pc,
-		 uint flags, char __user *buf, size_t cnt);
+int ptp_release(struct posix_clock_context *pccontext);
 
-__poll_t ptp_poll(struct posix_clock *pc,
-	      struct file *fp, poll_table *wait);
+ssize_t ptp_read(struct posix_clock_context *pccontext, uint flags, char __user *buf,
+		 size_t cnt);
+
+__poll_t ptp_poll(struct posix_clock_context *pccontext, struct file *fp,
+		  poll_table *wait);
 
 /*
  * see ptp_sysfs.c
diff --git a/include/linux/posix-clock.h b/include/linux/posix-clock.h
index 468328b1e1dd5..ef8619f489203 100644
--- a/include/linux/posix-clock.h
+++ b/include/linux/posix-clock.h
@@ -14,6 +14,7 @@
 #include <linux/rwsem.h>
 
 struct posix_clock;
+struct posix_clock_context;
 
 /**
  * struct posix_clock_operations - functional interface to the clock
@@ -50,18 +51,18 @@ struct posix_clock_operations {
 	/*
 	 * Optional character device methods:
 	 */
-	long    (*ioctl)   (struct posix_clock *pc,
-			    unsigned int cmd, unsigned long arg);
+	long (*ioctl)(struct posix_clock_context *pccontext, unsigned int cmd,
+		      unsigned long arg);
 
-	int     (*open)    (struct posix_clock *pc, fmode_t f_mode);
+	int (*open)(struct posix_clock_context *pccontext, fmode_t f_mode);
 
-	__poll_t (*poll)   (struct posix_clock *pc,
-			    struct file *file, poll_table *wait);
+	__poll_t (*poll)(struct posix_clock_context *pccontext, struct file *file,
+			 poll_table *wait);
 
-	int     (*release) (struct posix_clock *pc);
+	int (*release)(struct posix_clock_context *pccontext);
 
-	ssize_t (*read)    (struct posix_clock *pc,
-			    uint flags, char __user *buf, size_t cnt);
+	ssize_t (*read)(struct posix_clock_context *pccontext, uint flags,
+			char __user *buf, size_t cnt);
 };
 
 /**
@@ -90,6 +91,24 @@ struct posix_clock {
 	bool zombie;
 };
 
+/**
+ * struct posix_clock_context - represents clock file operations context
+ *
+ * @clk:              Pointer to the clock
+ * @private_clkdata:  Pointer to user data
+ *
+ * Drivers should use struct posix_clock_context during specific character
+ * device file operation methods to access the posix clock.
+ *
+ * Drivers can store a private data structure during the open operation
+ * if they have specific information that is required in other file
+ * operations.
+ */
+struct posix_clock_context {
+	struct posix_clock *clk;
+	void *private_clkdata;
+};
+
 /**
  * posix_clock_register() - register a new clock
  * @clk:   Pointer to the clock. Caller must provide 'ops' field
diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index 05e73d209aa87..706559ed75793 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -19,7 +19,8 @@
  */
 static struct posix_clock *get_posix_clock(struct file *fp)
 {
-	struct posix_clock *clk = fp->private_data;
+	struct posix_clock_context *pccontext = fp->private_data;
+	struct posix_clock *clk = pccontext->clk;
 
 	down_read(&clk->rwsem);
 
@@ -39,6 +40,7 @@ static void put_posix_clock(struct posix_clock *clk)
 static ssize_t posix_clock_read(struct file *fp, char __user *buf,
 				size_t count, loff_t *ppos)
 {
+	struct posix_clock_context *pccontext = fp->private_data;
 	struct posix_clock *clk = get_posix_clock(fp);
 	int err = -EINVAL;
 
@@ -46,7 +48,7 @@ static ssize_t posix_clock_read(struct file *fp, char __user *buf,
 		return -ENODEV;
 
 	if (clk->ops.read)
-		err = clk->ops.read(clk, fp->f_flags, buf, count);
+		err = clk->ops.read(pccontext, fp->f_flags, buf, count);
 
 	put_posix_clock(clk);
 
@@ -55,6 +57,7 @@ static ssize_t posix_clock_read(struct file *fp, char __user *buf,
 
 static __poll_t posix_clock_poll(struct file *fp, poll_table *wait)
 {
+	struct posix_clock_context *pccontext = fp->private_data;
 	struct posix_clock *clk = get_posix_clock(fp);
 	__poll_t result = 0;
 
@@ -62,7 +65,7 @@ static __poll_t posix_clock_poll(struct file *fp, poll_table *wait)
 		return EPOLLERR;
 
 	if (clk->ops.poll)
-		result = clk->ops.poll(clk, fp, wait);
+		result = clk->ops.poll(pccontext, fp, wait);
 
 	put_posix_clock(clk);
 
@@ -72,6 +75,7 @@ static __poll_t posix_clock_poll(struct file *fp, poll_table *wait)
 static long posix_clock_ioctl(struct file *fp,
 			      unsigned int cmd, unsigned long arg)
 {
+	struct posix_clock_context *pccontext = fp->private_data;
 	struct posix_clock *clk = get_posix_clock(fp);
 	int err = -ENOTTY;
 
@@ -79,7 +83,7 @@ static long posix_clock_ioctl(struct file *fp,
 		return -ENODEV;
 
 	if (clk->ops.ioctl)
-		err = clk->ops.ioctl(clk, cmd, arg);
+		err = clk->ops.ioctl(pccontext, cmd, arg);
 
 	put_posix_clock(clk);
 
@@ -90,6 +94,7 @@ static long posix_clock_ioctl(struct file *fp,
 static long posix_clock_compat_ioctl(struct file *fp,
 				     unsigned int cmd, unsigned long arg)
 {
+	struct posix_clock_context *pccontext = fp->private_data;
 	struct posix_clock *clk = get_posix_clock(fp);
 	int err = -ENOTTY;
 
@@ -97,7 +102,7 @@ static long posix_clock_compat_ioctl(struct file *fp,
 		return -ENODEV;
 
 	if (clk->ops.ioctl)
-		err = clk->ops.ioctl(clk, cmd, arg);
+		err = clk->ops.ioctl(pccontext, cmd, arg);
 
 	put_posix_clock(clk);
 
@@ -110,6 +115,7 @@ static int posix_clock_open(struct inode *inode, struct file *fp)
 	int err;
 	struct posix_clock *clk =
 		container_of(inode->i_cdev, struct posix_clock, cdev);
+	struct posix_clock_context *pccontext;
 
 	down_read(&clk->rwsem);
 
@@ -117,14 +123,20 @@ static int posix_clock_open(struct inode *inode, struct file *fp)
 		err = -ENODEV;
 		goto out;
 	}
+	pccontext = kzalloc(sizeof(*pccontext), GFP_KERNEL);
+	if (!pccontext) {
+		err = -ENOMEM;
+		goto out;
+	}
+	pccontext->clk = clk;
+	fp->private_data = pccontext;
 	if (clk->ops.open)
-		err = clk->ops.open(clk, fp->f_mode);
+		err = clk->ops.open(pccontext, fp->f_mode);
 	else
 		err = 0;
 
 	if (!err) {
 		get_device(clk->dev);
-		fp->private_data = clk;
 	}
 out:
 	up_read(&clk->rwsem);
@@ -133,14 +145,20 @@ static int posix_clock_open(struct inode *inode, struct file *fp)
 
 static int posix_clock_release(struct inode *inode, struct file *fp)
 {
-	struct posix_clock *clk = fp->private_data;
+	struct posix_clock_context *pccontext = fp->private_data;
+	struct posix_clock *clk;
 	int err = 0;
 
+	if (!pccontext)
+		return -ENODEV;
+	clk = pccontext->clk;
+
 	if (clk->ops.release)
-		err = clk->ops.release(clk);
+		err = clk->ops.release(pccontext);
 
 	put_device(clk->dev);
 
+	kfree(pccontext);
 	fp->private_data = NULL;
 
 	return err;
-- 
2.51.0



