Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4564E9C3A;
	Thu, 17 Sep 2026 17:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666667; cv=none; b=dmT0F48OCQHWHjfrmJRY7WJDguCVhLrOOCIHBikebVTO/h6gfDdM7tRloAkfvr4iodj9UUcnrXuQWLCZNsw9izWfTsRrsXNyySjMpkoNLxy/mjKk/4NnAD5BnW9141SzyQ1svjQLf0BHxqQQNHbhx5r8jwe+XxUc+zt7ELP0ilk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666667; c=relaxed/simple;
	bh=C2b9HW12lFMKctzLhac12dZaCETv40tCdY3jyNvu0IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzBklDXSm1y6eyoa4xqXqMBaI9Fq2i9yf5hfxxR1n9OEzqwAuRZj+S1QUIBkYtAH+Mq1vetU0w0OV21rqvM3c1a+Ttft7K/buRayqzvNp5oEvd2fdnmXBBfmyYUoWocFupefbCwVRO7O5sbi2lciE1BBVjfgUto3ZunBXmuxpg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2Zg3V23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2Zg3V23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733751F000FF;
	Thu, 17 Sep 2026 17:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666666;
	bh=wwFCqLsu2dh1kUxGMRC4bArdxkkebck2ibgDqOgfDis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2Zg3V23PGe6R6W14BMoP51EcbHpp7RNCwPFRogoRmzElG+SmF8/haOGgTtDRRBrl
	 +F3EFDRhUvQVbqvrmV5noB80lojYARJz4VBb9XMJ3YK7H+lo6Yi/EQMh+udArhI+O5
	 hSf0emthxqZPAvYZ61YUyRDQcntgJpRAQ3QwKvmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1114/1250] xfs: fix backwards skipping logic in xrep_quota_block
Date: Thu, 17 Sep 2026 16:15:09 +0100
Message-ID: <20260917151622.419821369@linuxfoundation.org>
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
@@ -327,7 +327,7 @@ xrep_quota_block(
 		 * If there's nothing that would impede a dqiterate, we're
 		 * done.
 		 */
-		if ((ddq->d_type & XFS_DQTYPE_REC_MASK) != dqtype ||
+		if ((ddq->d_type & XFS_DQTYPE_REC_MASK) == dqtype &&
 		    id == be32_to_cpu(ddq->d_id)) {
 			xfs_trans_brelse(sc->tp, bp);
 			return 0;


