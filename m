Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE651CC89D;
	Wed,  6 Nov 2024 12:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897129; cv=none; b=X9mJqmXU2Pu5l/H9yT10mdWKCj7r933rajcK0qA22c539A1zq2iZc2u9siuljHG5cFKb2SNmBJLHqrymIC9PeC678B1lU6FIUmY5O84iXmOLBv7bfcQzD9+B9mdOoPbFmcJ6PLyTyrGFnff2w5uzmt15fMBwqTC+cpoS9H83gsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897129; c=relaxed/simple;
	bh=cTZG8mE375rNCweyWDrxsPQCscczkL6mtDNo78KgE2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUvFhl3TeisgHPEoGPZ6naZXplTGaXBvijp8oaL4W8crMSU/QwN+M0uoibia2hXiAkAhHV9UsVXZYz5cTuTWzEnkYRNWPC/ktvB9Phhc+12BkpBmf6Fn5ROYWFQg1/V3KLvoyVTGYYMXcuoES3Gb4InS2oovKZnGZJe6FFQ3Fqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgclvZv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgclvZv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E69C4CED5;
	Wed,  6 Nov 2024 12:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897129;
	bh=cTZG8mE375rNCweyWDrxsPQCscczkL6mtDNo78KgE2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NgclvZv/EioJThmKauwZGxhTr+MmqfRq06cbET3euHSR5vf9RC7Rc4N/h1So3Z1ji
	 V6bo0L0So1BxbQBnk4W2IW2t2j2QP4Cm+WxyJUAioF+S2VTAwFWe86mUc2clxKyX08
	 CTmrkauIoQ5yPC8y6tzZtCFT9JDVhYfrNJPu1uoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/126] iomap: dont bother unsharing delalloc extents
Date: Wed,  6 Nov 2024 13:04:01 +0100
Message-ID: <20241106120307.195118777@linuxfoundation.org>
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
index 527d3bcfc69a7..b1af9001e6db0 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1096,7 +1096,7 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 		return length;
 
 	/*
-	 * Don't bother with holes or unwritten extents.
+	 * Don't bother with delalloc reservations, holes or unwritten extents.
 	 *
 	 * Note that we use srcmap directly instead of iomap_iter_srcmap as
 	 * unsharing requires providing a separate source map, and the presence
@@ -1105,6 +1105,7 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 	 * fork for XFS.
 	 */
 	if (iter->srcmap.type == IOMAP_HOLE ||
+	    iter->srcmap.type == IOMAP_DELALLOC ||
 	    iter->srcmap.type == IOMAP_UNWRITTEN)
 		return length;
 
-- 
2.43.0



