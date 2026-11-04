Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828978;
	b=S14TFjDruUhQaEEZVyN+PwJGNsmD/nA20xzcq8HkX3WzJJrjZ2GuPb0sRUH1Y2bGxtag
	 eioAziMd0Wj9zrRvsxP1C8g0y8bmmv3lt/R3dZlzPJBzUOWybxBMjVi1yldwy4hIdFLQX
	 Uf/xLjyF8yQNHc4IgfS4CmSCF9nHrmChU6zA2dQ2rhKHoQuWcjdydb+fHKQK0x0tVl4Ht
	 f5U4zYtkEiDQHqedunOFqiqj7C247YW+MEyYD63eCl4wF3MXwLM2i10BAyMcVvrMqAU1U
	 8ulNzAbYRl1XL7d43wcJqWw5p4h7YmOm7nloeDCjDqCZEdS/YkWTyqFV3EE4id6azCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MTxEskI2a59RqGp4CubFIbMdemA3py2ZzXetd7QnY3U=;
	b=EqjMtHceF4oxjv/npTzkDMhjxaaI4QJRaHK3T8hF3k028NcZqrXXMzLqkoW4Chs7+DGU
	 uM+QdDIE+HoXCDLi/+xYdm0B2dOhvo5gWHZIJYSCzXULRAsCpskk/90jyGx9pz4eMgAiB
	 jvYVJyzZ7G+zBOVRnv1/WOUbQpW/219ms3Xdt7Vk2mszY7t6OrrsWyUY7UUYGqclviOQD
	 LYmIUOIiTxnwF9ql3A7RxNJxpd1wrR7ouqRIcPxLdbCc/ofST7bu2XbNe43I18UAx2T2N
	 GUIWOY/AX/WgNzCj8ouLqPZhahSqBrv43kH+Hnh5/b8ohfVOd/KvjnssYAb6f6jqYUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWzzhfhO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E946070754;
	Wed,  4 Nov 2026 21:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWzzhfhO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651561F00919;
	Wed,  4 Nov 2026 21:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828977;
	bh=MTxEskI2a59RqGp4CubFIbMdemA3py2ZzXetd7QnY3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWzzhfhOylxwOVhUvlkujBqXXHU9MdfAQ6wxm4K5PRXKnSC4+2Fc32pA77QW3Z7cq
	 a4zvJcKM05eDEUEDU6faXgw46mysaCvLC/VSPqlAXsEh2zLFiOvBpPjB7tdgujy9UK
	 NYHsOJxQr4avLbZ2KK6H9u6G+KOQ139U9QMyv4Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 365/547] xfs: fix correction of unwritten extents in quota file data fork
Date: Wed,  4 Nov 2026 16:09:09 -0500
Message-ID: <20261104211048.664510043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 6f2792720673f569fa3e1f68181b9d6fd26802b5 upstream.

LOLLM noticed a couple of problems with the code that fixes unwritten
mappings in the quota file's data fork: first, we should zero the ondisk
contents as part of converting them to "unwritten" just in case we crash
shortly after the conversion.  Second, and more importantly, it noticed
that we fail to resynchronize the iext tree cursor after modifying the
iext tree.  If the tree shape changes, we could be in a world of hurt.
Third, we should force a quotacheck if we reset an ondisk dquot.  Fix
all issues.

Cc: stable@vger.kernel.org # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota_repair.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -416,7 +416,9 @@ xrep_quota_data_fork(
 	/* Check for data fork problems that apply only to quota files. */
 	max_dqid_off = XFS_DQ_ID_MAX / qi->qi_dqperchunk;
 	ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
-	for_each_xfs_iext(ifp, &icur, &irec) {
+	xfs_iext_first(ifp, &icur);
+
+	while (xfs_iext_get_extent(ifp, &icur, &irec)) {
 		if (isnullstartblock(irec.br_startblock)) {
 			error = -EFSCORRUPTED;
 			goto out;
@@ -440,16 +442,35 @@ xrep_quota_data_fork(
 
 			error = xfs_bmapi_write(sc->tp, sc->ip,
 					irec.br_startoff, irec.br_blockcount,
-					XFS_BMAPI_CONVERT, 0, &nrec, &nmap);
+					XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO, 0,
+					&nrec, &nmap);
 			if (error)
 				goto out;
 			ASSERT(nrec.br_startoff == irec.br_startoff);
 			ASSERT(nrec.br_blockcount == irec.br_blockcount);
 
+			/*
+			 * We just zeroed the ondisk dquot, so counts could be
+			 * wrong.  Schedule a quotacheck to fix that.
+			 */
+			xrep_force_quotacheck(sc, dqtype);
 			error = xfs_defer_finish(&sc->tp);
 			if (error)
 				goto out;
+
+			/*
+			 * Set cursor to the next block past the extent we just
+			 * converted because bmapi write could have merged
+			 * records.
+			 */
+			if (!xfs_iext_lookup_extent(sc->ip, ifp,
+					irec.br_startoff + irec.br_blockcount,
+					&icur, &irec))
+				break;
+			continue;
 		}
+
+		xfs_iext_next(ifp, &icur);
 	}
 
 	if (!joined) {


