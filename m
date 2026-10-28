Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215589;
	b=hgCQsA4p2GugUftx3056AjU182kGUZpP6JDHNlJJCdtoVuvzcoHtl8Vqv7gEcjyJMBHs
	 jkPfDFaItCV3szFvTjxbksT9VkVANMiqFddl2yXPcptb08Dm9TtT6h86yL2vwa/i2BB8U
	 F5HunPkrwE5f04sWPfozIeYQiHn/OmpIl4V2UKj+c7n6HD9lDmfpy97vfnH2gJCpp8C9b
	 fHeV9F6gK4lSaSNiwci5Rr5BXSJ/q/0C9aFv9rBWA9nIWbYHPXVF8hzUWo0F1vpVR1kr+
	 dJDuxt+NlkQsDgZIg0eTjZGT3GqT3uy3k2S2HaOOm/+c1A29RjFHyTfCI22dX0Uq7tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P1Dv4SU6tEWgKGirixMqcCSTHyyT+U9jdXtxHdCkh48=;
	b=JS7rCw5o43WEF/AoWAxFmo0mrECmxrlbNikNY5FKtZA0H9WJXY7U9uTCJMG5lA0dYQ8/
	 LbaixCKplhqleJNsXxVK37BKeSjBmg72mzrjXhSGXPRciAXA7bEscXDEKXQVPZhNWDrzB
	 im5T8NqZzfAcABRDSUcsfGpAZTIQt0lbsSUwQhPtezRqYw5B69HLQ7dYKjRp8mBTqLQuo
	 r7Q8ptg3Z1s5NEOdTxFIoEdbeHgKoFQXdIiQs/YF0f7mLZ26pLTHditjeR6g+TvdL/I88
	 maJaklgqDDyH4Xb3FIhx2hcruYvKtk0RfsgO9bmIk7wY371HCacAAPsSwjel9JcvnTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8z+77nC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFED606A31A;
	Wed, 28 Oct 2026 19:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8z+77nC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA141F01825;
	Wed, 28 Oct 2026 19:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215589;
	bh=P1Dv4SU6tEWgKGirixMqcCSTHyyT+U9jdXtxHdCkh48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w8z+77nCkiRwah0zl2/pJvEKLaZSuZT1HA9+vGw+H7ppp/emMUp6Av3eD7lRgmX3f
	 LVs+cuD+tWogqK7ak8WvXsEWBcEFlDNTHb1mCrD+aj5aRVQFLa9JoCz5kKiMeCoG4f
	 QTpRpweKjH95aHCqApr/ADHWyaBlYJnhnhgJPpwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Cen <rollkingzzc@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Gui-Dong Han <2045gemini@gmail.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1262/1887] ocfs2: validate fast symlink target during inode read
Date: Wed, 28 Oct 2026 17:55:58 +0100
Message-ID: <20261028170528.143907282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Cen <rollkingzzc@gmail.com>

[ Upstream commit e234973f286ed2e8961a24561ec91594ec3e3ff8 ]

ocfs2_validate_inode_block() already rejects several inconsistent
self-contained dinodes before they are exposed to the rest of the
filesystem.  Fast symlinks need the same treatment.

A zero-cluster symlink is treated as a fast symlink and later read through
page_get_link() and ocfs2_fast_symlink_read_folio().  That path uses
strnlen() on the inline payload and then copies len + 1 bytes into the
folio.  If a corrupt dinode stores an i_size that does not fit the inline
area or omits the terminating NUL at i_size, that copy reads past the end
of the inode block buffer.

Reject zero-cluster symlink dinodes whose i_size exceeds the inline
fast-symlink capacity or whose inline payload is not NUL-terminated
exactly at i_size when the inode block is validated.  This keeps malformed
fast symlinks from reaching the read path.

Validation reproduced this kernel report:
KASAN use-after-free in ocfs2_fast_symlink_read_folio+0x12c/0x1f0
RIP: 0033:0x7f5c6d859aa7
Read of size 3905
Call trace:
  dump_stack_lvl+0x66/0xa0 (?:?)
  print_report+0xce/0x630 (?:?)
  ocfs2_fast_symlink_read_folio+0x12c/0x1f0 (fs/ocfs2/inode.c:?)
  srso_alias_return_thunk+0x5/0xfbef5 (?:?)
  __virt_addr_valid+0x19f/0x330 (?:?)
  kasan_report+0xe0/0x110 (?:?)
  kasan_check_range+0x105/0x1b0 (?:?)
  __asan_memcpy+0x23/0x60 (?:?)
  filemap_read_folio+0x27/0xe0 (?:?)
  filemap_read_folio+0x35/0xe0 (?:?)
  do_read_cache_folio+0x138/0x230 (?:?)
  __page_get_link+0x26/0x110 (?:?)
  page_get_link+0x2e/0x70 (?:?)
  vfs_readlink+0x15e/0x250 (?:?)
  touch_atime+0x4d/0x370 (?:?)
  do_readlinkat+0x186/0x200 (?:?)
  do_user_addr_fault+0x65a/0x890 (?:?)
  __x64_sys_readlink+0x46/0x60 (?:?)
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f (?:?)

Link: https://lore.kernel.org/20260528151230.361127-1-rollkingzzc@gmail.com
Fixes: ea022dfb3c2a ("ocfs: simplify symlink handling")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Gui-Dong Han <2045gemini@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 73b2dda9ffe7b..ed7b4be3ea7a5 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1585,6 +1585,29 @@ int ocfs2_validate_inode_block(struct super_block *sb,
 		goto bail;
 	}
 
+	if (S_ISLNK(le16_to_cpu(di->i_mode)) &&
+	    !le32_to_cpu(di->i_clusters)) {
+		int max_inline = ocfs2_fast_symlink_chars(sb);
+		u64 i_size = le64_to_cpu(di->i_size);
+
+		if (i_size >= max_inline) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: fast symlink i_size %llu exceeds max %d\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)i_size,
+					 max_inline - 1);
+			goto bail;
+		}
+
+		if (strnlen((char *)di->id2.i_symlink, i_size + 1) != i_size) {
+			rc = ocfs2_error(sb,
+					 "Invalid dinode #%llu: fast symlink is not NUL-terminated at i_size %llu\n",
+					 (unsigned long long)bh->b_blocknr,
+					 (unsigned long long)i_size);
+			goto bail;
+		}
+	}
+
 	if (le32_to_cpu(di->i_flags) & OCFS2_CHAIN_FL) {
 		struct ocfs2_chain_list *cl = &di->id2.i_chain;
 
-- 
2.53.0



