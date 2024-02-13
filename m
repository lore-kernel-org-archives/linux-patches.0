Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CCF60241;
	Tue, 13 Feb 2024 17:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845250; cv=none; b=bFELrRmuPtU14jcvUmxPDmK1oLX8hhNA4fJdefQEQ0JVUSNXDNsEEMIX4VNtazn7P2DM9Hb/Z3AIVSIC4yzKdIOZuc+MeLtDH0uUd4AMra3ENyYlrixxg3tT/cAbGlX2fDx7rKruF6Xw6LpaCk73VofbfE4R5U0m2QNSLF2+YPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845250; c=relaxed/simple;
	bh=Tja3WL4hwf9REFdFMI8Qz4wec3l9XCF7zdG68txrtHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7x6/+rE4tUQQN8VXTgh7LXHbitX4B3+tNlavVoJHjMajgjm+zQR+c+JnRiR/5Eu3HdTcSOSQIBY/i+vq2kosJdR0aeIZRHASUiujimpai9kHb4cebpPNnaGL+L/QY5EALSyBt9GSDticRE57dJSsEoCWgcftIEPJ0wbAhEIMFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VGtJYdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VGtJYdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B500C433F1;
	Tue, 13 Feb 2024 17:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845250;
	bh=Tja3WL4hwf9REFdFMI8Qz4wec3l9XCF7zdG68txrtHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VGtJYdjPddTT0TUhTOZxq8c8Zu+2oi1oM7zef/tV699pXzCjkhqSM0MemwKZhxJh
	 OnmMLwiLqpTpY9CA5GY8vEGy3oHm+gbweItXJPNwugaJS1J0Z1XX/hBmzf9BhWgXU1
	 olLOYsZrJByV+01w1FQU8wZ8J7afPKC0Uw+hfcmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/121] xfs: factor out xfs_defer_pending_abort
Date: Tue, 13 Feb 2024 18:20:36 +0100
Message-ID: <20240213171853.768352112@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

commit 2a5db859c6825b5d50377dda9c3cc729c20cad43 upstream.

Factor out xfs_defer_pending_abort() from xfs_defer_trans_abort(), which
not use transaction parameter, so it can be used after the transaction
life cycle.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index bcfb6a4203cd..88388e12f8e7 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -245,21 +245,18 @@ xfs_defer_create_intents(
 	return ret;
 }
 
-/* Abort all the intents that were committed. */
 STATIC void
-xfs_defer_trans_abort(
-	struct xfs_trans		*tp,
-	struct list_head		*dop_pending)
+xfs_defer_pending_abort(
+	struct xfs_mount		*mp,
+	struct list_head		*dop_list)
 {
 	struct xfs_defer_pending	*dfp;
 	const struct xfs_defer_op_type	*ops;
 
-	trace_xfs_defer_trans_abort(tp, _RET_IP_);
-
 	/* Abort intent items that don't have a done item. */
-	list_for_each_entry(dfp, dop_pending, dfp_list) {
+	list_for_each_entry(dfp, dop_list, dfp_list) {
 		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_abort(tp->t_mountp, dfp);
+		trace_xfs_defer_pending_abort(mp, dfp);
 		if (dfp->dfp_intent && !dfp->dfp_done) {
 			ops->abort_intent(dfp->dfp_intent);
 			dfp->dfp_intent = NULL;
@@ -267,6 +264,16 @@ xfs_defer_trans_abort(
 	}
 }
 
+/* Abort all the intents that were committed. */
+STATIC void
+xfs_defer_trans_abort(
+	struct xfs_trans		*tp,
+	struct list_head		*dop_pending)
+{
+	trace_xfs_defer_trans_abort(tp, _RET_IP_);
+	xfs_defer_pending_abort(tp->t_mountp, dop_pending);
+}
+
 /*
  * Capture resources that the caller said not to release ("held") when the
  * transaction commits.  Caller is responsible for zero-initializing @dres.
-- 
2.43.0



