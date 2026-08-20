Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240143806D8;
	Thu, 20 Aug 2026 15:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239130; cv=none; b=cO18fJ3QbhCYq7qpnU14vPXFjwIcsKByod+EGwT2fMNvntBeWIzj8Sn4ZH6Qr/y1sm3YxRCT1TMHQEOpGwPiebCFhQyS+ydRi8KSwcOvvQl7fYPfDDEMdhrJSdKyLzBKhKXeOIPkc+eCgrXXMs22w8y95u+mdpHyvBuSNfrQad0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239130; c=relaxed/simple;
	bh=m/FJRelM62Z2UAJUjwBVw2zK00R01+Om3Vu9G4SpbrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTA/fvHeVOclECLqsGBQMZilVqsBhAzfU0d2ggk6lPLXBGuO/n2ihFLFYvXRl0VD2gh/wEVPN03A2jwnxCsgg9aHodxVXbPVxTd9/eDNAxkcDQ1JkO8/xKRIJidYivI2o4ZGv15HDs7MxMyVod/rOPNvQiZtxOzvHSKneUgveTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oT2VlVcP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oT2VlVcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628601F00A3A;
	Thu, 20 Aug 2026 15:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239126;
	bh=1KazMG10dlSO0xxKg2jnznuNkAQrcK87qhS+1Td/OHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oT2VlVcPkWWrPZ29f1eegzi5OzXAcYXnCmcAd9fPtegKxjh10fcsmGYvlH4jI9zk4
	 jq+h0n0R5wD4Qid+N/dhvtH0x3DRI0l4p4hy1Yniqiky7TZxirPgzXHGmYGHhIgswe
	 mdLVqf2LRzFvEZsEtbjigxiP3/WfbIeAsepELr3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 122/217] xfs: dont return EFSCORRUPTED when scrubbing corrupt parent pointers
Date: Thu, 20 Aug 2026 16:54:50 +0200
Message-ID: <20260820145241.404882400@linuxfoundation.org>
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

commit 8af9cd79cdf6ee96ec610d707db22244fa21eb40 upstream.

LOLLM noticed that scrub sets the CORRUPT flag when xfs_parent_from_attr
thinks it's been given a corrupt parent pointer.  This eliminates the
potential to repair the filesystem because that error code is bubbled up
the call stack.  Fix this by collapsing them all to ECANCELED in
xchk_parent_pptr, which doesn't have that trait.

Cc: stable@vger.kernel.org # v6.10
Fixes: 0d29a20fbdba89 ("xfs: scrub parent pointers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/parent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -486,7 +486,7 @@ xchk_parent_scan_attr(
 			valuelen, &parent_ino, NULL);
 	if (error) {
 		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
-		return error;
+		return -ECANCELED;
 	}
 
 	/* No self-referential parent pointers. */


