Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A981AA1F4;
	Fri,  4 Sep 2026 05:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498737; cv=none; b=pubJVSaHJxW3jia+Li7yS+6tnWOstph3GKHVgdTvzbFMfDbPYwcDY53ZMy/jTujDJKWKk3IJ/UFD8IEU02gOklY3Ar34zuZWsYOWStJdv3oiDF8UNZkTkDS8PYLy190X8W1MrRzp+PC2CkI5IJvyT8KK5eZzJaJ8/FjWWHu3tQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498737; c=relaxed/simple;
	bh=hI5mnBn1mDL4FFdXoIR1QBNBbcSigdgcmyDjADrW5Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZI7Wb9K3AwyVdShweIV8+nrF5m+NKMVe8PhAxgFpyWZ6sQeK1oML2BEsjPl1E4RR7A8c1fC7501y7HTIJuXt9AW/pNV1nV+NdApWAeS7O0ArGXVUAiPll+fuOmU1E0MavC9ut5AoKW362YoTf+Wfw7rbxypU157eOzzwLjetLa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkjbfK8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkjbfK8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4431F00A3D;
	Fri,  4 Sep 2026 05:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498736;
	bh=Sw/M40p1B2tZ0PyKLX7hz7PqDvR/eUrugd27xk5QVT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkjbfK8V4wLeeE5zZFSioUUG6rz5kUMfM8mzlQpD76ehBPJpP6rfY7u1NCzwuKdt3
	 lzFcV9Nokhi5FkEzqf2zDm6HYkendQieg3zl9UncKbtPXKRmrz7LysGwmRiIMT8lle
	 BoBsRrafem1PITJ16eZ9KEY70+dyk77MEIGHE9VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 167/713] nfsd: clear CALLBACK_RUNNING on failed delegation recall queue
Date: Fri,  4 Sep 2026 06:52:15 +0200
Message-ID: <20260904045807.564783199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit b036727d334b1b7cd4c1f1fba3b59ba93a6bbe96 upstream.

nfsd_break_one_deleg() sets NFSD4_CALLBACK_RUNNING via test_and_set_bit
at entry to serialize recall work, then calls nfsd4_run_cb() to queue
the recall.  When the queue attempt fails the refcount bump is undone,
but the RUNNING bit is left set.  The only site that clears the bit is
nfsd41_destroy_cb() (fs/nfsd/nfs4callback.c), which runs from the
workqueue and is therefore unreachable when nothing was queued.

The bit becomes a permanent latch on dp->dl_recall.cb_flags: every
subsequent break_lease() on the same delegation hits the early-return
guard in nfsd_break_one_deleg() and silently skips the recall, so the
delegation is never broken and the conflicting open or lock stalls.

Fix by clearing NFSD4_CALLBACK_RUNNING on the !queued branch alongside
the refcount_dec.

Fixes: 1054e8ffc5c4 ("nfsd: prevent callback tasks running concurrently")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-cb_recall_any_callback_running_stuck-v1-2-310011a028f3@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5616,8 +5616,10 @@ static void nfsd_break_one_deleg(struct
 	refcount_inc(&dp->dl_stid.sc_count);
 	queued = nfsd4_run_cb(&dp->dl_recall);
 	WARN_ON_ONCE(!queued);
-	if (!queued)
+	if (!queued) {
 		refcount_dec(&dp->dl_stid.sc_count);
+		clear_bit(NFSD4_CALLBACK_RUNNING, &dp->dl_recall.cb_flags);
+	}
 }
 
 /* Called from break_lease() with flc_lock held. */


