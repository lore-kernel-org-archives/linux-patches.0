Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C631ABCB8;
	Thu,  6 Jun 2024 14:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683285; cv=none; b=MgmHZZ0e4xqNdK4U1hjrTO7a6QCYBByMdNP612isDoJ4SavcRjKZein8sEuJmaN9kDhtX3fnW0vAvbma6aNDVr7dycieG2JWHEFHsB9+Qhx97NPGWoDUs4lqLWMO0LWSUswgiyUU6P6p8l8v80WZOYoi4XVRrBsKu4ZyODiM7yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683285; c=relaxed/simple;
	bh=pJZFQJxSUcu1hvCR+4uaaW2+/J/bnPO18Ok0h3jU8x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsIMdmpL+Pz7r74kZQlj6K1Vkfvd3zzi8yM6EbyJFsBpEiPJmFjSWl68Ni5VJsLWrcVU1wRYlTPrBQbI1Z6XGhOk407frMyMxtA90CLQQRB/2gTw5A2NczKpJYV6xS78oXYWMA4+MSOypIj2T8x0ADjyvjYIsL8BsZXiIxHnURM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0zFOJBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0zFOJBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6366C2BD10;
	Thu,  6 Jun 2024 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683284;
	bh=pJZFQJxSUcu1hvCR+4uaaW2+/J/bnPO18Ok0h3jU8x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0zFOJBLNeeiM6tFhdpb3fNO8RUuLNBfuBkV1LkTObbiRKwj4Ja0216N8uL0qWvID
	 hMl9ywaT8SE4zv7rdYpycffzKyrIfXIJBtv1CYqk2fgc6g2GW4HePOSxZoJ2P9ViZA
	 uB3Z6bNmTxMWNlUvTcThSzQypEkabe+HLJ01rGO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/744] scsi: bfa: Ensure the copied buf is NUL terminated
Date: Thu,  6 Jun 2024 15:58:18 +0200
Message-ID: <20240606131739.648745943@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index 52db147d9979d..f6dd077d47c9a 100644
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



