Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C3C22EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eRyGAX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F39C433C8;
	Mon,  6 Nov 2023 13:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277251;
	bh=DGHfhCN/6hUA3SsNVqWjGv+ZeyvKgtkqbKGTbGts7Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eRyGAX4b64VisMVfhrzzjnp9c6ZEUCM2HlrwR9QsSkZov4Ipnpz2FJ01O0T7pZSX
	 nRcEpiy8iYYNH06Lou1X5xgT+ym8F85mLA+AC8cY5yJWbO/2IWD/ecuyP/pfngstHs
	 wfmlUEIp9kvDMUQUCZTplvPxKtMA8hlcIHPCdXVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Marcano <gabemarcano@yahoo.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/128] fs/ntfs3: Fix directory element type detection
Date: Mon,  6 Nov 2023 14:04:08 +0100
Message-ID: <20231106130313.138500921@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

From: Gabriel Marcano <gabemarcano@yahoo.com>

[ Upstream commit 85a4780dc96ed9dd643bbadf236552b3320fae26 ]

Calling stat() from userspace correctly identified junctions in an NTFS
partition as symlinks, but using readdir() and iterating through the
directory containing the same junction did not identify the junction
as a symlink.

When emitting directory contents, check FILE_ATTRIBUTE_REPARSE_POINT
attribute to detect junctions and report them as links.

Signed-off-by: Gabriel Marcano <gabemarcano@yahoo.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index fb438d6040409..d4d9f4ffb6d9a 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -309,7 +309,11 @@ static inline int ntfs_filldir(struct ntfs_sb_info *sbi, struct ntfs_inode *ni,
 		return 0;
 	}
 
-	dt_type = (fname->dup.fa & FILE_ATTRIBUTE_DIRECTORY) ? DT_DIR : DT_REG;
+	/* NTFS: symlinks are "dir + reparse" or "file + reparse" */
+	if (fname->dup.fa & FILE_ATTRIBUTE_REPARSE_POINT)
+		dt_type = DT_LNK;
+	else
+		dt_type = (fname->dup.fa & FILE_ATTRIBUTE_DIRECTORY) ? DT_DIR : DT_REG;
 
 	return !dir_emit(ctx, (s8 *)name, name_len, ino, dt_type);
 }
-- 
2.42.0



