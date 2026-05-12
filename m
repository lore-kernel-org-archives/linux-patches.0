Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDA93C0A1A;
	Tue, 12 May 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608132; cv=none; b=YwBHtbzvhGH4CNy/Ll1ROBEV8+mAT+W50fSGu0sFHV1DyKDhIaQVKGIjjA0doqHhsTMDF1WVu+IS0I0i+miHSu2lbLXIxn1MaGKBPmIF/EVXjVSK6znDa0eNGC8lsIg2ClacVPOosoT5xAyUHXnko+he+Ffs147OnQiS03GejBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608132; c=relaxed/simple;
	bh=3fC73MDVvI3gGAtLCSPhWkvzJORwqv+QlVarAH2UmSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b56lApmqaXiGqHGi7nTbkTN7ocOjriInwaWqZfkC7Jlk0aOS8WHucoMX0jCoNrJYcynwiMnmELaG0nVux4RpF5C34ZsTS+HbBgbfshmx6BawdsAUbkas7GML6REu7Y7+clqmQoOonTfROPtBSUMNva7FzMmbtqvu9Llp8WZi7Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZywL6LI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZywL6LI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B99C2BCB0;
	Tue, 12 May 2026 17:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608131;
	bh=3fC73MDVvI3gGAtLCSPhWkvzJORwqv+QlVarAH2UmSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZywL6LIl/IFp0ZoUwGo+fRY5lQnlYsewjAQEB2Nx0zDzm61ETQvOUpwlkABgAENf
	 gOJjNqbQTmXl15AgQ3fPmZnn6Ib1tmgviv895NxGOqjC3l4iEJxD/tpkE7LU1iVjc0
	 WunyRTYDmXFl4201bEkeWud1jtdTQs6v1x6SQyAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 168/206] f2fs: fix uninitialized kobject put in f2fs_init_sysfs()
Date: Tue, 12 May 2026 19:40:20 +0200
Message-ID: <20260512173936.420719081@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit b635f2ecdb5ad34f9c967cabb704d6bed9382fd0 upstream.

In f2fs_init_sysfs(), all failure paths after kset_register() jump to
put_kobject, which unconditionally releases both f2fs_tune and
f2fs_feat.

If kobject_init_and_add(&f2fs_feat, ...) fails, f2fs_tune has not been
initialized yet, so calling kobject_put(&f2fs_tune) is invalid.

Fix this by splitting the unwind path so each error path only releases
objects that were successfully initialized.

Fixes: a907f3a68ee26ba4 ("f2fs: add a sysfs entry to reclaim POSIX_FADV_NOREUSE pages")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/sysfs.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -1795,24 +1795,26 @@ int __init f2fs_init_sysfs(void)
 	ret = kobject_init_and_add(&f2fs_feat, &f2fs_feat_ktype,
 				   NULL, "features");
 	if (ret)
-		goto put_kobject;
+		goto unregister_kset;
 
 	ret = kobject_init_and_add(&f2fs_tune, &f2fs_tune_ktype,
 				   NULL, "tuning");
 	if (ret)
-		goto put_kobject;
+		goto put_feat;
 
 	f2fs_proc_root = proc_mkdir("fs/f2fs", NULL);
 	if (!f2fs_proc_root) {
 		ret = -ENOMEM;
-		goto put_kobject;
+		goto put_tune;
 	}
 
 	return 0;
 
-put_kobject:
+put_tune:
 	kobject_put(&f2fs_tune);
+put_feat:
 	kobject_put(&f2fs_feat);
+unregister_kset:
 	kset_unregister(&f2fs_kset);
 	return ret;
 }


