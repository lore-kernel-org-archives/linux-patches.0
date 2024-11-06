Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43171F76AD;
	Wed,  6 Nov 2024 12:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897026; cv=none; b=qU3EtTY0CesIc2BAKn4/cLmhH4jO2PwsK48AT3qv34UnOqshuNBtpaIwLgfxRSC+LT1uk1ZrMGyPBac6cwjzfeVegKftSd6POraINtifUc6rr5csYNRu2FhtErW734DItZ9NmSLgEHOkhA6v5fd6iHW0nIzZlc/wu+cneyyGDig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897026; c=relaxed/simple;
	bh=RBjkcHo4eVQKdjMmMeENmZGfAxBtCnqD/NrU2PRUzv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smycdeniHfdbIb2fQXwgGMx3rEHWckRJZr9lIaBzszv4B/doBrgPcJ7w+q8DqBif4nhvxEDCkE/ijbv+AJb7saUYiiY9eycdRLI2D7wgMD1PqYXaF/QKWnRcKnJGsZEqeZlW8hB5gwBnxO50RvS+DvcdQeN4LW02i7fZ7Gy1HBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAV7uoWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAV7uoWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB394C4CECD;
	Wed,  6 Nov 2024 12:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897026;
	bh=RBjkcHo4eVQKdjMmMeENmZGfAxBtCnqD/NrU2PRUzv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAV7uoWjIyUWpWZOfr3mX3fKeS7hVMYRV4FflZtwTzsU6V6rkz+0jXMhlFWsHgBd3
	 EbpbfU+oke8jC4OISyLMU4D6OMW+2iqPPnWdqDDgldpUYdP97UL/zqLRQaLH7npnGh
	 DPjHkCQ9ruM7VML735fpqIEjbafKwU/2uyhZjI94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruansy.fnst@fujitsu.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/126] fsdax: remove zeroing code from dax_unshare_iter
Date: Wed,  6 Nov 2024 13:04:03 +0100
Message-ID: <20241106120307.246805589@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

[ Upstream commit 95472274b6fed8f2d30fbdda304e12174b3d4099 ]

Remove the code in dax_unshare_iter that zeroes the destination memory
because it's not necessary.

If srcmap is unwritten, we don't have to do anything because that
unwritten extent came from the regular file mapping, and unwritten
extents cannot be shared.  The same applies to holes.

Furthermore, zeroing to unshare a mapping is just plain wrong because
unsharing means copy on write, and we should be copying data.

This is effectively a revert of commit 13dd4e04625f ("fsdax: unshare:
zero destination if srcmap is HOLE or UNWRITTEN")

Cc: ruansy.fnst@fujitsu.com
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/172796813311.1131942.16033376284752798632.stgit@frogsfrogsfrogs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 50793801fc7f ("fsdax: dax_unshare_iter needs to copy entire blocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 74f9a14565f59..fa5a82b27c2f6 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1239,14 +1239,6 @@ static s64 dax_unshare_iter(struct iomap_iter *iter)
 	if (ret < 0)
 		goto out_unlock;
 
-	/* zero the distance if srcmap is HOLE or UNWRITTEN */
-	if (srcmap->flags & IOMAP_F_SHARED || srcmap->type == IOMAP_UNWRITTEN) {
-		memset(daddr, 0, length);
-		dax_flush(iomap->dax_dev, daddr, length);
-		ret = length;
-		goto out_unlock;
-	}
-
 	ret = dax_iomap_direct_access(srcmap, pos, length, &saddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
-- 
2.43.0



