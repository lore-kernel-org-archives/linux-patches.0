Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09DC3568E0;
	Tue, 26 Aug 2025 14:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219068; cv=none; b=dtrBii6usc65KGiFzl2GAPbz2Iwle20L6Z3adSeLjvon8lHkfSWzaRug3LL/wAh3u+/kBhJwLpJFR2NqDLXGtMK6MG7rEscrNAn6ZpXvEn/heMtMjquT5DpCjfBDkUugh+d+Mv5LZIKKjZX3U9v1BhyrWBueBpkk1Hn0W5b4wqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219068; c=relaxed/simple;
	bh=TqhwU8nQGzgG6K4ipZ8Yomhp+l0fJ/8QetLzD3kpNPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsbrI8KcteyaAERQ+HXe9sntXnPH3Yyhl1itgEnwp4RGDO/z4rvYLeb2vM82ItwVoTyDxkrtoE4ww8foNJ6Z4Nwuv2sIv42hCyAveLPDKKWgRI88hCP5XP4An9Y9JVaKV5K9gZdzUSmW9cI7tpf5qb166buz3tWHuTiGecRvem0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jn8+4+xs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jn8+4+xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEF9C4CEF1;
	Tue, 26 Aug 2025 14:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219068;
	bh=TqhwU8nQGzgG6K4ipZ8Yomhp+l0fJ/8QetLzD3kpNPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jn8+4+xsTkomExRxTEVjxcgcXhwdAzayel0o+9I/zijJfWisj0jGfzRgSiVCCzTG7
	 /ggNDbc/8/RGRD9uQX1uKf2zhEm/xEPGdwpenD7wJMGulOoWOoc1DWDQB1CMZ33kUY
	 DQLmwOO4dJr/MecvysS5TA28MEbl6Ue3FndSg1xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+630f6d40b3ccabc8e96e@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 240/403] jfs: Regular file corruption check
Date: Tue, 26 Aug 2025 13:09:26 +0200
Message-ID: <20250826110913.462403009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 2d04df8116426b6c7b9f8b9b371250f666a2a2fb ]

The reproducer builds a corrupted file on disk with a negative i_size value.
Add a check when opening this file to avoid subsequent operation failures.

Reported-by: syzbot+630f6d40b3ccabc8e96e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=630f6d40b3ccabc8e96e
Tested-by: syzbot+630f6d40b3ccabc8e96e@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 930d2701f206..44872daeca01 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -44,6 +44,9 @@ static int jfs_open(struct inode *inode, struct file *file)
 {
 	int rc;
 
+	if (S_ISREG(inode->i_mode) && inode->i_size < 0)
+		return -EIO;
+
 	if ((rc = dquot_file_open(inode, file)))
 		return rc;
 
-- 
2.39.5



