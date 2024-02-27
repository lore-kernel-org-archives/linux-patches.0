Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677F054FA5;
	Tue, 27 Feb 2024 13:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040705; cv=none; b=G11WE1YPF+Pzs3ec5VQXBn0ZnCufZuDgbDCSBf7pSsuFveU7UPp6PVOgiHdjpIsL9IYvDsCebnVKl2yKEVDtNK3MOr9eyAQr6xBUCRSUQUZoSlmvMVzGzoH16ks3iWQqyn1QPRR5cPcm+0UwUUHGnN3l3ud0AOe0sANYP+pAwLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040705; c=relaxed/simple;
	bh=mWrU7HBx1t51AkMqP4drYEzMQSLL2L4mNKmIshkxaAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJ7VD9Xv13vtpky6oQ9RyaqxRgVMhUS3LXY00HWVvjY0RZtkGWLjrwsEOyFM4K4fiYFLCjUrdekqjqHYOClHhBxsinwgFBKk+JEsFgHIGPFhk0N+rhXhGTU7diysBwPB1VfIhCEsdMds3Bl7JZDW0yOO59UEhr5cb1hLKiUtNe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxibAdzH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxibAdzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA96AC43394;
	Tue, 27 Feb 2024 13:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040705;
	bh=mWrU7HBx1t51AkMqP4drYEzMQSLL2L4mNKmIshkxaAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxibAdzH5bIwjWbWMFHXJF9PaxQCbLa2pwpWPFG/FRIu3ofVUcvBtY2oGRHWJfZ4z
	 p6LbF4CfypTXiwNT4Fe0JUJ9MhdIOS2Zc8iOsmOsvDgYgBE/bgNe7bpFAUrGU+RArq
	 hPlghdPvlTc9mcJsoIk6DGAXMdTNL5WAK+hhP7/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 080/334] fs/ntfs3: Print warning while fixing hard links count
Date: Tue, 27 Feb 2024 14:18:58 +0100
Message-ID: <20240227131633.120192038@linuxfoundation.org>
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

[ Upstream commit 85ba2a75faee759809a7e43b4c103ac59bac1026 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 5e3d713749185..fa6c7965473c8 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -412,7 +412,6 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 		goto out;
 
 	if (!is_match && name) {
-		/* Reuse rec as buffer for ascii name. */
 		err = -ENOENT;
 		goto out;
 	}
@@ -427,6 +426,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
 	if (names != le16_to_cpu(rec->hard_links)) {
 		/* Correct minor error on the fly. Do not mark inode as dirty. */
+		ntfs_inode_warn(inode, "Correct links count -> %u.", names);
 		rec->hard_links = cpu_to_le16(names);
 		ni->mi.dirty = true;
 	}
-- 
2.43.0



