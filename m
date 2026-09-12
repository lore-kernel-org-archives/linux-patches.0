Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3925B386541;
	Sat, 12 Sep 2026 14:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224311; cv=none; b=G7U0DkxTQ8F/N1/lMOzE/2iYpXm8CFRpsWwNbFTPXbznanQMOk+ugSC41Atz87Zx3g2748LTvBs0gBeQzV4NhOnwo4FTyDv1M8gEwdc41hTLuYa6iXPnhOMRN02bBc0Jyc9xiril7peJdr68NmmitOnqq4GA5cZS8/grCDsH4VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224311; c=relaxed/simple;
	bh=cOWNZMbQsJAHp/MJZurF/c0ZIToKFXLwMic7zSdyoTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLzQUMBkzzEBxu5iy7Wxmg7wVcdc+zePa630t9Gf8Z6aa/gdLmP9TbkHqJ8Y0M5++RkQBZv835gI+1h3zRMRujIzycumweE8zop4tAHOFM5yaPV6SLVTokHREhumsKKIMZg4S9bX5dCibuOcilkLy8tiKkZDdlugC9Ab6soxBxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D05Q3tIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D05Q3tIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458AD1F000FF;
	Sat, 12 Sep 2026 14:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224310;
	bh=i53OnsXlH4ym1cXzHPBTQtoU8hw/EbR0lMj1jVSE7ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D05Q3tILIUFiKotE12q3xE4nBrEZcFWI6S/RNGMlscaPxxnvvaF6l7/ILFnxP8v6S
	 ottIYEso00E/8H16EXEk85SyA0wrZlWvNArbWuMV2yNoiiAmeyC1nQp8MFgs2Rfe7G
	 PJXIb6b25cji+cqxwXM05UAslFPh56gF69jCsGTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0968/1424] fanotify: report full event length for FIONREAD
Date: Sat, 12 Sep 2026 08:56:40 +0200
Message-ID: <20260912065628.990474458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 763ca835d8fd5..f1b8dc8dcc8d1 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -972,11 +972,13 @@ static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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
 
@@ -984,7 +986,8 @@ static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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



