Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AE851014;
	Tue, 23 Jan 2024 00:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970075; cv=none; b=NnNooqHbTy+ea/IGgC1xiczY7j+QctsJXe6ZVkfLGNXSG9KwfozbX8PpmbzVe9kF91DshYpZ7WScw3Xhz5tPhvdWJAlY57AOZhmrI/gBNeSB22VEs7Vbqd/DEwE8/64F1BOKOwBjlaIrBkvFVTHkURHXIoJLDCeRUppc1yIpIRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970075; c=relaxed/simple;
	bh=nnV+sKR/7HGxbfai+Y64ZU6EhUsMQjTsyy8n23zDZDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tshtWCNnoFQZI4ch8g5tc8iHh1f6kPMD9L2P4ljWdHWW3tyXHb8/TUX5JAPUQ4tfDN5LSZU6fEKeQw+Vy8n7s1HCw5lkQTz1LUh4RgbIYEGPdBTby5urctHSxWTnFiGLVFAHAGZna0+Mr/RgY1wUmQsVM4KfDOTZktAf6Rxk1XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4zq0NDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4zq0NDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B8CC433F1;
	Tue, 23 Jan 2024 00:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970074;
	bh=nnV+sKR/7HGxbfai+Y64ZU6EhUsMQjTsyy8n23zDZDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4zq0NDDevOAojoprlyQeE0PpNuGaN8RqJ+a9iQTfw4OylrBuItE65E7e3mXVjnSh
	 IFY213g9w664X72iK7b9Y7d9VDtam0oho5genYTO2RBgHsdTQRBJ+PlsuX/2cEofph
	 I9jmycGfkKAp8wTd2EgL6J2lpH5SZ71BgjL5WJHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 556/641] apparmor: free the allocated pdb objects
Date: Mon, 22 Jan 2024 15:57:40 -0800
Message-ID: <20240122235835.545930628@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index ed4c9803c8fa..957654d253dd 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -99,13 +99,14 @@ const char *const aa_profile_mode_names[] = {
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
2.43.0



