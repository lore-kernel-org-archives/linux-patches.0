Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6099722301;
	Thu, 16 Jul 2026 13:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210136; cv=none; b=cHfsuYYx8WYeWdZjvacyxXmYFrE+umMmqDVn+wuplatTZjiBb88026ygGA4BvzgZhFM5ps4/Af+o2isV7bx2jSN7+q2P9gbun6cLWPIMfH6Pm9jw3dB03LBNVAgNcxrPqPhEPXqKsUJWGw5s9p77MDFUBOgR74r3RrWgqXqRL40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210136; c=relaxed/simple;
	bh=6J1OoYuOqScHkePwYyiGC9jUwGYRhEPGfAd+Rz+yy4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXlqd+VRW9KeGQlzhxQgMFynYk//ztrAmbN4H184yre3oUnLUkYeU1VV9Ic/P4z/pebUjowOqrOnuwt0P7bpEfBJol7O+S8TL2inWSfzlIs2379CPC8oQEZ8ROnquiaONRdoKZbNNDQ5VGHgdMWTZH2YopttFVg6LKP0SLi58m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVnLw7J7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVnLw7J7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88B91F000E9;
	Thu, 16 Jul 2026 13:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210135;
	bh=7F2lok5Zpw5PoKkZVgmO5C2kf7LGKdRbOHo/a+bOxVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVnLw7J7FcIqIs9nYMISyZ+tCv0f7KEd8K1lHSDl79UvhTkt7QI2Rp+AgvyscRMkv
	 Ky5wsCc7fL+KCidczNli5dpgSg9aUH116MVcN9FR6W8t4DhwL7CRAKZxWlwMau5cP5
	 YYn4mxRnSlHbffxtUsbMmy4OKw9U4kBa/cdRz0ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Waiman Long <longman@redhat.com>,
	Richard Guy Briggs <rgb@redhat.com>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.1 444/518] audit: fix removal of dangling executable rules
Date: Thu, 16 Jul 2026 15:31:52 +0200
Message-ID: <20260716133057.552919337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Robaina <rrobaina@redhat.com>

commit 888a0396e154524f4027f27da84bdbec9eb68916 upstream.

When an audited executable is deleted from the disk, its dentry
becomes negative. Any later attempt to delete the associated audit
rule will lead to audit_alloc_mark() encountering this negative
dentry and immediately aborting, returning -ENOENT.

This early abort prevents the subsystem from allocating the temporary
fsnotify mark needed to construct the search key, meaning the kernel
cannot find the existing rule in its own lists to delete it. This
leaves a dangling rule in memory, resulting in the following error
while attempting to delete the rule:

 # ./audit-dupe-exe-deadlock.sh
 No rules
 Error deleting rule (No such file or directory)
 There was an error while processing parameters

 # auditctl -l
 -a always,exit -S all -F exe=/tmp/file -F path=/tmp/file -F key=dr

 # auditctl -D
 Error deleting rule (No such file or directory)
 There was an error while processing parameters

This patch fixes this issue by removing the d_really_is_negative()
check. By doing so, a dummy mark can be successfully generated for
the deleted path, which allows the audit subsystem to properly match
and flush the dangling rule.

Cc: stable@kernel.org
Fixes: 76a53de6f7ff ("VFS/audit: introduce kern_path_parent() for audit")
Acked-by: Waiman Long <longman@redhat.com>
Acked-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit_fsnotify.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -84,10 +84,6 @@ struct audit_fsnotify_mark *audit_alloc_
 	dentry = kern_path_parent(pathname, &path);
 	if (IS_ERR(dentry))
 		return ERR_CAST(dentry); /* returning an error */
-	if (d_really_is_negative(dentry)) {
-		audit_mark = ERR_PTR(-ENOENT);
-		goto out;
-	}
 
 	audit_mark = kzalloc_obj(*audit_mark);
 	if (unlikely(!audit_mark)) {


