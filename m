Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828914;
	b=5bXCe26m2Lc35T5eDRSFhit9MI1hd3hzJGUXegsg14av8HiS9ja+jrpa1SFaMWJbFMHW
	 YHnx59N5IWrcZWmprsGG9myJJcvtGjdBt3C9vtsxWSAxdJv7v8LrDUOgT489GugY2tm2z
	 pnsUzv6ui9rbv682GrLJ4hef+qsHTDxcChm6/DbUqrxZpgoGezSiHs2CKn+lDsI/RDIla
	 dSEh3D4HdsRa/wwVeGCt+m+Qkh7FsLMwwhXHemy98Pf14mBlCXPrL/v9ymELGEbxKKFWX
	 ++O0Gpw5d2ZmkcynNj4BAMDkHX8N51qw25U49lmo+ZKRxC5cg5crVSYbDwO+XFXLvQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l8jqM3+/V5wXeKuttZbSrfXtNIAlWesXkM+/L+A6Jds=;
	b=VaRNiOlViO90jwoRaUOeUlh365q7oSRkynpKWumF4XbTqm6iTGf9JhUiycIn0GFtVGAU
	 8Yld0kPSMRfdhx7o2SRKMamquBZzqGPv/rx6I/1AKNftbFCzBLg5NWwtckSQoE1Lcvewp
	 BRhNf2JY0RRNRds4C2A2LWvqHVCt/06XFF3R83yTeL6JwAvMDZkY5oWRtqGJdud2HNqO0
	 8mjex/ge+NACgSSg3C6A3QSJbFEE9eV6/RSBnvnwqEf/LgOsgrhlKpxdwic3h9LHM/eDb
	 2iuQvvkmJ4/DU9wEf0tABPUPy9ke6TGwajbTPiwg3hrAQ9T33yTraILJ6TUfz3I5Nfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GjDd2Xua;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC79607031B;
	Wed,  4 Nov 2026 21:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GjDd2Xua
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511A91F00A15;
	Wed,  4 Nov 2026 21:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828913;
	bh=l8jqM3+/V5wXeKuttZbSrfXtNIAlWesXkM+/L+A6Jds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjDd2Xuaz3lqzt0yw+LnuC/D/ghWHMVqpvZKsQ2ZCCv0HGhP8j5SD2HLa3z9v8qjl
	 EQbmT+AeXBBLgh0fOgMbLxLJyogeXNXjNvKk3JVi1VDbZ0oJjpBDUpI4EB+9lkJlsB
	 IBXGGFK39X6GUpPBgSqX6JPdhaDW17R+v4XY4aC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 305/547] xfs: online quotacheck must dirty dquot if enforcement adjustments needed
Date: Wed,  4 Nov 2026 16:08:09 -0500
Message-ID: <20261104211046.873137079@linuxfoundation.org>
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

commit 244425cf63d7e3a0ff5736b41f0e0afe807f7031 upstream.

LOLLM noticed that we have no way to force xchk_commit_dquot to call
xfs_qm_adjust_dqenforcement if nothing else is wrong with the dquot.
Therefore, add a new predicate to force the dirty flag if the dquot has
zero limits and there are default limits; or if the grace period timer
needs adjusting.

Cc: stable@vger.kernel.org # v6.9
Fixes: 96ed2ae4a9b06b ("xfs: repair dquots based on live quotacheck results")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quotacheck_repair.c |   51 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -39,6 +39,54 @@
  * dquot is locked.
  */
 
+static bool
+xqcheck_dqres_force_dirty(
+	const struct xfs_dquot_res	*res,
+	const struct xfs_quota_limits	*qlim)
+{
+	/* zero limits mean that we should set the default limits */
+	if (res->softlimit == 0 && qlim->soft != 0)
+		return true;
+	if (res->hardlimit == 0 && qlim->hard != 0)
+		return true;
+
+	/* do we need to adjust the timer setting? */
+	if ((res->softlimit && res->count > res->softlimit) ||
+	    (res->hardlimit && res->count > res->hardlimit)) {
+		if (!res->timer)
+			return true;
+	} else {
+		if (res->timer)
+			return true;
+	}
+
+	return false;
+}
+
+/* Decide if we need to adjust the dquot limits or timers */
+static bool
+xqcheck_dquot_force_dirty(
+	const struct xfs_dquot	*dq)
+{
+	struct xfs_quotainfo	*qi = dq->q_mount->m_quotainfo;
+	struct xfs_def_quota	*defq;
+
+	/* root dquot does not enforce limits */
+	if (dq->q_id == 0)
+		return false;
+
+	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
+
+	if (xqcheck_dqres_force_dirty(&dq->q_blk, &defq->blk))
+		return true;
+	if (xqcheck_dqres_force_dirty(&dq->q_ino, &defq->ino))
+		return true;
+	if (xqcheck_dqres_force_dirty(&dq->q_rtb, &defq->rtb))
+		return true;
+
+	return false;
+}
+
 /* Commit new counters to a dquot. */
 static int
 xqcheck_commit_dquot(
@@ -91,6 +139,9 @@ xqcheck_commit_dquot(
 		dirty = true;
 	}
 
+	if (!dirty && xqcheck_dquot_force_dirty(dq))
+		dirty = true;
+
 	xcdq.flags |= (XQCHECK_DQUOT_REPAIR_SCANNED | XQCHECK_DQUOT_WRITTEN);
 	error = xfarray_store(counts, dq->q_id, &xcdq);
 	if (error == -EFBIG) {


