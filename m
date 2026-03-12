Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA793B6C02;
	Thu, 12 Mar 2026 20:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347297; cv=none; b=MKYnzMEoUra5RYOoH4AV1wTyYxJ7DaOwk9LHIBR5cN+SOsKRkYZnxmUN+OPVZHVv53itudMrLQGxb8O9v/X196PRtS+J4PdL5eI4Y9uWWkxcgaywNu2HhMUiRCumTSkCNztBMU8pKXATh7fMWyjbBqe/UFhRdKSvW5ZzO7RKrPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347297; c=relaxed/simple;
	bh=608NjzKQ5ySF4dZhGUnUEQizpRs5UTEDOHuErrI15/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCwyflM0xJmUcZSKbklSbWghRdWqco1sFdO7a4vHKVy+nTn1upZ0ftCeNMJwiqlIF+UkmdZ8ArV2OGJepYgbNV/P2BdZKivM3MdnXGF/ZBPKS/ZsGsjttto1DNggi60/s106EvEvd5i/uXe8M5j16KEEW8vUg0129YstfdZOETw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRqDnzKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRqDnzKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73E6C4CEF7;
	Thu, 12 Mar 2026 20:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347297;
	bh=608NjzKQ5ySF4dZhGUnUEQizpRs5UTEDOHuErrI15/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRqDnzKD6dDEOlG1+u4ZNSUkXbKfudKAOtJYvhvLdgtD6KNbAtXRV6K/ouDCpoVTg
	 SpxuyZMQvrpymNJLzFMJpe51548wThFuIsNfaC48BZQEemag+dLkd8RpyZ9bSW3Zb3
	 RJaa4ABC+P66ffNaicPnoH5FsbQuyY+2RLzXhUrg=
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
Subject: [PATCH 6.12 254/265] apparmor: fix side-effect bug in match_char() macro usage
Date: Thu, 12 Mar 2026 21:10:41 +0100
Message-ID: <20260312201027.518157626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>

commit 8756b68edae37ff546c02091989a4ceab3f20abd upstream.

The match_char() macro evaluates its character parameter multiple
times when traversing differential encoding chains. When invoked
with *str++, the string pointer advances on each iteration of the
inner do-while loop, causing the DFA to check different characters
at each iteration and therefore skip input characters.
This results in out-of-bounds reads when the pointer advances past
the input buffer boundary.

[   94.984676] ==================================================================
[   94.985301] BUG: KASAN: slab-out-of-bounds in aa_dfa_match+0x5ae/0x760
[   94.985655] Read of size 1 at addr ffff888100342000 by task file/976

[   94.986319] CPU: 7 UID: 1000 PID: 976 Comm: file Not tainted 6.19.0-rc7-next-20260127 #1 PREEMPT(lazy)
[   94.986322] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   94.986329] Call Trace:
[   94.986341]  <TASK>
[   94.986347]  dump_stack_lvl+0x5e/0x80
[   94.986374]  print_report+0xc8/0x270
[   94.986384]  ? aa_dfa_match+0x5ae/0x760
[   94.986388]  kasan_report+0x118/0x150
[   94.986401]  ? aa_dfa_match+0x5ae/0x760
[   94.986405]  aa_dfa_match+0x5ae/0x760
[   94.986408]  __aa_path_perm+0x131/0x400
[   94.986418]  aa_path_perm+0x219/0x2f0
[   94.986424]  apparmor_file_open+0x345/0x570
[   94.986431]  security_file_open+0x5c/0x140
[   94.986442]  do_dentry_open+0x2f6/0x1120
[   94.986450]  vfs_open+0x38/0x2b0
[   94.986453]  ? may_open+0x1e2/0x2b0
[   94.986466]  path_openat+0x231b/0x2b30
[   94.986469]  ? __x64_sys_openat+0xf8/0x130
[   94.986477]  do_file_open+0x19d/0x360
[   94.986487]  do_sys_openat2+0x98/0x100
[   94.986491]  __x64_sys_openat+0xf8/0x130
[   94.986499]  do_syscall_64+0x8e/0x660
[   94.986515]  ? count_memcg_events+0x15f/0x3c0
[   94.986526]  ? srso_alias_return_thunk+0x5/0xfbef5
[   94.986540]  ? handle_mm_fault+0x1639/0x1ef0
[   94.986551]  ? vma_start_read+0xf0/0x320
[   94.986558]  ? srso_alias_return_thunk+0x5/0xfbef5
[   94.986561]  ? srso_alias_return_thunk+0x5/0xfbef5
[   94.986563]  ? fpregs_assert_state_consistent+0x50/0xe0
[   94.986572]  ? srso_alias_return_thunk+0x5/0xfbef5
[   94.986574]  ? arch_exit_to_user_mode_prepare+0x9/0xb0
[   94.986587]  ? srso_alias_return_thunk+0x5/0xfbef5
[   94.986588]  ? irqentry_exit+0x3c/0x590
[   94.986595]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   94.986597] RIP: 0033:0x7fda4a79c3ea

Fix by extracting the character value before invoking match_char,
ensuring single evaluation per outer loop.

Fixes: 074c1cd798cb ("apparmor: dfa move character match into a macro")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/match.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -408,13 +408,18 @@ aa_state_t aa_dfa_match_len(struct aa_df
 	if (dfa->tables[YYTD_ID_EC]) {
 		/* Equivalence class table defined */
 		u8 *equiv = EQUIV_TABLE(dfa);
-		for (; len; len--)
-			match_char(state, def, base, next, check,
-				   equiv[(u8) *str++]);
+		for (; len; len--) {
+			u8 c = equiv[(u8) *str];
+
+			match_char(state, def, base, next, check, c);
+			str++;
+		}
 	} else {
 		/* default is direct to next state */
-		for (; len; len--)
-			match_char(state, def, base, next, check, (u8) *str++);
+		for (; len; len--) {
+			match_char(state, def, base, next, check, (u8) *str);
+			str++;
+		}
 	}
 
 	return state;
@@ -448,13 +453,18 @@ aa_state_t aa_dfa_match(struct aa_dfa *d
 		/* Equivalence class table defined */
 		u8 *equiv = EQUIV_TABLE(dfa);
 		/* default is direct to next state */
-		while (*str)
-			match_char(state, def, base, next, check,
-				   equiv[(u8) *str++]);
+		while (*str) {
+			u8 c = equiv[(u8) *str];
+
+			match_char(state, def, base, next, check, c);
+			str++;
+		}
 	} else {
 		/* default is direct to next state */
-		while (*str)
-			match_char(state, def, base, next, check, (u8) *str++);
+		while (*str) {
+			match_char(state, def, base, next, check, (u8) *str);
+			str++;
+		}
 	}
 
 	return state;


