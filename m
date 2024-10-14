Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8112519E802;
	Mon, 14 Oct 2024 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918717; cv=none; b=mAslwM9Mu1dY0Q1YeYbFWRDNmSRXXiL5p0cHiLmo3rF4zGg6mSZ8XiN6cgRff2C9/3snwaNCxss5yvmp7d6GPDqzObKO8nF49O1fGR9eahjM053QZ6q+RWCRXwMVpID+6ByQGUVhcvI0ID9M/AsiNWe9DVtPeICGs1pw+RsO3UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918717; c=relaxed/simple;
	bh=0j5etSD2r/L0lMUsBScBrpj1H7ldCyNatnoEwNl3JZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLb4GvdZJQN8ZxBYWVSsdozvIP+RA4dQal+jFYeTHH1gI229kXZSRVIa5+MMEcpCJwip3qnp4LTtFhimroSUfEF+J+pcYjzqXlAAu+MKBGTKdEYCz9UER8Nw5OvfiWV8I2RPQbVO1zG2H4Gewz/aR7mq3ui5tA7zBV1u0ePvz8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F75BWVBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F75BWVBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE903C4CEC3;
	Mon, 14 Oct 2024 15:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918717;
	bh=0j5etSD2r/L0lMUsBScBrpj1H7ldCyNatnoEwNl3JZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F75BWVBLnaQIfuZgMnaeCXWaS+WCIdDE0SnXXonjPVlcPCTKP9Z3Lifx4kOmhWQTj
	 06Vcgb3Ma1x/iIxEpWTKAslsA9kycrw7x5Z2Pl8le+DHCTLWV/LMUND0KdaaKEzrGe
	 lpbEGeqm9GOJatrwMuyJM+1FHAUvAWmxkL70p0zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 403/798] iomap: constrain the file range passed to iomap_file_unshare
Date: Mon, 14 Oct 2024 16:15:57 +0200
Message-ID: <20241014141233.779468652@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit a311a08a4237241fb5b9d219d3e33346de6e83e0 ]

File contents can only be shared (i.e. reflinked) below EOF, so it makes
no sense to try to unshare ranges beyond EOF.  Constrain the file range
parameters here so that we don't have to do that in the callers.

Fixes: 5f4e5752a8a3 ("fs: add iomap_file_dirty")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20241002150213.GC21853@frogsfrogsfrogs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c               | 6 +++++-
 fs/iomap/buffered-io.c | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 626745bc1ad86..7ecad1a28a894 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1262,11 +1262,15 @@ int dax_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 	struct iomap_iter iter = {
 		.inode		= inode,
 		.pos		= pos,
-		.len		= len,
 		.flags		= IOMAP_WRITE | IOMAP_UNSHARE | IOMAP_DAX,
 	};
+	loff_t size = i_size_read(inode);
 	int ret;
 
+	if (pos < 0 || pos >= size)
+		return 0;
+
+	iter.len = min(len, size - pos);
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.processed = dax_unshare_iter(&iter);
 	return ret;
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0f7dabc6c764e..98617f00101d6 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1126,11 +1126,15 @@ iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 	struct iomap_iter iter = {
 		.inode		= inode,
 		.pos		= pos,
-		.len		= len,
 		.flags		= IOMAP_WRITE | IOMAP_UNSHARE,
 	};
+	loff_t size = i_size_read(inode);
 	int ret;
 
+	if (pos < 0 || pos >= size)
+		return 0;
+
+	iter.len = min(len, size - pos);
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.processed = iomap_unshare_iter(&iter);
 	return ret;
-- 
2.43.0



