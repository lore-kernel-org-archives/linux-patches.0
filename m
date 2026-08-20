Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2340D3403F8;
	Thu, 20 Aug 2026 17:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247073; cv=none; b=JLKQgSXCjFbV5LjvvLWjg3SQzHwNtioOCvdySMwP76nTMcN3Mr+Y22a02j7PQI+W+EnJCp673P7OY66pC8FLbdWTrkD23QgBcJgk5YzsJHDQS5GFB8IewzJXlZ2Ykdum03opUJSadrYPZIZEdSOPa5RLjbSGBlNmv8NhcNXiBd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247073; c=relaxed/simple;
	bh=WNvg7qSKlCwT49WYsP6HbuV8zKWJLVmym2e/WX5LYLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYJ9WktjPe0qMSujR2psQjcNx7yzJFBeriui+k95mZ77vPDOYjPYJHqO6Qd9UAHVBjZic5fdvXyJcbQT/diV9W4wczHnXo4wW+sSPn0wAyEQ48NzIZXNfg9tDhX3x271GErioSyGCdcTc41QDkM5/5w5One3QFYwvIvxR9wdKaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0L/vtiUp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0L/vtiUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6863C1F000E9;
	Thu, 20 Aug 2026 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247071;
	bh=p2y3sb/dI389uDlvk1u0oKgcvguq4U9hOJsKjZfY08w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0L/vtiUpNboiIqQLCTNYs0/tmZiNkYpSzW/sSq7wfglF5hsATaq7g1dcN6A+ja2X2
	 Uk0l6u2NTZOsG3QlFGokMjYFM03ZSPDtkHqZSSCR3BaMoP4HKLoGsNMdLZay9tdcIe
	 3DY8UrFKv+32bVMqyeEiASQZi1FoxAbB49xgIbIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 102/220] xfs: dont walk off the end of a null sc->sa.agi_bp in AGI repair
Date: Thu, 20 Aug 2026 16:54:52 +0200
Message-ID: <20260820145226.546417950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

commit 1e96a00e0d3a00be6e4f368b2f18e2d345f813ce upstream.

LOLLM noticed a longstanding bug where xrep_iunlink_walk_ondisk_bucket
tries to walk ragi->sc->sa.agi_bp to rebuild the unlinked inode lists.
Unfortunately, it's possible for agi_bp to be null if the buffer
verifier fails, so we have to use ragi->agi_bp (which skips verifier
checks) instead.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1083,7 +1083,7 @@ xrep_iunlink_walk_ondisk_bucket(
 	unsigned int		bucket)
 {
 	struct xfs_scrub	*sc = ragi->sc;
-	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
+	struct xfs_agi		*agi = ragi->agi_bp->b_addr;
 	xfs_agino_t		prev_agino = NULLAGINO;
 	xfs_agino_t		next_agino;
 	int			error = 0;


