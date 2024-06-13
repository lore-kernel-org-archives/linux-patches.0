Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3B514533A;
	Thu, 13 Jun 2024 12:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281166; cv=none; b=OwZRG5JPcGKapNZ+NedGG5jozgTTVknb4Qkw27TdbSiM+soYtpeGzr8kkgP9UxZWynvU1tUSckYbmi/Dk23nV07srR48L55W4LNAIz0k6dNCU5Kx6ml9kQZb+PDfb/DMi7zIT0DGk1ZNX0duGguQAClj4uaP9KwAlDeyXBYntpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281166; c=relaxed/simple;
	bh=dEwMnYkJ4BV7cxyslfSnTYFf09v7jDfsk3PBTHmYElM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/I4XFE8kLlUd7TawVte9hiyTBiZyl9ccyK+b3Id++iBVv1ZwrbgEsHYFijjJY1m3y8swv5usHSsaiKBVdvsk03CNkiw30hreMNIydmgQo4HJMiZljWex8ulP9dDfzbbYBROj7wnX4vuVFgDCQrCaqMGPMruwsj+txijT6HmPhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSdz6PPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSdz6PPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8964CC2BBFC;
	Thu, 13 Jun 2024 12:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281165;
	bh=dEwMnYkJ4BV7cxyslfSnTYFf09v7jDfsk3PBTHmYElM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSdz6PPVONj4OtWgrV9V95WyEGC0yq66WuONxt9OwGpjE4PeJZWsqDmHpAZoKLzIB
	 mndOAFqW19zbMc53xDfV4XiqCMntPb3XSaolW8h6sr5h2h4WMNYHe1e8HRBzRnDiPs
	 L6Eb+y4bhIXvTZbjmpRYAKOI/KFKkwf1/CmFvydo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/317] f2fs: fix to check pinfile flag in f2fs_move_file_range()
Date: Thu, 13 Jun 2024 13:32:59 +0200
Message-ID: <20240613113253.794323906@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit e07230da0500e0919a765037c5e81583b519be2c ]

ioctl(F2FS_IOC_MOVE_RANGE) can truncate or punch hole on pinned file,
fix to disallow it.

Fixes: 5fed0be8583f ("f2fs: do not allow partial truncation on pinned file")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9cf04b9d3ad8e..f66959ae01636 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2835,7 +2835,8 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
 			goto out;
 	}
 
-	if (f2fs_compressed_file(src) || f2fs_compressed_file(dst)) {
+	if (f2fs_compressed_file(src) || f2fs_compressed_file(dst) ||
+		f2fs_is_pinned_file(src) || f2fs_is_pinned_file(dst)) {
 		ret = -EOPNOTSUPP;
 		goto out_unlock;
 	}
-- 
2.43.0



