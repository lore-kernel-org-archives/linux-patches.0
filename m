Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039047;
	b=oZApzN+5/m9xjHnWJMSzrEeZeo/J+2tdIRSvHZu5A+QSmp0lEzS3pdH1v31ft9HscUSN
	 R1atJRi8QOcFwb7qlfaRa4vhaK2w4Ftwpm60/tntV7tGNMvnuKb0F2eD7+VHQqMPWfqwE
	 IwEtKDGSqFuhW5tcQTOy4ZqcKRAvICdivW11tzGfKAcOiy95z+7cGmcX/tDa1nuWOQ7eR
	 K66LfwU74fuToIw/SZjNMz7QQAoDHX5FWWAlnpPHygRd2ythubVmRAuByrfCZtnFyMARL
	 M5evHZCHVgkc4s17mjUl8xdsHQujDo+k4NIZkadIc6t2O5LIl5g3xEq1m8i6ID8Ufmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7wNa1ymWABzuFAcqp2HYDUKQ8ZTC2Yl94i9VgvR1wlE=;
	b=UEFuZY4DPtlyxc6zihTxjrIeB5HdzXCvNygjM7kRrilcfOBi3fnTgAX/W+lfLfrTsInA
	 OPW8ZaKdPdoh7/+/3oQf9/uxARxJW4jIKTN6KePno4oLmW2DJeUH89DwTGWAnuj/OrTsy
	 KZED5T/fiBrmLkCzMMYKgVYY/QGs9SPbmmqdV9L4Zyaa83pgwbZOz3EGoJo13NtQue2z0
	 jpYrkV5KxgAJ75V4UvowWij3HEI89VePy48+K0zb9IqMfhdUHKkqP+4mgUBG5uMby08FJ
	 ipXD6QAbxQb2hdmQjXUlaTQMfI5qmjKEs34BUx4a3DwaJyvERe8+Z1wkt99QkI1Y9nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gKbFwbe5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62E7606A333;
	Wed, 18 Nov 2026 21:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gKbFwbe5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EBA1F000CD;
	Wed, 18 Nov 2026 21:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039047;
	bh=7wNa1ymWABzuFAcqp2HYDUKQ8ZTC2Yl94i9VgvR1wlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gKbFwbe525CcHkaCOzDF7+bysC7QgO4OJ5OPoBzvA9ipc5D1/zxJkdbXrjWFYotxz
	 pIiEaKP8CtDwyo4T2ITB1MXNgh0wVE/d+UTknhPBJvSvRwiGVu32jT9NZq4MLxa+lg
	 Zt8hbefsDKJCKPututV/u6ToZQBH8vuZoKeUZ9hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1958/3318] mm/shmem: make shmem_file() check the files inode
Date: Wed, 18 Nov 2026 15:43:00 +0100
Message-ID: <20261118150420.824332305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit d3710111839d11339e414b1bb3fea3d05ab83f6e ]

shmem_file() only checks if file->f_mapping is a shmem mapping. This
mapping can belong to another file, however, as with a Coda file backed
by a tmpfs container after mmap().

So it does not guarantee that the file inode is an actual shmem inode.

Seal handling and memfd preservation use this check before accessing
shmem inode state, so they can access an inode of the wrong type.

Let's make shmem_file() check the inode's file operations instead, to
identify shmem inodes reliably. This will identify regular shmem inodes,
including memfds and ordinary tmpfs files, independently of wrapper file
operations.

Use shmem_mapping() in collapse_file() instead to not change the behavior
of collapse_file(): it operates on the page cache and uses mapping->host
for shmem inode operations. Focusing on the file does not seem relevant.

Fixes: c49fcfcda8b5 ("mm/shmem: update file sealing comments and file checking")
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Link: https://patch.msgid.link/20261031-fixes_core-v3-3-d6437171ecc3@kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Adjusted context to preserve the existing inline shmem_mapping() helper and surrounding declarations. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/shmem_fs.h | 15 ++++++---------
 mm/khugepaged.c          |  2 +-
 mm/shmem.c               |  5 +++++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 134c686c8676c..e4b24b4442bb9 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -93,12 +93,18 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
+bool shmem_file(struct file *file);
 extern const struct address_space_operations shmem_aops;
 static inline bool shmem_mapping(struct address_space *mapping)
 {
 	return mapping->a_ops == &shmem_aops;
 }
 #else
+static inline bool shmem_file(struct file *file)
+{
+	return false;
+}
+
 static inline bool shmem_mapping(struct address_space *mapping)
 {
 	return false;
@@ -159,15 +165,6 @@ static inline struct page *shmem_read_mapping_page(
 					mapping_gfp_mask(mapping));
 }
 
-static inline bool shmem_file(struct file *file)
-{
-	if (!IS_ENABLED(CONFIG_SHMEM))
-		return false;
-	if (!file || !file->f_mapping)
-		return false;
-	return shmem_mapping(file->f_mapping);
-}
-
 /*
  * If fallocate(FALLOC_FL_KEEP_SIZE) has been used, there may be pages
  * beyond i_size's notion of EOF, which fallocate has committed to reserving:
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8a907d636c454..25fb56d4d13f9 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1785,6 +1785,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			 struct collapse_control *cc)
 {
 	struct address_space *mapping = file->f_mapping;
+	const bool is_shmem = shmem_mapping(mapping);
 	struct page *page;
 	struct page *tmp, *dst;
 	struct folio *folio, *new_folio;
@@ -1793,7 +1794,6 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	int nr_none = 0, result = SCAN_SUCCEED;
-	bool is_shmem = shmem_file(file);
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
diff --git a/mm/shmem.c b/mm/shmem.c
index 0f7c7ec48837a..74517e446f63f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -263,6 +263,11 @@ static const struct vm_operations_struct shmem_vm_ops;
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
+bool shmem_file(struct file *file)
+{
+	return file && file_inode(file)->i_fop == &shmem_file_operations;
+}
+
 bool vma_is_anon_shmem(struct vm_area_struct *vma)
 {
 	return vma->vm_ops == &shmem_anon_vm_ops;
-- 
2.53.0



