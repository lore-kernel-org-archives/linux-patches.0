Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D3743CEEC;
	Sat, 12 Sep 2026 08:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202367; cv=none; b=AkcfYSgHD1ULfPuRXV0jQNaA5Um0/1oUwRXfB5s682TgAPnBza90qHHDwt8C3cpWReBWfIfgWvxwucYQmKtUzG0iCBosMYAYRg1FWuzfUS7E3qyaRmKOxehDACeIsI/haa3s0b0GPOJylJ7Tr9aA8sLyYdnvph7xnOYwecWj2hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202367; c=relaxed/simple;
	bh=s2IDEYtKgj0+HUCztrjXb5dgUYDrVugKOqKxDmxaCAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nopcmgd4OP2dN+4CyAyHUbZjOC0fgKLHeiq1WsF2LdSECHwYJ0uHBaVcpzAJsJgMtRZ1JAGtUmmFEU5KyVPy9uoQ68jhyw1DXzPNZWqLrLSmuRuw3aR0MXepdyECGDfRlitx06tbZ09BlkK2Z85fgSIrWBHAnSkWo1c+lgJ+hLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFkuk6XK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFkuk6XK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFCA1F0089A;
	Sat, 12 Sep 2026 08:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202365;
	bh=5d1mmS+F5q3sdkX/KztP6BML5iCBozGZLp1KaDVLau8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFkuk6XKM1M187VPt1lHftVCKkkFj1zbnroHQgy0yjTwDtU3f2gYfgY3V0JBG2dVk
	 Cv4q1OEM3/zwO20Sc21O+LJQToEUGRpFqzBsRYZ2RX2OTobShxLM8pTFPpFIvOYWIE
	 +9j7RNT2WeOE7XSTpNjvtnd0t9uA5DaQM83ce+a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1145/1815] module: use strscpy() to copy module names in stats and dup tracking
Date: Sat, 12 Sep 2026 08:48:15 +0200
Message-ID: <20260912065715.895146648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 1d720a5311ba0..8b6f8f177de4f 100644
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
index 3a9672f93a8ef..78b59bc05387f 100644
--- a/kernel/module/stats.c
+++ b/kernel/module/stats.c
@@ -253,7 +253,7 @@ int try_add_failed_module(const char *name, enum fail_dup_mod_reason reason)
 	mod_fail = kzalloc_obj(*mod_fail);
 	if (!mod_fail)
 		return -ENOMEM;
-	memcpy(mod_fail->name, name, strlen(name));
+	strscpy(mod_fail->name, name);
 	__set_bit(reason, &mod_fail->dup_fail_mask);
 	atomic_long_inc(&mod_fail->count);
 	list_add_rcu(&mod_fail->list, &dup_failed_modules);
-- 
2.53.0



