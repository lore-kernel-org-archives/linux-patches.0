Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A3D1F8AF5;
	Tue, 17 Dec 2024 17:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455844; cv=none; b=eykD2HwAiXHA78a5i0qtVnDZbJn3eG/oar9CfwrLU3CyTVzxwBD2A0cURdeeRWkJoFuuNRA5wthSn7y3jnp46eN0hUhKlu/8OJFqk+pbMpDgMCEsEn5Fr/ThFDNcygDMTCWILwpgwj+UkUx5od6++tbibGBCTF/1h3JTK18PbRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455844; c=relaxed/simple;
	bh=Lj5TI1rZ0zc7E4JU+wJTgw3G6HBlPlkU1UoRIeKP5uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssb2fQ6vnVxkZ8mX3USWF4FlYNHHnHZXXEyPIbqivEZyuPwFThtmv0A0pHBk6CvHEjemlVVMJPEoYe0xp3YThz3lHADWD/bm3yzuglJO76inTbs+5oBPAsBk6h6gvvIqjJf4zDNJJOIaruGZSVSYQwqLMQqTM6aAbjKPSufomv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DX+WNO/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DX+WNO/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C384C4CEDE;
	Tue, 17 Dec 2024 17:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455844;
	bh=Lj5TI1rZ0zc7E4JU+wJTgw3G6HBlPlkU1UoRIeKP5uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DX+WNO/LGAbujtiq2OgCxvz89Jzt+7csnWcys7a7MFAHgUY7EGWPTrxo3mguVlQoy
	 lMuCholPgSmRRtHAfxQaUyc1jkPvGoDkjw9XcVADIzFZmqWhxH9kWJapabe8nmZp3q
	 ZFrffPKJkJQQBYKEULLR6Quo77w/RxaB69+NHQcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.1 21/76] xfs: only run precommits once per transaction object
Date: Tue, 17 Dec 2024 18:07:01 +0100
Message-ID: <20241217170527.136885799@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -955,13 +955,6 @@ __xfs_trans_commit(
 
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
@@ -972,13 +965,12 @@ __xfs_trans_commit(
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


