Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793F63B27D8;
	Thu, 17 Sep 2026 17:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666593; cv=none; b=XDdR3P4WZ+LQxRYszMNubLfs6d0aFFa7mMhyMBe1aFSNDZNxlBC59fHByjQlKh7UmsZ2QAk04UlS4LZRmwYH7hCe6/LfUw+yvDKc+L20BkRZ8bECd3HILWyuRsU+xn81fHDYIJPx13ovkd6widZyrbve34ncJDyJxTqr6p5JiWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666593; c=relaxed/simple;
	bh=X873NFkCBLFkTJkvYoUWUN4s2yeBR62MZPZCRnXfrpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1etXm09bQqD52Z3DGWVrOJ3K3gQMCyXn8pOUtLDXbYOY8NtGyAa6a0QI2Rb0LiumgseYLaZYiTjF1LFMSO0jbv1bgBlX4RW+AUPboZzk48jKoHAmnQ401OdEb5nXTMIS65j9IJ5NW4F2bE946siT9u0dDdxjZXqU+3PszBCpa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eapMM//m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eapMM//m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03A01F000FF;
	Thu, 17 Sep 2026 17:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666592;
	bh=8OFTb6eIqtwTrejyb1d8PnViIHLYSDXOp/6EJxqH4pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eapMM//mTAMGoTRDxhOaxBcW6ebzfhbxR4gXpcRBRmc17z/c+xslLhGBzQoISMhBf
	 I4ES8yPeFeUqVJJ3KttrUxGzTZtrG/5wAvHWJPNIguoVvuIczCbAcgSxotUKAhNv+0
	 DKn7adkCu8YXfXVMDnmOowgc8Hq7fACx+2vMG/fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1089/1250] xfs: truncate quota file correctly when repairing quota file
Date: Thu, 17 Sep 2026 16:14:44 +0100
Message-ID: <20260917151621.675663308@linuxfoundation.org>
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

commit 0fc67528f54bb91dac22093749b425207c0fc245 upstream.

LOLLM noticed that xrep_quota_data_fork screws up the unit handling when
it computes the offset at which to start truncating the quota file.
max_dquid_off is the file block offset containing the highest possible
dquot, and xfs_bunmapi_range takes the starting file block offset.
Therefore, it makes no sense to multiply max_dquid_off by the blocksize;
all we need to do is start truncating at the next block.

Cc: stable@vger.kernel.org # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota_repair.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -457,8 +457,7 @@ xrep_quota_data_fork(
 
 	if (truncate) {
 		/* Erase everything after the block containing the max dquot */
-		error = xfs_bunmapi_range(&sc->tp, sc->ip, 0,
-				max_dqid_off * sc->mp->m_sb.sb_blocksize,
+		error = xfs_bunmapi_range(&sc->tp, sc->ip, 0, max_dqid_off + 1,
 				XFS_MAX_FILEOFF);
 		if (error)
 			goto out;


