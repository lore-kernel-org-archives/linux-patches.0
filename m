Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31741420DC;
	Tue, 27 Feb 2024 13:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041813; cv=none; b=SGb1fcZXxsLyXXr2BOQmHsvlOP6cmpOnlzt9P1mEOTClVqkQLJWKDjbp6TvIS+up7bE7/eMyZu43PEehzHPi2gh1tNJvUCNN4Ka8vdTA1B4+xXzqlYi6JUxO265FvGpnxG2ncKSR51xaUvDOWoXylqeQKazXMF1WAqywQphHU+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041813; c=relaxed/simple;
	bh=7QZpRIoZ20u7DYNpVS66/Z7kDMPjqcwGFI/0+sXdmdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFZqbDT26j1+EKilrqSgkBptx7a7YXR7PKtP5f0JniNHgoSmhoij3r41hAVVGWaMRBPpPg8vqdVttG6IlDPBFPtlxY5mwrWKBRq2/iTnEqOzie31qeup+sXX5b+MBf+mkCJK/+XY41yKW/FuCa1L5TTH45dURwyIL28gbJd/3mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7UlQgpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7UlQgpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83545C433C7;
	Tue, 27 Feb 2024 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041812;
	bh=7QZpRIoZ20u7DYNpVS66/Z7kDMPjqcwGFI/0+sXdmdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7UlQgpb3dakRrcqu2XvY6VuUH6tRTZhtc2zi9KdTwWlgTKaR433Rjit+3ktez7AD
	 tA2kL6Hz4/3ZYiz+mthJ3rm2Ff1whywMsegDw+J0XyjduqRLgVQDIy+6SlXLyh87mF
	 FVE4CcxChJ6b4USWuK9OXoYYF5m8DxS3+BbBOKDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/299] fs/ntfs3: Drop suid and sgid bits as a part of fpunch
Date: Tue, 27 Feb 2024 14:23:10 +0100
Message-ID: <20240227131628.472755377@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit e50f9560b8168a625703a3e7fe1fde9fa53f0837 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 6e1c456c9ae7f..5530b4cf1ee52 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -498,10 +498,14 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 		ni_lock(ni);
 		err = attr_punch_hole(ni, vbo, len, &frame_size);
 		ni_unlock(ni);
+		if (!err)
+			goto ok;
+
 		if (err != E_NTFS_NOTALIGNED)
 			goto out;
 
 		/* Process not aligned punch. */
+		err = 0;
 		mask = frame_size - 1;
 		vbo_a = (vbo + mask) & ~mask;
 		end_a = end & ~mask;
@@ -524,6 +528,8 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 			ni_lock(ni);
 			err = attr_punch_hole(ni, vbo_a, end_a - vbo_a, NULL);
 			ni_unlock(ni);
+			if (err)
+				goto out;
 		}
 	} else if (mode & FALLOC_FL_COLLAPSE_RANGE) {
 		/*
@@ -563,6 +569,8 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 		ni_lock(ni);
 		err = attr_insert_range(ni, vbo, len);
 		ni_unlock(ni);
+		if (err)
+			goto out;
 	} else {
 		/* Check new size. */
 		u8 cluster_bits = sbi->cluster_bits;
@@ -639,6 +647,7 @@ static long ntfs_fallocate(struct file *file, int mode, loff_t vbo, loff_t len)
 		}
 	}
 
+ok:
 	err = file_modified(file);
 	if (err)
 		goto out;
-- 
2.43.0



