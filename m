Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B7134A308;
	Tue, 26 Aug 2025 13:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214237; cv=none; b=ZnBnd4/ag/qYHWaPXD1C56+ewL/fT1Q28ImZFQ1FNWBuGz0ejeVycP1tFzPfFfXOqD/UBz/ZQz10BFDirMABmqmU/89/GjkGdPjlPIr3Wczg5zXvsn++CothbfJSU7m9OKKuRGg3IfNNQA4w4oHdFjWEFstIBQSJl4J8mWPJKQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214237; c=relaxed/simple;
	bh=c+lypIBoJ5KojWS+e95z+KqT4u4Ve0rVOWOXoXu8DpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hV4ZmQ965PH7mz/hWQqfcR/uSJfHJD7x0wKa3fAgunyA+bkraUUI/L70sZYvOu9ZxiKmW82qxJDqe1IG+Sur9q30I5FSQnM+4Umz8wxt3Uvfgl6ASs0xLtW3KaFJ8v9SgPrBYn6tmLlhJRGdOe3ikeZKg1evV+bN54sIwagBKCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYP6nrSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYP6nrSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD045C4CEF1;
	Tue, 26 Aug 2025 13:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214237;
	bh=c+lypIBoJ5KojWS+e95z+KqT4u4Ve0rVOWOXoXu8DpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYP6nrSR2rMIRerS4YTOx+Pcb2grpW4vCjs1vlLtNs/xU7tkPSWklou1bpgWmO114
	 kTr8Ipp+DeUE0qpy2Z/FAR9z20C7mSaaXU5vxXFUmPg0kDaR9Ali7TiUPJ+TmcWJub
	 gDBPJVnp4q3bhorHXXJCPQps3+YBOAmV3hSMT9zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/482] fix locking in efi_secret_unlink()
Date: Tue, 26 Aug 2025 13:05:16 +0200
Message-ID: <20250826110932.383283826@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e700a5ef7043..d996feb0509a 100644
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



