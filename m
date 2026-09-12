Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963B12F8EAE;
	Sat, 12 Sep 2026 14:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222176; cv=none; b=X9BaVXjoTdNWG6KW4eYMOxtbBdDAnyZrHXagyTtlKmgDastL11Z5bEh7U1UXUhdNadpi5yAO5sPlmy2PhbT3NmIzhgW5co8ifiaAjrM+pD5iw9yCndHFKJ2Uh+rVgE0Rv8+mJDG2GtFASrPXv8GRpyVvlkkfEMTwGDloGoQ9uSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222176; c=relaxed/simple;
	bh=DbXQNhuy4Fi6DVlSz8zTLQTWG2jx6aglinoyAiN7cyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0fy1zOB4Y/nv5j210CipyOc9SSoYRw5pwIt4l+LgP5DF8erTimQaqMuE8njn3BFmYDccNrE8MJ2Y9rT6jfKN3zFPb3eYjat2gg0no2c9R1UVyoHzD7aXW137AJ8xEr8WdlS5G4sq/pExnlgwtYQKbPeCyZxhHP9LNxA0LohAPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdiTPMkk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdiTPMkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3478B1F000FF;
	Sat, 12 Sep 2026 14:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222175;
	bh=8SFVc7NOIZGBDvM0sD6YAmurxqb2QD8zNi4YNa5joH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tdiTPMkkdFXXfGtaP016YJfx9tRX7QIQtEBeFAvCUsxWHJyDndrRYC52CJbMxFbEg
	 oj0byO7RxVaXM+1VrQrt+Ss87PYjDplhMJ9h01o2A1OO+rFb2CB4e9cBTzBK0P2bui
	 44CYVUR/yw/StDyA+ycLcQXVCANJjCEkScnYgjZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 0506/1424] f2fs: fix to off-by-one issue in f2fs_zero_post_eof_page()
Date: Sat, 12 Sep 2026 08:48:58 +0200
Message-ID: <20260912065618.621894708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -50,7 +50,7 @@ static void f2fs_zero_post_eof_page(stru
 	if (lock)
 		filemap_invalidate_lock(inode->i_mapping);
 	/* zero or drop pages only in range of [old_size, new_size] */
-	truncate_inode_pages_range(inode->i_mapping, old_size, new_size);
+	truncate_inode_pages_range(inode->i_mapping, old_size, new_size - 1);
 	if (lock)
 		filemap_invalidate_unlock(inode->i_mapping);
 }


