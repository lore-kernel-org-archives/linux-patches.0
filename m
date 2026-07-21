Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF57346DFE3;
	Tue, 21 Jul 2026 17:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655386; cv=none; b=C71OJW4SvC6rd8B9j+ZKOXt/CEPNJCyhPyvShZwtHxJgP9eAGJjOXlJG4BatdUry3khBpP1lDI8KPeu5RFRcUnuEv3rkDpaPIWb/lVwhrsRtw27WpjZOXIbVAV2Iy4sm6wHc0xcPHdGoYbFBJd2eMzKl1Fk7sgbDk5v+g3Dy2Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655386; c=relaxed/simple;
	bh=bXHt5erxFgTHXGSGF9k4q13dwuwx0cIWAEt9sc53q34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+lgW+FD7oO00RmN3WqOOfsfjg/g/DvWc8nJWkFYUgFpkOjrLjOE9WA8ak79CB/SbT/dn2WDf3sWnQslyZqIuP/74Ls12P5HQ/dKA/9ZyxsOc+cw6i0qx+3NG1fqcsvrQBvGiVLBvc83CESBz3/PsKQnJm7mEwVusz8e8rlS4dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFBDkTpp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFBDkTpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2130F1F000E9;
	Tue, 21 Jul 2026 17:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655385;
	bh=jQjFC8dq9VIy9Clksvgmx16vPcMTUH+DTYlTkHMxVhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sFBDkTppvFVPjGgLPEkNSEGU+wTfvU79I4XhuqIlYK9G4dhUfrCXEUGiegEFBo/f7
	 NEIpESP8Es5neA8G4yXQBow2KMGbF/QoIJgGPI34kJnkktygoBgreLGkXydlBedlHY
	 nlOXTjrSiOyF69WxxKVPlxSJnbQtS45RwpBRNzkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 2063/2077] xfs: factor out a xfs_zone_mark_free helper
Date: Tue, 21 Jul 2026 17:28:56 +0200
Message-ID: <20260721152641.358219983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 16fc9d358d12e6e9cc553162b4064ad58e7fa869 ]

Add a helper for adding a zone to the free pool in preparation of adding
another caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: ae3692c7f440 ("xfs: add newly added RTGs to the free pool in growfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_zone_alloc.c |   11 +++++++++--
 fs/xfs/xfs_zone_alloc.h |    1 +
 fs/xfs/xfs_zone_gc.c    |    4 +---
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -944,6 +944,14 @@ xfs_zone_rgbno_is_valid(
 			rtg_rgno(rtg), XFS_RTG_FREE);
 }
 
+void
+xfs_zone_mark_free(
+	struct xfs_rtgroup	*rtg)
+{
+	xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
+	atomic_inc(&rtg_mount(rtg)->m_zone_info->zi_nr_free_zones);
+}
+
 static void
 xfs_free_open_zones(
 	struct xfs_zone_info	*zi)
@@ -1082,8 +1090,7 @@ xfs_init_zone(
 
 	if (write_pointer == 0) {
 		/* zone is empty */
-		atomic_inc(&zi->zi_nr_free_zones);
-		xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
+		xfs_zone_mark_free(rtg);
 		iz->available += rtg_blocks(rtg);
 	} else if (write_pointer < rtg_blocks(rtg)) {
 		/* zone is open */
--- a/fs/xfs/xfs_zone_alloc.h
+++ b/fs/xfs/xfs_zone_alloc.h
@@ -42,6 +42,7 @@ void xfs_zoned_wake_all(struct xfs_mount
 bool xfs_zone_rgbno_is_valid(struct xfs_rtgroup *rtg, xfs_rgnumber_t rgbno);
 void xfs_mark_rtg_boundary(struct iomap_ioend *ioend);
 
+void xfs_zone_mark_free(struct xfs_rtgroup *rtg);
 uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
 		enum xfs_free_counter ctr);
 void xfs_zoned_show_stats(struct seq_file *m, struct xfs_mount *mp);
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -924,9 +924,7 @@ xfs_zone_gc_finish_reset(
 		goto out;
 	}
 
-	xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
-	atomic_inc(&zi->zi_nr_free_zones);
-
+	xfs_zone_mark_free(rtg);
 	xfs_zoned_add_available(mp, rtg_blocks(rtg));
 
 	wake_up_all(&zi->zi_zone_wait);


