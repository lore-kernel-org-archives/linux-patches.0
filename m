Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E19331A6E;
	Sat, 12 Sep 2026 18:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239338; cv=none; b=YtuazSWNTyTN2bnMABgoc+3gqa75fPSf3AJ5gVIwwOhYtTxRm1YDfNNfdjPsAh7ci4RhB9eR3mm0xE353HfZuR6nkvqOGrtA2U37+esSgaZMSGqFwgr4tYYlrmwP0lSg/PCdM/wT2MOBWl+u9Dg8P3T/azIiv0WOOQDrjpMzPfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239338; c=relaxed/simple;
	bh=t1cqMvP+ebf93tX3FeWUVGoSPR+Zug4zgvGEHMPqUK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwKfzxEZycC4ImuVdR1/IrcVwrPEDGBMJhmNnsxL231hZF0dVlrdykJ0AVMyoM/LIiyRZTnVq4zWNtt/27rCHOogcPZkIZZ4r+ml4rRF3INj4lfL1OokDkBP+ma6pJRN0DsVCiwlEdWo7NiqdRoHIL/EBTAYf4LogDAlz8ZwJII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NJSfx3d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NJSfx3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B0F1F00893;
	Sat, 12 Sep 2026 18:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239336;
	bh=3fIltUKRn1O9FFkUF1ziyMnQF9v/JHgTg3mW6E+djTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1NJSfx3dw3f6uvkn4CbiRmjyRK7Q2UQQtRWT07eI/Qgnc/UpjMHQ+wHibphd+EI+K
	 oO1ZGIqRx7os1QKT/CdQEJR/TZLXTl1wXgo7D3Gx6N1XNaGBaYir3TQ43cNnEarLEs
	 cDUEn6H2P/ycajOO7Hs6WDwRZ+JJbKPSShS8epqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 645/935] fanotify: report full event length for FIONREAD
Date: Sat, 12 Sep 2026 09:01:15 +0200
Message-ID: <20260912065541.636843496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index 1abbb30bd0d91..26685b4c4a325 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -908,11 +908,13 @@ static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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
 
@@ -920,7 +922,8 @@ static long fanotify_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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



