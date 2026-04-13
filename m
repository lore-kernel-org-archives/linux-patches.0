Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4BD30BF68;
	Mon, 13 Apr 2026 17:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099834; cv=none; b=B9K+ia0NbDZGEXa62uo9gT971YLdK0Yp1J9uSU1hCclGdkKdVvC/OYYUMKsejPDnlUO4x5sYugnvlq5NYoZFdUjRxrIxEFF5DfO35/VQfGNtUKgvlGFff8wUY9KNY6NbCgACqq7as5aCawKGvYzYoKnATYaoJWVUcqtFU8F1dU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099834; c=relaxed/simple;
	bh=JhnGT4iqx0Dbl5QjykIjlpeIEueGHOZlCrSGPUBD3cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7Qf+aAWrTtwMgW5NGpEgx5Pki+i63DKQRiAVeCfZthtWvtByU0wS97pW6YD0I3OrAiu94rvyaddkLxgSSaTvmLrKbzVACfi3EbQ2/sNALkj83O5T+i3vqVnOrk2Ayj20VVOkmgrBGL7JVFz5lsLxiy3Pb+Dp4kY4J8HnyixaGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zc3BzPTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zc3BzPTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8599C2BCAF;
	Mon, 13 Apr 2026 17:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099834;
	bh=JhnGT4iqx0Dbl5QjykIjlpeIEueGHOZlCrSGPUBD3cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zc3BzPTyEK7o9hrD4337769hPyfORgFf4qVD1st+AAbrLjy7R/cZGksM36XkvHRaP
	 PEn1nYtssg7vkCwGxYvQ2C4YPuMyR6Azye+iZ7ASITAwAFKuVZ9zHBpzUDDx78TnsW
	 NJyqkaK+j6dX5oOfL1i4HwFFvEtHN13Sp5TSYzJY=
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
Subject: [PATCH 5.10 460/491] net: rfkill: prevent unlimited numbers of rfkill events from being created
Date: Mon, 13 Apr 2026 18:01:45 +0200
Message-ID: <20260413155836.259441726@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
[ replaced `rfkill_event_ext` with `rfkill_event`, `scoped_guard` with explicit mutex calls, and removed outer `data->mtx` lock in `rfkill_fop_open` to avoid deadlock with new internal locking ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rfkill/core.c |   40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -71,11 +71,14 @@ struct rfkill_int_event {
 	struct rfkill_event	ev;
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
 };
 
@@ -252,9 +255,12 @@ static void rfkill_global_led_trigger_un
 }
 #endif /* CONFIG_RFKILL_LEDS */
 
-static void rfkill_fill_event(struct rfkill_event *ev, struct rfkill *rfkill,
-			      enum rfkill_operation op)
+static int rfkill_fill_event(struct rfkill_int_event *int_ev,
+			     struct rfkill *rfkill,
+			     struct rfkill_data *data,
+			     enum rfkill_operation op)
 {
+	struct rfkill_event *ev = &int_ev->ev;
 	unsigned long flags;
 
 	ev->idx = rfkill->idx;
@@ -266,6 +272,16 @@ static void rfkill_fill_event(struct rfk
 	ev->soft = !!(rfkill->state & (RFKILL_BLOCK_SW |
 					RFKILL_BLOCK_SW_PREV));
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
@@ -277,10 +293,10 @@ static void rfkill_send_events(struct rf
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
@@ -1118,21 +1134,19 @@ static int rfkill_fop_open(struct inode
 	init_waitqueue_head(&data->read_wait);
 
 	mutex_lock(&rfkill_global_mutex);
-	mutex_lock(&data->mtx);
 	/*
-	 * start getting events from elsewhere but hold mtx to get
-	 * startup events added first
+	 * start getting events from elsewhere but hold rfkill_global_mutex
+	 * to get startup events added first
 	 */
 
 	list_for_each_entry(rfkill, &rfkill_list, node) {
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
@@ -1140,7 +1154,6 @@ static int rfkill_fop_open(struct inode
 	return stream_open(inode, file);
 
  free:
-	mutex_unlock(&data->mtx);
 	mutex_unlock(&rfkill_global_mutex);
 	mutex_destroy(&data->mtx);
 	list_for_each_entry_safe(ev, tmp, &data->events, list)
@@ -1200,6 +1213,7 @@ static ssize_t rfkill_fop_read(struct fi
 		ret = -EFAULT;
 
 	list_del(&ev->list);
+	data->event_count--;
 	kfree(ev);
  out:
 	mutex_unlock(&data->mtx);


