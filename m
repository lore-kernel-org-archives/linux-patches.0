Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C004C10EB;
	Thu, 17 Sep 2026 15:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660699; cv=none; b=fkrwPRPukurz64aqQHbYLuVaaFOvZ8w2n9XMliyMNGUsNo8jlkXw/Qx+rltyBIT0RlTeRfHhsZ57uGfNJxlLLlyrjOQ+8vsJoqDWT6Ju85JoxJEX3TeUhi3AhBf4vciwA65QMkYpz34JBLmRzbJ1EUJXZGUU7GJNYV7jWZD0Csw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660699; c=relaxed/simple;
	bh=ACa+FY/xwt2lwi0BbhHRZw2GxWKa1sdrYKHSoHrKwto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVDCI0rd+aWA496zgOuL9V/ZEyiUUG8wWgiNpKhWf+oCoT7hG1e25upiBbNkGDV4eN/awhO0hMGT/Nsbmbmcx43DK8j5OHas1+jDaLG92F2vsLUngpjzOlW4XkFWjSNdYcB1c6eMLZENqtnktsn5UEMPbv/gEJHpVrRIq1GVQHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htHKd6Bn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htHKd6Bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372221F000FF;
	Thu, 17 Sep 2026 15:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660697;
	bh=Dnh+KdETDH847v9WXKrNWYiwdjOGmHoMyX9QW7D5WFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=htHKd6BnTV7wL5cmky6UKygyxKJidRZ1iRsmRLOe+q3LKeiDnGlmla8N6mJ/dHkNw
	 QySgAME/lLI1Sg7FaLxgw1TzOjjZmThVUJ9DH3qRJFxhcwHT0no8IIGCB6Jrn8EJ5Z
	 ix1wqInChwkUCMNtte+CwJRSTYYoZZsxm3MOUccA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 679/733] xfs: cross-reference the rtgroup superblock extent, not block
Date: Thu, 17 Sep 2026 16:16:27 +0100
Message-ID: <20260917151409.682842169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


