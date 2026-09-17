Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1C04CDDD1;
	Thu, 17 Sep 2026 18:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671220; cv=none; b=e7jzCssJTF4XSAaQdzUQ1+H7WvOOv1UPFmIi9PrZ2QuBXm4oYVRg4r9H75/diy8flf/rQgdFHcileVT3KBV09e7UsQI2ycCMTwpTG1hj3Mku7A8YM/Z9SIQpAiMn/BUAbr5fyeK2o/Q8wdniy1jY7rD1dU3tiBSBBNVof/Y/btw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671220; c=relaxed/simple;
	bh=tJasTcEXFAhT2zIni/6V8q5ze1TfGS9LoLHsr9T/EF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prG3pqPkxNSgWZrPHrYQEh51W1MgK72eXHiFmGehv9ERGNpiprxnR9nS9Y18smpUG0pGh2ZynAK3GolqwmVkaOUeRsdirGtHvo/gGVYoxRiKuKefOwfwjhQ86c9N46u5qGZk1vJR+8q3uy9ADCUaF19nvK/qlb1GTjHqtCedZbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZIDRHo3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZIDRHo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121C61F000FF;
	Thu, 17 Sep 2026 18:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671219;
	bh=RnhjsSL+SAkcVO9GO9SXqxVQa3VtoOMWVFZ50YBffTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZIDRHo3vlDNpB3zmTXIEf7AK3bvUBuIdfMNm8xLlL8MuYDDBxsrSxI1ADl0e1AdH
	 YmxjNN4/MTi0+ccFEjcTEovIfsf6s0bqwZG+MIaVuEaSwqiTafEXCXPUknCeZ61TI0
	 4o+xlp7mbpv/I5jqOskeDxbWXdiMfqgmRKId2EN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Tia <floss@jetm.me>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0905/1102] xfs: initialise error in xfs_defer_finish_one()
Date: Thu, 17 Sep 2026 16:14:08 +0100
Message-ID: <20260917151603.326101894@linuxfoundation.org>
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

From: Javier Tia <javier@peridio.com>

commit 6176d21d7bd609632c5b7e87a3adb9be29ec1e72 upstream.

xfs_defer_finish_one() declares error without an initialiser and only
assigns it inside the loop over dfp->dfp_work.  When that list is empty
the loop body never runs, control falls through to the "Done with the
dfp, free it" path, and the function returns an indeterminate value.

An item-less pending item reaches this through xfs_defer_add_barrier(),
which xfs_reap_ag_blocks() uses on any CONFIG_XFS_ONLINE_REPAIR kernel.
xfs_defer_finish_noroll() treats any non-EAGAIN return as fatal, so a
non-zero stack value turns a successful barrier into a
SHUTDOWN_CORRUPT_INCORE in the middle of a repair.  Zero is the correct
result: reaching the free path means the item loop drained without a
non-zero error.

Fixes: 3f3cec031099 ("xfs: force small EFIs for reaping btree extents")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 89501e8bd2f8..843c33304441 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -583,7 +583,7 @@ xfs_defer_finish_one(
 	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	struct xfs_btree_cur		*state = NULL;
 	struct list_head		*li, *n;
-	int				error;
+	int				error = 0;
 
 	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
 
-- 
2.55.0



