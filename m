Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99992135AD;
	Tue, 21 Jul 2026 18:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658759; cv=none; b=Glq7vv/86mwU/vBbW3tQnBh722lD32tI4Vzd/lgBStfLTEWVPcHXALYC13Mn2QQA1EjhqhM2l33/EIa+w5HySmobF5VKhnJvF8li1KzhVdrys0Wu2UTDjZfBKqrUrATDF/ghu6mJB44whmZ8fxjME3/+Xy1FirGh9R9fCAgjvrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658759; c=relaxed/simple;
	bh=xtMrIJJQMxXQeep83lRCf0mKDQ+JA+9IBZO0XpskFsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0dezFhNnGqdK6yO+G5Zr+WlkWZoGY0l5qcfdnprj7hTIXeu3rgd3xHGQ3MKGx4iZhQJ0xiI4ic+sDt5crOSF/8BejIb2cYvFV2xPUl5PgHqdo2+8JVOLcTuqomruHjT8vaoBzhEIux+6SOFsRfwRbxaH0Ym/PFenBYNeH/+vo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2GM/aWK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2GM/aWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005511F00A3D;
	Tue, 21 Jul 2026 18:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658757;
	bh=F+q6RLdSksGfM2RQ57nuxFx5tt27evwLh7WoRCadHl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2GM/aWKkxQD45Ig6PBa56hxSQRhSkMWy2qeMsYM1UtdsoLW5SNeuEPegK8SmU7vA
	 Kbdgp6zCYznrLOz8IhIWbD8Cr4WTH2tBXxGgrMfrqjdOPLFo+ZFWPNtzQlUNpYtktQ
	 f7jPtmoLw//jj23OQbWcnc4cWEmf4se2ITwRouuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com,
	Tristan Madani <tristan@talencesecurity.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 1265/1611] ocfs2: use kzalloc for quota recovery bitmap allocation
Date: Tue, 21 Jul 2026 17:23:01 +0200
Message-ID: <20260721152543.903452828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit 93c8c6ea90be9e9df8fe14048ad4e3caad0770a6 upstream.

ocfs2 quota recovery allocates a bitmap buffer with kmalloc and does not
fully initialize it.  This can lead to use of uninitialized bits during
quota recovery from a corrupted filesystem image.

Use kzalloc instead to ensure the bitmap is zero-initialized.

Link: https://lore.kernel.org/20260418131048.1052507-1-tristmd@gmail.com
Reported-by: syzbot+7ea0b96c4ddb49fd1a70@syzkaller.appspotmail.com
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/quota_local.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -302,7 +302,7 @@ static int ocfs2_add_recovery_chunk(stru
 	if (!rc)
 		return -ENOMEM;
 	rc->rc_chunk = chunk;
-	rc->rc_bitmap = kmalloc(sb->s_blocksize, GFP_NOFS);
+	rc->rc_bitmap = kzalloc(sb->s_blocksize, GFP_NOFS);
 	if (!rc->rc_bitmap) {
 		kfree(rc);
 		return -ENOMEM;


