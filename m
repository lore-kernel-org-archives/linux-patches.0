Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B6119D074;
	Mon, 23 Dec 2024 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969675; cv=none; b=ZbMYpYxfH+euzTp//feSgmsH1bR3IPo9m3tbLP/gIIVWQE3VRhFdQdy3v0xHFMVjjCuDN1Qzb5T+xGf0zKXqMXZ9MqSEiB+gi8cPlAfEPgIqqj529Y2kvoiTKBCorjFtjjxlYnTXbGERYmGimyY+hFCbPJQhXIGOKCn+TArHg0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969675; c=relaxed/simple;
	bh=0F0N4P1NWfWg4yDD+8VIg6bcJO4ERANFXJRhCAAdGHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocR8hETkFZUrGVjp82h8TncOYCsyh+6PWG2xDm498Wdz0JEkzfmgnA1cwGjk9hy5vLguS1oUFmBB992AliNWlLAErF0CEi9pOeMOodagatWvSAZrEMH4SFlPzLo76aTiT62cYhmp9pYXnwjdlUAXRtdJ7wZjsM8OXu4Pr6rG2fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4pl92I0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4pl92I0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2275BC4CED4;
	Mon, 23 Dec 2024 16:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969675;
	bh=0F0N4P1NWfWg4yDD+8VIg6bcJO4ERANFXJRhCAAdGHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4pl92I0wdfGEkla7YhDCI4yebVOxHFvCpKSzu1z8XnOs2PUjwT/ALZdWBxKd/lhe
	 50/MwvQyKq7Wqd7UyT6JqpO5LbYKavtRo/TbrjZHFTLm9Uo4034i47N32+cO0o2Jta
	 eaOB1bW17HlwkzLYLexejwS/Mx4WImb8Z0f4OtUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/160] xfs: sb_spino_align is not verified
Date: Mon, 23 Dec 2024 16:57:14 +0100
Message-ID: <20241223155409.549643983@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit 59e43f5479cce106d71c0b91a297c7ad1913176c upstream.

It's just read in from the superblock and used without doing any
validity checks at all on the value.

Fixes: fb4f2b4e5a82 ("xfs: add sparse inode chunk alignment superblock field")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[djwong: actually tag for 6.12 because upstream maintainer ignored cc-stable tag]
Link: https://lore.kernel.org/linux-xfs/20241024165544.GI21853@frogsfrogsfrogs/
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 02ebcbc4882f..9e0ae312bc80 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -391,6 +391,20 @@ xfs_validate_sb_common(
 					 sbp->sb_inoalignmt, align);
 				return -EINVAL;
 			}
+
+			if (!sbp->sb_spino_align ||
+			    sbp->sb_spino_align > sbp->sb_inoalignmt ||
+			    (sbp->sb_inoalignmt % sbp->sb_spino_align) != 0) {
+				xfs_warn(mp,
+				"Sparse inode alignment (%u) is invalid.",
+					sbp->sb_spino_align);
+				return -EINVAL;
+			}
+		} else if (sbp->sb_spino_align) {
+			xfs_warn(mp,
+				"Sparse inode alignment (%u) should be zero.",
+				sbp->sb_spino_align);
+			return -EINVAL;
 		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
-- 
2.39.5



