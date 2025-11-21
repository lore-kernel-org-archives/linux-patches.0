Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A200190477;
	Fri, 21 Nov 2025 13:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731665; cv=none; b=Ph64PCJqyoRF/ag+ykY0/mXiYsUDHz1SiD2I/pu61hKEzBszOZCOcPHLzQJ9BGXDMKqWhtLqaSNnSwuuTge88Y1sl+dXoRJDM1iZ4kyNsElgAnPvwrgOzk7MWrP+z19SVz0ukNQAMl3RK9G3Q/wisk7kegJPpP3Xjv7FFD0fRJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731665; c=relaxed/simple;
	bh=sHaASRuJz3jerCzTL1RkCRv6L9O/6J3yxHI2NWNmhRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5r7FYuc2RxjsOY0Lzi9zYFT8Fafe6dqQydPG5moizEHlJhqK1tV6sgmhKg6l38e0T2SPecGswGV/4Cy78ZzCm/pTQbvDStwYuDbypbz+LK6xCL7pvA1U+gSMfRz/Bu6lMDEIz4CS65NajHaG88+I602+TbihRPwinJzDDEcSpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ms45BKcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ms45BKcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6CEC4CEF1;
	Fri, 21 Nov 2025 13:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731664;
	bh=sHaASRuJz3jerCzTL1RkCRv6L9O/6J3yxHI2NWNmhRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ms45BKcYpxBRTtV5xQEHKF50JJfeN8Hyu9ZjdvRh7Fu+j6m0uaop10rJm3DsDAOMx
	 t4+juFRTvR9gCGsJ8A6hNH8eubG9nNKd7Nm56hk6Zk3H6QcDcHHJ+y3hSea3SiHT5i
	 bNKx6s8gRsI8tqIErhXnhoYuHMlGLzlqMhhKo44M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	rtm@csail.mit.edu,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/185] NFSD: Skip close replay processing if XDR encoding fails
Date: Fri, 21 Nov 2025 14:11:05 +0100
Message-ID: <20251121130145.254116677@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ff8141e49cf70d2d093a5228f5299ce188de6142 ]

The replay logic added by commit 9411b1d4c7df ("nfsd4: cleanup
handling of nfsv4.0 closed stateid's") cannot be done if encoding
failed due to a short send buffer; there's no guarantee that the
operation encoder has actually encoded the data that is being copied
to the replay cache.

Reported-by: rtm@csail.mit.edu
Closes: https://lore.kernel.org/linux-nfs/c3628d57-94ae-48cf-8c9e-49087a28cec9@oracle.com/T/#t
Fixes: 9411b1d4c7df ("nfsd4: cleanup handling of nfsv4.0 closed stateid's")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 66383eeeed15a..e6b000a4a31aa 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5800,8 +5800,7 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
 		 */
 		warn_on_nonidempotent_op(op);
 		xdr_truncate_encode(xdr, op_status_offset + XDR_UNIT);
-	}
-	if (so) {
+	} else if (so) {
 		int len = xdr->buf->len - (op_status_offset + XDR_UNIT);
 
 		so->so_replay.rp_status = op->status;
-- 
2.51.0



