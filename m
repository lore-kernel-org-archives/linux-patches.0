Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED63879FD;
	Thu, 11 Apr 2024 10:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832611; cv=none; b=Gr5lYoSij7g+jVc0czVp2TrcExFVMN2QZEMzN/i0rRks5ANSBd1AKqwUvWGq3TMQfzU8L7xrE4Bhz+qc1ZJof7/hIrhiripi8hAubcnpzJmq7XejuI6LaoZe903H9QSRofeLWWhRjxBVPZnrJUaE6aWI/KoXVWaO8AjaO+V5mKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832611; c=relaxed/simple;
	bh=+rlw1V0qIUT3EM4JHpL3fCNV5QN+0Q+rfwHuifX240I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyOpjYDV+MfA3Noq10aOpf13JoIlx/42LcpLH+cRkEZ5SH4MMaZ2Sdzdup9oVmbzZrG4ozptfK+P8mgVoMl7ogh2bd1/srtgu4XiVQdr2BixFzD2az9hg7S2b0npUFsC5t8Z6d5+W8i5KrL4WUzA3y6KzotK3b7Srl51sBnObEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XELMgP0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XELMgP0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72786C433C7;
	Thu, 11 Apr 2024 10:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832610;
	bh=+rlw1V0qIUT3EM4JHpL3fCNV5QN+0Q+rfwHuifX240I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XELMgP0NTZSXwL51pIjmlPN5F9zMBBQFO9CcMifvT1pMOTAdO1GVWdPO/fVdJNcie
	 KWDwSPI3gf9V8VisexrT6beos24V5IMD+KsjV1m01Aj1cy6Yuqxt0ZoWHKr4sma3fe
	 3HSfdA3rC4zWzI9QDHRYe+598iPLGa3FyY8cCDxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Henrie <alexhenrie24@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 24/57] isofs: handle CDs with bad root inode but good Joliet root directory
Date: Thu, 11 Apr 2024 11:57:32 +0200
Message-ID: <20240411095408.727835565@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

From: Alex Henrie <alexhenrie24@gmail.com>

[ Upstream commit 4243bf80c79211a8ca2795401add9c4a3b1d37ca ]

I have a CD copy of the original Tom Clancy's Ghost Recon game from
2001. The disc mounts without error on Windows, but on Linux mounting
fails with the message "isofs_fill_super: get root inode failed". The
error originates in isofs_read_inode, which returns -EIO because de_len
is 0. The superblock on this disc appears to be intentionally corrupt as
a form of copy protection.

When the root inode is unusable, instead of giving up immediately, try
to continue with the Joliet file table. This fixes the Ghost Recon CD
and probably other copy-protected CDs too.

Signed-off-by: Alex Henrie <alexhenrie24@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20240208022134.451490-1-alexhenrie24@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/inode.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 0c6eacfcbeef1..07252d2a7f5f2 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -908,8 +908,22 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
 	 * we then decide whether to use the Joliet descriptor.
 	 */
 	inode = isofs_iget(s, sbi->s_firstdatazone, 0);
-	if (IS_ERR(inode))
-		goto out_no_root;
+
+	/*
+	 * Fix for broken CDs with a corrupt root inode but a correct Joliet
+	 * root directory.
+	 */
+	if (IS_ERR(inode)) {
+		if (joliet_level && sbi->s_firstdatazone != first_data_zone) {
+			printk(KERN_NOTICE
+			       "ISOFS: root inode is unusable. "
+			       "Disabling Rock Ridge and switching to Joliet.");
+			sbi->s_rock = 0;
+			inode = NULL;
+		} else {
+			goto out_no_root;
+		}
+	}
 
 	/*
 	 * Fix for broken CDs with Rock Ridge and empty ISO root directory but
-- 
2.43.0



