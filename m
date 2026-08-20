Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0B437CD28;
	Thu, 20 Aug 2026 15:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238984; cv=none; b=qyiENYXyVSDdOKpsenBo9d6miHjLpZ6LgmDGQRheYLm5bOBXc4M6VTEocfHYprP6qudQoM0lFJZ0BWKL9YM5hux49MUzvlCNEno5G0QPCze4wBNwfhSrF7PkT+00flsuj3Mmp5mju8r2AQJ4xgWICRd4ZxyBqc1kB96qQVxBWcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238984; c=relaxed/simple;
	bh=TNCY5ZEIB07VNgtwCAVm7xaJxSf1TqOBMGkYr2+7Mbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhCIKfvndgsJmJT5E58Vu9122gtZy9iUuj5TyOquwQ5vBr17AQOgq4h/4RbGfIeZm+uj91ghs4rqK/2OCmivBZxRlbtJZqLoO2CWArBMlI1QtuyVEy9q00O2YPOBlnuJBARhaYgF0qsAIjflrpt5oxdw2xGhlp6Yrri8OogpvPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pmV35zWR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pmV35zWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC491F000E9;
	Thu, 20 Aug 2026 15:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238983;
	bh=2JCkjbIe0rPXCS/AYfTCClecWOVuqMSPELA8AXAfHX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pmV35zWRks5apk6le+ZKBaGvADGywjttas3kgDf4rRO4mEMtfcGpkoXwfBdWlwpN/
	 bMHS/843FVjBcl45AcpalHAmbThzwUVKzzEESqAlLPZjO3JA+XoJMvKfJfapMYZhQ7
	 nSikJNuL7G7O/COItU/XDTLfpRobyWBCa5eAvtrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 108/217] xfs: check cowextsize in xrep_inode_cowextsize
Date: Thu, 20 Aug 2026 16:54:36 +0200
Message-ID: <20260820145240.989579512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

commit 270ffcd9b0a46254fbf3079d0e3341db7d7ec0e6 upstream.

LOLLM points out that the function that corrects cowextsize should check
i_cowextsize, not i_extsize.

Cc: stable@vger.kernel.org # v6.14
Fixes: a9600db96f74af ("xfs: detect and repair misaligned rtinherit directory cowextsize hints")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1956,7 +1956,7 @@ xrep_inode_cowextsize(
 	/* Fix misaligned CoW extent size hints on a directory. */
 	if ((sc->ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (sc->ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
-	    sc->ip->i_extsize % sc->mp->m_sb.sb_rextsize > 0) {
+	    xfs_extlen_to_rtxmod(sc->mp, sc->ip->i_cowextsize) > 0) {
 		sc->ip->i_cowextsize = 0;
 		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
 	}


