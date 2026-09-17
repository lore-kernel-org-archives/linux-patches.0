Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53974E9C23;
	Thu, 17 Sep 2026 17:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666632; cv=none; b=hj4eDR5Ie/ggqyruBJU3mYQIHt2fPDr0WG9RqYggGdLs8Hxv3NLg9v6K9qq6OdPrWl4bxhShaSRjJpy6U2FnnIr1r2njPerCfbL6QBZN9ullZ34idnEStzkdW3c6GqyYAPIDSJoY4orr2pXzE2qZg40vhU6JgY6q5JPz5n7jwRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666632; c=relaxed/simple;
	bh=ykiZsv2bXLusM9s0haZSzufveut7mQvhAvT2+GZhcPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZ+b9i9EqkXX5Dw0fdJ1LcVZNnsqULGbDwnf+ht7PaeQUh048GBu30+Y7LiAVNORDGZulouyOlP1vA9nMAmNGSX8Lge8KGKxCePpB7tDm8KIDydtGNQJsNuKgFppTfnLyGVipf5AyjmIpbUlocjiBJ1GVFgOhe4VfXRT/Deao+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5VcVTs7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5VcVTs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC69C1F000FF;
	Thu, 17 Sep 2026 17:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666630;
	bh=IDD0BbN3Jdc8785pOmNqyYqp4u820cMNH+tFpBHmpOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5VcVTs7xpK99rDR5DVvvX8CPtYeZhhsCjGbBw2vnvaadDJA0ieSHL5ol/iXJtcBO
	 hVHhfNPsMU7AxRZ2bnESauixb49UD2BZtyC4Tx9tMtOWpU4Vqrp+4xj3NFYE2bwgYK
	 YWYmvjsn+7ilIkw9K168ag6rbhk4D1Zo3bYCExrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1100/1250] xfs: log the tempip after we convert it to extents format
Date: Thu, 17 Sep 2026 16:14:55 +0100
Message-ID: <20260917151621.994661634@linuxfoundation.org>
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
 fs/xfs/scrub/symlink_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -291,7 +291,7 @@ xrep_symlink_swap_prep(
 		if (error)
 			return error;
 
-		xfs_trans_log_inode(sc->tp, sc->ip, 0);
+		xfs_trans_log_inode(sc->tp, sc->tempip, logflags);
 
 		error = xfs_defer_finish(&sc->tp);
 		if (error)


