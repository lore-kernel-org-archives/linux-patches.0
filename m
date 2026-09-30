Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F7651EDEE;
	Wed, 30 Sep 2026 17:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789656; cv=none; b=I3Ouh058FFOONdc0k3gEfl5wtSDRhEGY65FaUgnZtEosjupRZOyZiSyym4eWOC0G72IRHJSY0qUovU4qvRXQem22IH2vvaz3prWBbVoH384UrdP2cmgjD7VY1+LhsnHPUh2Gai98+LehusfVaSvFCAkJG83lrTK1wU1Qm5FYkO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789656; c=relaxed/simple;
	bh=h5JcY0BOH1cFBiCo7A32GDsZ5FaJ0cwJYpDiJ1dSJi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r03qljLVh8y78igQWTWwuqwvO4mEs6Rr8b6k2o0svf2L5htdZa5JV1S5guSkUNPWI3A5UzXrq+iK19yi+EcrXNUrDpdZuWG9qY3xccNFj5vIgChshS+W1ZGwBRg9onu8Y3JVoVtna32wlxP+GXOmog4e+kRmIL3zK/GrmYR8WzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vl2WrKrd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vl2WrKrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095DB1F00898;
	Wed, 30 Sep 2026 17:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789655;
	bh=NIzv6UlovlmfAQ9J7HHBeKMOe7++ocWqRJ2KgIRld6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vl2WrKrd3qsgXYaYF342omJA2iMRkUosoD1LGy3V9PwXR3njoVQzqoMgVU/19lV7Z
	 NK0HU/rWyQ6Tb23pQFxym4rt2JklVDhy7yOolV3XqdlLtGQmkt1Qgs3aJPDMJe4+Sg
	 IDY6g+KQ1U09ohzvfkEm8NTeP3H5EnrUlJJ+zu/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 555/877] xfs: fix blockgc group quota scanning when usrquota isnt enforced
Date: Wed, 30 Sep 2026 17:24:26 +0200
Message-ID: <20260930152426.620325185@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit f8f6382ff13109e19d0fc1d0224ff7d29641e56a upstream.

LOLLM noticed the copy-paste error here -- if user quotas aren't
enforced but we're near the group quota limit, we fail to set FLAG_GID
and hence we might not actually free any preallocations, causing
unnecessary EDQUOT.  Fix that.

Cc: stable@vger.kernel.org # v5.12
Fixes: c237dd7c709432 ("xfs: flush eof/cowblocks if we can't reserve quota for inode creation")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1593,7 +1593,7 @@ xfs_blockgc_free_dquots(
 		do_work = true;
 	}
 
-	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
+	if (XFS_IS_GQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
 		icw.icw_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
 		icw.icw_flags |= XFS_ICWALK_FLAG_GID;
 		do_work = true;


