Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08C9455605;
	Sat, 12 Sep 2026 10:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209949; cv=none; b=tCqWa5qdZS9TT3nDq9Cfp8uzUwGr24KhZVw76pFT0LFHD+ZB/yshlmo29UW5KEMUSkf/5BNoxoimqDEAJGiJDu4+yqn/l268UPzyk4680wyVg+HGkOxCU3CUMxfEBaq03q4oMaV8T31E4+BPTcCBb4XTq54tAhhMcM+YUNzOpYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209949; c=relaxed/simple;
	bh=6xK2Gnj1BT0xJzkjkqJXBTRsU3IT+bZj7xJuHhVdRMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGjuYvpwaj387VRcgfouRpQteeLDbbgZCDrlpcmCQwMYO7xjm/SdbUgnpjM7okxWD3BibG1Sg1ObXugVTnqGuJyDTdT8nrDbqgcitF8DWe1pQSkoNKrygBdI3moNL0Nr43TB0eUDEeFCY6Q9KzKNslNGDVbPI8wivnyihVjGtAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/duL6VV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/duL6VV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A952B1F000FF;
	Sat, 12 Sep 2026 10:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209948;
	bh=q6fkJvgTY5KbXwc1KalammwdKR43WqNq207wBScXW8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/duL6VV7dh0zYA6oV8laWgZtUq5zG2ax4UCJRNezZqzwObPDnvJ/+ZpYVvEIkqQ+
	 XR2/9VLhk73zyD58Vq9EQMABc4ZlQ2fEbbA5Abu+TsWJx4Dh8qy1t7HJnju7VlDN4L
	 8J4FT1k54gygSIx0s9n/KmJl6V6oQdA7nnIK+76A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0927/1518] module: use strscpy() to copy module names in stats and dup tracking
Date: Sat, 12 Sep 2026 08:51:36 +0200
Message-ID: <20260912065644.420421297@linuxfoundation.org>
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

From: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>

[ Upstream commit 93c29ebd1622fb0670701e1c1b3a978a5cac08b7 ]

Both try_add_failed_module() and kmod_dup_request_exists_wait() use
memcpy() with strlen() to copy module names into fixed-size
char[MODULE_NAME_LEN] buffers. Neither performs a bounds check on the
copy. Current callers always pass names originating from
mod->name (itself char[MODULE_NAME_LEN]), so this is not exploitable
today. However both functions accept a plain const char * with no
documented length contract, making them latent buffer overflows if a
future caller passes a longer string.

Replace memcpy() with strscpy() in both sites, which bounds the copy
to MODULE_NAME_LEN and always NUL-terminates.

Signed-off-by: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Stable-dep-of: 5eecb11b543f ("module/dups: Fix use-after-free in kmod_dup_req lifetime handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module/dups.c  | 2 +-
 kernel/module/stats.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/module/dups.c b/kernel/module/dups.c
index 0b633f2edda6b..6ecc42193de24 100644
--- a/kernel/module/dups.c
+++ b/kernel/module/dups.c
@@ -129,7 +129,7 @@ bool kmod_dup_request_exists_wait(char *module_name, bool wait, int *dup_ret)
 	if (!new_kmod_req)
 		return false;
 
-	memcpy(new_kmod_req->name, module_name, strlen(module_name));
+	strscpy(new_kmod_req->name, module_name);
 	INIT_WORK(&new_kmod_req->complete_work, kmod_dup_request_complete);
 	INIT_DELAYED_WORK(&new_kmod_req->delete_work, kmod_dup_request_delete);
 	init_completion(&new_kmod_req->first_req_done);
diff --git a/kernel/module/stats.c b/kernel/module/stats.c
index 3ba0e98b3c910..2a4e2f6708965 100644
--- a/kernel/module/stats.c
+++ b/kernel/module/stats.c
@@ -253,7 +253,7 @@ int try_add_failed_module(const char *name, enum fail_dup_mod_reason reason)
 	mod_fail = kzalloc(sizeof(*mod_fail), GFP_KERNEL);
 	if (!mod_fail)
 		return -ENOMEM;
-	memcpy(mod_fail->name, name, strlen(name));
+	strscpy(mod_fail->name, name);
 	__set_bit(reason, &mod_fail->dup_fail_mask);
 	atomic_long_inc(&mod_fail->count);
 	list_add_rcu(&mod_fail->list, &dup_failed_modules);
-- 
2.53.0



