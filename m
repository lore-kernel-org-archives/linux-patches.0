Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9C817E90E;
	Mon, 27 May 2024 19:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836867; cv=none; b=llP46mpT9x052Pe5bhjb4ctFA68Ta7rcSxNZKM/e9Wsfuab7SmG/1aS+MFcWbm/hxKwh9q9eWKe/smDAQZ+t7u82NiNjjFf5gphYElRTGLwWw1yK4qWOULdLINsFdZon9j2LXAyDApp1fg20mv4iCF/qydqW8BUYO8FgQPh1SoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836867; c=relaxed/simple;
	bh=sTDXQBGQOCbXKP2EvIm9pPjoodBfvodjNUABtn1Ud7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOnJCMeBIcGzJ6IYUT1gwGa7WdM18/K9MgsUc7sUkRZfy8sd4+uwfXVwQO4CKtsiRRPs2kJCLcC1/sW/Ok+Xa9iHn3Td61aUMz5qqqt7waHoMWiXOVJqhyteMEjmhD81H4hLFN1pCdS6IrRZwXO1dr4MMOeHDf5w7d3EiOo86gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyA/+AjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyA/+AjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FDEC2BBFC;
	Mon, 27 May 2024 19:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836867;
	bh=sTDXQBGQOCbXKP2EvIm9pPjoodBfvodjNUABtn1Ud7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyA/+AjKH86i4weaCFishDI0SizWax5xsRsL5S9c8eddRzyZKl1GlB6pg4iGTvhkG
	 cFCG/8OIZiZkgByzXZSmWchhUSIvvZFhFfSkfcpESoE1X3Thodxrfi2e29QixU4mGe
	 iqOy1X35TThI4ciUxRccm63FqR7tjR7r/WDhvbe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 218/427] scsi: bfa: Ensure the copied buf is NUL terminated
Date: Mon, 27 May 2024 20:54:25 +0200
Message-ID: <20240527185622.882473538@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



