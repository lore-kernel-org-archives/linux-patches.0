Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02AB301486;
	Tue, 26 Aug 2025 11:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207691; cv=none; b=SCSXGowKFXX4/EKan0fYbltDJ97eARX0MflGwn4ylVrvdp4lOlhIA6RTsOIRawYQpo96LKHp95t1TjQSY9xjp0VRO/yqX3rzOLoMA8EQXmXsBJFvcLWVxVUeG/TZzGvakba//6P2UWdEUSSAQbS+jALqpeDf+Xcldi/K89IiYCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207691; c=relaxed/simple;
	bh=koGxRDutZl7ugCcbpodkIjN9KfQxSYS+3sq/0bAYizY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+K5MM7UhPI9hcHwIqkdaZwLWmppwvJ5lhVGHq7Vv8DM+rpewEOd44B0VDgF/cadjMLDl0kPj+VrUgV5y+6OKqTfksWhCcQZ+KI7TxF2ZOf9Y9gdRjme/z3PewAPkeRFK0iNa0gHpwusEHEldQChrYs5pLfAHZHhNaRT3IdxpsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyDrUQCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyDrUQCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88861C4CEF1;
	Tue, 26 Aug 2025 11:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207690;
	bh=koGxRDutZl7ugCcbpodkIjN9KfQxSYS+3sq/0bAYizY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyDrUQCcmje44I0Msab53QaQ7sEUGW8RmP9WUCgnWbVG52Djbscsb7TLyDmmpePiA
	 Te2MbdIwIZ7i1CgCkXEUUMaFhaqKNGsWv5mgEzD2xG1xC+irDmi5iJMvOxfB13RBm5
	 lnNA0eik0h8QQRVI8r9lKZg172TS67osuIspWUcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.16 279/457] xfs: fix frozen file system assert in xfs_trans_alloc
Date: Tue, 26 Aug 2025 13:09:23 +0200
Message-ID: <20250826110944.274037808@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 647b3d59c768d7638dd17c78c8044178364383ca upstream.

Commit 83a80e95e797 ("xfs: decouple xfs_trans_alloc_empty from
xfs_trans_alloc") move the place of the assert for a frozen file system
after the sb_start_intwrite call that ensures it doesn't run on frozen
file systems, and thus allows to incorrect trigger it.

Fix that by moving it back to where it belongs.

Fixes: 83a80e95e797 ("xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc")
Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -284,8 +284,8 @@ xfs_trans_alloc(
 	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
 	 */
 retry:
-	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 	tp = __xfs_trans_alloc(mp, flags);
+	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error == -ENOSPC && want_retry) {
 		xfs_trans_cancel(tp);


