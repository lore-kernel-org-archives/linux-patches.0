Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511B71EF08F;
	Wed,  6 Nov 2024 12:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897409; cv=none; b=KfV8AiPhyJw2CPDT6n+b/1YvpkY3//4zZDIqqA9Rj7W4W7gpDOFLdPSqnVICXLO70YmmPYYcdK2/EezVHoM+H7ozYWUaDp1Tef+2eu4U+LMZi6dwqbF5ymwhknhDu+bVfGzHRIxxbqgfS9XFQV2SaPUokYG3enz2CET4vk7mGjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897409; c=relaxed/simple;
	bh=6q4xHU19O24OgAOlrHAnFOFQ79j1mVfio58OYumR/sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlvYZcKMFTO5JgGV12022M37mxox2Tbc8OnXcxe8FZLEyWaP9xYriCO/xvrlpl4sTQQkUWDqgtETFXtGJ0l+qxczqDYBNHXgEopDQgN37ZeBNdqCnc2sMUDp0G8vb7zEO54jqJu+qgn5tTBaxqldx0nE0xXUUMC+dip/dYRIjkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSfgoHPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSfgoHPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A030C4CECD;
	Wed,  6 Nov 2024 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897408;
	bh=6q4xHU19O24OgAOlrHAnFOFQ79j1mVfio58OYumR/sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSfgoHPsB1geC6ytSD0oX44CkHqWDGtFykiAnQ3p9ayDaGj1EVK9YJeRVA+/hnJ35
	 luwiA2sgcTKHciv/Axcw9KuLAutKei6brQl854fq0gr9SrxSfg0KcHhZN6DxFgsDPb
	 525Ow0nekCQ0dcv8jRhBCaBoL9we7NRJZkJs5dqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruansy.fnst@fujitsu.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/151] fsdax: remove zeroing code from dax_unshare_iter
Date: Wed,  6 Nov 2024 13:03:52 +0100
Message-ID: <20241106120310.044931747@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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
index 2f7f5e2d167dd..5e7fc5017570d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1276,14 +1276,6 @@ static s64 dax_unshare_iter(struct iomap_iter *iter)
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



