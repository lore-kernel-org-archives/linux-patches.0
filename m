Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C803F54B6;
	Thu, 16 Jul 2026 14:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211454; cv=none; b=uoWFXmtZ5yVd8RBEReoRAy3+3VPXZ1KdTUaJE56pbckVMWQTLYD4uf84Bhgww2c+21BOKaC7LP6sD7yEdoEYCgIANTS5hkltEkXdTzPTTNlI0Tshy6R3bWdXQa6g77UBtwDeFRDImPepasWqSDH3Z2BpYW4BeXlOts1fJFjgpv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211454; c=relaxed/simple;
	bh=w8k42BMDf041wrbT7ztGmgRFCaLtgVJs1eJAgPHPWvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFKhFd00Fa7DJLLlyxOb66dcyyvT348hLegSK07dkJElwODFn5QAU47J4U0ak7KQSWoISrYS86vA1wC5bXhtrh+kpVtmQozPqYV+GO6xxPtFE3Z2Q2VLuvy/CRTK2UIRl29sFjzNGPJJGjXD6p5Omvtxm75X2WXRrnZUV0nP8Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Blk4zV3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Blk4zV3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E211F00A3A;
	Thu, 16 Jul 2026 14:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211453;
	bh=LMYVu3izHFJaxGWc/uodtFsQfuxRAiRDVXzIM25RCTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Blk4zV3KmaXta9SA5+CFCaPsyJcGgiYsHKBe5JQwmIBayd4qIbfzPnN4Nff/NHOJ2
	 Mtp2P328SFnwYJE4Ot1Nc8CiGIeGEiR8a0wlG65Fr9KMSZlnPsAmdFAwC+/YVpy9wO
	 6QypMXJqtv+R+yqq3abxXhPrprH1/NimdM3UAit4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Waiman Long <longman@redhat.com>,
	Richard Guy Briggs <rgb@redhat.com>,
	Ricardo Robaina <rrobaina@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 417/480] audit: fix removal of dangling executable rules
Date: Thu, 16 Jul 2026 15:32:44 +0200
Message-ID: <20260716133053.837164509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
 
 	audit_mark = kzalloc(sizeof(*audit_mark), GFP_KERNEL);
 	if (unlikely(!audit_mark)) {


