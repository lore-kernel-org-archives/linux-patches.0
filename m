Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FDD13A885;
	Tue, 27 Feb 2024 13:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041799; cv=none; b=mU5K/+yy1ORTinoaTx1XliB8kGFzQSdA57cr4XgvucchHC9g+Ad7+0EcQo7B0ztfUdwAcKKaZeqKmqhnnUSHuziq8sNVciflLSNZVM6O9tGYsxPWZV16T7v1mmsDNkjspPAyRVwlGmir8UiWHR1pAY/uBM/qWZaTYcJbzZVQmAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041799; c=relaxed/simple;
	bh=GrupvDvKRxwrLZcC8VJRf79qYiHigvm5UE3N6l6nFeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=onbIsJzqCrfjXXtQU/DpW4uUvjEOzn5h9+r72i0RsgIz08mFPstkAPxcnpJLAPDveY5ygStaxgVpvV6A9sXXWocqoaOxpAKCdqVR85wczFE2XNR3MgpLXfFlyONwCZhhPLHyTc5npf/A6j61QbwXVLJyS48qhsyq9ifqs/dMRUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ut/IQpvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ut/IQpvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D569AC433F1;
	Tue, 27 Feb 2024 13:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041799;
	bh=GrupvDvKRxwrLZcC8VJRf79qYiHigvm5UE3N6l6nFeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ut/IQpvfVn8+wat4emOyc5Dioy0JKQiv7dX5bindkMFuQgvkp4QRGXKCXnUEpKGOv
	 E/pEjaZveOb+Ys9mBhdG7ee3QhJ+X00y+BNK814RWl46qFoV8xwkQWyTxtM0P65nVb
	 O4LZ5jR/3RMbv+C48m4Ls0wsR1TvywUmcc4IDVK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/299] fs/ntfs3: Print warning while fixing hard links count
Date: Tue, 27 Feb 2024 14:23:05 +0100
Message-ID: <20240227131628.320640447@linuxfoundation.org>
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

[ Upstream commit 85ba2a75faee759809a7e43b4c103ac59bac1026 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index d6d021e19aaa2..fb0466c115040 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -410,7 +410,6 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 		goto out;
 
 	if (!is_match && name) {
-		/* Reuse rec as buffer for ascii name. */
 		err = -ENOENT;
 		goto out;
 	}
@@ -425,6 +424,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
 	if (names != le16_to_cpu(rec->hard_links)) {
 		/* Correct minor error on the fly. Do not mark inode as dirty. */
+		ntfs_inode_warn(inode, "Correct links count -> %u.", names);
 		rec->hard_links = cpu_to_le16(names);
 		ni->mi.dirty = true;
 	}
-- 
2.43.0



