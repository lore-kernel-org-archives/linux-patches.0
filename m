Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817B63E315F;
	Wed, 30 Sep 2026 19:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796679; cv=none; b=Dp4jazcZDOdeS+/BKWQxuH0MG3mTBoUqUCjjORZJvzQrNpR/nfDpzioo3SXVzkEizcrDOdvRrMqAPIHsn9qksgsGnNDDgJEhi8HqNZjG8Ar3BPh8fdre+7EjdAZ9jWovDshpiCEYr2pydXkspJQydiA1CV31Jjthbqu4EsGyU+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796679; c=relaxed/simple;
	bh=v07vZXOrMbRjBJ2lhTKFQ9LqWoI+ugNBuCcs1sG2Aa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly6t6G9dznhRYxOiyRkOsj80jT02K07ww35eljEblkSh1+NL26OufjfEhJ+CWtEY4Zkv2pUCLFQloTgzfSIWoEruTcr9LIeEWKdM/AbydHPy1CGteO+aXcn+QG4beOb5bvgSl8S67jdWnFXnIrC4+ST5LBUnvMr9rPKUJS4srA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iNfuD9U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iNfuD9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4411F000FF;
	Wed, 30 Sep 2026 19:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796678;
	bh=2/MmpF1aZ6AJC1UCO+8H1DBbq++EiJ1GyjQ+3XROfLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1iNfuD9U5a2JbZVV226TcPUcHiMdRExoohU4Xcup/w+6PyoO3peWnObaHpK9gYs/p
	 PvkNWMvdQVxVttJaONIKXE6r1lCT64x+VPf0KhVtukSDzavX4lMjCXFG08ORwywWYB
	 0747llqPUPoLLw6o5Xa/45Fu/P8NqzcCcZt46buU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0953/1193] apparmor: free the allocated pdb objects
Date: Wed, 30 Sep 2026 17:27:17 +0200
Message-ID: <20260930152455.415395162@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 1af5aa82c976753e93eb52b72784e586a7d2844b ]

policy_db objects are allocated with kzalloc() inside aa_alloc_pdb() and
are not cleared in the corresponding aa_free_pdb() function causing leak:

unreferenced object 0xffff88801f0a1400 (size 192):
  comm "apparmor_parser", pid 1247, jiffies 4295122827 (age 2306.399s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81ddc612>] __kmem_cache_alloc_node+0x1e2/0x2d0
    [<ffffffff81c47c55>] kmalloc_trace+0x25/0xc0
    [<ffffffff83eb9a12>] aa_alloc_pdb+0x82/0x140
    [<ffffffff83ec4077>] unpack_pdb+0xc7/0x2700
    [<ffffffff83ec6b10>] unpack_profile+0x450/0x4960
    [<ffffffff83ecc129>] aa_unpack+0x309/0x15e0
    [<ffffffff83ebdb23>] aa_replace_profiles+0x213/0x33c0
    [<ffffffff83e8d341>] policy_update+0x261/0x370
    [<ffffffff83e8d66e>] profile_replace+0x20e/0x2a0
    [<ffffffff81eadfaf>] vfs_write+0x2af/0xe00
    [<ffffffff81eaf4c6>] ksys_write+0x126/0x250
    [<ffffffff890fa0b6>] do_syscall_64+0x46/0xf0
    [<ffffffff892000ea>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

Free the pdbs inside aa_free_pdb(). While at it, rename the variable
representing an aa_policydb object to make the function more unified with
aa_pdb_free_kref() and aa_alloc_pdb().

Found by Linux Verification Center (linuxtesting.org).

Fixes: 98b824ff8984 ("apparmor: refcount the pdb")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index df76104e3b338..a113afe79fdea 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -98,13 +98,14 @@ const char *const aa_profile_mode_names[] = {
 };
 
 
-static void aa_free_pdb(struct aa_policydb *policy)
+static void aa_free_pdb(struct aa_policydb *pdb)
 {
-	if (policy) {
-		aa_put_dfa(policy->dfa);
-		if (policy->perms)
-			kvfree(policy->perms);
-		aa_free_str_table(&policy->trans);
+	if (pdb) {
+		aa_put_dfa(pdb->dfa);
+		if (pdb->perms)
+			kvfree(pdb->perms);
+		aa_free_str_table(&pdb->trans);
+		kfree(pdb);
 	}
 }
 
-- 
2.53.0



