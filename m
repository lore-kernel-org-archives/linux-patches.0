Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27E31CFEB3;
	Wed,  2 Oct 2024 14:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878551; cv=none; b=YM5XEye9q4QUaZsJqJDvVpxa6TF2NHp/hGcBjFP6GbPyRWH3ZjC8EoLnm5/GmlQVbmEk/+Fy/NLu5eJxcWO8s0jfBF8eMoknmKOjoyCNfZTx98jvnqiy+GiQJwTwc8ZCIYE/gGTXN2j/GE3LWXIClF5Q+ESrJ/hZbZx3sIBYepU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878551; c=relaxed/simple;
	bh=KZYnsib3zO9Vp0aX+v/B30ED7IrUCkJApoH2874TUbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSaDmrs3vYjFbOWRIdHnKoWr3WlEOzT/DlEn6Y2c5/v1YNtOzZEUidlThY9aF/M1A29lgW9BEL1z167rBshevRJ8TuzPsggaKG4aQ99eVDg/G/Ldc7dydXztamTkxFmydLnIJ7HR+ldfdmd0CG7V0EzHy7uWuMATxwQ4pQBDnZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6Hd0zEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6Hd0zEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C0BC4CEC2;
	Wed,  2 Oct 2024 14:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878551;
	bh=KZYnsib3zO9Vp0aX+v/B30ED7IrUCkJApoH2874TUbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6Hd0zEde/UFPN+CfrUYQ4JG5AhN/ZNOWeNWTubLm4PyHPo7o6IKw9TTbvKuEDeVR
	 uLppfM+t2/174fERH9TjWic9R0eAFC581MXRuPIY27Ui0GSiRPH0XAwYABCNty9RX0
	 1E/r27WdyhqqbQG5xX2LM91i1tg1K395Skkot+rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangyun <yangyun50@huawei.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.10 453/634] fuse: use exclusive lock when FUSE_I_CACHE_IO_MODE is set
Date: Wed,  2 Oct 2024 14:59:13 +0200
Message-ID: <20241002125828.983105275@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yangyun <yangyun50@huawei.com>

commit 2f3d8ff457982f4055fe8f7bf19d3821ba22c376 upstream.

This may be a typo. The comment has said shared locks are
not allowed when this bit is set. If using shared lock, the
wait in `fuse_file_cached_io_open` may be forever.

Fixes: 205c1d802683 ("fuse: allow parallel dio writes with FUSE_DIRECT_IO_ALLOW_MMAP")
CC: stable@vger.kernel.org # v6.9
Signed-off-by: yangyun <yangyun50@huawei.com>
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b8afeca12487..1b5cd46c8225 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1345,7 +1345,7 @@ static bool fuse_dio_wr_exclusive_lock(struct kiocb *iocb, struct iov_iter *from
 
 	/* shared locks are not allowed with parallel page cache IO */
 	if (test_bit(FUSE_I_CACHE_IO_MODE, &fi->state))
-		return false;
+		return true;
 
 	/* Parallel dio beyond EOF is not supported, at least for now. */
 	if (fuse_io_past_eof(iocb, from))
-- 
2.46.2



