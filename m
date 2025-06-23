Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7DF1E22E6;
	Mon, 23 Jun 2025 21:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715334; cv=none; b=qRTJuHtVzjEa8rC/6vAtEb9PRvpvQqhg0dvJgLXTNVO/J07739ybbb4Wiw0k/42jPCD1H67xEuz+5VU8WeM5wm9OcOWfaV7qhN0iWL/H4Jgmdg90JQMqOew5giTfSSdMIVAtAW2AoWiVPv/dPJeEFn3kGKinOkeKuaYqfgu92PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715334; c=relaxed/simple;
	bh=zJprbTTjS79XKrcUxG52r+Ih9JF9Y4OSDEj7NTBJTqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2v/z8cRJ3VK0BFIsAjscTNRmVIDKpju39pMb/sSJcgsAYvbQsdiDm1BywqkowYTep2PwLSWLTKF71RkhLKXnUBf11PNFbQu5wzZooRK5So4Q7LyHbgr9a6dLIlcutJP0hPmrdjJ77XqYWALgWy0TWP69R+FSUEJUGpgalMuziU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXCmXhbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXCmXhbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B572CC4CEEA;
	Mon, 23 Jun 2025 21:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715334;
	bh=zJprbTTjS79XKrcUxG52r+Ih9JF9Y4OSDEj7NTBJTqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXCmXhbvWewFUQ4dHl1EQuVBL0T7205PXreMTQ8M5szBIyfjSleOXz7wlgNJMGTLj
	 P+ECd/b80Cy86g2QJR6API35JZEJvKG4+KkQhEVZ574CQhPL0oRm90xMgl7dABItWx
	 LJkV31X1G4M20M/4Dhjs0gnV/6dOQEy0xM+ExAEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 246/411] ftrace: Fix UAF when lookup kallsym after ftrace disabled
Date: Mon, 23 Jun 2025 15:06:30 +0200
Message-ID: <20250623130639.846222811@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ye Bin <yebin10@huawei.com>

commit f914b52c379c12288b7623bb814d0508dbe7481d upstream.

The following issue happens with a buggy module:

BUG: unable to handle page fault for address: ffffffffc05d0218
PGD 1bd66f067 P4D 1bd66f067 PUD 1bd671067 PMD 101808067 PTE 0
Oops: Oops: 0000 [#1] SMP KASAN PTI
Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
RIP: 0010:sized_strscpy+0x81/0x2f0
RSP: 0018:ffff88812d76fa08 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffffc0601010 RCX: dffffc0000000000
RDX: 0000000000000038 RSI: dffffc0000000000 RDI: ffff88812608da2d
RBP: 8080808080808080 R08: ffff88812608da2d R09: ffff88812608da68
R10: ffff88812608d82d R11: ffff88812608d810 R12: 0000000000000038
R13: ffff88812608da2d R14: ffffffffc05d0218 R15: fefefefefefefeff
FS:  00007fef552de740(0000) GS:ffff8884251c7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffc05d0218 CR3: 00000001146f0000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ftrace_mod_get_kallsym+0x1ac/0x590
 update_iter_mod+0x239/0x5b0
 s_next+0x5b/0xa0
 seq_read_iter+0x8c9/0x1070
 seq_read+0x249/0x3b0
 proc_reg_read+0x1b0/0x280
 vfs_read+0x17f/0x920
 ksys_read+0xf3/0x1c0
 do_syscall_64+0x5f/0x2e0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

The above issue may happen as follows:
(1) Add kprobe tracepoint;
(2) insmod test.ko;
(3)  Module triggers ftrace disabled;
(4) rmmod test.ko;
(5) cat /proc/kallsyms; --> Will trigger UAF as test.ko already removed;
ftrace_mod_get_kallsym()
...
strscpy(module_name, mod_map->mod->name, MODULE_NAME_LEN);
...

The problem is when a module triggers an issue with ftrace and
sets ftrace_disable. The ftrace_disable is set when an anomaly is
discovered and to prevent any more damage, ftrace stops all text
modification. The issue that happened was that the ftrace_disable stops
more than just the text modification.

When a module is loaded, its init functions can also be traced. Because
kallsyms deletes the init functions after a module has loaded, ftrace
saves them when the module is loaded and function tracing is enabled. This
allows the output of the function trace to show the init function names
instead of just their raw memory addresses.

When a module is removed, ftrace_release_mod() is called, and if
ftrace_disable is set, it just returns without doing anything more. The
problem here is that it leaves the mod_list still around and if kallsyms
is called, it will call into this code and access the module memory that
has already been freed as it will return:

  strscpy(module_name, mod_map->mod->name, MODULE_NAME_LEN);

Where the "mod" no longer exists and triggers a UAF bug.

Link: https://lore.kernel.org/all/20250523135452.626d8dcd@gandalf.local.home/

Cc: stable@vger.kernel.org
Fixes: aba4b5c22cba ("ftrace: Save module init functions kallsyms symbols for tracing")
Link: https://lore.kernel.org/20250529111955.2349189-2-yebin@huaweicloud.com
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6468,9 +6468,10 @@ void ftrace_release_mod(struct module *m
 
 	mutex_lock(&ftrace_lock);
 
-	if (ftrace_disabled)
-		goto out_unlock;
-
+	/*
+	 * To avoid the UAF problem after the module is unloaded, the
+	 * 'mod_map' resource needs to be released unconditionally.
+	 */
 	list_for_each_entry_safe(mod_map, n, &ftrace_mod_maps, list) {
 		if (mod_map->mod == mod) {
 			list_del_rcu(&mod_map->list);
@@ -6479,6 +6480,9 @@ void ftrace_release_mod(struct module *m
 		}
 	}
 
+	if (ftrace_disabled)
+		goto out_unlock;
+
 	/*
 	 * Each module has its own ftrace_pages, remove
 	 * them from the list.


