Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0532A47A76;
	Mon,  1 Apr 2024 16:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989430; cv=none; b=oIeOOLrRXhqjGrS1ubsTfK6Ru7PowKPbcBlyK5vBmVdPBylT5QQQosjeSJIacXQeI0SgVTkT9ouNIaw6gi/rJvdfRVIXWy0PE18xK81XU8Id92D9epx7luTBw2EP+nBDePjgva6ESV/ky1UaV1mFUswUeU6xR9aSo8+Al8RcQ/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989430; c=relaxed/simple;
	bh=IO+NqkC7UqDYetimoF7kKrlHVhLCMDWBiXBwlpiVm2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bo5s9Xge1K28x9mUiJ8LVqnnCHPHl3etuEeASrKZWwat7QDHeSoqK51Ge/pfftPnA+6ttdub7Oz3OyHIVi1P7pGrXFx9r9uPSnJbezdXc4mJp3fdiJ1A9j6fdxayVK1KK5fJHS68WBM1xIN6I9WqzEijjIGwEPeQzKDu8QCD5D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZH+SUF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZH+SUF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366E9C43394;
	Mon,  1 Apr 2024 16:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989429;
	bh=IO+NqkC7UqDYetimoF7kKrlHVhLCMDWBiXBwlpiVm2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZH+SUF5Zc8JAHizw5BIfiTINKucTKS0cFNcSl8+bJ6fYeth2VMEJTi9GqlRy9oGg
	 lIhWwncoEyTYYAwPTXLwwMvfsY2uhB4J4M67v8FyGIvEkPOau57vM7u9Fis0UKDlnC
	 vPcdGWim06U6cPsN0TnAReT6SunHuE7qtKoOVpUQ=
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
Subject: [PATCH 6.6 045/396] fat: fix uninitialized field in nostale filehandles
Date: Mon,  1 Apr 2024 17:41:34 +0200
Message-ID: <20240401152549.272642032@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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
index 3626eb585a983..93c97bf45b061 100644
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



