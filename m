Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4278E2FF174;
	Tue, 12 Aug 2025 18:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024972; cv=none; b=K/anrK3Pr0M8Acu6jDV20sDV9bqX9KyGyqC4PEkpTapTbMKo+9QQoT/vSpI7cywI93r66AsVCeaN/YyfwBg0ZYpbhUO/hBMURo/ubIv6nVua7+OKj8sEFHFNNkqOnGDnsicIi7YYA30UmlN5UM/F4YvcOHDvFELYo0YWryOxHZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024972; c=relaxed/simple;
	bh=coD8pF+nB0t+jA986TnykXMS3YbqTX/RxdHFb+TqN30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvGNBX9P7ovdSy5Pzh7wQmZVU5JpqeGYzSQBYZUGMjDNI89AGQAY8bBaRr2ZrnmnbYdIP4KguQ7yxFndf9JomOYlJVr/EVLMzQiGq8iAEnrlhGIaBeA0hJRoznbW4/Ug8LFlYYgeN423QkM3PgPKPw/0Btb5Ni1vtmFki+vmZ98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbZKIMvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbZKIMvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BC3C4CEF0;
	Tue, 12 Aug 2025 18:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024972;
	bh=coD8pF+nB0t+jA986TnykXMS3YbqTX/RxdHFb+TqN30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbZKIMvv53IG1AQLN3Xk7NtN7ZM/aavaQmtelAbDxVAxv59BlONNaWylEpwIkR466
	 DhxehpFOpQg6AitWWgFABuUGg2uvYZPcHsiqQ61RzaugUT1tYYreFz8LTzzsJSLOo6
	 X5Ad1FKCmo+dW+b+7MXcG4T4Nw48GoxqQEBdRdHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengxu Zhang <zhengxu.zhang@unisoc.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 488/627] exfat: fdatasync flag should be same like generic_write_sync()
Date: Tue, 12 Aug 2025 19:33:03 +0200
Message-ID: <20250812173444.687003987@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



