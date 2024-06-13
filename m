Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CBA384;
	Thu, 13 Jun 2024 12:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281921; cv=none; b=qPy20YCqxTOoXKCrn88OLlwsvrKw1pF1cWy7VptMbcSDIQc2lSh84ePIz49CGctECEsOn5uakp8WjP+uqrF4F3C+ue2E/1DunqJJv4fjeQt863ApuColXaeNheeRQPJfaB0nRACtynMKe7UG9joqT84Yt0BJHuKqTXn+qRSEzCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281921; c=relaxed/simple;
	bh=1VKfiI4Fbjj1jTSA48Kyi+NsU1cmR74giIUU61wTs+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSV/Ei/LG4coiF14DEGiDoGYTVyuOGqWTYeI7IM6UpqWZBQJka9RwJnwj413Bb1d8ITWzyJcuym263skjpD6SWp73/OJqGgA0/0HQtQeOz7Cx4BleL428IoiPA13nfcc4xOV/RaqgwAeGMMBm2JWX6AEnHqzwGAfy6qAJUJMypM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvzwQFb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvzwQFb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBFFC4AF1A;
	Thu, 13 Jun 2024 12:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281921;
	bh=1VKfiI4Fbjj1jTSA48Kyi+NsU1cmR74giIUU61wTs+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvzwQFb4/pBy++uYdYXwn9fwQItqwiNyTFGLTIISDXDRANtK540mTcai/n+wBa8CC
	 Ji3OSdYNdJMs3aTRc+gagmViDgEFGErMeeEHDOwR4w8BYj+i7XAKr+C/knm7xMT8j/
	 kN6z0bxFtvu6oZj4JSIehk1BIx4Qe82iWxWwXMzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/402] scsi: bfa: Ensure the copied buf is NUL terminated
Date: Thu, 13 Jun 2024 13:30:58 +0200
Message-ID: <20240613113306.075597814@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit 13d0cecb4626fae67c00c84d3c7851f6b62f7df3 ]

Currently, we allocate a nbytes-sized kernel buffer and copy nbytes from
userspace to that buffer. Later, we use sscanf on this buffer but we don't
ensure that the string is terminated inside the buffer, this can lead to
OOB read when using sscanf. Fix this issue by using memdup_user_nul instead
of memdup_user.

Fixes: 9f30b674759b ("bfa: replace 2 kzalloc/copy_from_user by memdup_user")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://lore.kernel.org/r/20240424-fix-oob-read-v2-3-f1f1b53a10f4@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bfa/bfad_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index fd1b378a263a0..d3c7d4423c514 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -250,7 +250,7 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	unsigned long flags;
 	void *kern_buf;
 
-	kern_buf = memdup_user(buf, nbytes);
+	kern_buf = memdup_user_nul(buf, nbytes);
 	if (IS_ERR(kern_buf))
 		return PTR_ERR(kern_buf);
 
@@ -317,7 +317,7 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 	unsigned long flags;
 	void *kern_buf;
 
-	kern_buf = memdup_user(buf, nbytes);
+	kern_buf = memdup_user_nul(buf, nbytes);
 	if (IS_ERR(kern_buf))
 		return PTR_ERR(kern_buf);
 
-- 
2.43.0



