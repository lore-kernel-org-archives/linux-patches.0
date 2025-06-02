Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC3B221578;
	Mon,  2 Jun 2025 14:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874696; cv=none; b=Zieze/F0MWpzTyXSA6w7DS1J2Ye3wOnsdGp9qDwLRfUz3jzSQ9lSLeI+sgkvFjjMA8pSb2/nkL1Dmwd0C7TkG8BsecsepM9D0nH5IhlrJsfVXc+pHgdYJZn25hQHueKzKIJHyUowPRhGOg5zwB2QOfbh+ZrR7MYrD4CWKYJYxDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874696; c=relaxed/simple;
	bh=11Gvab3YB3jBK4RfD7TnvZRVCtckIiJC3Jd+SQnV4n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ+6OtmOBhigf4zapvVK5SgSeEsH5DXZlnBx5JR1q7lfiG8pkXyBAdalrbu8ran+mJoYzGa+XyRjy7wwjoZtscPejBsSUY0PfMPoeS29+20anlHRTG89nFkMd6bkf2kqPa9tM3sj6nSn36vZ/bpD3iGB0rCRJE+0dEKngGO1tGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyrancwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyrancwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F224C4CEF0;
	Mon,  2 Jun 2025 14:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874695;
	bh=11Gvab3YB3jBK4RfD7TnvZRVCtckIiJC3Jd+SQnV4n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyrancwzMEZxoUAIY76MjnnhWRMrinT/OhF7zl7POw+QHadwR5udiOaULAxqnSvTL
	 OjOboi9XU52qBfAyei3zlX2LrjW6Q2y89jmh0lCAbCP4aCSnhu9J7H3f3tAX7A1zWR
	 XijrW6Vgb/Hp76MYHuWTNj4rxJs6rs9ihLXSwmSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/204] NFSv4/pnfs: Reset the layout state after a layoutreturn
Date: Mon,  2 Jun 2025 15:46:49 +0200
Message-ID: <20250602134258.664180094@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a6362c07cff63..d91576a587e4e 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -710,6 +710,14 @@ pnfs_mark_matching_lsegs_invalid(struct pnfs_layout_hdr *lo,
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
@@ -1162,6 +1170,7 @@ void pnfs_layoutreturn_free_lsegs(struct pnfs_layout_hdr *lo,
 		pnfs_mark_matching_lsegs_invalid(lo, &freeme, range, seq);
 		pnfs_free_returned_lsegs(lo, &freeme, range, seq);
 		pnfs_set_layout_stateid(lo, stateid, NULL, true);
+		pnfs_reset_return_info(lo);
 	} else
 		pnfs_mark_layout_stateid_invalid(lo, &freeme);
 out_unlock:
-- 
2.39.5



