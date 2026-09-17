Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7146C4C33D3;
	Thu, 17 Sep 2026 18:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671193; cv=none; b=huzKyR1aLFLva7NniIf4A1FVLkmgkqlySOhzRD72gyMjbSm2ngFibI0lC7PGFue9Pk/ZiguyJ5r+H7l2XTXbqRVHegbCTKn2bhDPYEIinWqhybK+Shn7LmF621zGFGW5UOfBf6PE1P67GTfXzIqmMEp9lLkC1YwTMKLXQjg7bq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671193; c=relaxed/simple;
	bh=hCbfcpbpWGVV+fbuRTIUbNFrMTcw7V7xqsS9csr//UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xw1Nx8plDV7Rx7x9HU6DsWbTxfHLHomAvj5Ih+TccRLAjk5thksl43QCIaaZeYHM83dbHVPhkIdbelsP8BFH8NOpfg/Z0/gjFYiFeMJFjf1VkMGYhQyfow4TWETo+DgQy72A3+xtiDeDczSWRWdu5mx03CWrLG0VdImNbrndgm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02akiAWj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02akiAWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E4E1F000FF;
	Thu, 17 Sep 2026 18:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671192;
	bh=ZPDWee84tHczW0sOHGwU1kcgosip7nuyaq8P05Ysub8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02akiAWj0r8hse28je6L4U8HCgIknTFQplccwvIsl9p+PgDyFLcE7ExCR7i9P7Qi5
	 7STtrwRRP8v0mgMB8gRTNFYAg8UY/bWkce5bJwKm0EZwDAbp1wSNtQudiBtII5S9wH
	 YgocIAjuLUdaeKGWJcSsumuZYP7ui81G3decFlHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0897/1102] xfs: truncate quota file correctly when repairing quota file
Date: Thu, 17 Sep 2026 16:14:00 +0100
Message-ID: <20260917151603.110592360@linuxfoundation.org>
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


