Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFAD523786;
	Wed, 30 Sep 2026 18:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793697; cv=none; b=QcHV0CDx3BeqA59CYQPeX0Wml20Skb67Qu7iHvotmsp+xWPNpuqFGLxoQXgptHtdXsYZIZNYD3ehAzoChaOrcX7kq6PSMe0r/zaxjmh7PTs4dAkwBLrEElzGVds0jk+DDgtf/BkpWdw900EWWX2cZW5MQUqb6u7JBaa7lfd3das=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793697; c=relaxed/simple;
	bh=nc97bt7dzdKpjfYGURMG32Lbzb3UDPaHULXDpOKNBnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3zLbLf9GnCrL/Hk2pVkW8MzI87+DJLrByRn/UooJ5mXD43Gm8r+rsSlj0g7jRcwoAEruudaY8YDB5EdO0Et9+wCAmW8XaTZ0zia9FgM+lwNSPaiSEd7zp36y99WQYBkXTHzVwZgfIsH89QCEJGUwGjUwn5zf0UCypkw3aDi4Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQ2ugVbj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQ2ugVbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFF11F000FF;
	Wed, 30 Sep 2026 18:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793696;
	bh=yaSRmTOW2nnkKTk1E5Fz7xM09s9ROE4gTwSo90kGDVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQ2ugVbjCY27FMtiY2vIF9c9kiCaAvyI491R8icwwRFMUAMKA0galnRcb8F1CozGu
	 QzRS0+vRbtNcsP7p+KeGvQ/EuIvdv6ljiNPxd6anobFXvTfCFIE9/BVJ+K97841YC9
	 cDxTmEs+OtX0WQSKY4CPIFTqAcqpHxdwvI7lO8X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 345/395] xfs: drop dquot flush lock when we cant find a buffer to flush
Date: Wed, 30 Sep 2026 17:30:07 +0200
Message-ID: <20260930152348.156578363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit ffb48dccce1960a9ea24463a2f3c21d124d6b672 upstream.

LOLLM noticed that xfs_qm_flush_one fails to drop the dquot flush lock
if it can't grab the buffer associated with the dquot.  Since there's no
buffer, nobody else is going to drop the dqflock, so we need to do it
ourselves.

Cc: stable@vger.kernel.org # v6.13
Fixes: ca378189fdfa89 ("xfs: convert quotacheck to attach dquot buffers")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_qm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1477,16 +1477,22 @@ xfs_qm_flush_one(
 
 	error = xfs_dquot_use_attached_buf(dqp, &bp);
 	if (error)
-		goto out_unlock;
+		goto out_dqflock;
 	if (!bp) {
 		error = -EFSCORRUPTED;
-		goto out_unlock;
+		goto out_dqflock;
 	}
 
 	error = xfs_qm_dqflush(dqp, bp);
 	if (!error)
 		xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
+	mutex_unlock(&dqp->q_qlock);
+	xfs_qm_dqrele(dqp);
+	return error;
+
+out_dqflock:
+	xfs_dqfunlock(dqp);
 out_unlock:
 	xfs_dqunlock(dqp);
 	return error;


