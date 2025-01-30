Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A941BD9D3;
	Thu, 30 Jan 2025 14:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247330; cv=none; b=iMyp0GyhWkXNfPji6CyTzhSfOmbo4CGtoIITRCKSsLnqVFgWuqdA+0WtzsQVWsWN+V1ghn7kiQ3jxLbEyaPnzV+/Ak4uHY8SmNTxoSH+b9eJv48tRwOyDe7E9UZwT0K2t7m96Pwlk7ZhMLfgiYNAPQoX0+X0E6ywwmsr3XXujTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247330; c=relaxed/simple;
	bh=wO7f8FuIlveU/gNbtZoFkccswLHg9OZfTDuHHbdKsKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpW4F1/HncUN00x7AeyDV6AVmH1W1PPz6gmtBvGyaYtgEFKMnDeVSHRBSHFdHJjEw5JS54+bmjy0QSSpw6qvOOBEWlXqr5bMk+MEGv4T+9rlSRz7k9KpAJ5VNpbOiy3LlQKHrUyK2oSgC3A0ciSB7Oq8a0Hh69bNmJQzzXaRQRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Di4RPOMq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Di4RPOMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22750C4CED2;
	Thu, 30 Jan 2025 14:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247329;
	bh=wO7f8FuIlveU/gNbtZoFkccswLHg9OZfTDuHHbdKsKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Di4RPOMquTg/FKXLYSWw+/gC+YPezHy+eCkMjiN1uWIku9BzAvm9e/qxUQY5V249c
	 g3vJWc9nY2BADZH53DviE4gkZWtj2Py7OX7MD+fbCIXu4MzoqG2BuTaEZbxLPxBlDl
	 Cice8QPpAFAttVtpi7l9hdwNaJfkc8FXDwwYFCHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8c652f14a0fde76ff11d@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: [PATCH 5.15 14/24] fs/ntfs3: Additional check in ntfs_file_release
Date: Thu, 30 Jan 2025 15:02:06 +0100
Message-ID: <20250130140127.866809923@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 031d6f608290c847ba6378322d0986d08d1a645a upstream.

Reported-by: syzbot+8c652f14a0fde76ff11d@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/file.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1192,8 +1192,16 @@ static int ntfs_file_release(struct inod
 	int err = 0;
 
 	/* If we are last writer on the inode, drop the block reservation. */
-	if (sbi->options->prealloc && ((file->f_mode & FMODE_WRITE) &&
-				      atomic_read(&inode->i_writecount) == 1)) {
+	if (sbi->options->prealloc &&
+	    ((file->f_mode & FMODE_WRITE) &&
+	     atomic_read(&inode->i_writecount) == 1)
+	   /*
+	    * The only file when inode->i_fop = &ntfs_file_operations and
+	    * init_rwsem(&ni->file.run_lock) is not called explicitly is MFT.
+	    *
+	    * Add additional check here.
+	    */
+	    && inode->i_ino != MFT_REC_MFT) {
 		ni_lock(ni);
 		down_write(&ni->file.run_lock);
 


