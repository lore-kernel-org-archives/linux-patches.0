Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8983D1EF085;
	Tue, 17 Dec 2024 17:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456486; cv=none; b=VwVlZSrGzc6k2XB6CBFERGhvz3LuPKVEul+cf51nGNkRiIvaZa+Z9PJSlMqASlIcJzItk8G5mO4RPsfDNjmWAhBBZdNGKAXmnmnPnVahycoueiaN+29+QwR2pGbqBOq3X50VR7jvInbcrDikvq1Am6MDOqqlX6VyUpcp+GEYWJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456486; c=relaxed/simple;
	bh=mr3ZbEjnR0xmim4ZGdX6N3fh1qZvao6bHRJ6jw561TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8FdCuWzU2mR8umeCwYIZmzY7Jm6OdpA0dl/WqEmvsIIcU6jkA3dtYlkZZLfXWJkQfHxszZyYYAziRKdlduJBHoXIVmilu7Cr7Pf0/Fsn401LoFQIxcQerLVoxpvmUE3TxvWIAeT1sayOsnWr6BL8U6GyM4Dc8gzdrueDKb+0Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrycHGxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrycHGxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10343C4CED3;
	Tue, 17 Dec 2024 17:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456486;
	bh=mr3ZbEjnR0xmim4ZGdX6N3fh1qZvao6bHRJ6jw561TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YrycHGxFNnhPDcXPDmYBwVfCjH57ha4+2Tf8RPT5qSKaLX7C8BmiGWr7cIxJlqBa1
	 hcmfyDeprV/CCbsIjlVDE7AA7Uu9WLd0rTlgeWdmhq14FjPq5+s4x+K4q7vr4YTP46
	 qr0+ier9Dyt58VfYXdblssEl5maqztfjqyflPflY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 074/172] xfs: only run precommits once per transaction object
Date: Tue, 17 Dec 2024 18:07:10 +0100
Message-ID: <20241217170549.357524722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 44d9b07e52db25035680713c3428016cadcd2ea1 upstream.

Committing a transaction tx0 with a defer ops chain of (A, B, C)
creates a chain of transactions that looks like this:

tx0 -> txA -> txB -> txC

Prior to commit cb042117488dbf, __xfs_trans_commit would run precommits
on tx0, then call xfs_defer_finish_noroll to convert A-C to tx[A-C].
Unfortunately, after the finish_noroll loop we forgot to run precommits
on txC.  That was fixed by adding the second precommit call.

Unfortunately, none of us remembered that xfs_defer_finish_noroll
calls __xfs_trans_commit a second time to commit tx0 before finishing
work A in txA and committing that.  In other words, we run precommits
twice on tx0:

xfs_trans_commit(tx0)
    __xfs_trans_commit(tx0, false)
        xfs_trans_run_precommits(tx0)
        xfs_defer_finish_noroll(tx0)
            xfs_trans_roll(tx0)
                txA = xfs_trans_dup(tx0)
                __xfs_trans_commit(tx0, true)
                xfs_trans_run_precommits(tx0)

This currently isn't an issue because the inode item precommit is
idempotent; the iunlink item precommit deletes itself so it can't be
called again; and the buffer/dquot item precommits only check the incore
objects for corruption.  However, it doesn't make sense to run
precommits twice.

Fix this situation by only running precommits after finish_noroll.

Cc: <stable@vger.kernel.org> # v6.4
Fixes: cb042117488dbf ("xfs: defered work could create precommits")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -834,13 +834,6 @@ __xfs_trans_commit(
 
 	trace_xfs_trans_commit(tp, _RET_IP_);
 
-	error = xfs_trans_run_precommits(tp);
-	if (error) {
-		if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
-			xfs_defer_cancel(tp);
-		goto out_unreserve;
-	}
-
 	/*
 	 * Finish deferred items on final commit. Only permanent transactions
 	 * should ever have deferred ops.
@@ -851,13 +844,12 @@ __xfs_trans_commit(
 		error = xfs_defer_finish_noroll(&tp);
 		if (error)
 			goto out_unreserve;
-
-		/* Run precommits from final tx in defer chain. */
-		error = xfs_trans_run_precommits(tp);
-		if (error)
-			goto out_unreserve;
 	}
 
+	error = xfs_trans_run_precommits(tp);
+	if (error)
+		goto out_unreserve;
+
 	/*
 	 * If there is nothing to be logged by the transaction,
 	 * then unlock all of the items associated with the


