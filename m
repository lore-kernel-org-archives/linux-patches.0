Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FA914386C;
	Thu, 13 Jun 2024 11:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278825; cv=none; b=Vb4p2GNqK+Dfz5SBIgY1cT2mxgdW8F7VOUVlN3K3FPQpRyPprE13ftkAvKOhRNYbzptBVW5d0HHG+v0x4UGw7sfNzxad613w6FjF+dRXEaCUP9k2te2tCZV9vCAk2UzJp2Xto/05bGCyU2+Oj6HKII83v7z99dwnSgRS0FZHLEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278825; c=relaxed/simple;
	bh=wP7LXAfpw2VhhKBDiWwDqQaJ8Nqn6+0ENxmoKl/iXQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxW7z6gjR37aoE+MxBblb4dV1Rga/irVp26otGrSS/DqvLK33dNuYy1joTqQvHBPKkR/C6xn3JqK0IOcdtKfncmsMngVuCKrbQnoQND4NB46eTA85VVBrhNtcTvbNfstiHv8i1tJXkKj4Pyqr4Gs0yN7qqjeq2nzPTLoGXfLF/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzCeFzs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzCeFzs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA031C32786;
	Thu, 13 Jun 2024 11:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278825;
	bh=wP7LXAfpw2VhhKBDiWwDqQaJ8Nqn6+0ENxmoKl/iXQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzCeFzs3p6Yu/wcYDSlCgeaif9cuw8K00ULSs6OTk40+/zSbfqY+ltbh3R4woyTN7
	 Pk5zGmy/6A+Si7sI9ArY9WvFoQTwdYg0869IYJq2YO/C9MjQuhEDxm42P5jj+7cQzg
	 v3v1J+wgjW7upufq+kVYpNpayR4m7j/zVAqgFLjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/213] scsi: bfa: Ensure the copied buf is NUL terminated
Date: Thu, 13 Jun 2024 13:31:39 +0200
Message-ID: <20240613113229.977929323@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 349cfe7d055eb..30c344322d531 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -258,7 +258,7 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	unsigned long flags;
 	void *kern_buf;
 
-	kern_buf = memdup_user(buf, nbytes);
+	kern_buf = memdup_user_nul(buf, nbytes);
 	if (IS_ERR(kern_buf))
 		return PTR_ERR(kern_buf);
 
@@ -325,7 +325,7 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 	unsigned long flags;
 	void *kern_buf;
 
-	kern_buf = memdup_user(buf, nbytes);
+	kern_buf = memdup_user_nul(buf, nbytes);
 	if (IS_ERR(kern_buf))
 		return PTR_ERR(kern_buf);
 
-- 
2.43.0



