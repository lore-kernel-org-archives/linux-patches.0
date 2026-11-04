Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827144;
	b=GwotE3l4WJoyud/TGFTyV8w8t3Wpub5WUU1MILHFjVVnwtloCBK0YnXbpI6nXtBuHIVD
	 f6labbYb9MOfak0B6H9BioecTaWiEEag6GxyykEiiLwriG3m/aqIGJZFVNyHOoNAoIwHC
	 yd6+DLMY+zW/9iSW0uXXBija+Sf67g+WeSAEmswPS7wbyFIubOmfGTVSoENeK29Dj0IQS
	 kLDF2AbtQF1V8mpFWZkdmnrLqdZJkYv2nqMXEFoFAIe5l31MjhzyBUJ4jub06tuJhAEjF
	 ual8G8nUM2uqWq2SMZ5Y8BxKNEHV+dDaVkEwkgccPvORoK+ZMyLUhmZZO0dvY8S6G0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s4Tx5rvt7McMmBCZaZk6940HKAZNPoufC/ud0z+vmI0=;
	b=DYjKKPq+TGlKHOsPdP8ZhGM5fTvfdNM90RqTq39wnqs7I+gu3hnG+rtKtY9GHa7czFiQ
	 Vbf/X4vszy0Og6UJ3uSDJ3FJ8EhukY9TZQZrEk3PP70xGWkRhc8XChUi8PRSlBOF/Zgwa
	 7eMmmsOPOwC4k2frSAcTqvbzg5Z1kVdeNbtS/omDG6UmyEFhieUTCm0PcOEe4R6Vajq8U
	 oPNm6KVfzAJ74N84wmOpsH7lx84M7ArMwSqp8KedMAbDRwixuExPcNsKBFLuh1o11zwG4
	 YoQ+/oOIWYH1/H/MCn5P28dUmzpsY12pMjwikPK6xvWcnJ70gz8CDCyPbQA2NATknKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7TWUB+8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3476E606AB0D;
	Wed,  4 Nov 2026 21:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7TWUB+8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0D01F00A17;
	Wed,  4 Nov 2026 21:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827144;
	bh=s4Tx5rvt7McMmBCZaZk6940HKAZNPoufC/ud0z+vmI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7TWUB+8GR9AlNuq5qHEXGt36FNgphtnXW5RuPFAaqlOiVSxkusgN6bIHUnfhtTcM
	 /ewYPVBy8ybYu1VFLCWtx2fCwSGn/cdmyNKLR0TVTnxUVl5V7peVzZq5W6wWW6jGsW
	 /e5Ot5rx6zoq0ymA4nUx8z4FystbYEOUnFYhV2BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 213/547] filelock: keep superblock active through delegation wait
Date: Wed,  4 Nov 2026 16:06:37 -0500
Message-ID: <20261104211044.205128591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Gongyi <zhaogongyi@bytedance.com>

commit c206cdfee6c037b829178bb7e17e6e37ddc9aa35 upstream.

A caller may drop its path after try_break_deleg() returns a delegated
inode but before break_deleg_wait() finishes. The extra inode reference
held in struct delegated_inode does not keep the superblock active.

After a lazy unmount, closing the delegation holder can release the last
mount reference and shut down the superblock while another task waits for
the delegation break. The waiter's final iput() can then enter the
filesystem's eviction code after its superblock-private state was freed.
This has been observed as a KASAN use-after-free in shmem_evict_inode().

When try_break_deleg() saves a delegated inode, take an active reference
to its superblock while the caller still pins the mount. Keep that
reference through break_deleg_wait() and the final iput(), then release
it with deactivate_super(). This protects every caller of the helpers,
including the mknod, mkdir, symlink and rmdir paths that drop their path
before waiting.

Fixes: e12d203b8c88 ("vfs: allow mkdir to wait for delegation break on parent")
Fixes: 4fa76319cd0c ("vfs: allow rmdir to wait for delegation break on parent")
Fixes: c826229c6a82 ("vfs: make vfs_create break delegations on parent directory")
Fixes: e8960c1b2ee9 ("vfs: make vfs_mknod break delegations on parent directory")
Fixes: 92bf53577f01 ("vfs: make vfs_symlink break delegations on parent dir")
Link: https://lore.kernel.org/r/20261016093421.90725-1-zhaogongyi@bytedance.com
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
Link: https://patch.msgid.link/20261023111250.17696-1-zhaogongyi@bytedance.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/filelock.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/include/linux/filelock.h
+++ b/include/linux/filelock.h
@@ -530,8 +530,8 @@ static inline bool is_delegated(struct d
  *
  * Break delegations in a non-blocking fashion. If there are
  * outstanding delegations and @di is set, then an extra reference
- * will be taken on @inode and @di->di_inode will be populated so
- * that it may be waited upon.
+ * will be taken on @inode and its superblock, and @di->di_inode will
+ * be populated so that it may be waited upon.
  *
  * Returns 0 if there is no need to wait or an error. If -EWOULDBLOCK
  * is returned, then @di will be populated (if non-NULL).
@@ -545,16 +545,21 @@ static inline int try_break_deleg(struct
 	if (ret == -EWOULDBLOCK && di) {
 		di->di_inode = inode;
 		ihold(inode);
+		/* The caller may drop its mount before break_deleg_wait(). */
+		atomic_inc(&inode->i_sb->s_active);
 	}
 	return ret;
 }
 
 static inline int break_deleg_wait(struct delegated_inode *di)
 {
+	struct inode *inode = di->di_inode;
+	struct super_block *sb = inode->i_sb;
 	int ret;
 
-	ret = break_deleg(di->di_inode, 0);
-	iput(di->di_inode);
+	ret = break_deleg(inode, 0);
+	iput(inode);
+	deactivate_super(sb);
 	di->di_inode = NULL;
 	return ret;
 }


