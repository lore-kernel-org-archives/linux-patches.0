Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B406A29D288;
	Sat, 12 Sep 2026 19:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242868; cv=none; b=VyiLcUZIvl8q/1bhzf2tqKchSyNBFwEAylGWqNWWHoeJwx1EGGeAFYamVhIDcqPC+Xtt0utCzMK+N7K3/Y1LlNmLUr3tJzYdSYMfIPsyB1zHQ70vNpk38jPMYufplmjU6lorKuPj0l8UNL7sMBfzXYR0B2kO9rQFngkGa2Wy/Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242868; c=relaxed/simple;
	bh=gJcavtxLSa2Jq/BKcpPlNJgRpeEfl4pgeP4UuAFUKWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er6mnTajn/2oMFYE/vt0D5DekulnxahrlyOqVJECevpD7zViyflb7RnOMtRVfJOiVD3fxWjREOk+fg+F2T+al6SbMBAEDoZ332gECHyNwJ2XqMu9aquwuKY8+R6AxIU64rHl5e/Wkhqv1yYVIf4+aIIfxgeag2hbpq3pPMtdRlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czLXbHts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czLXbHts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5351F000FF;
	Sat, 12 Sep 2026 19:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242867;
	bh=9xy5Md7eZb89A4UJKa4brEm0YXULfP+nSo+t2VOiKDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czLXbHts7R9n91zev7s682oV5AacrNNIPBZii17S6qPjMY574wiP7+Hh4DoToS/vm
	 UnZDuaHfexs66z/c5/VHtONlutBegoRwS6S9XQPruYgQf90nZdHbQrhfabfpfufM17
	 DpKvddzwFVNPlY/IJ+huJmoW6f4mRDk0IlFpCunc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 554/798] fanotify: report full event length for FIONREAD
Date: Sat, 12 Sep 2026 09:03:02 +0200
Message-ID: <20260912065529.828203060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 68615158c12de36220446dfea5cfdf9ba6c19690 ]

fanotify_ioctl(FIONREAD) reports the number of bytes available to read
from the event queue.  It currently accounts only FAN_EVENT_METADATA_LEN
for each queued event.

That underestimates events that carry additional information records, such
as FAN_REPORT_DFID_NAME events.  A userspace program that uses FIONREAD to
size its read buffer can receive a length that is smaller than the next
event.  Reading with that buffer then fails with -EINVAL, while a larger
buffer succeeds and reports a larger metadata.event_len.

Use fanotify_event_len() when summing queued events so FIONREAD includes
all info records.

Fixes: 5e469c830fdb ("fanotify: copy event fid info to user")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Link: https://patch.msgid.link/20260731021827.602479-1-chenyichong@uniontech.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 634de85a2f034..a1cca006b511a 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -900,11 +900,13 @@ static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 {
 	struct fsnotify_group *group;
 	struct fsnotify_event *fsn_event;
+	unsigned int info_mode;
 	void __user *p;
 	int ret = -ENOTTY;
 	size_t send_len = 0;
 
 	group = file->private_data;
+	info_mode = FAN_GROUP_FLAG(group, FANOTIFY_INFO_MODES);
 
 	p = (void __user *) arg;
 
@@ -912,7 +914,8 @@ static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case FIONREAD:
 		spin_lock(&group->notification_lock);
 		list_for_each_entry(fsn_event, &group->notification_list, list)
-			send_len += FAN_EVENT_METADATA_LEN;
+			send_len += fanotify_event_len(info_mode,
+						       FANOTIFY_E(fsn_event));
 		spin_unlock(&group->notification_lock);
 		ret = put_user(send_len, (int __user *) p);
 		break;
-- 
2.53.0



