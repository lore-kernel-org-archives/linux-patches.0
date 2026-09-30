Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E488836998C;
	Wed, 30 Sep 2026 18:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794539; cv=none; b=Nh/gZgHD9hhIAi1RzlipdR9am+VCoiq5QiVcPEu60Ua9G9+cYnCZulFUDl8Y5F+VivPZQ57P3/a/ZAFdt6NJ2ZmC3nUZRBqvlj2Xk5QvSpRdKCH23qu7Ek1iKHl/Its/jjPTu1PUDYfhtuN7nr16j4YROLs9azJ2fKwJlKDDTZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794539; c=relaxed/simple;
	bh=cWriDPfjmOTf+rQHEC354ZwgXWTzfJioLrFz7qVcuoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/52zQoqylD0lkwK5LUU6z/fXdooezhjr6T2YY/uJGYSXxX68zNfqevmBa+YoDQEVPD2NMXlQlX0F5aycs81gQWBgI+UH1PNvqNA//Txx/4nXCszpOj2K/JC8ImqR75CBpkXXd/YSI018C3dLhCY2khj0w+YpvG0o64sAnW4UMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRQU8xUd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRQU8xUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4984F1F000FF;
	Wed, 30 Sep 2026 18:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794537;
	bh=mTObJZEDM2+LCyZ7l+Al7cwql0yJkgkqtBgVdIQvrsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mRQU8xUdTMbM4N4Dd56fdJE3o3lmlrfy4YURhIoTSHr1xe5jByr/8opDFwM/KX+G6
	 LqqSlzFTFqnB35WodRu3PSvyGmtoUjp4Xe5bPXFLmrnhIKJniM3um5YoQJy+KABSbj
	 J9Ls7Y1RuA0qjA1LiUzb0qdM5Pg7cGCwgo1MoFyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Yichao <liyichao.1@bytedance.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0229/1193] fuse: set ff->flock only on success
Date: Wed, 30 Sep 2026 17:15:13 +0200
Message-ID: <20260930152439.282501960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

[ Upstream commit 71947173cef279be5eed209ec28f8c11f9d73159 ]

If FUSE_SETLK fails (e.g., due to EWOULDBLOCK), we shall not set
FUSE_RELEASE_FLOCK_UNLOCK in fuse_file_release().

Reported-by: Li Yichao <liyichao.1@bytedance.com>
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index a18ec80f57f9b..553c163afbc2d 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2680,8 +2680,9 @@ static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
 		struct fuse_file *ff = file->private_data;
 
 		/* emulate flock with POSIX locks */
-		ff->flock = true;
 		err = fuse_setlk(file, fl, 1);
+		if (!err)
+			ff->flock = true;
 	}
 
 	return err;
-- 
2.53.0



