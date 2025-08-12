Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A24A2EAB97;
	Tue, 12 Aug 2025 18:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022800; cv=none; b=lu/Q/qty3EWkWMAxTqC3+VWK8+QBQXX8xOYXvZGgb6eMOPl0+lCyD/5qRBzfe+IlI6sXw3zczXLUF67XvZzcGZYo73uTxUs04Dr6PZILiv84LMv+S1ZdP4/ZUZasJIQE0riB1bEPDugUjvOpyjt1Tsps/Vbu4vtbrVO7Jt+yGpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022800; c=relaxed/simple;
	bh=fV+CeBIwKplhQIGryD3Px3jeeiaEKLq7tVaEun6DvY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eldi5MoQennDgdLVey7XwFfTR7KDhEGkRWJbOGQdZqEyTwA+g/sljCdfFrOBFYZ05c2Uhf5VxsitmN+ULjNEG4VQKmvEueSqbAqJqMRWpbBxU4Ytinz2Q+wBczSmovvtUMRsVJVuXcJN1Lij65nXSu5isxG0Hs6FtVluuxegwag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlNQj4m6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlNQj4m6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF18C4CEF6;
	Tue, 12 Aug 2025 18:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022800;
	bh=fV+CeBIwKplhQIGryD3Px3jeeiaEKLq7tVaEun6DvY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlNQj4m6NPSJi8R1Eetn1t15ALpQnoOdKnlVOzN68xWU3vTCfDuejA0miS2UtRrLF
	 fVrB5GBhrbC+jG1BUlB81TtKCt0qfkQJZ7NrSKernv8mix2Yo6pppwcwpb3x1tW28F
	 74FLzeKDD3/SmDko2xxxfjfp8Fj7S475lFKophC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengxu Zhang <zhengxu.zhang@unisoc.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 263/369] exfat: fdatasync flag should be same like generic_write_sync()
Date: Tue, 12 Aug 2025 19:29:20 +0200
Message-ID: <20250812173024.657704254@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Zhengxu Zhang <zhengxu.zhang@unisoc.com>

[ Upstream commit 2f2d42a17b5a6711378d39df74f1f69a831c5d4e ]

Test: androbench by default setting, use 64GB sdcard.
 the random write speed:
	without this patch 3.5MB/s
	with this patch 7MB/s

After patch "11a347fb6cef", the random write speed decreased significantly.
the .write_iter() interface had been modified, and check the differences
with generic_file_write_iter(), when calling generic_write_sync() and
exfat_file_write_iter() to call vfs_fsync_range(), the fdatasync flag is
wrong, and make not use the fdatasync mode, and make random write speed
decreased. So use generic_write_sync() instead of vfs_fsync_range().

Fixes: 11a347fb6cef ("exfat: change to get file size from DataLength")
Signed-off-by: Zhengxu Zhang <zhengxu.zhang@unisoc.com>
Acked-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 841a5b18e3df..7ac5126aa4f1 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -623,9 +623,8 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (pos > valid_size)
 		pos = valid_size;
 
-	if (iocb_is_dsync(iocb) && iocb->ki_pos > pos) {
-		ssize_t err = vfs_fsync_range(file, pos, iocb->ki_pos - 1,
-				iocb->ki_flags & IOCB_SYNC);
+	if (iocb->ki_pos > pos) {
+		ssize_t err = generic_write_sync(iocb, iocb->ki_pos - pos);
 		if (err < 0)
 			return err;
 	}
-- 
2.39.5



