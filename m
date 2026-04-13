Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DBF28C874;
	Mon, 13 Apr 2026 16:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098561; cv=none; b=Q1jYO7KlP7y8PMIAmxnKUJEIei6gG0ecD1hBO2Xdbs3BpQwikbA3xw4jaN8LXTOybH1rPWi7sWRJ4sPE336Y4JtYdG+rXz+H6xM2KzWlyl/b7bmBa1ZS2dZ0zEr/f3oCNzq8g8301FcBL2cRLYh/GYKxC9GS/5HuNlizkmYNtmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098561; c=relaxed/simple;
	bh=HKS3kuiSEGuc/cfmpwXG1M1fUgzshIQbMHUbbSQj830=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ga5vMbTcEurtvBgb0siQaUK0fNpP6zf29WT2RtKoXFgHgYwyJnP5KfirqaTA1U5EG5Pd4s2EoK+Paj5ElTKOChSkaclI/KHXi935w9fB4l52/vgcrncJx7Q71fvi13cu3SqVJTuFuQ4K60OPqVvfi3ispn8el5wf/kFq3OD/4vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlwsXAhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlwsXAhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12753C2BCB0;
	Mon, 13 Apr 2026 16:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098561;
	bh=HKS3kuiSEGuc/cfmpwXG1M1fUgzshIQbMHUbbSQj830=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlwsXAhUkC1Ezhjx886L/GKzm5oizkje/fKcPFzwIlKI9ClV6RJSz9TtXP33Vahpr
	 yXsIlrOpPLDNE76B0Fk6tz3GGKcPY6LzgB2EWgNQBRwEidwcF7XOw4dZK+s9URi1BF
	 8Pk5p4FtRl+/r2AiC76zwoFcnh0QUhXOgLJ6Mzzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	stable <stable@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 545/570] net: rfkill: prevent unlimited numbers of rfkill events from being created
Date: Mon, 13 Apr 2026 18:01:16 +0200
Message-ID: <20260413155850.863116135@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit ea245d78dec594372e27d8c79616baf49e98a4a1 ]

Userspace can create an unlimited number of rfkill events if the system
is so configured, while not consuming them from the rfkill file
descriptor, causing a potential out of memory situation.  Prevent this
from bounding the number of pending rfkill events at a "large" number
(i.e. 1000) to prevent abuses like this.

Cc: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026033013-disfigure-scroll-e25e@gregkh
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ replaced `scoped_guard()` with explicit `mutex_lock()`/`mutex_unlock()` calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rfkill/core.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -72,11 +72,14 @@ struct rfkill_int_event {
 	struct rfkill_event_ext	ev;
 };
 
+/* Max rfkill events that can be "in-flight" for one data source */
+#define MAX_RFKILL_EVENT	1000
 struct rfkill_data {
 	struct list_head	list;
 	struct list_head	events;
 	struct mutex		mtx;
 	wait_queue_head_t	read_wait;
+	u32			event_count;
 	bool			input_handler;
 	u8			max_size;
 };
@@ -254,10 +257,12 @@ static void rfkill_global_led_trigger_un
 }
 #endif /* CONFIG_RFKILL_LEDS */
 
-static void rfkill_fill_event(struct rfkill_event_ext *ev,
-			      struct rfkill *rfkill,
-			      enum rfkill_operation op)
+static int rfkill_fill_event(struct rfkill_int_event *int_ev,
+			     struct rfkill *rfkill,
+			     struct rfkill_data *data,
+			     enum rfkill_operation op)
 {
+	struct rfkill_event_ext *ev = &int_ev->ev;
 	unsigned long flags;
 
 	ev->idx = rfkill->idx;
@@ -270,6 +275,16 @@ static void rfkill_fill_event(struct rfk
 					RFKILL_BLOCK_SW_PREV));
 	ev->hard_block_reasons = rfkill->hard_block_reasons;
 	spin_unlock_irqrestore(&rfkill->lock, flags);
+
+	mutex_lock(&data->mtx);
+	if (data->event_count++ > MAX_RFKILL_EVENT) {
+		data->event_count--;
+		mutex_unlock(&data->mtx);
+		return -ENOSPC;
+	}
+	list_add_tail(&int_ev->list, &data->events);
+	mutex_unlock(&data->mtx);
+	return 0;
 }
 
 static void rfkill_send_events(struct rfkill *rfkill, enum rfkill_operation op)
@@ -281,10 +296,10 @@ static void rfkill_send_events(struct rf
 		ev = kzalloc(sizeof(*ev), GFP_KERNEL);
 		if (!ev)
 			continue;
-		rfkill_fill_event(&ev->ev, rfkill, op);
-		mutex_lock(&data->mtx);
-		list_add_tail(&ev->list, &data->events);
-		mutex_unlock(&data->mtx);
+		if (rfkill_fill_event(ev, rfkill, data, op)) {
+			kfree(ev);
+			continue;
+		}
 		wake_up_interruptible(&data->read_wait);
 	}
 }
@@ -1149,7 +1164,6 @@ static int rfkill_fop_open(struct inode
 	init_waitqueue_head(&data->read_wait);
 
 	mutex_lock(&rfkill_global_mutex);
-	mutex_lock(&data->mtx);
 	/*
 	 * start getting events from elsewhere but hold mtx to get
 	 * startup events added first
@@ -1159,11 +1173,10 @@ static int rfkill_fop_open(struct inode
 		ev = kzalloc(sizeof(*ev), GFP_KERNEL);
 		if (!ev)
 			goto free;
-		rfkill_fill_event(&ev->ev, rfkill, RFKILL_OP_ADD);
-		list_add_tail(&ev->list, &data->events);
+		if (rfkill_fill_event(ev, rfkill, data, RFKILL_OP_ADD))
+			kfree(ev);
 	}
 	list_add(&data->list, &rfkill_fds);
-	mutex_unlock(&data->mtx);
 	mutex_unlock(&rfkill_global_mutex);
 
 	file->private_data = data;
@@ -1171,7 +1184,6 @@ static int rfkill_fop_open(struct inode
 	return stream_open(inode, file);
 
  free:
-	mutex_unlock(&data->mtx);
 	mutex_unlock(&rfkill_global_mutex);
 	mutex_destroy(&data->mtx);
 	list_for_each_entry_safe(ev, tmp, &data->events, list)
@@ -1232,6 +1244,7 @@ static ssize_t rfkill_fop_read(struct fi
 		ret = -EFAULT;
 
 	list_del(&ev->list);
+	data->event_count--;
 	kfree(ev);
  out:
 	mutex_unlock(&data->mtx);


