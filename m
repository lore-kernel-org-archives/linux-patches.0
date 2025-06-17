Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E2B285041;
	Tue, 17 Jun 2025 16:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178459; cv=none; b=NsEgu65ZhlD8MgbnS7PaFb0Sfavc7cFfGbfFK473Cc5EsEVDpBi714x6Qnojf44FpREgPKfSq3PwyPtw3dHFZH2bKHZIMusHbsxqfk0RLERuOfsCOuPEQ0xJaNL9sJ3qXcLBURAIFslQHGlfyB6YqaSpdTbxoIoJyrF8GLPJ/LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178459; c=relaxed/simple;
	bh=lDAoUGUokhW5GzHoIzgjTrLawXqclDljGsqrBZ0Dl4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzgB/yQWMiJkzYtEaLH5FKwIIfArwGIwY8CxVrdKVRtnGlzC0uD5/tRl2qkWplXYgwYQMR5cZfdUlbKBUNfx+eS8AIZ61HSxJ0k4cicBFJgNCnfo4lA0dz6VJE6WQC1zBndaQAZU1WyIX5v6m5xXyGG6tDt0QpwFsRFzGIOmEEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBQWBUl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBQWBUl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFF1C4CEE7;
	Tue, 17 Jun 2025 16:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178459;
	bh=lDAoUGUokhW5GzHoIzgjTrLawXqclDljGsqrBZ0Dl4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBQWBUl83aJnZvX9dJW4GSdONC8aNVBRLN3ganR+WzfvkFVSMRmXXYmJ54GceglMx
	 j57MACMaSTW7V6tZ8VWKpBZ3FUBAJk/qQsbO7KJJUv/64cJaxUNnCTWaGfnv+dmUfT
	 RitRs/+xr493Rbg1DBo3g0do2FALaf+wIF8WCqiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Bill ODonnell <bodonnel@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 502/512] xfs: dont assume perags are initialised when trimming AGs
Date: Tue, 17 Jun 2025 17:27:48 +0200
Message-ID: <20250617152439.963290794@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

commit 23be716b1c4f3f3a6c00ee38d51a57ef7db9ef7d upstream.

When running fstrim immediately after mounting a V4 filesystem,
the fstrim fails to trim all the free space in the filesystem. It
only trims the first extent in the by-size free space tree in each
AG and then returns. If a second fstrim is then run, it runs
correctly and the entire free space in the filesystem is iterated
and discarded correctly.

The problem lies in the setup of the trim cursor - it assumes that
pag->pagf_longest is valid without either reading the AGF first or
checking if xfs_perag_initialised_agf(pag) is true or not.

As a result, when a filesystem is mounted without reading the AGF
(e.g. a clean mount on a v4 filesystem) and the first operation is a
fstrim call, pag->pagf_longest is zero and so the free extent search
starts at the wrong end of the by-size btree and exits after
discarding the first record in the tree.

Fix this by deferring the initialisation of tcur->count to after
we have locked the AGF and guaranteed that the perag is properly
initialised. We trigger this on tcur->count == 0 after locking the
AGF, as this will only occur on the first call to
xfs_trim_gather_extents() for each AG. If we need to iterate,
tcur->count will be set to the length of the record we need to
restart at, so we can use this to ensure we only sample a valid
pag->pagf_longest value for the iteration.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Fixes: 89cfa899608f ("xfs: reduce AGF hold times during fstrim operations")
Cc: <stable@vger.kernel.org> # v6.6
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_discard.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -146,6 +146,14 @@ xfs_discard_extents(
 	return error;
 }
 
+/*
+ * Care must be taken setting up the trim cursor as the perags may not have been
+ * initialised when the cursor is initialised. e.g. a clean mount which hasn't
+ * read in AGFs and the first operation run on the mounted fs is a trim. This
+ * can result in perag fields that aren't initialised until
+ * xfs_trim_gather_extents() calls xfs_alloc_read_agf() to lock down the AG for
+ * the free space search.
+ */
 struct xfs_trim_cur {
 	xfs_agblock_t	start;
 	xfs_extlen_t	count;
@@ -183,6 +191,14 @@ xfs_trim_gather_extents(
 	if (error)
 		goto out_trans_cancel;
 
+	/*
+	 * First time through tcur->count will not have been initialised as
+	 * pag->pagf_longest is not guaranteed to be valid before we read
+	 * the AGF buffer above.
+	 */
+	if (!tcur->count)
+		tcur->count = pag->pagf_longest;
+
 	if (tcur->by_bno) {
 		/* sub-AG discard request always starts at tcur->start */
 		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
@@ -329,7 +345,6 @@ xfs_trim_perag_extents(
 {
 	struct xfs_trim_cur	tcur = {
 		.start		= start,
-		.count		= pag->pagf_longest,
 		.end		= end,
 		.minlen		= minlen,
 	};


