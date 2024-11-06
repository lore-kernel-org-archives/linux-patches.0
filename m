Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EB91FA248;
	Wed,  6 Nov 2024 12:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897403; cv=none; b=ZImDZaTHi72f4UggjWFmbBXwZdHsd8k6bMhCyQ9dCU2RAjBGKuNyKuMZ9nj/Bo8Q3IFA/a0x3wGUqVRt6DNx/7wCMBiMR3k/KECg9NSkauGJuOmXnWVwt82fdOP4KCWdzRGsBkK+OJ+b9LaBFe3oKZjTsM9UMNWE4ev+Oqg4kE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897403; c=relaxed/simple;
	bh=uHm1IOiF7PNHEIg5Xgq3CqLanRcbwSrt0nOoRJg1HV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8Yb8RqgMerMpjflYBIAo3DiiRg7GLJXLdsBEhfuyjGNmU4S4KFsQSPw5zOYc0w1nfSLjtP86SNaDRHie2igPTgRbvEiTPOatSdnNR1oyZiJ+mM7x+3O0+jlhqxD83JfeQ0gvrmhpJ1A3PyqCDvtyTVvcI9vM/hCxK1rVzywbDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SujI1fWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SujI1fWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E3AC4CECD;
	Wed,  6 Nov 2024 12:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897402;
	bh=uHm1IOiF7PNHEIg5Xgq3CqLanRcbwSrt0nOoRJg1HV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SujI1fWt+kNH5qgzNjfdkGRqyXpBSeCIh1Th0eGuiLJM7Mophw+0A1QIeoNenI352
	 l9wZixcEF3EmWCVoM+Hlkc1dc0InOXt+1W23ID/q+dBAO4w+RujCr+pdGIZ7ku05B+
	 fS+3TBis8NR1Ngaw5nxIoU4d4jCD5S+ZW7eYODrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/151] iomap: dont bother unsharing delalloc extents
Date: Wed,  6 Nov 2024 13:03:50 +0100
Message-ID: <20241106120309.991625456@linuxfoundation.org>
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

[ Upstream commit f7a4874d977bf4202ad575031222e78809a36292 ]

If unshare encounters a delalloc reservation in the srcmap, that means
that the file range isn't shared because delalloc reservations cannot be
reflinked.  Therefore, don't try to unshare them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20241002150040.GB21853@frogsfrogsfrogs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 50793801fc7f ("fsdax: dax_unshare_iter needs to copy entire blocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 7db9bb0d15184..eb65953895d24 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1282,7 +1282,7 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 		return length;
 
 	/*
-	 * Don't bother with holes or unwritten extents.
+	 * Don't bother with delalloc reservations, holes or unwritten extents.
 	 *
 	 * Note that we use srcmap directly instead of iomap_iter_srcmap as
 	 * unsharing requires providing a separate source map, and the presence
@@ -1291,6 +1291,7 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 	 * fork for XFS.
 	 */
 	if (iter->srcmap.type == IOMAP_HOLE ||
+	    iter->srcmap.type == IOMAP_DELALLOC ||
 	    iter->srcmap.type == IOMAP_UNWRITTEN)
 		return length;
 
-- 
2.43.0



