Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EFC5F54E;
	Tue, 13 Feb 2024 17:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845234; cv=none; b=bBHJLmasKYKDX/DTWrodT2EQbNa1j4odcGfZbVLBoAJz0n7f7LzS/RT09qqZGqU+fbwIKIp8evxIzX7tnt0MvCA0lNjA9zP+Cpnv7kmaA8OLf7VZdebOtWJ6N03+hfVRvmucUFLwIbp8fngEzGeTNuiPz02t51HOdJvFBGehn8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845234; c=relaxed/simple;
	bh=21ANDs2KpDOEdf6T37Cp9l6IJJJRJAtTBk8YCrrCil4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXLGcE/ec8C0c2t6Q+mvwOLvhBbwo2S8S3phXv/3RWDZ8xdovql1T1IRXfQfPcKAO+ZIApkCW+idrZzkjxdejfUKq7S+rlN7iyDg5JNfZJHgzjLpdKeMxo3k2aIHRXggeb4CpIYBiYsuwNqOvsZFmFZgPredtanc7jWHz3QGDEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXgMwFdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXgMwFdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC52C433C7;
	Tue, 13 Feb 2024 17:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845234;
	bh=21ANDs2KpDOEdf6T37Cp9l6IJJJRJAtTBk8YCrrCil4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXgMwFdlwnz7Lh243Jnxx1pE8jUhSK4N1jQ5OgzTkyCakftZIy0tEUfHYgquKXYGO
	 lHjlLXou8bPj5qlwdw1R9s7UDAg/8ibKQ1x74PV5CPDfpNdg/uaV/Y+Q/Eza2tuglS
	 05R1zT46lpUBFVBX4h2pkCf4ZmOvMhXPk22AVAWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/121] xfs: fix units conversion error in xfs_bmap_del_extent_delay
Date: Tue, 13 Feb 2024 18:20:31 +0100
Message-ID: <20240213171853.620201285@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit ddd98076d5c075c8a6c49d9e6e8ee12844137f23 upstream.

The unit conversions in this function do not make sense.  First we
convert a block count to bytes, then divide that bytes value by
rextsize, which is in blocks, to get an rt extent count.  You can't
divide bytes by blocks to get a (possibly multiblock) extent value.

Fortunately nobody uses delalloc on the rt volume so this hasn't
mattered.

Fixes: fa5c836ca8eb5 ("xfs: refactor xfs_bunmapi_cow")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 26bfa34b4bbf..617cc7e78e38 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4827,7 +4827,7 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got_endoff >= del_endoff);
 
 	if (isrt) {
-		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
+		uint64_t	rtexts = del->br_blockcount;
 
 		do_div(rtexts, mp->m_sb.sb_rextsize);
 		xfs_mod_frextents(mp, rtexts);
-- 
2.43.0



