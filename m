Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B875F4D17AB;
	Thu, 17 Sep 2026 18:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671208; cv=none; b=g78CBLWoHYJiV1SYOQE0HJOLh81HWxn4QTSuYRwfzCxOMO+VydCscrAyb0fmRdVS4ldsl+MEL+lQpGYeiF8TfwKuK64cYzrJVFdfUAwlNnq5qH/YicRgbaFH4HFty8Cywi640CkNx+MWG8soQqCxPVkBOV/T3SYlQteEWycjs88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671208; c=relaxed/simple;
	bh=EJoLVjPyZ0ZRkHha6DzBGQYJWRbnMuUMDPBMWEz38CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcKKDFNsdPd1ocUtcJ1vnwDAJ+S15DZ1ltKIPbOVM44xFmpD4rW3y4XePfmdqFAVxX7xo9azGVa+DoukBiLz22VAbc3UzEG0NCg93tDEV7LhPMkHfZXViOvHdM2eqtfVdlrHeuw/jADX6nhsVhVHgpaMldDSpdzSodu14sRGKRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6n6lnK8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6n6lnK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC781F000FF;
	Thu, 17 Sep 2026 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671207;
	bh=nB1O6XaR/iWR0ddw5KynnhZXldUasQenjYFhUowH8pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6n6lnK8152EC94Tp4uVHXZ6m7FliwEEGGvqNaDXKIKzMLDsMZQLjap3uL8b4FQz4
	 ZGaiZBh19hOdRvT6sz8L7I7AuPcD1SWVVIy5TwUv1G/WWkJ1K6QPZQxY32xqmB4faw
	 GFiiSB5ltWOOgDB5Xw9V6ylixQaE3iEpUy4xFv28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0901/1102] xfs: reset parent pointer args before each dir tree unlink repair
Date: Thu, 17 Sep 2026 16:14:04 +0100
Message-ID: <20260917151603.220835712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 69e10c2b4a51b4ff3c88a70e90f5180ad58c758f upstream.

LOLLM noticed that xfs_parent_removename only partially initializes the
passed-in parent pointer arguments object.  In the directory tree repair
code, we could decide to remove multiple links to a file, so we don't
want state from one call to bleed into the next one.  Zero the whole
thing explicitly.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index 8acd55b8c769..1d1eafcf6eb5 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -479,6 +479,7 @@ xrep_dirtree_unlink(
 	}
 
 	if (xfs_has_parent(sc->mp)) {
+		memset(&dl->ppargs, 0, sizeof(dl->ppargs));
 		error = xfs_parent_removename(sc->tp, &dl->ppargs, dp,
 				&dl->xname, sc->ip);
 		if (error)
-- 
2.55.0



