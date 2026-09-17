Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB584D17BD;
	Thu, 17 Sep 2026 18:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671239; cv=none; b=eYCAlsp0OF9niA0aHZqAw6fLxUWb++ZEu1X3gn/cDe86y35TnlWqX0B/G5V3Q4/YtpZj2coOYlaHo6ewUL8GRhpZ5s52PcXMBLq/MO3yx67Sm6WZxtdOd+6CLQ8w4HXYIL97q1xjdkkJ+vFZ7OSk8FHMM2MQbgyQNTpXSHXm/vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671239; c=relaxed/simple;
	bh=WBg0g9pKcUXTxapuvwmj3kG4jbcgqcMKiilHbTKXl+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USn39i/R53fzFk0mOrEVYg7vm8EZDmASuTnR57pBjS5FuKaPnMI2tsSpTldW7F4BjUG/Wg1Cux227dG2EWtdQ28Ea1pUx5JQM5cPlKYLDI2uA5JiJl8SDFoSg7J39l0WMF808XEPp09qRaiNzXlCCrSdscMokwaol5ZNOWgWNHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIhEv6o9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIhEv6o9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6841F000FF;
	Thu, 17 Sep 2026 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671238;
	bh=aT9eC5UcIKb+7mlBPtEKpk7JsQ/Yl4UkNPDbthxSmnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oIhEv6o9CtRltY+h8T3Hh+x4OREevfXcLjqcNv4SH9tnLTaJxOwpuO7bcNcYQfBo6
	 C6bxIhDLhBzvFs775GO7u93k+M/BuR9lf/Z2UX6rDJh0N4u2whrqH0Ch/oMX1r69+8
	 bkBgO5rgFmNPcIBaScIGqaxvusi8cTH0RXsTIJcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0910/1102] xfs: fix backwards skipping logic in xrep_quota_block
Date: Thu, 17 Sep 2026 16:14:13 +0100
Message-ID: <20260917151603.456924749@linuxfoundation.org>
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


