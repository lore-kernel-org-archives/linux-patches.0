Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2626A537F7;
	Tue, 23 Jan 2024 00:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970088; cv=none; b=i7DYNYx1lQ1u4TAlVAFRjgJmr3PL+2bidKyT7rCZI4wMUlqOFO1hV+fV6bQwWrqjYOR3VewKx+pwTLuiDedgOwu9ct1CPbhGQMzGuwGOBK77VNsjwyYht0ppbN5zYtXx8QZnLEGm3rTs1siUswpCpn9IvoZ0xmKWiC43tL2j2QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970088; c=relaxed/simple;
	bh=JiXRcifdb6dg7GHtC3VImIZ2Lsxz7dRff6VlRQcyE8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8V9v9fSdLAOOYWzvjQ3euPa73zwJkYEHaruUr2STp3Wr2/NasGuNr7vB70gSK3ulPNp4g7LVYyaX+haA0Ow+Ab1XRaXY565JZfoBLjKqR3jQwPvq818QL3+NpG6MTdujB1Zr0agtVhs70CHTM0L4joi0Z3DsNcn/FrNjJBu8cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqAm/m83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqAm/m83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86651C433C7;
	Tue, 23 Jan 2024 00:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970088;
	bh=JiXRcifdb6dg7GHtC3VImIZ2Lsxz7dRff6VlRQcyE8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqAm/m83Lkdk4f9KvOVCry9p7IbakiU5CHHeP2MFEGlTjUPxudn42rV+pb2q3lmJr
	 NnxGgBFEKOMCmwsYgeYQ1EldSCrovu5eaHlQ7c1faB5Qhxu/LSCQy42T3BYogyIO7g
	 n6RhHza2G/3XwGK0fVacqEwNCbt3tC2ZM+gr3BtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 560/641] apparmor: fix possible memory leak in unpack_trans_table
Date: Mon, 22 Jan 2024 15:57:44 -0800
Message-ID: <20240122235835.670949826@linuxfoundation.org>
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

[ Upstream commit 1342ad786073e96fa813ad943c19f586157ae297 ]

If we fail to unpack the transition table then the table elements which
have been already allocated are not freed on error path.

unreferenced object 0xffff88802539e000 (size 128):
  comm "apparmor_parser", pid 903, jiffies 4294914938 (age 35.085s)
  hex dump (first 32 bytes):
    20 73 6f 6d 65 20 6e 61 73 74 79 20 73 74 72 69   some nasty stri
    6e 67 20 73 6f 6d 65 20 6e 61 73 74 79 20 73 74  ng some nasty st
  backtrace:
    [<ffffffff81ddb312>] __kmem_cache_alloc_node+0x1e2/0x2d0
    [<ffffffff81c47194>] __kmalloc_node_track_caller+0x54/0x170
    [<ffffffff81c225b9>] kmemdup+0x29/0x60
    [<ffffffff83e1ee65>] aa_unpack_strdup+0xe5/0x1b0
    [<ffffffff83e20808>] unpack_pdb+0xeb8/0x2700
    [<ffffffff83e23567>] unpack_profile+0x1507/0x4a30
    [<ffffffff83e27bfa>] aa_unpack+0x36a/0x1560
    [<ffffffff83e194c3>] aa_replace_profiles+0x213/0x33c0
    [<ffffffff83de9461>] policy_update+0x261/0x370
    [<ffffffff83de978e>] profile_replace+0x20e/0x2a0
    [<ffffffff81eac8bf>] vfs_write+0x2af/0xe00
    [<ffffffff81eaddd6>] ksys_write+0x126/0x250
    [<ffffffff88f34fb6>] do_syscall_64+0x46/0xf0
    [<ffffffff890000ea>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

Call aa_free_str_table() on error path as was done before the blamed
commit. It implements all necessary checks, frees str_table if it is
available and nullifies the pointers.

Found by Linux Verification Center (linuxtesting.org).

Fixes: a0792e2ceddc ("apparmor: make transition table unpack generic so it can be reused")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lib.c           | 1 +
 security/apparmor/policy_unpack.c | 7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
index 4c198d273f09..cd569fbbfe36 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -41,6 +41,7 @@ void aa_free_str_table(struct aa_str_table *t)
 			kfree_sensitive(t->table[i]);
 		kfree_sensitive(t->table);
 		t->table = NULL;
+		t->size = 0;
 	}
 }
 
diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 47ec097d6741..9575da5fd4cb 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -478,6 +478,8 @@ static bool unpack_trans_table(struct aa_ext *e, struct aa_str_table *strs)
 		if (!table)
 			goto fail;
 
+		strs->table = table;
+		strs->size = size;
 		for (i = 0; i < size; i++) {
 			char *str;
 			int c, j, pos, size2 = aa_unpack_strdup(e, &str, NULL);
@@ -520,14 +522,11 @@ static bool unpack_trans_table(struct aa_ext *e, struct aa_str_table *strs)
 			goto fail;
 		if (!aa_unpack_nameX(e, AA_STRUCTEND, NULL))
 			goto fail;
-
-		strs->table = table;
-		strs->size = size;
 	}
 	return true;
 
 fail:
-	kfree_sensitive(table);
+	aa_free_str_table(strs);
 	e->pos = saved_pos;
 	return false;
 }
-- 
2.43.0



