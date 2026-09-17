Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AB14E1C97;
	Thu, 17 Sep 2026 18:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671218; cv=none; b=ffQG38eCQ/XcSVp178YbmwLZ0NqZzgtexNIgaDOGk2EXp4Ot2F79/sxIjhV/OCTMg8kB1+z0ArqYbRKf/9M6uWaMRkExm/JyBk5QqBMmTWZmgaIwrcuFe7Fw8ZO9dFCBVKmcXfT5Xk2miqsUbqSGsWYjg34Qz6g7aRlTtLYcjwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671218; c=relaxed/simple;
	bh=RxflrMXbDDq39kwb7+JLdOhbhUO4ADFZ8Hacj1QYarg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogj1djWk818/iWh885caZGPnUdkY03x9ziFFPOZ/E6svUQ9068UxXfvTPyOEVxnzao/8kdyZG9/Du+mwmzfPipW6AV5bXoJ0jt8aGrEQzZeG+mBtM+C3a7GDyIzUzm9uKo6TtHjpYY7j166vzqcAzgonNZPFpFaokAnNvGQ7+G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlYHYswK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlYHYswK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151B71F000FF;
	Thu, 17 Sep 2026 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671216;
	bh=oEdGQOudntlPzHcYInSrdaGTlKKuL8krZhOdTxYjjsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QlYHYswKiLQQ5eWBGZmzJHLTezeuJN2BgM13ADTf+7FB5orwFsuHZMl0HLAdN9x4K
	 o8mlJoE2wiLU+VdlySjC0ZL+NTlakzZtZE6M3uswHG+fiR8NTPwSYPSsqHe7Xkb5Ff
	 zC3/ErhWndkBIUtp4WoptnFP9Aw7beHP18yEOMXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0904/1102] xfs: log the tempip after we convert it to extents format
Date: Thu, 17 Sep 2026 16:14:07 +0100
Message-ID: <20260917151603.300534536@linuxfoundation.org>
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

commit ed799148e0d63ef41ab60ce98963a1dc423090d3 upstream.

LOLLM points out that xrep_symlink_swap_prep converts sc->tempip to an
extents format file prior to the atomic swap, but incorrectly logs
sc->ip immediately afterwards.  Fix that, and the other problem that
we're supposed to tell xfs_trans_log_inode what to log and don't.

Cc: stable@vger.kernel.org # v6.10
Fixes: 2651923d8d8db0 ("xfs: online repair of symbolic links")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/symlink_repair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index 91c86ea0e0f1..181961364233 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -291,7 +291,7 @@ xrep_symlink_swap_prep(
 		if (error)
 			return error;
 
-		xfs_trans_log_inode(sc->tp, sc->ip, 0);
+		xfs_trans_log_inode(sc->tp, sc->tempip, logflags);
 
 		error = xfs_defer_finish(&sc->tp);
 		if (error)
-- 
2.55.0



