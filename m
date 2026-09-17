Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F51849D59C;
	Thu, 17 Sep 2026 18:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671261; cv=none; b=IFkSQgvwLlIBvGbkHw/Gf0Be9KvNA+Fb4HLhkmfFxxFMr4w2fsMIJs6Ks83ZF86uDIqajJS3zjkxLVx4eiXsEkJRNmkscry9dzEdYXtVE9qexadgS1ImnuX4mXt8OmyFW7I1Fpy7zg6z3zQFiGra7JN5l9Ghyfv8b4pwJewOrwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671261; c=relaxed/simple;
	bh=PQLFCd/QwG/QWD2FfR547DZspFRrcT0+jV0xi1bLZnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kP5broUd6Jf47KtPHULmq87myDgiPUqcZkeVx4gVcOnWHkh76J9OzP7AxMQ3BxqApd4kwdon66KZ3mvxQ9DX/QGSb9P+MDRpnvT0JoCDbqz5hkcjrxa+0vFkjMYpozQapPMyEXZKqpc6pewT+seqj1VBgT0JuUl6jcQ2wl15yyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGi9nZWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGi9nZWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736681F000FF;
	Thu, 17 Sep 2026 18:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671260;
	bh=XK6E6PVA0U5uMP8VnIof7NV5xux+0+4bJ/IkwmEsMM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGi9nZWiSgSTf82pGmV3zGXAZZ2vizgmLIfXUGGmxPVftVlHqe8plp3nTErexdIAB
	 vlEzsJgvJployd/Na1j2gl/47stk7KhvCBtKZdOtp9mQgooTYMzwFhDyfl20EDcQfC
	 xWKF2EssDtsDhj8KOHszESowczACrsMrZ9R8BlO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0917/1102] xfs: compute dquot checksum after resetting dd_lsn in repair
Date: Thu, 17 Sep 2026 16:14:20 +0100
Message-ID: <20260917151603.647893942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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


