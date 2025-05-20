Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851C7242D93;
	Tue, 20 May 2025 13:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749150; cv=none; b=Lf70eBFXMuntsQvJn0rK6iUaBW/5vQ2V8LEcE0S9OAgXgBQaGniY142ZjTcI11MCx6KPTWvBq/miFckg467iGy4OLzw4x1G1dxNIDCH+JU+jRXIURpz+x8Fio/NnjhJUJ6uMb+muNwAFhdNGHFMOxWXY+3GwNvWSRDdE7Rh7buE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749150; c=relaxed/simple;
	bh=OvanAK6dQS3Y5OTM9QBRTPllcQrUYSma0jpgmLimEPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNdINOy896whcce+SFjTc0YxuDPx1UNUO6iQlKG14fELBQbI31JXwBJpECcbcFpHvwTK2Apn6PVLmfFLrH5OVDNOXUxc04HeHROo4HYJamaNzijmRK7ZcEG/Ik04Vr1XDSSQIXjXDX0Q5GPzl8H/r5cmUQui6207K6m0tZPwnYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AyUWLWhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AyUWLWhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F907C4CEE9;
	Tue, 20 May 2025 13:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749149;
	bh=OvanAK6dQS3Y5OTM9QBRTPllcQrUYSma0jpgmLimEPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AyUWLWhXjDoHicQsxJDLWqSBer+4oR7ZqC391xAt8jIxBSIBtudIJdvQ8IUR3tvrJ
	 zhP/NG6ZR7VJnrhNjkALAXzDwjxf7+x9BJsdKcZCLkWvhd9g9kCMfZxEu/7b9Jr5ap
	 EfTzFNvIboGPPSU8EiP974E3Wl25Z2a5GvqOm+6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/59] NFSv4/pnfs: Reset the layout state after a layoutreturn
Date: Tue, 20 May 2025 15:50:04 +0200
Message-ID: <20250520125754.360088841@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 6d6d7f91cc8c111d40416ac9240a3bb9396c5235 ]

If there are still layout segments in the layout plh_return_lsegs list
after a layout return, we should be resetting the state to ensure they
eventually get returned as well.

Fixes: 68f744797edd ("pNFS: Do not free layout segments that are marked for return")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 4016cc5316230..83935bb1719ad 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -729,6 +729,14 @@ pnfs_mark_matching_lsegs_invalid(struct pnfs_layout_hdr *lo,
 	return remaining;
 }
 
+static void pnfs_reset_return_info(struct pnfs_layout_hdr *lo)
+{
+	struct pnfs_layout_segment *lseg;
+
+	list_for_each_entry(lseg, &lo->plh_return_segs, pls_list)
+		pnfs_set_plh_return_info(lo, lseg->pls_range.iomode, 0);
+}
+
 static void
 pnfs_free_returned_lsegs(struct pnfs_layout_hdr *lo,
 		struct list_head *free_me,
@@ -1177,6 +1185,7 @@ void pnfs_layoutreturn_free_lsegs(struct pnfs_layout_hdr *lo,
 		pnfs_mark_matching_lsegs_invalid(lo, &freeme, range, seq);
 		pnfs_free_returned_lsegs(lo, &freeme, range, seq);
 		pnfs_set_layout_stateid(lo, stateid, NULL, true);
+		pnfs_reset_return_info(lo);
 	} else
 		pnfs_mark_layout_stateid_invalid(lo, &freeme);
 out_unlock:
-- 
2.39.5



