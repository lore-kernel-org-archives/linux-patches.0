Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376754BEE54;
	Sat, 12 Sep 2026 09:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205200; cv=none; b=hvh8DVWeqf5U2i0PRuhaWuYLn1HUHy40Er98ll9KKcp1eEC488FnJevQY9iu7WFvDAjmUY9DEokMDtFZJHc4pS0WWyQram47F+0uJp8RiLMm/azMUrQkJCsp7W0N8k/WpeFZimMOQTMBWbGngUrwXh0BBN2Ab+OzrEe5kfvui7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205200; c=relaxed/simple;
	bh=tUMKHicZvD9XBO4qSlKg/MfGX3GP/GXqPHzFlItQd4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJIdjAnwN/aTC8agDSzekpsPEbrM1kawjRn5D1BVBWSeXc+qKI2WooXn3BmEk+y/bqBGDUPPzh8EALOLvyr1h/GJzfnKONit9EagTLwsGI6EofKDFseEPusam02lI5XZIsWza2eFy6fDj320GnYC6lZzlxCv4MOcXLNYNTKKnxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVTDRBh+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVTDRBh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FEB1F000FF;
	Sat, 12 Sep 2026 09:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205199;
	bh=H0XmdNg9U5K7XqxG9mNRbo4aw5zbittnyx3Z+TATesk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVTDRBh+3oBk4frNNf7qhIj06hAOOzIQnv8o4Rq+nZDPKNHApdOkhtijpLfWCn6Vn
	 M6GPa19cU8r2A95ypNjB8B4MoHAm9sDCCSaW1WQqhDaox7+yqyeqfyFAcarQYdPl9k
	 FK3yO1ecYBZB2ZGnIMsMbaTV17yqtV0q3OjpoT/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+faed97c4ed43bfe7fee5@syzkaller.appspotmail.com,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1768/1815] apparmor: policy_int make sure list heads are initialized before fail path
Date: Sat, 12 Sep 2026 08:58:38 +0200
Message-ID: <20260912065730.507882946@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 3daad923a8685adb66087e0d819559b7eb6ba975 ]

If profile create fails before policy_init is complete the list heads
are not properly initialized causing profile_free() sanity checks to
trigger the following splat.

AppArmor WARN aa_policy_destroy: (((!list_empty(&policy->profiles) && (&policy->profiles)->prev != ((void *) 0x122 + (0xdead000000000000UL))))):
WARNING: security/apparmor/lib.c:509 at aa_policy_destroy+0x164/0x1b0 security/apparmor/lib.c:509, CPU#0: syz.0.17/5541
Modules linked in:
CPU: 0 UID: 0 PID: 5541 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:aa_policy_destroy+0x16b/0x1b0 security/apparmor/lib.c:509
Code: 85 ed 7e 4d e8 96 bc 37 fd 5b 41 5c 41 5e 41 5f 5d e9 19 27 4e 07 cc e8 83 bc 37 fd 48 8d 3d 0c f0 d3 0b 48 c7 c6 a4 eb 38 8e <67> 48 0f b9 3a e9 04 ff ff ff e8 66 bc 37 fd 48 8d 3d ff ef d3 0b
RSP: 0018:ffffc9000345eaa0 EFLAGS: 00010293
RAX: ffffffff848f530d RBX: ffff88803f734800 RCX: ffff88801af2a580
RDX: 0000000000000000 RSI: ffffffff8e38eba4 RDI: ffffffff90634320
RBP: 0000000000000000 R08: 0000000000000cc0 R09: 00000000ffffffff
R10: dffffc0000000000 R11: fffffbfff1d95913 R12: dead000000000122
R13: ffff88803f734800 R14: ffff88803f734828 R15: dffffc0000000000
FS:  00007f5f6a1836c0(0000) GS:ffff88808c519000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d02407b048 CR3: 0000000012aa9000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 aa_free_profile+0x9d/0x9f0 security/apparmor/policy.c:334
 aa_alloc_profile+0x1e4/0x3e0 security/apparmor/policy.c:416
 unpack_profile security/apparmor/policy_unpack.c:1153 [inline]
 aa_unpack+0x17db/0x7430 security/apparmor/policy_unpack.c:1748
 aa_replace_profiles+0x226/0x2a20 security/apparmor/policy.c:1183
 policy_update+0x234/0x4a0 security/apparmor/apparmorfs.c:505
 profile_load+0x1cb/0x320 security/apparmor/apparmorfs.c:522
 vfs_write+0x296/0xba0 fs/read_write.c:685
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5f6939e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5f6a183028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f5f69625fa0 RCX: 00007f5f6939e0d9
RDX: 0000000000000041 RSI: 0000200000000400 RDI: 0000000000000003
RBP: 00007f5f6a183090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007f5f69626038 R14: 00007f5f69625fa0 R15: 00007ffe23725c18

Reported-by: syzbot+faed97c4ed43bfe7fee5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=faed97c4ed43bfe7fee5
Fixes: fe6bb31f590c9 ("apparmor: split out shared policy_XXX fns to lib")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
index e41ff57798b25..b284cfcc5d349 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -482,6 +482,8 @@ bool aa_policy_init(struct aa_policy *policy, const char *prefix,
 	char *hname;
 	size_t hname_sz;
 
+	INIT_LIST_HEAD(&policy->list);
+	INIT_LIST_HEAD(&policy->profiles);
 	hname_sz = (prefix ? strlen(prefix) + 2 : 0) + strlen(name) + 1;
 	/* freed by policy_free */
 	hname = aa_str_alloc(hname_sz, gfp);
@@ -494,8 +496,6 @@ bool aa_policy_init(struct aa_policy *policy, const char *prefix,
 	policy->hname = hname;
 	/* base.name is a substring of fqname */
 	policy->name = basename(policy->hname);
-	INIT_LIST_HEAD(&policy->list);
-	INIT_LIST_HEAD(&policy->profiles);
 
 	return true;
 }
-- 
2.53.0



