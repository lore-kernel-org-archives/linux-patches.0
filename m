Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0226D4C10EB;
	Thu, 17 Sep 2026 15:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660705; cv=none; b=O/2gi3G2Nf3NsHSWynabitJSbtz7XLjT9Z8bktl1h9EEcqE/cLLUuQlKkNCuw6V6Atbs+kLSXvp5eJGKhYxx66pSNObWkN/h1lYer6rRn8XUWn8Bqddgdy4mp26PVW8T0GUfMfvkjD4wQwcnidXUCbY72QgGmQz8Bs7DDOrSPTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660705; c=relaxed/simple;
	bh=p8A4brXaegj9D69iyde5VyTdfcG4+KEUFLrgFHbdPi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjCeIEbaZrpR0mU7cb749EuFe6rFv0OEwyc+K0pjdwj4rq228kMLf5DFoEq+cFzTtc61lOxkzfune+q5Gle8jDc5XoL/JIk5zqM96+doxSb1O58NarinXTaGwq7m8r4zpnzGUHvhQQaX9tjXfbpYRKJTjtWfnzkvdlk+ba3dCak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxkUtcFW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxkUtcFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA8B1F000FF;
	Thu, 17 Sep 2026 15:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660703;
	bh=lx2dwoRlUC4YkssHkambbVNhxn8hW4+kdCeGXIYnwxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxkUtcFWcd17yTrhj9k9T5u4aBX776pSwscpdjh+iKl8OrIq/YMi9qmSczbI0tbNz
	 KbUGTqSQg3JcevmitBK2HGrYC2zY9JV/3H76nSvLiIDXUzQp0zE6mRGNqbDLrdL6Wj
	 ocvEDs9etdE5mXWdBB1CjSx3JJ5crMMdd29GkA5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 681/733] xfs: compute dquot checksum after resetting dd_lsn in repair
Date: Thu, 17 Sep 2026 16:16:29 +0100
Message-ID: <20260917151409.741433141@linuxfoundation.org>
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
@@ -363,11 +363,18 @@ xrep_quota_block(
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


