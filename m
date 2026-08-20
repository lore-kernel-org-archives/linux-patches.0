Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCE536A37A;
	Thu, 20 Aug 2026 15:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238506; cv=none; b=XGFHYRdvCAxIbSbSzpjzASjrzdu36JMId8Po6ATdediev4xTWcINwoPWB07PGg8gQFfh+KawlQ8M9BFmOflFbVDurTvIqDeznyYt3aEAGSU7+pSJNDZyfEFClNEG1Fm7qznziPjxVSAyfQWoZdv+PVe8ejqK5Xe0GCVDIvFHr2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238506; c=relaxed/simple;
	bh=ybTP800xhC4QpKVddMB+7K7VKIlnu1h2Eh9WbKC4ug8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNYKVkek5xuXlRXvpnPJL6RJNPIBVejEnpINy7Ko2cX8vge3ajlTkeIYleeafji+bZxoE6WetHBZ6l3WQdKObnxc499cJsFqPGA+xBGgH5+rg2FZpPyUQBJvdtXTAryJHoHwinF1x2jwfwXogQNBUe7IDmACYG1w4LDi2HCqdt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wChN1YK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wChN1YK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7BE1F000E9;
	Thu, 20 Aug 2026 15:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238505;
	bh=6R02FLETnD+fZhCfZ0XKtK+5blut2NphoBBf2lx+z3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wChN1YK2IPwqrcpUpCGo0RhLqEXGfI+DVEA/ju3pcQRcK3g3V78NR+W2t88SG3YNh
	 DpUBuRB8V9Qo/KFz++N1tOgWFN+607CggVva3B/WcbAkRkbX1/WZru/tpnjNuEM2yg
	 IrZCM3+5k/SmjdFl5FilP1QwJX4kXpZgzhgXozVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 144/228] xfs: dont return EFSCORRUPTED when scrubbing corrupt parent pointers
Date: Thu, 20 Aug 2026 16:54:46 +0200
Message-ID: <20260820145248.979555944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


