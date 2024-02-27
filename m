Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503AD16423;
	Tue, 27 Feb 2024 14:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042608; cv=none; b=USCXBDXlGXAj8iS0d9k+Uh5HTO365EKLbrjKv7JXYhpBkM9Weke+xinl7Qc4YZ1dRag4GzseiluQxSsZkGjXTmhgPcvTkQxNmaIr30ZXU6xOYKiSnvyBfMQfIJa0EhI8QJvnd8SL5vIRLRErClt4xaPhGnFk54+kX0RT6UTH0zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042608; c=relaxed/simple;
	bh=89eY/eMTcSjPXb19CzgKzlKjo5emMa9FoaIACHd1z90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z973yDhEVDXKNPuoRJZHfHBFVxsNck3YV5tUwb8eTltGrEizqVCK2lIt3aUHPeMC6T+mIGKxVjdYSr/2lUp835Y11zFs1sHoNNGGLjTz7DwL/aeDWPsmSmGokHAUgyJuqH7jkQTnEGPHa74EaQAzE3KgOKE7NibAWCKVFmVZxzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YplAn0xW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YplAn0xW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8329C433C7;
	Tue, 27 Feb 2024 14:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042608;
	bh=89eY/eMTcSjPXb19CzgKzlKjo5emMa9FoaIACHd1z90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YplAn0xWxSqBjj5jMxGRNwejxyuSIYfCSoMvA+AEm/x57JmCdX8RsRYDrL9flxNrC
	 acXpub18dJ5x8nBANdbkleAhaGmCYiNBnTao7u/Pqw7Y9EH0up4v6I2TWDspYB6kv3
	 Ep8LIUS58smZ5lTL+QDHlbp7C8FLSW/HpaWJoLmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/245] fs/ntfs3: Print warning while fixing hard links count
Date: Tue, 27 Feb 2024 14:24:03 +0100
Message-ID: <20240227131616.912442210@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 85ba2a75faee759809a7e43b4c103ac59bac1026 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 176b04a5d1adb..0ff673bb4b2be 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -402,7 +402,6 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 		goto out;
 
 	if (!is_match && name) {
-		/* Reuse rec as buffer for ascii name. */
 		err = -ENOENT;
 		goto out;
 	}
@@ -417,6 +416,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 
 	if (names != le16_to_cpu(rec->hard_links)) {
 		/* Correct minor error on the fly. Do not mark inode as dirty. */
+		ntfs_inode_warn(inode, "Correct links count -> %u.", names);
 		rec->hard_links = cpu_to_le16(names);
 		ni->mi.dirty = true;
 	}
-- 
2.43.0



