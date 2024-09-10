Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02F2194C8B;
	Tue, 10 Sep 2024 10:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962934; cv=none; b=BcojRCQ0db2SU903UmwJ+HKKNDLSujdwLLk+FRXLxN6BYtyeZcNqdRgnKsp/GkB3RPcN/yUCx5xhKo1BOVX1u56/N8jCMxDWTteS3uUBqFazUyijZBlk8YErX7AxqyN+YtT35k6LuuogtCqOX5moaGpECGHH1fue5A24sPqw9DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962934; c=relaxed/simple;
	bh=mxebgZ4SubVvsfIAON/TviTKWRZkHjBs/e1P67vgWBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjB0jGqqAwHcMTbKqGnJTD+nrlm8u007y5P0djPDp9M7AEmiSxmOO9Zu3d+l+8RPPVuxIsnRoTbaAhqFFfQXvyQiScW2eeJIPic2qnkgsczkig9VpyQ19+Kff3m/Pn5BMQKub5gnJ835YfAtKbxu5LfR/fxBvWTqhgy74waQHQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oP2d4Yru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oP2d4Yru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC91C4CEC6;
	Tue, 10 Sep 2024 10:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962933;
	bh=mxebgZ4SubVvsfIAON/TviTKWRZkHjBs/e1P67vgWBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oP2d4YruTe2EVqrkLbCz4wU/UKQWllZ5JR74/wWHf6vl3poZtc0s+s96J3XyPqe9W
	 rXeWFlnBK3CPOL9LH9RWLricwIs2sf0e5sfknAG1Xyj9NiT1nTDtAPYrvb4dtt0uMl
	 fBR4KEn/qevmLgerCjP43McR/YDurYxjtjMfy82E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/192] fs/ntfs3: One more reason to mark inode bad
Date: Tue, 10 Sep 2024 11:31:16 +0200
Message-ID: <20240910092600.134523298@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit a0dde5d7a58b6bf9184ef3d8c6e62275c3645584 ]

In addition to returning an error, mark the node as bad.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 6cce71cc750e..7bfdc91fae1e 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1601,8 +1601,10 @@ int ni_delete_all(struct ntfs_inode *ni)
 		asize = le32_to_cpu(attr->size);
 		roff = le16_to_cpu(attr->nres.run_off);
 
-		if (roff > asize)
+		if (roff > asize) {
+			_ntfs_bad_inode(&ni->vfs_inode);
 			return -EINVAL;
+		}
 
 		/* run==1 means unpack and deallocate. */
 		run_unpack_ex(RUN_DEALLOCATE, sbi, ni->mi.rno, svcn, evcn, svcn,
-- 
2.43.0



