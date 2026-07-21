Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BADC372050;
	Tue, 21 Jul 2026 15:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649061; cv=none; b=s1LnQl2TXsMX+zKCbdRT05SBjvhXlFFW3hUGGXwhNUEFFbsaO6nqzJT9rPBjWryWpG/BE4f86ky9Q8Jl7Qr5qiFSkKX5R3idQh8es+Hgs5h6Om67NhaZ+v+wa0XSZciE0NFLBjiqAqJhRE56p6WG/AtF6vU5Pa218K1Tg/4WRb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649061; c=relaxed/simple;
	bh=gyZxlCyiIq3TYJjNQvj13fnUXHrSPQZuTOuY08VjhcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPrarrkzGzJ/QKbJp7uLUfHNVqN7M6/4YX8WMci75eBd0G55jLQktY46vPFnDD3xkmm+gbb0/m2lI1NQZiZNb/uP7E6NXQ5/RrBcn6rzti+S02Yb8kDHDN22YIIJbiW8TdZrKFLIjVczm6sDnNcCfp15OU6pr3EhVRWFvORk8Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCzcCeRy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCzcCeRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B084A1F000E9;
	Tue, 21 Jul 2026 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649060;
	bh=l/saLUn54fYG/A/nWE1xmbN8iYrUtEtMfMJHXc7fcWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCzcCeRymiYCEnWLvPflT6Oty57Pgu4B6IOOIsA45Fn/F60cFJkqcPNd3IFNHRXB4
	 LWcpgSKmUnNZ2VhKblvw7vjNQG1kRVhoMwXtYtxmezLVmJJ2+X5KP+BgsgMxyzQm61
	 Cqxqe9Y2oJ2UfdawG3yWRCbpblqsFtpLW0qKFH6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+36e50496c8ac4bcde3f9@syzkaller.appspotmail.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0435/2077] bpf: fix UAF by restoring RCU-delayed inode freeing in bpffs
Date: Tue, 21 Jul 2026 17:01:48 +0200
Message-ID: <20260721152603.012867463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit b93c55b4932dd7e32dca8cf34a3443cc87a02906 ]

commit 4f375ade6aa9 ("bpf: Avoid RCU context warning when unpinning
htab with internal structs") moved inode cleanup from ->free_inode()
into ->destroy_inode() to avoid sleeping in RCU context when calling
bpf_any_put(). However this removed the RCU delay on freeing the
inode itself and the cached symlink body (i_link), both of which
can be accessed by RCU pathwalk (pick_link, may_lookup etc.).

This causes a use-after-free when a concurrent unlinkat() drops the
last inode reference and destroy_inode() frees the inode immediately,
while another task is still walking the path in RCU mode and reads
inode->i_opflags (offset +2) inside current_time() -> is_mgtime().

KASAN reports:
  BUG: KASAN: slab-use-after-free in is_mgtime include/linux/fs.h:2313
  Read of size 2 at addr ffff8880407e4282 (offset +2 = i_opflags)

The rules (per Al Viro):
  ->destroy_inode()  called immediately, can sleep, use for blocking
                     cleanup e.g. bpf_any_put()
  ->free_inode()     called after RCU grace period, use for freeing
                     inode and anything RCU-accessible e.g. i_link

Fix: split the two concerns properly:
  - keep bpf_any_put() in bpf_destroy_inode() since it is blocking
    and needs to run promptly
  - introduce bpf_free_inode() to handle kfree(i_link) and
    free_inode_nonrcu() with proper RCU delay, preventing the UAF

Fixes: 4f375ade6aa9 ("bpf: Avoid RCU context warning when unpinning htab with internal structs")
Reported-by: syzbot+36e50496c8ac4bcde3f9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=36e50496c8ac4bcde3f9
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/all/20260423043906.GN3518998@ZenIV/
Link: https://lore.kernel.org/all/20260602002607.110866-1-kartikey406@gmail.com/T/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://lore.kernel.org/r/20260602025249.113828-1-kartikey406@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/inode.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 25c06a0118258d..188c774a469ca5 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -766,10 +766,18 @@ static void bpf_destroy_inode(struct inode *inode)
 {
 	enum bpf_type type;
 
-	if (S_ISLNK(inode->i_mode))
-		kfree(inode->i_link);
 	if (!bpf_inode_type(inode, &type))
 		bpf_any_put(inode->i_private, type);
+}
+
+/*
+ * Called after RCU grace period - safe to free inode and anything
+ *  that might be accessed by RCU pathwalk (inode fields, i_link).
+ */
+static void bpf_free_inode(struct inode *inode)
+{
+	if (S_ISLNK(inode->i_mode))
+		kfree(inode->i_link);
 	free_inode_nonrcu(inode);
 }
 
@@ -778,6 +786,7 @@ const struct super_operations bpf_super_ops = {
 	.drop_inode	= inode_just_drop,
 	.show_options	= bpf_show_options,
 	.destroy_inode	= bpf_destroy_inode,
+	.free_inode	= bpf_free_inode,
 };
 
 enum {
-- 
2.53.0



