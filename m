Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C5D4F3EA3;
	Thu, 17 Sep 2026 17:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666688; cv=none; b=jMHS+KqwBL2ywo7UAxnY5JEa5JIlnhkb3fH+Zq2xu9Jnn5e0y3iqoZ8aNp0fIXeFIvGng0KKawJVnQ7pZzg6CKDFu6rIZhmmfCfWfJL0rZLJusjYdiAIPry5U9ON4b4UdoPaFkl2Xxkl4zEHAnaIwB8enGNO/d87AacVqRVsiq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666688; c=relaxed/simple;
	bh=ngzVTWM9WBoNre1MnHVS6ouuD7kw27OM/rvjAhGCCps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cf6m8OXqbdyIHA6RJzHGDLbsWGR7EraXecv1QMUeDdMZ52+ddEXeEJB2lLh3qYFVRLdbo82MKiyreohlSGT61ohZuOtd8Ox4+GCeOMsWvTktBNKsgUK1JHi0/h7dRaqdRvi6lc4txOgYa6oa958ecEDxSFIljcUz2G+mSW8+Pw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2H+Rdd/p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2H+Rdd/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604DA1F000FF;
	Thu, 17 Sep 2026 17:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666686;
	bh=ere9Lm29WXIhtnBv4tszx20k1ghwD7mtaynHO6MDuPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2H+Rdd/pyX4nuoXBiaHVM8cWtZ7RgeYI3wsnqr5tRuv7dptOQOM0E6B9Axpu+Xg7v
	 d5b4xS3BRzge2eTE3JZH4LbWqWcNd8B8/xPekr7glzsPLjF1SdTbSGIs2lB1pw5vP3
	 T1cKi6p15o9z7biEg0IwrLcleuTDsCt9GAJEqKcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1121/1250] xfs: cross-reference the rtgroup superblock extent, not block
Date: Thu, 17 Sep 2026 16:15:16 +0100
Message-ID: <20260917151622.615327242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 79ab1af2034b2ad10c5f18910937b938d2ad2219 upstream.

LOLLM noticed that when libxfs creates a realtime superblock, it will
create an rtrmapbt record covering the entire rtextent in which the
superblock lives.  However, the cross-referencing checks only look for
the first block, which means that we can miss a corrupt rtrmap record.
That will get picked up by the rtrmap scrubber, but we should make the
rgsuper scrubber more robust anyway.

Cc: stable@vger.kernel.org # v6.13
Fixes: 3f1bdf50ab1b9c ("xfs: scrub the realtime group superblock")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rgsuper.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -36,8 +36,10 @@ xchk_rgsuperblock_xref(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
-	xchk_xref_is_used_rt_space(sc, xfs_rgbno_to_rtb(sc->sr.rtg, 0), 1);
-	xchk_xref_is_only_rt_owned_by(sc, 0, 1, &XFS_RMAP_OINFO_FS);
+	xchk_xref_is_used_rt_space(sc, xfs_rgbno_to_rtb(sc->sr.rtg, 0),
+			sc->mp->m_sb.sb_rextsize);
+	xchk_xref_is_only_rt_owned_by(sc, 0, sc->mp->m_sb.sb_rextsize,
+			&XFS_RMAP_OINFO_FS);
 }
 
 int


