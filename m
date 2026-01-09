Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9D035B159;
	Fri,  9 Jan 2026 12:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962299; cv=none; b=QnmYuO3gPS23uOlJqxVEwQJlWZpr15uSHybZxudHcFWJ8BST75bO4+jd9GW+dj1RLlf8wqnU42pDBEApRmrc3qQlhSEbhq+29aPhsy/oPsAPifNdHiPSa9yC2Hn+27Db7RGQ9z8WgtWoQ+8rHMXuX+nQyE2M3QbTCuQgqnjzgnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962299; c=relaxed/simple;
	bh=gjwEXrLBMZ2HZzIMprZc/xgmuVwpb9luZ+lyvMtSHYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fa2s7WL/5AbHq2PXb6STZ/IyDAYH+SRqXNFKnXlRVp1OnRwrTjed8gkcVVws3eA7wF/HdB5vPA9ePgvkmF3RVXNFB/Gfefmux+oGgRWaU/KljaPj4gXvjvpNbFsF0+57+USULOrxIl2zL/DvtrQRUOV7B7dxu+Bvhcqudm936Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N24LbA7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N24LbA7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656ACC4CEF1;
	Fri,  9 Jan 2026 12:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962298;
	bh=gjwEXrLBMZ2HZzIMprZc/xgmuVwpb9luZ+lyvMtSHYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N24LbA7QKoodWAKN9gmwgJ2bcpeIZuP0VczwxPMulI3OafYQEDe1jA/UNMVzc746K
	 73e3L9D8XCTRtsj5ro712Pzgu0vkl9rH+JhyREHzGM86o0k0E9B1Ba7+qdNada3rLh
	 GjskashL9f5Ac/PsSE3DN4nFh+qzYWQBKviPmeP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 283/634] ksmbd: skip lock-range check on equal size to avoid size==0 underflow
Date: Fri,  9 Jan 2026 12:39:21 +0100
Message-ID: <20260109112128.181308182@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianchang Zhao <pioooooooooip@gmail.com>

commit 5d510ac31626ed157d2182149559430350cf2104 upstream.

When size equals the current i_size (including 0), the code used to call
check_lock_range(filp, i_size, size - 1, WRITE), which computes `size - 1`
and can underflow for size==0. Skip the equal case.

Cc: stable@vger.kernel.org
Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -330,6 +330,9 @@ static int check_lock_range(struct file
 	struct file_lock_context *ctx = file_inode(filp)->i_flctx;
 	int error = 0;
 
+	if (start == end)
+		return 0;
+
 	if (!ctx || list_empty_careful(&ctx->flc_posix))
 		return 0;
 
@@ -830,7 +833,7 @@ int ksmbd_vfs_truncate(struct ksmbd_work
 		if (size < inode->i_size) {
 			err = check_lock_range(filp, size,
 					       inode->i_size - 1, WRITE);
-		} else {
+		} else if (size > inode->i_size) {
 			err = check_lock_range(filp, inode->i_size,
 					       size - 1, WRITE);
 		}


