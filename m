Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447D26A03B;
	Tue, 23 Jan 2024 02:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975341; cv=none; b=NXVFn7mrZI152i0QdWOhWbmjf3nBueqXTxkCpr1f2ABecN0InVFjuWCvHbjxIYkE5ua12yOKssDykAqPeCMoXOjBIovSrOSqJGs2N9E9tXOr0KcqnOKamVU/6J45A6PjoOoltCkU0PqJjo426inJwye60VlTdFAIf3N3xXwhfO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975341; c=relaxed/simple;
	bh=EHxg1DX9nuDZRQ+Y7Nj308ZDUByqVtLwsT/5XJU0/Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAY2Cy1JyDAQPP0gl9TkKjOiFAB9U/Dqxfad5HF5MMslHcX5QKw/zhjNE3P4vPlCL3/MRXnHegkmFbhi9IL2VZ3TRvotf5iJn8KxI2fY2BFFt5FqStH0O+Qdsb0l92bjnBwXn3ulva/qDTSQgPX7gU/Qi3INfA+QgYN/ZZw1gqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtqRTa+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtqRTa+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065FDC433B1;
	Tue, 23 Jan 2024 02:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975341;
	bh=EHxg1DX9nuDZRQ+Y7Nj308ZDUByqVtLwsT/5XJU0/Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtqRTa+Hm4Z7SY8ATZLeS/cbOo5AGsokQiHaKhGZxS/7nX1lQ0CE6iGW/sKgBU6qE
	 03k5HXPoicTHZLh6Hjhp1xNbLbZrG2juQSBR3xnuSIpmJOaWx3P5GTliWnLwRvqcc+
	 dzx2vMDIWuQpRB58H/tuFGinkG9YYYqfvVlMXdtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 278/583] f2fs: fix to update iostat correctly in f2fs_filemap_fault()
Date: Mon, 22 Jan 2024 15:55:29 -0800
Message-ID: <20240122235820.502030032@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit bb34cc6ca87ff78f9fb5913d7619dc1389554da6 ]

In f2fs_filemap_fault(), it fixes to update iostat info only if
VM_FAULT_LOCKED is tagged in return value of filemap_fault().

Fixes: 8b83ac81f428 ("f2fs: support read iostat")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index e36a3208a3e9..a631d706e117 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -42,7 +42,7 @@ static vm_fault_t f2fs_filemap_fault(struct vm_fault *vmf)
 	vm_fault_t ret;
 
 	ret = filemap_fault(vmf);
-	if (!ret)
+	if (ret & VM_FAULT_LOCKED)
 		f2fs_update_iostat(F2FS_I_SB(inode), inode,
 					APP_MAPPED_READ_IO, F2FS_BLKSIZE);
 
-- 
2.43.0



