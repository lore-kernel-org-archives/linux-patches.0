Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A1632274E;
	Mon, 18 Aug 2025 12:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521681; cv=none; b=UfOqUbR2EGvFIEdLTTcTYasJAgyv/NRjCPSk/ro3iVOsdTdYnEteDvhoQTSFVWpUzeSWQ/z4x7To9I214nqdKSVqO2/Pal7v8iseAIcCXUwpLbbK6cx17pgTnNy+P3WgyccQCZzFg5MEe/I2e9JLuuV+6jf0y0u+QZauRs8/gpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521681; c=relaxed/simple;
	bh=6x3YgsUqiFMGXhrXT24+P4AUHBD6Po0fprEROBaeHnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Co5VQJ0LoU0GFepeKU3vTyWdohpyCsR699PwwN1cFwJzHEj7nMUuJ55AqK0qhgb6los2/i7bAOS9hd0IC1kQ5zDpAlGzlGuw1OsA8HYR2JbwqhL1F5UgV6VC9leSUS1WC6aV3WkIOzzvMe22jFK7vhdFSHS3sj3126Oqm3944bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0UGUbre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0UGUbre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16941C4CEEB;
	Mon, 18 Aug 2025 12:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521681;
	bh=6x3YgsUqiFMGXhrXT24+P4AUHBD6Po0fprEROBaeHnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0UGUbreBKPJJdv79k/uZC4K/jcyJZ9Z2XmmXvKVSLN/QgbfeJWZqLXKBDJQh/0BY
	 W7rtA58CgkugoNJnF1Uim+BkI0MmmvGBwH51CW2Dh9D1vGcLfVrEuFdvGPgJbriQ8A
	 6LxzR64tT2btWflL7Fy4GrV0La2uwoYln4dS1AOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/444] fix locking in efi_secret_unlink()
Date: Mon, 18 Aug 2025 14:41:58 +0200
Message-ID: <20250818124452.400307642@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 2c58d42de71f9c73e40afacc9d062892d2cc8862 ]

We used to need securityfs_remove() to undo simple_pin_fs() done when
the file had been created and to drop the second extra reference
taken at the same time.  Now that neither is needed (or done by
securityfs_remove()), we can simply call simple_unlink() and be done
with that - the broken games with locking had been there only for the
sake of securityfs_remove().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virt/coco/efi_secret/efi_secret.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/virt/coco/efi_secret/efi_secret.c b/drivers/virt/coco/efi_secret/efi_secret.c
index cd29e66b1543..8482be108e82 100644
--- a/drivers/virt/coco/efi_secret/efi_secret.c
+++ b/drivers/virt/coco/efi_secret/efi_secret.c
@@ -136,15 +136,7 @@ static int efi_secret_unlink(struct inode *dir, struct dentry *dentry)
 		if (s->fs_files[i] == dentry)
 			s->fs_files[i] = NULL;
 
-	/*
-	 * securityfs_remove tries to lock the directory's inode, but we reach
-	 * the unlink callback when it's already locked
-	 */
-	inode_unlock(dir);
-	securityfs_remove(dentry);
-	inode_lock(dir);
-
-	return 0;
+	return simple_unlink(inode, dentry);
 }
 
 static const struct inode_operations efi_secret_dir_inode_operations = {
-- 
2.39.5



