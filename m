Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF5212B9E
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iP9FBocY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEE8C433C7;
	Mon, 23 Oct 2023 11:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059360;
	bh=M3BSKEX2ahY37YgAv5jpxmUxFbKCjaBzdER2EVBP9C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iP9FBocYe9uj8y3M/U/Jck756i7As2DNjtdg1JR8skCJGx2USt1xYou6xcFQ1uOnw
	 9MOebTbWIz0420FHptO6ANdhjgUc54niW8CzX87UCvIb05tMvJuUS+BvN05hHJkuGI
	 9xRYD3hjpqjXSBHUU5rwX/VUsiLNaWP/9QXS+QHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 115/241] rfkill: sync before userspace visibility/changes
Date: Mon, 23 Oct 2023 12:55:01 +0200
Message-ID: <20231023104836.689871403@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2c3dfba4cf84ac4f306cc6653b37b6dd6859ae9d ]

If userspace quickly opens /dev/rfkill after a new
instance was created, it might see the old state of
the instance from before the sync work runs and may
even _change_ the state, only to have the sync work
change it again.

Fix this by doing the sync inline where needed, not
just for /dev/rfkill but also for sysfs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rfkill/core.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 01fca7a10b4bb..08630896b6c88 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -48,6 +48,7 @@ struct rfkill {
 	bool			persistent;
 	bool			polling_paused;
 	bool			suspended;
+	bool			need_sync;
 
 	const struct rfkill_ops	*ops;
 	void			*data;
@@ -368,6 +369,17 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
 		rfkill_event(rfkill);
 }
 
+static void rfkill_sync(struct rfkill *rfkill)
+{
+	lockdep_assert_held(&rfkill_global_mutex);
+
+	if (!rfkill->need_sync)
+		return;
+
+	rfkill_set_block(rfkill, rfkill_global_states[rfkill->type].cur);
+	rfkill->need_sync = false;
+}
+
 static void rfkill_update_global_state(enum rfkill_type type, bool blocked)
 {
 	int i;
@@ -730,6 +742,10 @@ static ssize_t soft_show(struct device *dev, struct device_attribute *attr,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
+	mutex_lock(&rfkill_global_mutex);
+	rfkill_sync(rfkill);
+	mutex_unlock(&rfkill_global_mutex);
+
 	return sysfs_emit(buf, "%d\n", (rfkill->state & RFKILL_BLOCK_SW) ? 1 : 0);
 }
 
@@ -751,6 +767,7 @@ static ssize_t soft_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	mutex_lock(&rfkill_global_mutex);
+	rfkill_sync(rfkill);
 	rfkill_set_block(rfkill, state);
 	mutex_unlock(&rfkill_global_mutex);
 
@@ -783,6 +800,10 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 {
 	struct rfkill *rfkill = to_rfkill(dev);
 
+	mutex_lock(&rfkill_global_mutex);
+	rfkill_sync(rfkill);
+	mutex_unlock(&rfkill_global_mutex);
+
 	return sysfs_emit(buf, "%d\n", user_state_from_blocked(rfkill->state));
 }
 
@@ -805,6 +826,7 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	mutex_lock(&rfkill_global_mutex);
+	rfkill_sync(rfkill);
 	rfkill_set_block(rfkill, state == RFKILL_USER_STATE_SOFT_BLOCKED);
 	mutex_unlock(&rfkill_global_mutex);
 
@@ -1032,14 +1054,10 @@ static void rfkill_uevent_work(struct work_struct *work)
 
 static void rfkill_sync_work(struct work_struct *work)
 {
-	struct rfkill *rfkill;
-	bool cur;
-
-	rfkill = container_of(work, struct rfkill, sync_work);
+	struct rfkill *rfkill = container_of(work, struct rfkill, sync_work);
 
 	mutex_lock(&rfkill_global_mutex);
-	cur = rfkill_global_states[rfkill->type].cur;
-	rfkill_set_block(rfkill, cur);
+	rfkill_sync(rfkill);
 	mutex_unlock(&rfkill_global_mutex);
 }
 
@@ -1087,6 +1105,7 @@ int __must_check rfkill_register(struct rfkill *rfkill)
 			round_jiffies_relative(POLL_INTERVAL));
 
 	if (!rfkill->persistent || rfkill_epo_lock_active) {
+		rfkill->need_sync = true;
 		schedule_work(&rfkill->sync_work);
 	} else {
 #ifdef CONFIG_RFKILL_INPUT
@@ -1171,6 +1190,7 @@ static int rfkill_fop_open(struct inode *inode, struct file *file)
 		ev = kzalloc(sizeof(*ev), GFP_KERNEL);
 		if (!ev)
 			goto free;
+		rfkill_sync(rfkill);
 		rfkill_fill_event(&ev->ev, rfkill, RFKILL_OP_ADD);
 		list_add_tail(&ev->list, &data->events);
 	}
-- 
2.40.1



