Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4354221FB8;
	Mon,  2 Jun 2025 14:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875334; cv=none; b=ryo0E58SnEEanUgK5wXmM/JytYhQFOMoNZxzZj/u9trXvY+ZD2ecNQbnqUzGhvIVM6bzn9laImn0oI12Yf0sBVydkHkrB46p8i4kuKgvFnAmgB5DGMKyKiCsVDeXTYeShya+oUfLospfljHJCdhU6IBBLfSXSfk1y5HxCtzsinM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875334; c=relaxed/simple;
	bh=1IVVrkoEa8qlTW3LevI+vGuJYdF6HAlNmbMJcSLf+NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3QVhcGJmJSojnyESF865H3SlcxLOmFl8S4VIaXD4d991gwO0UEiQUhugaypEA72OEEK5ywZM7JYiqESWF5vL4c28oNDQ3K3vA/br+pT8T1voG5WDHIu5syp3VC+IN74lbzZP9CxTtrsinIK590bikjpqW/RQ1PbiOZlc0vBqK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnQGTi9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnQGTi9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C143C4CEEE;
	Mon,  2 Jun 2025 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875333;
	bh=1IVVrkoEa8qlTW3LevI+vGuJYdF6HAlNmbMJcSLf+NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZnQGTi9NBDgzKOy/F2+tV7tvDRDFqd8dw/tM5EfvzyPv+F9Pf6KdZtob3nFyrB6hF
	 NEsfmdrr2icgwxYt63C2XLEWQymTi98z2I5FLFvJbPGzq54RyZbS6mU90GE05HFZB9
	 wiqtwkhgspRdH7UFvKWCgwgPVxEJr0S8IsBTwPDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/270] NFSv4/pnfs: Reset the layout state after a layoutreturn
Date: Mon,  2 Jun 2025 15:46:19 +0200
Message-ID: <20250602134311.021144293@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 39ac4824b97de..1800836306a5d 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -733,6 +733,14 @@ pnfs_mark_matching_lsegs_invalid(struct pnfs_layout_hdr *lo,
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
@@ -1183,6 +1191,7 @@ void pnfs_layoutreturn_free_lsegs(struct pnfs_layout_hdr *lo,
 		pnfs_mark_matching_lsegs_invalid(lo, &freeme, range, seq);
 		pnfs_free_returned_lsegs(lo, &freeme, range, seq);
 		pnfs_set_layout_stateid(lo, stateid, NULL, true);
+		pnfs_reset_return_info(lo);
 	} else
 		pnfs_mark_layout_stateid_invalid(lo, &freeme);
 out_unlock:
-- 
2.39.5



