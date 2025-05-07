Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFC11A2390;
	Wed,  7 May 2025 18:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643518; cv=none; b=PQacOIUvQq5lNxgFT0HwYWrjtY876VncWyP4nVkam+FmEKQDjNMaRZqK+JdwUAYR9Uc6c8Xlj2KIXJgNqyfz3YDzBRbZ2zrBQlBfg4lQvjkeHUXe058cZav8NcyCrWW6SMxpD29OE4TMz8QYSBIDUuCgbhIBSmHrBfjq8saJ84Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643518; c=relaxed/simple;
	bh=CUhTA9VIwuoasC9Ja1zyVQYnY8OFh0ZQtnOwTk0TTP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h28IBGgRfE3PiNGU9mc3tjeBc4NSd2nhZ78lma1ZblDhOeCjmMUqA4SmMeEtDoXcwKQysdqDEtfuVjw7zr4ODw2aEf3Hd/vODD4gOFc11uECBK+Zl+KlEY3yd+tFVVuhA3PEvr/NUDkEU1ow4ki+W1ccrdmjr97Q0lRRH6/6yHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuGdQTc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuGdQTc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E94C4CEE2;
	Wed,  7 May 2025 18:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643517;
	bh=CUhTA9VIwuoasC9Ja1zyVQYnY8OFh0ZQtnOwTk0TTP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuGdQTc0snvJRNrK/VCIVS2ChmnwxB2y/VYRiw36pSX/7NzqiyoEqFBNs4vhuFy98
	 W0SZ3gdClPXw7A1S3O6YgMmqMFs3gsBflvPACKPUEo16itu94iZIRJiHVsp3nmQxT9
	 wJG5RzIDK1GsRavJMQ/k2NfNYoXwWxxLDniXIVsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 31/97] xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional
Date: Wed,  7 May 2025 20:39:06 +0200
Message-ID: <20250507183808.245535159@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit fc8d0ba0ff5fe4700fa02008b7751ec6b84b7677 ]

Allow callers to pass a NULLL seq argument if they don't care about
the fork sequence number.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4580,7 +4580,8 @@ xfs_bmapi_convert_delalloc(
 	if (!isnullstartblock(bma.got.br_startblock)) {
 		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
-		*seq = READ_ONCE(ifp->if_seq);
+		if (seq)
+			*seq = READ_ONCE(ifp->if_seq);
 		goto out_trans_cancel;
 	}
 
@@ -4626,7 +4627,8 @@ xfs_bmapi_convert_delalloc(
 	ASSERT(!isnullstartblock(bma.got.br_startblock));
 	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags,
 				xfs_iomap_inode_sequence(ip, flags));
-	*seq = READ_ONCE(ifp->if_seq);
+	if (seq)
+		*seq = READ_ONCE(ifp->if_seq);
 
 	if (whichfork == XFS_COW_FORK)
 		xfs_refcount_alloc_cow_extent(tp, bma.blkno, bma.length);


