Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260FF14600E;
	Thu, 11 Apr 2024 10:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830528; cv=none; b=RymjtGEXO2pVxGEY/zvliVv8jgtjnWFKF9Tlzx0wDKoedAIyxt9NYZhfK+Jzyg5/3DMO7OKzWX6OqC2gkudQmxF+pabhz5vGPWS7RXA9QVI5cAY+pzhG2a/6Lll92Mr7doQ8J995SR8vCAilyb7BkES5ZRKmebYV7hVShWuE42A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830528; c=relaxed/simple;
	bh=MNHt9bC8Sm/Qqsb7gVRvqAH9e2M0QIPuwvTvEE1Y4OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpD8zM1Pa6EgVMYFBLzrqDu32KH5ETjTaJc5XOpuL9cZx3eKti3e24Mynd7DofdqMh4QECQcAksW3NNFL6SY0xD6FELK8oNJ4H6bA7p/dMHUyUUb2pyprK4JchQW3C4eCy0l6t/t6WomU76hsWFO55D+U4tTVP66QcFxTnxlqOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7k/9T7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7k/9T7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98260C433F1;
	Thu, 11 Apr 2024 10:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830528;
	bh=MNHt9bC8Sm/Qqsb7gVRvqAH9e2M0QIPuwvTvEE1Y4OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7k/9T7TMyHxrZvPI2VDady1nsVGnW2R97sXY1CkRPG7T9l/h1Oqy2ErXGmPYK01D
	 O2X0ixaRGr96Kb4CR5zOxuyzB7c16YNBZwB1TTW6pIgzHSzRLKT63ZCZ9uSqcmLHaA
	 WUlKjKISO/gEZumy4VT455Pthea/bQaAyDI+wSrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ce5dea5b1539ff36769@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Amir Goldstein <amir73il@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/215] fat: fix uninitialized field in nostale filehandles
Date: Thu, 11 Apr 2024 11:53:52 +0200
Message-ID: <20240411095425.580772789@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit fde2497d2bc3a063d8af88b258dbadc86bd7b57c ]

When fat_encode_fh_nostale() encodes file handle without a parent it
stores only first 10 bytes of the file handle. However the length of the
file handle must be a multiple of 4 so the file handle is actually 12
bytes long and the last two bytes remain uninitialized. This is not
great at we potentially leak uninitialized information with the handle
to userspace. Properly initialize the full handle length.

Link: https://lkml.kernel.org/r/20240205122626.13701-1-jack@suse.cz
Reported-by: syzbot+3ce5dea5b1539ff36769@syzkaller.appspotmail.com
Fixes: ea3983ace6b7 ("fat: restructure export_operations")
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/nfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index af191371c3529..bab63eeaf9cbc 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -130,6 +130,12 @@ fat_encode_fh_nostale(struct inode *inode, __u32 *fh, int *lenp,
 		fid->parent_i_gen = parent->i_generation;
 		type = FILEID_FAT_WITH_PARENT;
 		*lenp = FAT_FID_SIZE_WITH_PARENT;
+	} else {
+		/*
+		 * We need to initialize this field because the fh is actually
+		 * 12 bytes long
+		 */
+		fid->parent_i_pos_hi = 0;
 	}
 
 	return type;
-- 
2.43.0



