Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CED35C6AA;
	Sat, 12 Sep 2026 11:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214242; cv=none; b=CIb03Z8jxwtBKQ33CF45EAumSWYsX9jF8XGi/g+ZQ0vL6eI+odFHpHG2w1BoVd2kbfNnzkBTfLTzZjG8yRd/LlJiotnFcJ/ctKvZHm1YShiFHj/ozY17CBNCeL5D+lI2hpwYkAbh9SgRgJdHxHt8jKT/IoqkflLwfECt0HYK3s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214242; c=relaxed/simple;
	bh=ZM0DHcBVV9G6ukAEVPHVcXhl+SagRldFGLEDUTNi3Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPwwLDHIYw375AlOOEY5CeKFUP3r1pMM5mmsWcju0qZDBKD++h5lvGhfSUyrnZsWchqse4gf8QW9lomAKUJDAqn7tLZeyd4l1M21dpG0IQtxb7gCtWQSWDEt8ADOhUBFuJ1cHFCI4fIsy40lu+8WQwkYOnMUzcZnTPar59unROs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCnD7d/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCnD7d/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8401F000FF;
	Sat, 12 Sep 2026 11:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214241;
	bh=Hhj1/rUUAFlaozxHFBUAvGxaUfitI/ep6y3+/TVucG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCnD7d/GpuNG3lohNtZ46SPLw5VRvWbtOX+PTcSHiQf6jjx9vX6oavDcTy02X4DBm
	 ww0bhkFAY4XkB9mVDhDWqdU0X6+wgldAMHF9twBPrkDh+3Cm/D9tl/Nd1OmhMlwyXR
	 NVV51/1h8nxpjZRhFfXTcGSqq/EHqaOt515D50tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 0255/1376] f2fs: fix to off-by-one issue in f2fs_zero_post_eof_page()
Date: Sat, 12 Sep 2026 08:44:41 +0200
Message-ID: <20260912065613.222486123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit b2205d3cfd6c76fd5c5443ee9fdb498cfb0e1c66 upstream.

Otherwise, it will drop one more page after new_size which is not
necessary.

Cc: stable@kernel.org
Fixes: ba8dac350faf ("f2fs: fix to zero post-eof page")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -49,7 +49,7 @@ static void f2fs_zero_post_eof_page(stru
 	if (lock)
 		filemap_invalidate_lock(inode->i_mapping);
 	/* zero or drop pages only in range of [old_size, new_size] */
-	truncate_inode_pages_range(inode->i_mapping, old_size, new_size);
+	truncate_inode_pages_range(inode->i_mapping, old_size, new_size - 1);
 	if (lock)
 		filemap_invalidate_unlock(inode->i_mapping);
 }


