Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD8A4848BD;
	Thu, 17 Sep 2026 16:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663873; cv=none; b=OXzSOTeTbDI5AlMDEdubPyZKYKbl9vMY1UGOXW981IXM8RW+y6fel6qTx8/dFoIAJIWegW+7+hrfXOCSY+VSJP/j2LtDV+50pStY9HTc7bb8zIBZjJbQFiw57Kfmw0Rh+pqgJ4gaWZZGWluS4Mp3U5rWJLhcp+TW36MYBhVASs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663873; c=relaxed/simple;
	bh=yb6vu4tqCBaw4ssfXddPlN1tvav1o78zEF62BQ5cUgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwWd0SAWYHg/529A8KHjC5kSsqYEIwjIxzG0xKXmP0zC+mrIl4LliWq1HkcaR0UQir2PWtAPt/CA14irkSgs2tmjjxpiSlYgzet6juSlcrIIiHX2YMeK3iRbZoTPjRj0SpNeTPZdAXxRGtPEmavKYJjkNFrifuj6NjE2ick2/g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxHH/IiY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxHH/IiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BE61F00893;
	Thu, 17 Sep 2026 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663871;
	bh=+ZciwdpbSEXJ0P9aSqQsRoihiLcnC79Fa9t0hjjFs6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxHH/IiYX49gVcWqrR3ZXnQ6fZxlIaw/NXulpwhHTxLPKMDNq19fSsgMGnCugLHsr
	 HRj7DqhWTGpn38m1vYNKH9MWimlOaCEzbItsgC7Ne7q2M20rGo+d8P0osQtllxqBcP
	 KkerVdIAVtFvEq7fnrHsjxIT08Y5yfAk/Ano4vxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0183/1250] isofs: handle set_blocksize failures
Date: Thu, 17 Sep 2026 15:59:38 +0100
Message-ID: <20260917151557.071103637@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 25ef4c4d9f0e96fb89c0ae0d7127c3f12a31bc32 ]

isofs uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-8-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/isofs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index ad3143d4066bf..3433fa14cd014 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -818,7 +818,8 @@ static int isofs_fill_super(struct super_block *s, struct fs_context *fc)
 	 * entries.  By forcing the blocksize in this way, we ensure
 	 * that we will never be required to do this.
 	 */
-	sb_set_blocksize(s, orig_zonesize);
+	if (!sb_set_blocksize(s, orig_zonesize))
+		goto out_freesbi;
 
 	sbi->s_nls_iocharset = NULL;
 
-- 
2.53.0



