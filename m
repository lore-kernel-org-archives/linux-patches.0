Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEAC2472A2;
	Mon, 13 Apr 2026 16:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096666; cv=none; b=G72hdvpNTy2v6pufmooKrxsl38gDpXp0OnSs7qSWQ1cIEC9nUi3Zi06BJy70mtYZq0DdYGEWm0H3lNm/8u9Y2fuJgC8SLSqImdwnKdn7sqgF3pq3mNAEdyKMNlDOij3HHf+9cYuNnRvgWXANwXLrwhXYsRejPYfEFUabdZCM9/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096666; c=relaxed/simple;
	bh=aYQR2H9in7updI4JZvyMlL2srCiEU01pJ2Ia9SRuZW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvHqWMlXjACLIk92NjACfUCfw9KqpaWy/mVrbUNJLcjR+E9dZhfqV7lOcuMTMqcUQbqc/P5qlQvaiNZruq8BLgrw7Px7Zx9HdQxUQ14JO55LKSIWZP+W7rAU3yCj+Rc0YDK6x0ZVdZPsVwSnYXfPKkxZ74rO0R5iC4GoW/mrvdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcgGn6ri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcgGn6ri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38E4C2BCAF;
	Mon, 13 Apr 2026 16:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096666;
	bh=aYQR2H9in7updI4JZvyMlL2srCiEU01pJ2Ia9SRuZW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcgGn6ri1ZIe0YpU2OjSng+LE64tZ1gHp3u18Ko8+Ek1iPhwYvpeeBS9JafAA6xs5
	 55Iej7bEJEfStkkhIScH/R56nV84gw4Lsv4A6GuhU7WIkTbEUlkY6rLR4z16XOb15R
	 9qCPdbh1JxfXGIoNj03+fv4xzt7Bz2s4XQEpYK6E=
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
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 05/70] net: rfkill: prevent unlimited numbers of rfkill events from being created
Date: Mon, 13 Apr 2026 18:00:00 +0200
Message-ID: <20260413155728.384162898@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit ea245d78dec594372e27d8c79616baf49e98a4a1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rfkill/core.c |   35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -73,11 +73,14 @@ struct rfkill_int_event {
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
@@ -255,10 +258,12 @@ static void rfkill_global_led_trigger_un
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
@@ -271,6 +276,15 @@ static void rfkill_fill_event(struct rfk
 					RFKILL_BLOCK_SW_PREV));
 	ev->hard_block_reasons = rfkill->hard_block_reasons;
 	spin_unlock_irqrestore(&rfkill->lock, flags);
+
+	scoped_guard(mutex, &data->mtx) {
+		if (data->event_count++ > MAX_RFKILL_EVENT) {
+			data->event_count--;
+			return -ENOSPC;
+		}
+		list_add_tail(&int_ev->list, &data->events);
+	}
+	return 0;
 }
 
 static void rfkill_send_events(struct rfkill *rfkill, enum rfkill_operation op)
@@ -282,10 +296,10 @@ static void rfkill_send_events(struct rf
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
@@ -1186,10 +1200,8 @@ static int rfkill_fop_open(struct inode
 		if (!ev)
 			goto free;
 		rfkill_sync(rfkill);
-		rfkill_fill_event(&ev->ev, rfkill, RFKILL_OP_ADD);
-		mutex_lock(&data->mtx);
-		list_add_tail(&ev->list, &data->events);
-		mutex_unlock(&data->mtx);
+		if (rfkill_fill_event(ev, rfkill, data, RFKILL_OP_ADD))
+			kfree(ev);
 	}
 	list_add(&data->list, &rfkill_fds);
 	mutex_unlock(&rfkill_global_mutex);
@@ -1259,6 +1271,7 @@ static ssize_t rfkill_fop_read(struct fi
 		ret = -EFAULT;
 
 	list_del(&ev->list);
+	data->event_count--;
 	kfree(ev);
  out:
 	mutex_unlock(&data->mtx);


