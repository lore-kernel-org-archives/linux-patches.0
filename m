Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ADF2459C0;
	Tue, 20 May 2025 13:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749419; cv=none; b=fy6gZt4seZ8E69fXCVf9H2Y8Rcac6K1Q2jEz/BwO5rcMmzI4gzbSSuLzoZLyOpoblPgKvM+4/u3RadlLJtVbKSuBGmBXm0gHk98StAOt7zLo/aYx3caKEF3bgJtsURTKVwUpNu5snTWosb5rkkd582lXPKPG5QCOHy8Hxt3J3I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749419; c=relaxed/simple;
	bh=FEppOwl902pnfpgAP3/ZiyN7D9EShuIZlyaz2uA2LKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKba8fZQ3n+3GuUedhgjcOAv7H3zqDv3dR8773IHPxTSyk8nTI8TivffS8FMBdEx9mMVkHm0T6JUpMtmUsZB8TtJNaHLFzwwOzpDAPCKCHrjlm2W2qyZLEdAWKnAo2EE5r11SmowMdsKvjt31RidnfzLvABP+HmVX3zscDVuSdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxo/PWjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxo/PWjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76781C4CEE9;
	Tue, 20 May 2025 13:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749418;
	bh=FEppOwl902pnfpgAP3/ZiyN7D9EShuIZlyaz2uA2LKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxo/PWjNzqyl2jU+b8hCYKcAZTwGy3Bs1oArEgXS8jOeHLzb2RvJ3GdWnl6JyMq/O
	 QyPZwaZ7RglgwNeOMd1TjwF/KDUDVFYBkoWcsfNIWaNj+piKFbEQzb7DjMHo0efzbd
	 /JqpoGqA6p9+KsiXEcLu9WRpTC4PxUfrnxbSD3kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 39/97] NFSv4/pnfs: Reset the layout state after a layoutreturn
Date: Tue, 20 May 2025 15:50:04 +0200
Message-ID: <20250520125802.191250336@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


