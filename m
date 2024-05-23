Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C366A1E504;
	Thu, 23 May 2024 13:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470116; cv=none; b=L9NxrBmXjJPfN2R7c858tOijsr7BXJwMGMcfQPXpJ3YOsYilksyYqHVxP18ZfKfkFSUsIFpqYjlr1PzXRYodf7ACeL1GJEZEKWUL3+TTwfSRCrpkRiT7oioT/FA4cYQuhQ+b4XHWuks724SmVDg/9EprEZj6oo1HuqA5CBpQyMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470116; c=relaxed/simple;
	bh=bfOTqECI+WRDBBG9cy1vni/lTn9XmkLtVCP5WzzFaxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxFxocjF/LSTFs+gLgofsvBpkSly5oTEbZARXsaB+DUonTBbWtaaAeDBCENcVBDEf9XYlZTO7N/7eIb1mrx8S1a74/65anN5oQ8iwdCVBkTyUm7QkR4sP7+QkC+dykJldi9aUr9WFjxGxHlIb3LNLz+ruEPsDFeNZJLLonbFm6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXmcNEAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXmcNEAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADDEC2BD10;
	Thu, 23 May 2024 13:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470116;
	bh=bfOTqECI+WRDBBG9cy1vni/lTn9XmkLtVCP5WzzFaxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXmcNEAGjh1aTyFJgCXMvVa0nDkcjTRjw+uZHvNGXqxeUfhpj5AT0o6wa/KvtR9sF
	 a4afG/3yE4BOeLrbtodrsAyZ/w9D2edemwJfLlVbk7CxUKNYAstP3df7bpsnmSPfGj
	 xDS6LivnzmMab2ImFmUXiWuxinDO56cyeP+/5zOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, George Guo" <guodongtai@kylinos.cn>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 4.19 16/18] tracing: Remove unnecessary var_ref destroy in track_data_destroy()
Date: Thu, 23 May 2024 15:12:39 +0200
Message-ID: <20240523130326.355822129@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>
References: <20240523130325.727602650@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Zanussi <tom.zanussi@linux.intel.com>

commit ff9d31d0d46672e201fc9ff59c42f1eef5f00c77 upstream.

Commit 656fe2ba85e8 (tracing: Use hist trigger's var_ref array to
destroy var_refs) centralized the destruction of all the var_refs
in one place so that other code didn't have to do it.

The track_data_destroy() added later ignored that and also destroyed
the track_data var_ref, causing a double-free error flagged by KASAN.

==================================================================
BUG: KASAN: use-after-free in destroy_hist_field+0x30/0x70
Read of size 8 at addr ffff888086df2210 by task bash/1694

CPU: 6 PID: 1694 Comm: bash Not tainted 5.1.0-rc1-test+ #15
Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01 v03.03
07/14/2016
Call Trace:
 dump_stack+0x71/0xa0
 ? destroy_hist_field+0x30/0x70
 print_address_description.cold.3+0x9/0x1fb
 ? destroy_hist_field+0x30/0x70
 ? destroy_hist_field+0x30/0x70
 kasan_report.cold.4+0x1a/0x33
 ? __kasan_slab_free+0x100/0x150
 ? destroy_hist_field+0x30/0x70
 destroy_hist_field+0x30/0x70
 track_data_destroy+0x55/0xe0
 destroy_hist_data+0x1f0/0x350
 hist_unreg_all+0x203/0x220
 event_trigger_open+0xbb/0x130
 do_dentry_open+0x296/0x700
 ? stacktrace_count_trigger+0x30/0x30
 ? generic_permission+0x56/0x200
 ? __x64_sys_fchdir+0xd0/0xd0
 ? inode_permission+0x55/0x200
 ? security_inode_permission+0x18/0x60
 path_openat+0x633/0x22b0
 ? path_lookupat.isra.50+0x420/0x420
 ? __kasan_kmalloc.constprop.12+0xc1/0xd0
 ? kmem_cache_alloc+0xe5/0x260
 ? getname_flags+0x6c/0x2a0
 ? do_sys_open+0x149/0x2b0
 ? do_syscall_64+0x73/0x1b0
 ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
 ? _raw_write_lock_bh+0xe0/0xe0
 ? __kernel_text_address+0xe/0x30
 ? unwind_get_return_address+0x2f/0x50
 ? __list_add_valid+0x2d/0x70
 ? deactivate_slab.isra.62+0x1f4/0x5a0
 ? getname_flags+0x6c/0x2a0
 ? set_track+0x76/0x120
 do_filp_open+0x11a/0x1a0
 ? may_open_dev+0x50/0x50
 ? _raw_spin_lock+0x7a/0xd0
 ? _raw_write_lock_bh+0xe0/0xe0
 ? __alloc_fd+0x10f/0x200
 do_sys_open+0x1db/0x2b0
 ? filp_open+0x50/0x50
 do_syscall_64+0x73/0x1b0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fa7b24a4ca2
Code: 25 00 00 41 00 3d 00 00 41 00 74 4c 48 8d 05 85 7a 0d 00 8b 00 85 c0
75 6d 89 f2 b8 01 01 00 00 48 89 fe bf 9c ff ff ff 0f 05 <48> 3d 00 f0 ff ff
0f 87 a2 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
RSP: 002b:00007fffbafb3af0 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 000055d3648ade30 RCX: 00007fa7b24a4ca2
RDX: 0000000000000241 RSI: 000055d364a55240 RDI: 00000000ffffff9c
RBP: 00007fffbafb3bf0 R08: 0000000000000020 R09: 0000000000000002
R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000003 R14: 0000000000000001 R15: 000055d364a55240
==================================================================

So remove the track_data_destroy() destroy_hist_field() call for that
var_ref.

Link: http://lkml.kernel.org/r/1deffec420f6a16d11dd8647318d34a66d1989a9.camel@linux.intel.com

Fixes: 466f4528fbc69 ("tracing: Generalize hist trigger onmax and save action")
Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3587,7 +3587,6 @@ static void track_data_destroy(struct hi
 			       struct action_data *data)
 {
 	destroy_hist_field(data->track_data.track_var, 0);
-	destroy_hist_field(data->track_data.var_ref, 0);
 
 	kfree(data->track_data.var_str);
 


