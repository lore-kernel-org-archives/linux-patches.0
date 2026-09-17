Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0C13B42E3;
	Thu, 17 Sep 2026 17:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666634; cv=none; b=JXu//+sumtY/PDlO2FxNrwS96WbUb59PaBoeawSP5dd4B2ZY97bEHLmYbg6NeE9iT7xjrpNILTLJCfCmcrtkNN8RSQWg/92mN3DxvcFtayoKtRKAMLqRFxHv31ZfJqbf6thLaLxaRuOJCmVV4fESikK7dXsJjFCBgzuiod/6zk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666634; c=relaxed/simple;
	bh=y7sHaA/Fytx18rSu7ZOACOijEUthf89281HMUDvbTYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qp0Wbnts8PFZLuOJ6UoEVVrH5VrBg9SSh42rhYNKdf2Sp3c2EL8F1Symz5OOsfDABiDR8BAdH2deE+Zu65ZyS2mFc7Mw6Gw1WeNrMZOmH1Zrz7ClMwx4ph0O+co9hOf747H0s+5RTdqKM874Ly3BVy0ifca2/nDhOYapt0HH/I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdGfpz9c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdGfpz9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF181F000FF;
	Thu, 17 Sep 2026 17:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666633;
	bh=qmF5QCnoSCfEgRmXX+swRn+2Heg2T2MlwbrSgnO31sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qdGfpz9cur/x8zfFhdUsX0lYhTk4ovma1GTCXO7u9bDqbYrOf8a0KpORUzk/3Um8B
	 AjOk5P1qIZ8uqOeB5x9KlKCFno+UCd/sHh1SKee9ZVYdG1/c5jycAoxfH6DgU0bnLY
	 0w2dtJZI2VanwYcsEsLyb0FfVGN2Y6y4pQqE5I8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Tia <floss@jetm.me>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1101/1250] xfs: initialise error in xfs_defer_finish_one()
Date: Thu, 17 Sep 2026 16:14:56 +0100
Message-ID: <20260917151622.023243552@linuxfoundation.org>
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
 fs/xfs/libxfs/xfs_defer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -583,7 +583,7 @@ xfs_defer_finish_one(
 	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	struct xfs_btree_cur		*state = NULL;
 	struct list_head		*li, *n;
-	int				error;
+	int				error = 0;
 
 	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
 


