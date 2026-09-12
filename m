Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB833299920;
	Sat, 12 Sep 2026 10:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208965; cv=none; b=Le14cnZnESbs/Al+N2//CD8K5CXIEXQukJqvVMWWEeXfLWRBEmIlqYEBX/kzDEXr0R1ElMfXSCU9sW1w5pnPZQrm9Acys3jUbEuf6E2+aBiEgTYRkepkRUu2uWcXiKWsEWQ+hNXGj7aTDIpZ/fPpXNYkTS6Q/lmbO7RT1J7n4hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208965; c=relaxed/simple;
	bh=7y+z1sfxf5gG8fXbz1HrdYVKDHj2hHL3bClknfRN/QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcsYYKZgqBWwRqOxVmpwdCweefHAAtjVWNIAwHpTsPYKOlYzIaO1xysB/ZHUGJiqVOX85syBr35As/GZWo6d8ZFrmgEExvMxTuWZSJGA/14zW9RICdg4mH8se6ZmE1qd4+y85ILkn5pcRtca5qI3Xmb4TCCP4w6hCyL8HQ/d7e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUmmgIDN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUmmgIDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36751F00893;
	Sat, 12 Sep 2026 10:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208964;
	bh=8gNN6+dFPZgETE2FFQTqGa4xpfqdkvaiM8Yto+oAYe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yUmmgIDNqZUowWdKgqqpPr0eH8uYIGdoQJy5zcwkuYqic77h8LlixwsB+kCeQ2TIg
	 coHPhziQwU87JQmJ4I+ntKBLy4X0J/eJC0j+yiarGehpwZ87R/K8MHC8jZeYJxWSbA
	 tpftmXoQP0ikEQ/FQTn/0AfJ4l+NFFLwnLTNTIoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0724/1518] fanotify: report full event length for FIONREAD
Date: Sat, 12 Sep 2026 08:48:13 +0200
Message-ID: <20260912065639.813866605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9dbe33cf2ceaa..629407c3e8737 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1158,11 +1158,13 @@ static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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
 
@@ -1170,7 +1172,8 @@ static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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



