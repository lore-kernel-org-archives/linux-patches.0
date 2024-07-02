Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77D21BE226;
	Tue,  2 Jul 2024 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940523; cv=none; b=S6Y7u9FFSfgqP+kh1IzrTNxFNCgvSy4ObF2ED7iOk3JbxMH5HOD19bjhbpPAQWJOcl9EHM0cH9rKV+2uQyKGw4+EpH7G2gLJltGD2GlkHehrmeznmvVCKYgxg7dDKUsx4VBrYk3wzT1g8m1UTJ12wT4mnZRJzcuf1F2odET+gCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940523; c=relaxed/simple;
	bh=vhhShmEWpXh6sEXpsoVi3sE60sF0ngoeK56Fq9INgEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSFOuZb3BBcvVaXb0elov+eOHhOYukLUL80zuZPOuAqhKAU9P7Xmz5dJK3x58Z2YknOKWL8e7bclxcFynK/qeAWv/d9k5YtvSw/Iq8AlyjlE2q8PPwvWTUeNokHalV7aYhA6AureVA3qEM7Tttfo0jOBo9oUaygHdcsszHeQBjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEXXqi/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEXXqi/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA85C4AF07;
	Tue,  2 Jul 2024 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940523;
	bh=vhhShmEWpXh6sEXpsoVi3sE60sF0ngoeK56Fq9INgEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEXXqi/azeTSnDjZcL41m2GuVuH2SSHxxDyzj0pC0jiXkYHB7/eKIgTPSpEu8s2tQ
	 /PZmAApVAe0SbMewcqyUFFPvKkWf+5NURtNogC2jtjj5PZVfHldhz5MVt3b3y/K/0q
	 98Hk+5UP85ao7NdW8FixjAZOwPljXTUbgLPVI6q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.9 179/222] drm/drm_file: Fix pid refcounting race
Date: Tue,  2 Jul 2024 19:03:37 +0200
Message-ID: <20240702170250.818160288@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 4f2a129b33a2054e62273edd5a051c34c08d96e9 upstream.

<maarten.lankhorst@linux.intel.com>, Maxime Ripard
<mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>

filp->pid is supposed to be a refcounted pointer; however, before this
patch, drm_file_update_pid() only increments the refcount of a struct
pid after storing a pointer to it in filp->pid and dropping the
dev->filelist_mutex, making the following race possible:

process A               process B
=========               =========
                        begin drm_file_update_pid
                        mutex_lock(&dev->filelist_mutex)
                        rcu_replace_pointer(filp->pid, <pid B>, 1)
                        mutex_unlock(&dev->filelist_mutex)
begin drm_file_update_pid
mutex_lock(&dev->filelist_mutex)
rcu_replace_pointer(filp->pid, <pid A>, 1)
mutex_unlock(&dev->filelist_mutex)
get_pid(<pid A>)
synchronize_rcu()
put_pid(<pid B>)   *** pid B reaches refcount 0 and is freed here ***
                        get_pid(<pid B>)   *** UAF ***
                        synchronize_rcu()
                        put_pid(<pid A>)

As far as I know, this race can only occur with CONFIG_PREEMPT_RCU=y
because it requires RCU to detect a quiescent state in code that is not
explicitly calling into the scheduler.

This race leads to use-after-free of a "struct pid".
It is probably somewhat hard to hit because process A has to pass
through a synchronize_rcu() operation while process B is between
mutex_unlock() and get_pid().

Fix it by ensuring that by the time a pointer to the current task's pid
is stored in the file, an extra reference to the pid has been taken.

This fix also removes the condition for synchronize_rcu(); I think
that optimization is unnecessary complexity, since in that case we
would usually have bailed out on the lockless check above.

Fixes: 1c7a387ffef8 ("drm: Update file owner during use")
Cc: <stable@vger.kernel.org>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_file.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -469,14 +469,12 @@ void drm_file_update_pid(struct drm_file
 
 	dev = filp->minor->dev;
 	mutex_lock(&dev->filelist_mutex);
+	get_pid(pid);
 	old = rcu_replace_pointer(filp->pid, pid, 1);
 	mutex_unlock(&dev->filelist_mutex);
 
-	if (pid != old) {
-		get_pid(pid);
-		synchronize_rcu();
-		put_pid(old);
-	}
+	synchronize_rcu();
+	put_pid(old);
 }
 
 /**


