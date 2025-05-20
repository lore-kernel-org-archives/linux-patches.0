Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B23419F137;
	Tue, 20 May 2025 14:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749786; cv=none; b=Axln3aEPVonaI6zlicV527QuT721eO4xtJxOIdPL85rpEDhs95NqwuRfbRcY/V53/RokACO8jFhj2LkS0+4/4MPhAlXVSdodwue4X4NH7grqLbXjLfqSu5ynJDA1ME3wv1Lgj0ueJVnkoUktHwC1S9LVQmN0wrWxI6EHb/cNE1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749786; c=relaxed/simple;
	bh=7RbzkqKlwK315JGDFJIXCsfZkRG+Ta3LblttXNJVEJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEa4LHdF0dmc84rt+aTAhsH5c/uwHzEBBzL29c/xkMQCaJPIznLhrS9MBwo1mYOcMl6iVbWY61nqb3hnC5WcO9Xm8uL/JsuU1Z/nE+WRQgTJE/ORhXU/CSQQ2c1oQwq//JYd9jZwdjQnlpVaKvP0B0op8J4YUzVO/7FIbwBC4kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFEWEJvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFEWEJvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2AAC4CEE9;
	Tue, 20 May 2025 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749786;
	bh=7RbzkqKlwK315JGDFJIXCsfZkRG+Ta3LblttXNJVEJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFEWEJvYNxXvPDcjdeK3sW5Xsq7LVjRKQVAd/Op4HSvtACZz3qMFiP7xdPZUXID7f
	 9Ha5COu2bBRHOnyztN2N22rkWB6L4TdtY8x7MK3oNxtl8kKvmueJ4/eKHb2bXi6kG2
	 S+yra+tRlI1Xz5JYOOYv07W2/7kiIigmo9q/GIRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/117] NFSv4/pnfs: Reset the layout state after a layoutreturn
Date: Tue, 20 May 2025 15:50:25 +0200
Message-ID: <20250520125806.365889708@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/nfs/pnfs.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -732,6 +732,14 @@ pnfs_mark_matching_lsegs_invalid(struct
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
@@ -1180,6 +1188,7 @@ void pnfs_layoutreturn_free_lsegs(struct
 		pnfs_mark_matching_lsegs_invalid(lo, &freeme, range, seq);
 		pnfs_free_returned_lsegs(lo, &freeme, range, seq);
 		pnfs_set_layout_stateid(lo, stateid, NULL, true);
+		pnfs_reset_return_info(lo);
 	} else
 		pnfs_mark_layout_stateid_invalid(lo, &freeme);
 out_unlock:


