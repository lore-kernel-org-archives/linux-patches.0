Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA54248F5D;
	Tue, 20 May 2025 14:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750184; cv=none; b=jk1SEWl2uGdHP1OWZBtppO9mwAaFvL/srZmakVcZ8367oW/8QR3cvV9PQAYhuSasqSgY2buvYi/7n+woT/l8RFehGxpXVUsswW0etalcURuZAgMFK+6PkwJ3ti8mmOvmIzuUTr0f0G3oUbDf8AWd4GfyMcJd6u7N0tPA/nixo2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750184; c=relaxed/simple;
	bh=ZNFOS39kZrB1XhdY2BzuTgp/G1LlXI4AC35AYkgNu0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaYnwvuXiA5UVWg/kdG5y8nlPyiRBvhd9lC8kokT3Vyl6JfJlts1ag6TWCJkPEMgAbtQPh0/kZ+kSGhQ839xWPV+h3Mv8ROuS4rHcEymGgEHaE5MQpOZ1uI/Bdc/iPFL9gfWCu0/Ug8meCs1RD18h+UUtbuPahp5rD5Dbj4qSmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFkfI8Lu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFkfI8Lu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6702EC4CEE9;
	Tue, 20 May 2025 14:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750183;
	bh=ZNFOS39kZrB1XhdY2BzuTgp/G1LlXI4AC35AYkgNu0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFkfI8Luz9PDpEa832+zO9arE/SFZ0oUugn6kr06reHI9uKudOR/JpEKr0wDPTTKh
	 53BzIa7vQHmAnvGudiFgloLVmwQK3J9XNQMWrUwWv0e1KukpInZb6JY7sPYT6s0ihP
	 1asetRXDwmaLmf7R4iv9hYR44c0U2hKaTHgfrdK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/143] NFSv4/pnfs: Reset the layout state after a layoutreturn
Date: Tue, 20 May 2025 15:50:23 +0200
Message-ID: <20250520125812.735804659@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -745,6 +745,14 @@ pnfs_mark_matching_lsegs_invalid(struct
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
@@ -1292,6 +1300,7 @@ void pnfs_layoutreturn_free_lsegs(struct
 		pnfs_mark_matching_lsegs_invalid(lo, &freeme, range, seq);
 		pnfs_free_returned_lsegs(lo, &freeme, range, seq);
 		pnfs_set_layout_stateid(lo, stateid, NULL, true);
+		pnfs_reset_return_info(lo);
 	} else
 		pnfs_mark_layout_stateid_invalid(lo, &freeme);
 out_unlock:


