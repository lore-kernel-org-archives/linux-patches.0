Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A67A401A1E;
	Thu, 12 Mar 2026 20:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773345894; cv=none; b=TqAhs1A5YW+gDPqpfCGxTidhPsPB4ZzW7sl5Tx/o4XzjyaNzMv1xjcOqziF/rYkqE18BThb0OvmA2/XIkshb8qQyskeJKdVqCv3EsIn55JXMBij7zOxGVFIhqQA9k7+3TzJDEFIfCl1ohMlfqr+Lc4WY99Q1yMDOFyI84xixwtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773345894; c=relaxed/simple;
	bh=TosWTobnCzPXtiK+zdvyIiaZORyd1RwUG5mfFhFrNTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBx2Mj0fBi9ylCutFfM4qkWAsJX5d7eCPb+JGF3UXulUHGrQIayHeHjdBXLNZDbIwuOEWBZC6zYC5Delg3g1lwIO4F17fZW+croydKHD4MC+vKi/1K3lOiYGHAUP6tjC+PlUrAzaOgNgZ/h1HZGUb00GpjA7eGUPZEOwswese1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OaPC5Z1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OaPC5Z1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EF3C19425;
	Thu, 12 Mar 2026 20:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773345894;
	bh=TosWTobnCzPXtiK+zdvyIiaZORyd1RwUG5mfFhFrNTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaPC5Z1ygmnAD6CAN+oU45fxDIFs/nnuEjDx0oEgkvZD9s+X43Y4XNTD4yLooczE+
	 MfErbNBjQOYvBx0FUG55uqGP9T8rF7lbnKestTi/eICtUCpZySe+Kyc4fWykbLgmhS
	 fyYMrofLvhyIBflmpBCiS3g2SHoNibSo5YuBAJEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.19 08/13] apparmor: fix missing bounds check on DEFAULT table in verify_dfa()
Date: Thu, 12 Mar 2026 21:03:40 +0100
Message-ID: <20260312200321.979206131@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312200321.671986598@linuxfoundation.org>
References: <20260312200321.671986598@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>

commit d352873bbefa7eb39995239d0b44ccdf8aaa79a4 upstream.

The verify_dfa() function only checks DEFAULT_TABLE bounds when the state
is not differentially encoded.

When the verification loop traverses the differential encoding chain,
it reads k = DEFAULT_TABLE[j] and uses k as an array index without
validation. A malformed DFA with DEFAULT_TABLE[j] >= state_count,
therefore, causes both out-of-bounds reads and writes.

[   57.179855] ==================================================================
[   57.180549] BUG: KASAN: slab-out-of-bounds in verify_dfa+0x59a/0x660
[   57.180904] Read of size 4 at addr ffff888100eadec4 by task su/993

[   57.181554] CPU: 1 UID: 0 PID: 993 Comm: su Not tainted 6.19.0-rc7-next-20260127 #1 PREEMPT(lazy)
[   57.181558] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   57.181563] Call Trace:
[   57.181572]  <TASK>
[   57.181577]  dump_stack_lvl+0x5e/0x80
[   57.181596]  print_report+0xc8/0x270
[   57.181605]  ? verify_dfa+0x59a/0x660
[   57.181608]  kasan_report+0x118/0x150
[   57.181620]  ? verify_dfa+0x59a/0x660
[   57.181623]  verify_dfa+0x59a/0x660
[   57.181627]  aa_dfa_unpack+0x1610/0x1740
[   57.181629]  ? __kmalloc_cache_noprof+0x1d0/0x470
[   57.181640]  unpack_pdb+0x86d/0x46b0
[   57.181647]  ? srso_alias_return_thunk+0x5/0xfbef5
[   57.181653]  ? srso_alias_return_thunk+0x5/0xfbef5
[   57.181656]  ? aa_unpack_nameX+0x1a8/0x300
[   57.181659]  aa_unpack+0x20b0/0x4c30
[   57.181662]  ? srso_alias_return_thunk+0x5/0xfbef5
[   57.181664]  ? stack_depot_save_flags+0x33/0x700
[   57.181681]  ? kasan_save_track+0x4f/0x80
[   57.181683]  ? kasan_save_track+0x3e/0x80
[   57.181686]  ? __kasan_kmalloc+0x93/0xb0
[   57.181688]  ? __kvmalloc_node_noprof+0x44a/0x780
[   57.181693]  ? aa_simple_write_to_buffer+0x54/0x130
[   57.181697]  ? policy_update+0x154/0x330
[   57.181704]  aa_replace_profiles+0x15a/0x1dd0
[   57.181707]  ? srso_alias_return_thunk+0x5/0xfbef5
[   57.181710]  ? __kvmalloc_node_noprof+0x44a/0x780
[   57.181712]  ? aa_loaddata_alloc+0x77/0x140
[   57.181715]  ? srso_alias_return_thunk+0x5/0xfbef5
[   57.181717]  ? _copy_from_user+0x2a/0x70
[   57.181730]  policy_update+0x17a/0x330
[   57.181733]  profile_replace+0x153/0x1a0
[   57.181735]  ? rw_verify_area+0x93/0x2d0
[   57.181740]  vfs_write+0x235/0xab0
[   57.181745]  ksys_write+0xb0/0x170
[   57.181748]  do_syscall_64+0x8e/0x660
[   57.181762]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   57.181765] RIP: 0033:0x7f6192792eb2

Remove the MATCH_FLAG_DIFF_ENCODE condition to validate all DEFAULT_TABLE
entries unconditionally.

Fixes: 031dcc8f4e84 ("apparmor: dfa add support for state differential encoding")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/match.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -160,9 +160,10 @@ static int verify_dfa(struct aa_dfa *dfa
 	if (state_count == 0)
 		goto out;
 	for (i = 0; i < state_count; i++) {
-		if (!(BASE_TABLE(dfa)[i] & MATCH_FLAG_DIFF_ENCODE) &&
-		    (DEFAULT_TABLE(dfa)[i] >= state_count))
+		if (DEFAULT_TABLE(dfa)[i] >= state_count) {
+			pr_err("AppArmor DFA default state out of bounds");
 			goto out;
+		}
 		if (BASE_TABLE(dfa)[i] & MATCH_FLAGS_INVALID) {
 			pr_err("AppArmor DFA state with invalid match flags");
 			goto out;


