Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960C024E019;
	Tue, 29 Apr 2025 16:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945737; cv=none; b=P0P4tKxkQjSAL66ZpIXnber2rxul7391dAbaBvUz86vKvavmQHwldlSPvQ98Hqlr1bzYX7voTCnYi2tjjZhpQPQDKlKeEtGQABkp8u57RkiWojYRqPcy/blBmeq3PXL8QvPidjm6TPsm6qwxWjn2kLHMFSVIMp67pIki/DYZ+uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945737; c=relaxed/simple;
	bh=fiUK1MimHjjjHoJFTMqIxU7didn+AFCUF25mM2B9yUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gN5tr8NTWVkcGvOvDrT8+eD14HRRnNuuDWBRdv9KnqdR0tKOkUjCuy8t1Q8AlfnP4PfLY24tMdOe7UPjfXxiv4+J/b7WZX09783Q5G92nE2MuWzjwMT3AL8wZNpX/rNFuMDxbbuQZgzwtdZgPbSEesaL0XYSrPckxXYzuQIpHmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaPY0uub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaPY0uub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A804C4CEE3;
	Tue, 29 Apr 2025 16:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945737;
	bh=fiUK1MimHjjjHoJFTMqIxU7didn+AFCUF25mM2B9yUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaPY0uubcWb1hYazvuG3PbU8jhS+ICeYa4VkYVH1blv3FZTIsdZbMqxE7jQ4n+qF2
	 8oe28jUaKXyG/5NF2KQLvOnEL3+kMz2n6F3BYOiy+zU1QI+Ghq7nP5d/VH72w8ErJg
	 DrtTJboSt2tzWiReSFKfaHsBzYCCrX0b3T1awtw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 033/311] ceph: Fix incorrect flush end position calculation
Date: Tue, 29 Apr 2025 18:37:50 +0200
Message-ID: <20250429161122.389930886@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit f452a2204614fc10e2c3b85904c4bd300c2789dc ]

In ceph, in fill_fscrypt_truncate(), the end flush position is calculated
by:

                loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SHIFT - 1;

but that's using the block shift not the block size.

Fix this to use the block size instead.

Fixes: 5c64737d2536 ("ceph: add truncate size handling support for fscrypt")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 7dd6c2275085b..e3ab07797c850 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2362,7 +2362,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 
 	/* Try to writeback the dirty pagecaches */
 	if (issued & (CEPH_CAP_FILE_BUFFER)) {
-		loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SHIFT - 1;
+		loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SIZE - 1;
 
 		ret = filemap_write_and_wait_range(inode->i_mapping,
 						   orig_pos, lend);
-- 
2.39.5



