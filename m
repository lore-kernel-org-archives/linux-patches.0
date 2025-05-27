Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B196E255E26;
	Tue, 27 May 2025 16:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364431; cv=none; b=ZJhM2SVC8drLmhCCbsAP1x4dfMSopp31OBqodLfwKWPikeF2ts7STt6LobRQn30c+cVjRVYMC7bCF+xqLoQJ4/OQI5YtEiuNE20puPMgMDSRtceSE+jrspWc9QCp2k+00VqX8UfFfELDijLJH0CYBjqtgt3OyB3PjqY3ZsxCBgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364431; c=relaxed/simple;
	bh=JFRW+y0x8gaDmOE/NlZ4kKA0xRoO6E0+8OrvicC5vQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTCDJbV5KSXB5qDyRABqiBYSvzNJZZWkA4tHe9H5joXkrY9ePvGh/2ILa553WvyPAuhK6dKL4biRscaIIX5S9p493/bOCGbuZeMt+ObxO4SOGuRwyJO/moCaYpE15xi05Ol4wAgCL/+LlB/LRvz89cgi3N311Xz2CFIVlTB8ldU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbnzZHk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbnzZHk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374CEC4CEE9;
	Tue, 27 May 2025 16:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364431;
	bh=JFRW+y0x8gaDmOE/NlZ4kKA0xRoO6E0+8OrvicC5vQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbnzZHk4uVLVPBmSgseTAeAbBhjjzNnUh6sP2GPQdI5/lzAA2dRY07ly4qviFmM7n
	 5wBxsOCXav4w54dncb0I5R+CDZwxQwY3jfNFOITXVsC0qriazj5Qtj3rEZo8TM1bu8
	 lEs4g/ar/usHkAdGtiTn9CNW1JqNBZAJaUj8sxqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/626] NFSv4: Check for delegation validity in nfs_start_delegation_return_locked()
Date: Tue, 27 May 2025 18:19:07 +0200
Message-ID: <20250527162447.254688475@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 9e8f324bd44c1fe026b582b75213de4eccfa1163 ]

Check that the delegation is still attached after taking the spin lock
in nfs_start_delegation_return_locked().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/delegation.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 325ba0663a6de..8bdbc4dca89ca 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -307,7 +307,8 @@ nfs_start_delegation_return_locked(struct nfs_inode *nfsi)
 	if (delegation == NULL)
 		goto out;
 	spin_lock(&delegation->lock);
-	if (!test_and_set_bit(NFS_DELEGATION_RETURNING, &delegation->flags)) {
+	if (delegation->inode &&
+	    !test_and_set_bit(NFS_DELEGATION_RETURNING, &delegation->flags)) {
 		clear_bit(NFS_DELEGATION_RETURN_DELAYED, &delegation->flags);
 		/* Refcount matched in nfs_end_delegation_return() */
 		ret = nfs_get_delegation(delegation);
-- 
2.39.5



