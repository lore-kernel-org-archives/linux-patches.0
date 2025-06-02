Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA62221FCA;
	Mon,  2 Jun 2025 14:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874692; cv=none; b=oSSNgUtX0ikjOD6zC5tWdpT0iA6EMJSmtPKsI8+CMOuFFFS9/zmaIwiPEQp7BFwOP+BY6vhM4lLPz7L+gkWsqDeKiHxLfkh28/ggjiRyhsceFnuS8/wzWgOqIdFRGKAk8KMm3+D8jC0LWH5y06pekqfJhTWU/DQGF50n7tiiUuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874692; c=relaxed/simple;
	bh=1yDuNNk7amAoANH6Z2PobwPzwa4oqduI9q6BDGsbl/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlBJJ2jNEWxkhOoysUHOVJvpBG8PjtrWGtgKPvKkd4KUxsDBKu0E4GmFmg6c3QvxY9UIWURfof5vEsNYbDXiesucJgf6Urx5fk7IdMJwFsRq1a8bp8QlhIratEB0WemVpLOVF0BtRHna02zNYp8J4Nruzihozby+6ClN7KYgRMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQwf1Gah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQwf1Gah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64966C4CEEB;
	Mon,  2 Jun 2025 14:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874692;
	bh=1yDuNNk7amAoANH6Z2PobwPzwa4oqduI9q6BDGsbl/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQwf1Gah6xEdZyPb5KsxXMAFbMlo9ZUwyIPgfJTni47J2PJ8feVAn6OiUgLsoJcH5
	 NCv4SxKkqaaRxzVl/U74JnmmMyuwVCThqWYojtHGcznjwsOh1JyFX3FMlerZJlfIZb
	 x2K40qOZkz7fbvZox85hgTk63iF8wQ/HXcIhrIj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/204] NFSv4/pnfs: pnfs_set_layout_stateid() should update the layout cred
Date: Mon,  2 Jun 2025 15:46:48 +0200
Message-ID: <20250602134258.625662552@linuxfoundation.org>
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

[ Upstream commit 59b5639490f51aa604d18064dcf0c2d72eb1decf ]

If the cred assigned to the layout that we're updating differs from
the one used to retrieve the new layout segment, then we need to
update the layout plh_lc_cred field.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 6d6d7f91cc8c ("NFSv4/pnfs: Reset the layout state after a layoutreturn")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_proc.c |  2 +-
 fs/nfs/pnfs.c          | 20 ++++++++++++++++----
 fs/nfs/pnfs.h          |  1 +
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index 31922657e836e..1397e0816ba09 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -284,7 +284,7 @@ static u32 initiate_file_draining(struct nfs_client *clp,
 		goto unlock;
 	}
 
-	pnfs_set_layout_stateid(lo, &args->cbl_stateid, true);
+	pnfs_set_layout_stateid(lo, &args->cbl_stateid, NULL, true);
 	switch (pnfs_mark_matching_lsegs_return(lo, &free_me_list,
 				&args->cbl_range,
 				be32_to_cpu(args->cbl_stateid.seqid))) {
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 90961dae4dc3b..a6362c07cff63 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -943,10 +943,21 @@ pnfs_destroy_all_layouts(struct nfs_client *clp)
 	pnfs_destroy_layouts_byclid(clp, false);
 }
 
+static void
+pnfs_set_layout_cred(struct pnfs_layout_hdr *lo, const struct cred *cred)
+{
+	const struct cred *old;
+
+	if (cred && cred_fscmp(lo->plh_lc_cred, cred) != 0) {
+		old = xchg(&lo->plh_lc_cred, get_cred(cred));
+		put_cred(old);
+	}
+}
+
 /* update lo->plh_stateid with new if is more recent */
 void
 pnfs_set_layout_stateid(struct pnfs_layout_hdr *lo, const nfs4_stateid *new,
-			bool update_barrier)
+			const struct cred *cred, bool update_barrier)
 {
 	u32 oldseq, newseq, new_barrier = 0;
 
@@ -954,6 +965,7 @@ pnfs_set_layout_stateid(struct pnfs_layout_hdr *lo, const nfs4_stateid *new,
 	newseq = be32_to_cpu(new->seqid);
 
 	if (!pnfs_layout_is_valid(lo)) {
+		pnfs_set_layout_cred(lo, cred);
 		nfs4_stateid_copy(&lo->plh_stateid, new);
 		lo->plh_barrier = newseq;
 		pnfs_clear_layoutreturn_info(lo);
@@ -1149,7 +1161,7 @@ void pnfs_layoutreturn_free_lsegs(struct pnfs_layout_hdr *lo,
 
 		pnfs_mark_matching_lsegs_invalid(lo, &freeme, range, seq);
 		pnfs_free_returned_lsegs(lo, &freeme, range, seq);
-		pnfs_set_layout_stateid(lo, stateid, true);
+		pnfs_set_layout_stateid(lo, stateid, NULL, true);
 	} else
 		pnfs_mark_layout_stateid_invalid(lo, &freeme);
 out_unlock:
@@ -2382,14 +2394,14 @@ pnfs_layout_process(struct nfs4_layoutget *lgp)
 
 	if (!pnfs_layout_is_valid(lo)) {
 		/* We have a completely new layout */
-		pnfs_set_layout_stateid(lo, &res->stateid, true);
+		pnfs_set_layout_stateid(lo, &res->stateid, lgp->cred, true);
 	} else if (nfs4_stateid_match_other(&lo->plh_stateid, &res->stateid)) {
 		/* existing state ID, make sure the sequence number matches. */
 		if (pnfs_layout_stateid_blocked(lo, &res->stateid)) {
 			dprintk("%s forget reply due to sequence\n", __func__);
 			goto out_forget;
 		}
-		pnfs_set_layout_stateid(lo, &res->stateid, false);
+		pnfs_set_layout_stateid(lo, &res->stateid, lgp->cred, false);
 	} else {
 		/*
 		 * We got an entirely new state ID.  Mark all segments for the
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 68339680bb7d1..b0f91a4592cb5 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -270,6 +270,7 @@ bool nfs4_layout_refresh_old_stateid(nfs4_stateid *dst,
 void pnfs_put_layout_hdr(struct pnfs_layout_hdr *lo);
 void pnfs_set_layout_stateid(struct pnfs_layout_hdr *lo,
 			     const nfs4_stateid *new,
+			     const struct cred *cred,
 			     bool update_barrier);
 int pnfs_mark_matching_lsegs_invalid(struct pnfs_layout_hdr *lo,
 				struct list_head *tmp_list,
-- 
2.39.5



