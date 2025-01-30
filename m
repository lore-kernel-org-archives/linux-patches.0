Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1AB1BD9D3;
	Thu, 30 Jan 2025 14:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247370; cv=none; b=P5E7Htx1queBkqdpEFOxSigzkvzGJ6SH4pbT/gNLnohF+xM7gV7gRqmxCVPJAhkE5Qa8xqNhknExw8xG/0lQMS1gU8Pj+lcKf56JGf40ZByPt7WFcDQu0esPbZB2Tmi5alk1wQ8wGp4orT+60UuUXkgFDWOQxG3xo3/iNZg3/R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247370; c=relaxed/simple;
	bh=cneMccY0a2cLwh7L7UmisHWi9QAsIImji/KzIRJKoKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7HRtMcQL+6aulUBJv98l31Js5d5d8DhJ0+1OMfCcVkf6vp1tqYT3nckNrzcdIFbEIOThUkEFoINZ2AzBmMBKprRovXhNFFobYOt6wIY3aNx3pUlFXqR7paQXa1yK79wDglXFao9Ldq/ERWXz7ZLCvdquNPQjTtMlAnmLD7rK6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtH0PeVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtH0PeVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC3FC4CEE5;
	Thu, 30 Jan 2025 14:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247370;
	bh=cneMccY0a2cLwh7L7UmisHWi9QAsIImji/KzIRJKoKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AtH0PeVxkcQ8ci9BvhcSid3TzggP29pSTeYC7L3Wx5yELIizQlGR0pp+UjX0cko8z
	 D/RZt4u7Y0tQrAlF2X01HWOGiepLn0pCyWoxDwcV8HeW22wicP0K+ZeHyulRWqnCYI
	 qdB+7gWYpTAmhIS/BXbI89vIzixylvxMP6Q30Qyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 16/49] xfs: fix units conversion error in xfs_bmap_del_extent_delay
Date: Thu, 30 Jan 2025 15:01:52 +0100
Message-ID: <20250130140134.492596228@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit ddd98076d5c075c8a6c49d9e6e8ee12844137f23 ]

The unit conversions in this function do not make sense.  First we
convert a block count to bytes, then divide that bytes value by
rextsize, which is in blocks, to get an rt extent count.  You can't
divide bytes by blocks to get a (possibly multiblock) extent value.

Fortunately nobody uses delalloc on the rt volume so this hasn't
mattered.

Fixes: fa5c836ca8eb5 ("xfs: refactor xfs_bunmapi_cow")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4807,7 +4807,7 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got_endoff >= del_endoff);
 
 	if (isrt) {
-		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
+		uint64_t	rtexts = del->br_blockcount;
 
 		do_div(rtexts, mp->m_sb.sb_rextsize);
 		xfs_mod_frextents(mp, rtexts);


