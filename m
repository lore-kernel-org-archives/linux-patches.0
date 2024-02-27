Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09A913B2A7;
	Tue, 27 Feb 2024 13:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040742; cv=none; b=GWjnMy1LOPWVNgCe22XzVaXNq4GNE5133RX7pJNtuT0yx8/dCZB5VabJ5ZNOb3+E3vuxCqIpU6K4N5XqvY85ytP5xqrvvHeddb6x1y22US9EkGcrX4crFKpfU9Ku7LuU+SRPxY6vI8x+rphZ+gVOdahf959t2kpaM9T/hnVaOEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040742; c=relaxed/simple;
	bh=4wupQrzjWk6uINCKq1go0UG4xFJS69wzTux+wM1gb7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sc9LAYqrGq689KOrQzn8/iJEwUaevNzTG6wpDIlPHVeqKGIJ1rpA+FymBOVWy5wCCGzucO4mSsTCn1C21fMQcblkvRbszpao0qSpikhO+97WRK4hTe5W2ctzKVSe5JhU6eWhlXMuv2jw8iOcG/7/tslxuvIa8q1F9SsmSEk7VMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDKFPheq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDKFPheq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C896C433F1;
	Tue, 27 Feb 2024 13:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040741;
	bh=4wupQrzjWk6uINCKq1go0UG4xFJS69wzTux+wM1gb7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDKFPheq8fXq7DyA9yDCQ5/iO2zAbKR7Oq3rOjSMOJ0xq//0Yr+MkhZtPStiA1Xu0
	 VCVP3C+pz268cwzkg77GTGvzsli5KZPmbPGR0LJ5EmEZdhdyNKHa+513X3dw2Sj2Um
	 z1dpAn9v1cQ2uiCRzOArNV65e1AWV/MVsewA9wIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 086/334] fs/ntfs3: Drop suid and sgid bits as a part of fpunch
Date: Tue, 27 Feb 2024 14:19:04 +0100
Message-ID: <20240227131633.300517531@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit e50f9560b8168a625703a3e7fe1fde9fa53f0837 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index bb80ce2eec2f7..0ff5d3af28897 100644
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



