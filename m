Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F824C81;
	Thu, 15 Jan 2026 17:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497818; cv=none; b=PZfHjxRTTbM3nIaSScM/nXY4aiMHhUT06JJ/Rb+Ixkus7lZEcZwIlI996gcnVpyOd5zrbLj4s8meyrFP1vsDQqmEk1tvrqGC+GGrI8l6Mqn6SN/h5E8hiohFTqRduSAPevrs59hv2U3jERaKZdRJFxPNShQlhM1fa+bjT+5UzZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497818; c=relaxed/simple;
	bh=cTFYYXKPF5VGWVQS9O4Lgc+cFfSg/rXZDTdcI5gFM/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMfHnpRnyGfVKz0fPdQ9/SdwAlOe5tUJA9M0u+umWmu8ZkNr8Nh8myre41NMkseBMC7KxepzFyNRWRishH+0zbn5wv7rQd+huzsVHUMrUX3EhVTas92R/dKGKyfXSXR0omVxZ6xOyOFDECOgqK/EhV6f9IRqQoEZjGX4QiiG/Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGYV93m0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGYV93m0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E875C16AAE;
	Thu, 15 Jan 2026 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497818;
	bh=cTFYYXKPF5VGWVQS9O4Lgc+cFfSg/rXZDTdcI5gFM/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGYV93m06oXJ0BvhmIWpZil65aeZI0MZ2/241zZIEUuz9wiBHgYGaxxn2BHKoiBAA
	 dk29luDDPOzd+9zeD8hjLhUFVGVSlzEPjQH5UtTlT1BtWajzE4A/5cBzu5B4DIOXEt
	 /qNQL6djotumSH9dm/eNg6b3YX9I2ipxrVJDOu74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/554] livepatch: Match old_sympos 0 and 1 in klp_find_func()
Date: Thu, 15 Jan 2026 17:44:41 +0100
Message-ID: <20260115164254.032589467@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Song Liu <song@kernel.org>

[ Upstream commit 139560e8b973402140cafeb68c656c1374bd4c20 ]

When there is only one function of the same name, old_sympos of 0 and 1
are logically identical. Match them in klp_find_func().

This is to avoid a corner case with different toolchain behavior.

In this specific issue, two versions of kpatch-build were used to
build livepatch for the same kernel. One assigns old_sympos == 0 for
unique local functions, the other assigns old_sympos == 1 for unique
local functions. Both versions work fine by themselves. (PS: This
behavior change was introduced in a downstream version of kpatch-build.
This change does not exist in upstream kpatch-build.)

However, during livepatch upgrade (with the replace flag set) from a
patch built with one version of kpatch-build to the same fix built with
the other version of kpatch-build, livepatching fails with errors like:

[   14.218706] sysfs: cannot create duplicate filename 'xxx/somefunc,1'
...
[   14.219466] Call Trace:
[   14.219468]  <TASK>
[   14.219469]  dump_stack_lvl+0x47/0x60
[   14.219474]  sysfs_warn_dup.cold+0x17/0x27
[   14.219476]  sysfs_create_dir_ns+0x95/0xb0
[   14.219479]  kobject_add_internal+0x9e/0x260
[   14.219483]  kobject_add+0x68/0x80
[   14.219485]  ? kstrdup+0x3c/0xa0
[   14.219486]  klp_enable_patch+0x320/0x830
[   14.219488]  patch_init+0x443/0x1000 [ccc_0_6]
[   14.219491]  ? 0xffffffffa05eb000
[   14.219492]  do_one_initcall+0x2e/0x190
[   14.219494]  do_init_module+0x67/0x270
[   14.219496]  init_module_from_file+0x75/0xa0
[   14.219499]  idempotent_init_module+0x15a/0x240
[   14.219501]  __x64_sys_finit_module+0x61/0xc0
[   14.219503]  do_syscall_64+0x5b/0x160
[   14.219505]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[   14.219507] RIP: 0033:0x7f545a4bd96d
...
[   14.219516] kobject: kobject_add_internal failed for somefunc,1 with
    -EEXIST, don't try to register things with the same name ...

This happens because klp_find_func() thinks somefunc with old_sympos==0
is not the same as somefunc with old_sympos==1, and klp_add_object_nops
adds another xxx/func,1 to the list of functions to patch.

Signed-off-by: Song Liu <song@kernel.org>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
[pmladek@suse.com: Fixed some typos.]
Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/livepatch/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 147ed154ebc77..c49042f5e71ec 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -89,8 +89,14 @@ static struct klp_func *klp_find_func(struct klp_object *obj,
 	struct klp_func *func;
 
 	klp_for_each_func(obj, func) {
+		/*
+		 * Besides identical old_sympos, also consider old_sympos
+		 * of 0 and 1 are identical.
+		 */
 		if ((strcmp(old_func->old_name, func->old_name) == 0) &&
-		    (old_func->old_sympos == func->old_sympos)) {
+		    ((old_func->old_sympos == func->old_sympos) ||
+		     (old_func->old_sympos == 0 && func->old_sympos == 1) ||
+		     (old_func->old_sympos == 1 && func->old_sympos == 0))) {
 			return func;
 		}
 	}
-- 
2.51.0



