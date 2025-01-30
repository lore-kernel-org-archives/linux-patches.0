Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3651F1E991B;
	Thu, 30 Jan 2025 14:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247408; cv=none; b=Z0bv9dkdCUPCxGyMk7qH2eL4kJCzVBPl3V4kvWi/3W5Ue44w3+KNa6OkkLnyiwIrMXee7ttneKybnY9xKbk7BDVC93lrYRhyHTxZtJuQHmG91N/9ySXmu1fphCHeKzS7rfLF2lqPeTIycVmJoTppJ2CUUAccFkQM6th8LD8Hnog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247408; c=relaxed/simple;
	bh=O+zHP9S8wuHrpxle5Gl+YPEZy7rhQe4eyoHwQP/CV9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sg03TxMoNzbp2k+uSXa39nc2Dk+KEK45pMQAYGRuRiOraPBjMjY0mWXnyRsjyL+8ViIJAJlNhMwYdUfcoMGSIPwaUmeIwtVwfDgEvS9olUomT3s+DNLqxvPYzM73rfyUvu2xOluUuPjd8Ov9VoKXOzRAiLbTMD0CNdF4MeppMTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bail6BCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bail6BCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA6DC4CED2;
	Thu, 30 Jan 2025 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247408;
	bh=O+zHP9S8wuHrpxle5Gl+YPEZy7rhQe4eyoHwQP/CV9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bail6BCDfk6mTweK7jSzyyV7sWFhXkw13U/TM139XJeo/Tfy+J2TUuXlfmhKwfD2y
	 F3Es7VdQFU/b5W0eHAo0Soq7tbs27COWyUd6qq24iS5d9xL1jujzIYNJedlGgzODvY
	 wXdLQ7BbN8WDMXG8Pg4VHSXQN7h4eULi/GQ8A6xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 21/49] xfs: factor out xfs_defer_pending_abort
Date: Thu, 30 Jan 2025 15:01:57 +0100
Message-ID: <20250130140134.691316123@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 2a5db859c6825b5d50377dda9c3cc729c20cad43 ]

Factor out xfs_defer_pending_abort() from xfs_defer_trans_abort(), which
not use transaction parameter, so it can be used after the transaction
life cycle.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

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


