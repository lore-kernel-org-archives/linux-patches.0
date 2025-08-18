Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F0C30F7F8;
	Mon, 18 Aug 2025 13:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522472; cv=none; b=TusA3FCoJgQjCt6in9wjnP5Gv0l1hqfIztoDxyTIMODFWuUTxE3wYLdlH4MYJx+ulrxQsmPLlupcYV6Dmsdbjev857XTMgfXe1V5HmZUFDnFVO6ezPsmGQYrBaiMkP0igLekjsA6pJ6+DbuzbF+LLdu9mP7sGpScXwJtwIIxq2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522472; c=relaxed/simple;
	bh=NCqm6b4Lj3v6M2qXzrGYEyhyMNtfnZ9bDLgtB49+Hk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqAAxaz1YYY9ritjBdEhLHgRtQmPIr1Tv1r45fAwNjJrUB28Q8dIvHXXm0nxd/S41E3+Wo+j+lYmI/OEIdc/mWOF2dZ2HS3B6fsh3kEHEgZHSFrTv4am4o28014z805m5xyG//6BLn1yiq6vxNXCqlGx8I6X+JzJ2Eub6tnsJGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPiRoxfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPiRoxfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64230C4CEEB;
	Mon, 18 Aug 2025 13:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522471;
	bh=NCqm6b4Lj3v6M2qXzrGYEyhyMNtfnZ9bDLgtB49+Hk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPiRoxfNlFOLXn+jlz0IUq1DizznaJtDOvbokmq0Hn7vG/QctgAzr1ffj4MDKKu3M
	 du/zkoe1Mff9qmA86F1Jqh/GlhjC6Nb9xJG9FViRrvDhSM0WAVFuhX3WABt8AZifAt
	 30bTDQPvZ9+j/BURLkgTm6V/RnCjwapx/vYuMW+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+630f6d40b3ccabc8e96e@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/444] jfs: Regular file corruption check
Date: Mon, 18 Aug 2025 14:45:19 +0200
Message-ID: <20250818124459.944433807@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 01b6912e60f8..742cadd1f37e 100644
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



