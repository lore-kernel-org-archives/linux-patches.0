Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE02A2EF281;
	Tue, 17 Jun 2025 16:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177306; cv=none; b=Bpfsw4ImFeB5la3toFsP7VIwzStRUM7H6iw+yDkAcsQcPATscI2neZgYxZUbJvc2bmFHxeuYExWkXHY4IhOmLqkWIf0ZWFe3ETw4qhpOdnTeZi4kfhEwwb+pTmf4cBASaRxAeHW+VHnJ5yVQ+8nrpvQHjQvmrdUl75wp/BZdeqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177306; c=relaxed/simple;
	bh=6IF5JfJhBrr5zgJSYos60XQLyphNjvQ5eMSy+hr7Nss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YAMPYobiXoxfvMpiO2aI6akaCOkXE7Lzlq5iF8GXem1v0r1YTNVMdQxvjbnoMAR4DPpDdZYZ1bxYUEit9jXpBk6wNcXpi+lV6XELJaZBruCKeFNCdOQZ+mTFW0x4P94dgQ5VmFDZ5FnLMmvQuEhA1H5kGMWsHyM9c7pndgxwG00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1uhU4ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1uhU4ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584DEC4CEE3;
	Tue, 17 Jun 2025 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177305;
	bh=6IF5JfJhBrr5zgJSYos60XQLyphNjvQ5eMSy+hr7Nss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1uhU4urUxX0UlAkKV5qcgXSlVpJrpgFNRHJZp3V2aPGuW5BsjdCQI7yfrcietVS1
	 4ieYDJMCBDMza8YJIrCBEt2Ix445gTGy1/Jj68PtfbqWFz3fsWRLPTFME53UFjgwQ4
	 i5E8DorSk03MeFw54qmU+kMx/8XnUdvwtpAWRR1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 287/780] kernfs: Relax constraint in draining guard
Date: Tue, 17 Jun 2025 17:19:55 +0200
Message-ID: <20250617152503.157635900@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit 071d8e4c2a3b0999a9b822e2eb8854784a350f8a ]

The active reference lifecycle provides the break/unbreak mechanism but
the active reference is not truly active after unbreak -- callers don't
use it afterwards but it's important for proper pairing of kn->active
counting. Assuming this mechanism is in place, the WARN check in
kernfs_should_drain_open_files() is too sensitive -- it may transiently
catch those (rightful) callers between
kernfs_unbreak_active_protection() and kernfs_put_active() as found out by Chen
Ridong:

	kernfs_remove_by_name_ns	kernfs_get_active // active=1
	__kernfs_remove					  // active=0x80000002
	kernfs_drain			...
	wait_event
	//waiting (active == 0x80000001)
					kernfs_break_active_protection
					// active = 0x80000001
	// continue
					kernfs_unbreak_active_protection
					// active = 0x80000002
	...
	kernfs_should_drain_open_files
	// warning occurs
					kernfs_put_active

To avoid the false positives (mind panic_on_warn) remove the check altogether.
(This is meant as quick fix, I think active reference break/unbreak may be
simplified with larger rework.)

Fixes: bdb2fd7fc56e1 ("kernfs: Skip kernfs_drain_open_files() more aggressively")
Link: https://lore.kernel.org/r/kmmrseckjctb4gxcx2rdminrjnq2b4ipf7562nvfd432ld5v5m@2byj5eedkb2o/

Cc: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20250505121201.879823-1-mkoutny@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c  | 5 +++--
 fs/kernfs/file.c | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index fc70d72c3fe80..43487fa83eaea 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1580,8 +1580,9 @@ void kernfs_break_active_protection(struct kernfs_node *kn)
  * invoked before finishing the kernfs operation.  Note that while this
  * function restores the active reference, it doesn't and can't actually
  * restore the active protection - @kn may already or be in the process of
- * being removed.  Once kernfs_break_active_protection() is invoked, that
- * protection is irreversibly gone for the kernfs operation instance.
+ * being drained and removed.  Once kernfs_break_active_protection() is
+ * invoked, that protection is irreversibly gone for the kernfs operation
+ * instance.
  *
  * While this function may be called at any point after
  * kernfs_break_active_protection() is invoked, its most useful location
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 66fe8fe41f060..a6c692cac6165 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -778,8 +778,9 @@ bool kernfs_should_drain_open_files(struct kernfs_node *kn)
 	/*
 	 * @kn being deactivated guarantees that @kn->attr.open can't change
 	 * beneath us making the lockless test below safe.
+	 * Callers post kernfs_unbreak_active_protection may be counted in
+	 * kn->active by now, do not WARN_ON because of them.
 	 */
-	WARN_ON_ONCE(atomic_read(&kn->active) != KN_DEACTIVATED_BIAS);
 
 	rcu_read_lock();
 	on = rcu_dereference(kn->attr.open);
-- 
2.39.5



