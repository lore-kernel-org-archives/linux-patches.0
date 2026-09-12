Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC0F3750C9;
	Sat, 12 Sep 2026 16:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230435; cv=none; b=FPNSccUZwvsqhyTfsxvNcf6RUonOOc8iayyqX+VvPuTnOWg0XiwSZ1xdhWdo/+iLIay4pvSnn9ZnTk1bEqahuobS+RtMnJyj4XoR2EGA7ZslNbFpIF24d1rwk9njg/aaY8yJ2NKaXXRvKcshzrt8RQ98jQiD2zs7z8gBnCHs16I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230435; c=relaxed/simple;
	bh=+Xr8CipRG1wPYWh/gpygzNDDTFSYZOQo4hejGJ0fDVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZESx03yFmBWUnvOfZO4ApG+G8qJPB+Ih1HhXTuBfSpgjgxqV7MPd06PqeFyXqChkzO7AI8fmbQcX+p6LMjKVswk9tR/xwraS8bUErcfrxHOFmBRJrz8+Ll7lpeXJfvYARWz/pSYcnnFoS57XB+HiV283k5wlBDrO7qwHpc0b9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZ7Q3CHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZ7Q3CHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0F11F000FF;
	Sat, 12 Sep 2026 16:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230434;
	bh=6lDdphsTKx3zzF74RbirRwbBTFbCF9rc2i2ApynSw0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZ7Q3CHY87eNGHY/Dntg+m0TqeKwG+tsLhr+8n2Ti5El1TRHmErN8FoISmuF7S4X7
	 0rZA1b25laq1Z+pqsNUEHqC/td6+usnTK+XbtFdYZhGlpC/y64mW0afx0mb32ukz2g
	 vTelWuAIv/AUXleiqbwr3AeqlOtg3voj33Hlv6xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0794/1191] fanotify: report full event length for FIONREAD
Date: Sat, 12 Sep 2026 08:58:42 +0200
Message-ID: <20260912065606.107131493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 48984f039fded..b8517857e6c25 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -912,11 +912,13 @@ static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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
 
@@ -924,7 +926,8 @@ static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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



