Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC7726B080;
	Thu, 13 Feb 2025 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458434; cv=none; b=BqkqFWOHIlRHSvv4bMkwShxToB63UbCUS/7s9No/IgWyFMZoeW+GkKYP/7us+tvz5q3bvKi0G5eJWdFK7ECc9UXG6pxWFIfVwW5Gbz7jhSd4kCV9LtFmMNo6dE5akC3zjhACZu9rf7HM4Kc89zTYr5HjZ7/6UwDn7xxTnI49zVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458434; c=relaxed/simple;
	bh=kHvJ979pXd4MzSLTrRv1LX/QsADdYbMpYDsezPPksvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/hCoVS1lzbmhBFF69o340pvOImy332G/BxYDljp26JoRsl5ikb5VMyWQbizGZLBZKpyWo4nP8XhJRYUMeIvRYuHENCM5h5f3Zjn/zedZAImEOOJvOFkS5iBeD7i103g3xHYNuj17D2mVg/mGLRvxxRCuwBeyZbgvmNTid5k1zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhbyfC1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhbyfC1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43566C4CED1;
	Thu, 13 Feb 2025 14:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458433;
	bh=kHvJ979pXd4MzSLTrRv1LX/QsADdYbMpYDsezPPksvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhbyfC1/v+Xl5XxanB1un0Bj5JK430hyzFaeCp9wI8bgQFXwI8zK6s9nYfCkBV6kT
	 etOWgP3GKVCDBRN4DO2BxRrhzQSsxCizFzYrNQh12qtHK+c9UuO/78LmddUML0JNPn
	 YtpSgM9sJ41ZiBhgeQdGNtp+c/Ltiv7aVQbOWCUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 397/422] xfs: avoid nested calls to __xfs_trans_commit
Date: Thu, 13 Feb 2025 15:29:06 +0100
Message-ID: <20250213142451.865817592@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit e96c1e2f262e0993859e266e751977bfad3ca98a upstream

Currently, __xfs_trans_commit calls xfs_defer_finish_noroll, which calls
__xfs_trans_commit again on the same transaction.  In other words,
there's function recursion that has caused minor amounts of confusion in
the past.  There's no reason to keep this around, since there's only one
place where we actually want the xfs_defer_finish_noroll, and that is in
the top level xfs_trans_commit call.

Fixes: 98719051e75ccf ("xfs: refactor internal dfops initialization")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)


--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -834,18 +834,6 @@ __xfs_trans_commit(
 
 	trace_xfs_trans_commit(tp, _RET_IP_);
 
-	/*
-	 * Finish deferred items on final commit. Only permanent transactions
-	 * should ever have deferred ops.
-	 */
-	WARN_ON_ONCE(!list_empty(&tp->t_dfops) &&
-		     !(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
-	if (!regrant && (tp->t_flags & XFS_TRANS_PERM_LOG_RES)) {
-		error = xfs_defer_finish_noroll(&tp);
-		if (error)
-			goto out_unreserve;
-	}
-
 	error = xfs_trans_run_precommits(tp);
 	if (error)
 		goto out_unreserve;
@@ -924,6 +912,20 @@ int
 xfs_trans_commit(
 	struct xfs_trans	*tp)
 {
+	/*
+	 * Finish deferred items on final commit. Only permanent transactions
+	 * should ever have deferred ops.
+	 */
+	WARN_ON_ONCE(!list_empty(&tp->t_dfops) &&
+		     !(tp->t_flags & XFS_TRANS_PERM_LOG_RES));
+	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES) {
+		int error = xfs_defer_finish_noroll(&tp);
+		if (error) {
+			xfs_trans_cancel(tp);
+			return error;
+		}
+	}
+
 	return __xfs_trans_commit(tp, false);
 }
 


