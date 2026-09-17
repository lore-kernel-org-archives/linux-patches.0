Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA0C4C10F3;
	Thu, 17 Sep 2026 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660675; cv=none; b=sfU8fE3CebSaLzpWa9G2lF/+NBtzWqXFIQ2ZcX+7omsXCUZWouEq1LDxjB58Gwtrf81cucm1Kn4dgNu37wBsQJZDrbt9d6eis2QdH42KL5LpAvHycslfboPX2BDSzIiHuEa6XWPm8y5eEumiwUmN9pOMzF4uEr0vrEt4tEbM4DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660675; c=relaxed/simple;
	bh=lcB15mWNnVUsDjfFg/roZ4iqZ/rUCEGiHnnKCGGr8+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+8zYwtndbdZIDOTYIdYmJ7McPyMpntTLmScdXLI3Atp9i7mpjaSRt9t6a58XUbiEVy64MOtoU2W0fKnBAViRKzUtM2zAJ+NUP85mxLb22INliXaDygKFLBqixiclXBL0txgIb4IOD3g7h/98AeqM9GGA5KRaPfCkClCHLC/NGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VogK2iA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VogK2iA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B037E1F000FF;
	Thu, 17 Sep 2026 15:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660674;
	bh=fnZ2eVf3tdnRX7jbpA3n3510BWv7HVvnHmyB7CL4RTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1VogK2iAiTC8UZzQa+K+q8sThyzFaH1f0IZUE6ue9MytewoP/8Y1snrSSqJvvqYbw
	 DGtdkGE5uuWvVAtFMlqsQJYIswyyxJFNMI6SX8ZNZJYipWIwly5cTy9qDt6tCWSzrA
	 ZduaFRcs7Ozr3neo8ATWgBFuRLhSPE/kafmQTpPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 672/733] xfs: fix backwards mergeability logic in refcount scrubber
Date: Thu, 17 Sep 2026 16:16:20 +0100
Message-ID: <20260917151409.470541912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit e8b01aaafffe6b852325debdf1ef4b13ccea1cd7 upstream.

When we start the refcount or rtrefcount btree scanners, prev_rec is
initialized to all zeroes.  This is done so that the record mergeability
checks skip the first record because you must have two records to
compare.  Unfortunately, I got the logic backwards, so scrub has never
complained about mergeable refcountbt records.  Fix this bug that LOLLM
noticed.

Cc: stable@vger.kernel.org # v6.4
Fixes: db0502b39c21d1 ("xfs: flag refcount btree records that could be merged")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c   |    2 +-
 fs/xfs/scrub/rtrefcount.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -410,7 +410,7 @@ xchk_refcount_mergeable(
 	const struct xfs_refcount_irec	*r1 = &rrc->prev_rec;
 
 	/* Ignore if prev_rec is not yet initialized. */
-	if (r1->rc_blockcount > 0)
+	if (r1->rc_blockcount == 0)
 		return false;
 
 	if (r1->rc_domain != r2->rc_domain)
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -376,7 +376,7 @@ xchk_rtrefcount_mergeable(
 	const struct xfs_refcount_irec	*r1 = &rrc->prev_rec;
 
 	/* Ignore if prev_rec is not yet initialized. */
-	if (r1->rc_blockcount > 0)
+	if (r1->rc_blockcount == 0)
 		return false;
 
 	if (r1->rc_startblock + r1->rc_blockcount != r2->rc_startblock)


