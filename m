Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E22251E458;
	Wed, 30 Sep 2026 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790302; cv=none; b=GuoX6ROjIxRlvYP+IvexauW1eCjdewvRHFM7Evjav8/F/BPYPLI2xJe9tcZonOqmZMzZsWVtuvU2mNXoVAgmigXEIrfaTIUFAaA5fOexJGd6PC3aR0b3EhDe6jyDMKBXxDWKmj/U2U1lO5erASAWbDIi/wHhbH00gNgG2cffQnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790302; c=relaxed/simple;
	bh=E/F5JvdsTBb+SGFMWcKAfaMtCgOQRQhCFBeyiJIdJq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ze/OcnNC0lk5JwP8L70nUw14R4zk7I2RBDoYBEDsDg4tGEHbwdXnEg0sZMymDwzJFT77kHAM0kstDtLdwND3U7Ay3ZWQtxiT5fnhSBOnokBhoJHM4t4L6n7G/7Z6HBm1leteRlTkZtMrSAJCc9BHbsV0I9xKWLVdCAt5IobFjP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqRM3yFs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqRM3yFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F70A1F000FF;
	Wed, 30 Sep 2026 17:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790301;
	bh=YigR575OVIVZjFqbsDJ0VmpbE6uLKGAOI8366sN1rXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MqRM3yFs7EyfFQ4c+KTUeDVfSpbNHQxgmuptk5wjNMJluPmcwLbMw+su3hBWC/Pb4
	 DJmXJkMd0tEB5FWav+Pi7/Po4i9dcd4JvvHFjcDTEVwKXMgvkr/q+nvVDORCsXJoqc
	 0MpdZGLm7LwHyl/J2RH1/zXvysCDO1Gs5JREXbxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 779/877] xfs: strengthen the "is cow staging" helpers in scrub
Date: Wed, 30 Sep 2026 17:28:10 +0200
Message-ID: <20260930152431.524385368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 0d43368844a75ad13561a1198a3b027940730756 ]

LOLLM pointed out a bug in both of the refcount scrub predicates that
determine if a range of blocks is marked as CoW staging in the btree.
While it compares blockcount < len, this isn't enough to determine that
the CoW staging record is at least as large as the range passed into the
helper.  Fix both of them.

Cc: stable@vger.kernel.org # v4.16
Fixes: f6d5fc21fdc713 ("xfs: cross-reference refcount btree during scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ Omitted the rtrefcount.c hunk because Linux 6.12 lacks realtime refcount scrub support. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -581,8 +581,12 @@ xchk_xref_is_cow_staging(
 	if (rc.rc_domain != XFS_REFC_DOMAIN_COW)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 
+	/* Can't start after bno */
+	if (rc.rc_startblock > agbno)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+
 	/* Must be at least as long as what was passed in */
-	if (rc.rc_blockcount < len)
+	if (rc.rc_startblock + rc.rc_blockcount < agbno + len)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 }
 


