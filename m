Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABE74C10EC;
	Thu, 17 Sep 2026 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660673; cv=none; b=LJD77xQ/depz6fwZy2m5g7ov0XfWCrpTCGTcRMWJcVzIoO0cNAx/uuVTAjHKCF1wwa3Bla5DxKx8AH4QaofgNBfsGpvLPndcWWgxUstXow46lLtqiftjV60rd61Kpvjyu46GKNi46OBzFOGFwQMV3mRqcqh0d40JUCurF85Sji4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660673; c=relaxed/simple;
	bh=nPTRbxuu0hS8tzXYezNHM4DfUDNCzFx8PryWl+KswI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0tCkDRHjkzcms3WyaKtpLXcocMKN20OdFU4CXRuJ2QARJL7EnOmIci/L1pG7QeUR389H8VTaodSnzCy3ZaxPR5q5uQRnK+tHPRvoxCwY7Ko9oLrtvPb2UC7/tucos4LeRiIhj52f1vNVeaHsgtpbhbthqb9zeTj1gHqa2S37IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGfIiPD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGfIiPD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD04B1F000FF;
	Thu, 17 Sep 2026 15:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660671;
	bh=2YQ0CiZLLTaYVJ6Jn9a2hPB5q16RH+q75K7IxObIHFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGfIiPD25ChD1gQW0qmgn2UoGIalzFtyni2SFDMn7plJjps9MdXLmu/3SrvkOxYYG
	 aMLOW8J4Oiy/qr5bxynjmlAyeEOHvp/pRphvGLFw3aQbdMqIHO6hKIsX+XDYrpKtcx
	 jUHFtF1RTbUiwr9aw0KSrm+qldeV4UO+G2hKukcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 671/733] xfs: fix backwards skipping logic in xrep_quota_block
Date: Thu, 17 Sep 2026 16:16:19 +0100
Message-ID: <20260917151409.440754883@linuxfoundation.org>
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

commit d7f97be48cbe3751e44a45373c0e91e93b976f98 upstream.

LOLLM complains about the logic in xrep_quota_block that skips
reinitializing the ondisk dquot if there aren't any problems that would
impede a dqiterate walk later.  I got the type checking logic backwards,
which is the source of the problem.  Fix that.

Cc: stable@vger.kernel.org # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -325,7 +325,7 @@ xrep_quota_block(
 		 * If there's nothing that would impede a dqiterate, we're
 		 * done.
 		 */
-		if ((ddq->d_type & XFS_DQTYPE_REC_MASK) != dqtype ||
+		if ((ddq->d_type & XFS_DQTYPE_REC_MASK) == dqtype &&
 		    id == be32_to_cpu(ddq->d_id)) {
 			xfs_trans_brelse(sc->tp, bp);
 			return 0;


