Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A80D1527B4;
	Sun, 26 Oct 2025 14:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490222; cv=none; b=ElRShPiR8ysBnWIe5DCJTWeTaqQ5xSDiGlKjUG+jassR7TC3Qck9dY4MB5/CzJBabI4uA1qlJ68vaI2RzszlVjUhx0CmCrve6G4JbFyWOVZMX2T6xdAAKi+bN82gFVNy3cIfWH3/7kliBVAkH1SnZIj3d3t+fhTkhmltoZRE6Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490222; c=relaxed/simple;
	bh=nD1RF0zkH787kOGZ392ZfvmB58XUzVJDUKgtF6+ndYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YQORqvcVrxCSnh5kD+jYORpw0EB0IoXqJA2cnoZHkeQgglJRBFKVIhPSBupkWvU8qFGBRbSD8oWbq2FVXv8hRKokyKKw7PBiMvunv9eQNxOk4pz8yFiGEYzDUo4xAr9U7Hbg9AZPMeN3VKKAp7vMj0t6woVq2InvNPKDAUdaYRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rHaEkTvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHaEkTvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D628C4CEFB;
	Sun, 26 Oct 2025 14:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490222;
	bh=nD1RF0zkH787kOGZ392ZfvmB58XUzVJDUKgtF6+ndYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHaEkTvlcq9VG3R1/C7Jz/v//zwA2jHssbsnmDrD8uJhIj4JoMthg+NFCjbuJgKfs
	 GNuUEUFK9F89nEVOJ5Uow0OhtIcZC1Qun7RYAji0fqxer9bm8TC2XCv80NWze9h0Qa
	 vR8l+HpOCw78VetAApeZGzKDrxjUeXb+AaskLgQAlFgTTV4a+dFifwCrdv2i+ji0Jm
	 h6Gmw8tjLuSX1MQ4Qq2IGYnkYYoEt16hY4EDDUGyCzX/w2KYrs5kWOsbC9ayOiI1Ey
	 NlX30vg+TOGGS168/vcatse4hcTtBSKhubdyVO0GIdUCtOHzzW7kYMHavEyEjQ3PDF
	 fGjur8+3G01RA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yikang Yue <yikangy2@illinois.edu>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	mikulas@artax.karlin.mff.cuni.cz
Subject: [PATCH AUTOSEL 6.17-5.4] fs/hpfs: Fix error code for new_inode() failure in mkdir/create/mknod/symlink
Date: Sun, 26 Oct 2025 10:48:50 -0400
Message-ID: <20251026144958.26750-12-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yikang Yue <yikangy2@illinois.edu>

[ Upstream commit 32058c38d3b79a28963a59ac0353644dc24775cd ]

The function call new_inode() is a primitive for allocating an inode in memory,
rather than planning disk space for it. Therefore, -ENOMEM should be returned
as the error code rather than -ENOSPC.

To be specific, new_inode()'s call path looks like this:
new_inode
  new_inode_pseudo
    alloc_inode
      ops->alloc_inode (hpfs_alloc_inode)
        alloc_inode_sb
          kmem_cache_alloc_lru

Therefore, the failure of new_inode() indicates a memory presure issue (-ENOMEM),
not a lack of disk space. However, the current implementation of
hpfs_mkdir/create/mknod/symlink incorrectly returns -ENOSPC when new_inode() fails.
This patch fix this by set err to -ENOMEM before the goto statement.

BTW, we also noticed that other nested calls within these four functions,
like hpfs_alloc_f/dnode and hpfs_add_dirent, might also fail due to memory presure.
But similarly, only -ENOSPC is returned. Addressing these will involve code
modifications in other functions, and we plan to submit dedicated patches for these
issues in the future. For this patch, we focus on new_inode().

Signed-off-by: Yikang Yue <yikangy2@illinois.edu>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- hpfs still preloads `err = -ENOSPC` in each operation, so a
  `new_inode()` failure is reported as disk space exhaustion; the patch
  overwrites `err` with `-ENOMEM` before bailing in `hpfs_mkdir()`
  (`fs/hpfs/namei.c:54`), `hpfs_create()` (`fs/hpfs/namei.c:157`),
  `hpfs_mknod()` (`fs/hpfs/namei.c:244`), and `hpfs_symlink()`
  (`fs/hpfs/namei.c:320`).
- `new_inode()` can only fail because the slab allocation chain
  `new_inode()` → `alloc_inode()` (`fs/inode.c:1145`, `fs/inode.c:340`)
  → `alloc_inode_sb()` (`include/linux/fs.h:3407`) returns `NULL` on
  memory pressure, so `-ENOMEM` is the correct status; returning
  `-ENOSPC` misleads user space and scripts about the root cause.
- This is a clean, localized bug fix with no behavioral risk beyond
  correcting the errno, so it fits stable backport guidelines.

 fs/hpfs/namei.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index e3cdc421dfba7..353e13a615f56 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -52,8 +52,10 @@ static struct dentry *hpfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	dee.fnode = cpu_to_le32(fno);
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail2;
+	}
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
@@ -153,9 +155,10 @@ static int hpfs_create(struct mnt_idmap *idmap, struct inode *dir,
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail1;
-	
+	}
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	result->i_mode |= S_IFREG;
@@ -239,9 +242,10 @@ static int hpfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail1;
-
+	}
 	hpfs_init_inode(result);
 	result->i_ino = fno;
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
@@ -314,8 +318,10 @@ static int hpfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 	dee.creation_date = dee.write_date = dee.read_date = cpu_to_le32(local_get_seconds(dir->i_sb));
 
 	result = new_inode(dir->i_sb);
-	if (!result)
+	if (!result) {
+		err = -ENOMEM;
 		goto bail1;
+	}
 	result->i_ino = fno;
 	hpfs_init_inode(result);
 	hpfs_i(result)->i_parent_dir = dir->i_ino;
-- 
2.51.0

