Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B03502D40;
	Thu, 17 Sep 2026 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666697; cv=none; b=F1XWoNsFycQBK4aQjuRLjyngkMjOQVocS4DLQFxuphUmp8KcU2/MpbcnHR2+5kS1qnpeDkubG313baBNjb0dD3avK2k1lyuUoPvQ92osFVBxuDDAMAQ0OUtGnHkJi4FFsBcBjzWln/4mjeKu0Tzu9Uhq0m8IzMsVCO1Z0yQTpwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666697; c=relaxed/simple;
	bh=hLC8S4UjRxIYU+w3I58E7dfWtG9L6rMU3nZ7z5FHGlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taNjSpUD3h47kZMtU8v1CPcHkD+6DMqR+nCAmWM1jFFR8pXkSLqje3g3425Em2c5l+xjDS3JZdv0CxZcXZ5TVPClTtF2ApmzUZMC2ZMb7WnQwFBncF4YaANJ9b/ElnS/6HTSpAHKofVmJFv/c0yLRD/0X5Z0e9fkEBd84Vip7rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ee1IR3hs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ee1IR3hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6C81F000FF;
	Thu, 17 Sep 2026 17:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666696;
	bh=Lg2Rw22kjg9ca5CE6THPZ7YpvQVj2OcEWWF2jvB/PMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ee1IR3hs6kDPTVFW5W7wJYpf7WA5PB48d2Nyzny1UIfRbC7aqhdCUuGdyDkbC9lhj
	 v3iDxk7mytgwX7T5pLTboUfD0eu1kKADLxtpX5ZM5AFfglOLri0KCxFNFDf5IhEe1c
	 hNboTs7M5q8Z2QAR+V0FMLnGTepUnthpqjvfZ+oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1123/1250] xfs: compute dquot checksum after resetting dd_lsn in repair
Date: Thu, 17 Sep 2026 16:15:18 +0100
Message-ID: <20260917151622.675281236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit de20f7014917d661afc03d9a1c157d0ae2775b49 upstream.

LOLLM complains that xrep_quota_block updates dd_lsn after calculating
the crc of the ondisk dquot.  That's clearly broken, so fix that.

Cc: stable@vger.kernel.org # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota_repair.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -365,11 +365,18 @@ xrep_quota_block(
 				ddq->d_rtbcount, &ddq->d_rtbtimer,
 				defq->rtb.time);
 
+		/*
+		 * This transaction operates on raw disk buffers, so we don't
+		 * have a dquot log item to assign the LSN for us.  Instead,
+		 * set it to zero so that log recovery will always replay any
+		 * logged dquot item atop this buffer.
+		 */
+		dqblk->dd_lsn = 0;
+
 		/* We only support v5 filesystems so always set these. */
 		uuid_copy(&dqblk->dd_uuid, &sc->mp->m_sb.sb_meta_uuid);
 		xfs_update_cksum((char *)dqblk, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
-		dqblk->dd_lsn = 0;
 	}
 	switch (dqtype) {
 	case XFS_DQTYPE_USER:


