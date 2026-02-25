Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A1A3019C5;
	Wed, 25 Feb 2026 06:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002751; cv=none; b=XkHZru8KHjMq7eyaYIT1Ri0Zx2jmJ67xln5ZAqsZd3moiGnzqTfYN65gLpa1uJ+nmZZtXFzzz9gQ69BNAvD5VtbvellkPTDGuupKbxcLz3SFomuD5m6fciYfagiYfRzOG0d/MqTGRpH0kAcyC8OFM+SQmIvcDAsYk6kSvcqGH10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002751; c=relaxed/simple;
	bh=R6Cq3Kag0z2h1/jS6B6tZdYa+MSxMj5BAFHGh9XPjsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgdi56Paf6Rndm4mqBMeMH/Ee/ZSiTcF5bGRtuWUyNSgb/E9sks2NT8naDk+84TjGxgRNmwk1cAIctmQWYThQ8kS1ZjlxQ+vJ3ICgxEC4YDgQvqx38aqr4anfoP8Av8N6OZaBWsLqm6HJmhXKvGJF7lRhiuchisZPsVuKOdl4Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIqXJqTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIqXJqTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B5FC116D0;
	Wed, 25 Feb 2026 06:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002751;
	bh=R6Cq3Kag0z2h1/jS6B6tZdYa+MSxMj5BAFHGh9XPjsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIqXJqTChNBYumKqp+jardBVyjE15QgOCl+sejhMzC745Jo34vl5zviqQCNrahroZ
	 3S6sQ7m4JXgjsL37ZMEDaGpa+WgqfRhrSoFT0FnfA2eTZ5Lb/gfebTaDcjykYgMEzj
	 0PJZUzKsDmpM+fudWWsuod8xeZAmWJBLgmy6RunQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 576/641] apparmor: fix invalid deref of rawdata when export_binary is unset
Date: Tue, 24 Feb 2026 17:25:02 -0800
Message-ID: <20260225012402.473297441@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Georgia Garcia <georgia.garcia@canonical.com>

[ Upstream commit df9ac55abd18628bd8cff687ea043660532a3654 ]

If the export_binary parameter is disabled on runtime, profiles that
were loaded before that will still have their rawdata stored in
apparmorfs, with a symbolic link to the rawdata on the policy
directory. When one of those profiles are replaced, the rawdata is set
to NULL, but when trying to resolve the symbolic links to rawdata for
that profile, it will try to dereference profile->rawdata->name when
profile->rawdata is now NULL causing an oops. Fix it by checking if
rawdata is set.

[  168.653080] BUG: kernel NULL pointer dereference, address: 0000000000000088
[  168.657420] #PF: supervisor read access in kernel mode
[  168.660619] #PF: error_code(0x0000) - not-present page
[  168.663613] PGD 0 P4D 0
[  168.665450] Oops: Oops: 0000 [#1] SMP NOPTI
[  168.667836] CPU: 1 UID: 0 PID: 1729 Comm: ls Not tainted 6.19.0-rc7+ #3 PREEMPT(voluntary)
[  168.672308] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  168.679327] RIP: 0010:rawdata_get_link_base.isra.0+0x23/0x330
[  168.682768] Code: 90 90 90 90 90 90 90 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 48 89 55 d0 48 85 ff 0f 84 e3 01 00 00 <48> 83 3c 25 88 00 00 00 00 0f 84 d4 01 00 00 49 89 f6 49 89 cc e8
[  168.689818] RSP: 0018:ffffcdcb8200fb80 EFLAGS: 00010282
[  168.690871] RAX: ffffffffaee74ec0 RBX: 0000000000000000 RCX: ffffffffb0120158
[  168.692251] RDX: ffffcdcb8200fbe0 RSI: ffff88c187c9fa80 RDI: ffff88c186c98a80
[  168.693593] RBP: ffffcdcb8200fbc0 R08: 0000000000000000 R09: 0000000000000000
[  168.694941] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88c186c98a80
[  168.696289] R13: 00007fff005aaa20 R14: 0000000000000080 R15: ffff88c188f4fce0
[  168.697637] FS:  0000790e81c58280(0000) GS:ffff88c20a957000(0000) knlGS:0000000000000000
[  168.699227] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  168.700349] CR2: 0000000000000088 CR3: 000000012fd3e000 CR4: 0000000000350ef0
[  168.701696] Call Trace:
[  168.702325]  <TASK>
[  168.702995]  rawdata_get_link_data+0x1c/0x30
[  168.704145]  vfs_readlink+0xd4/0x160
[  168.705152]  do_readlinkat+0x114/0x180
[  168.706214]  __x64_sys_readlink+0x1e/0x30
[  168.708653]  x64_sys_call+0x1d77/0x26b0
[  168.709525]  do_syscall_64+0x81/0x500
[  168.710348]  ? do_statx+0x72/0xb0
[  168.711109]  ? putname+0x3e/0x80
[  168.711845]  ? __x64_sys_statx+0xb7/0x100
[  168.712711]  ? x64_sys_call+0x10fc/0x26b0
[  168.713577]  ? do_syscall_64+0xbf/0x500
[  168.714412]  ? do_user_addr_fault+0x1d2/0x8d0
[  168.715404]  ? irqentry_exit+0xb2/0x740
[  168.716359]  ? exc_page_fault+0x90/0x1b0
[  168.717307]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 1180b4c757aab ("apparmor: fix dangling symlinks to policy rawdata after replacement")
Signed-off-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 391a586d0557f..7803b973b4c42 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -1639,6 +1639,15 @@ static const char *rawdata_get_link_base(struct dentry *dentry,
 
 	label = aa_get_label_rcu(&proxy->label);
 	profile = labels_profile(label);
+
+	/* rawdata can be null when aa_g_export_binary is unset during
+	 * runtime and a profile is replaced
+	 */
+	if (!profile->rawdata) {
+		aa_put_label(label);
+		return ERR_PTR(-ENOENT);
+	}
+
 	depth = profile_depth(profile);
 	target = gen_symlink_name(depth, profile->rawdata->name, name);
 	aa_put_label(label);
-- 
2.51.0



