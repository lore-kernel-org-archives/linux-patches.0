Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4A15187C2;
	Wed, 30 Sep 2026 17:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788011; cv=none; b=sT7kCo2ynEMN8mfJI+CWlNlivEg3vYa1F+sqWMqDi3FhjtJQ2o5U+7OZ1ch39ND8xhVG80Y0POITWtaLTtspg5AktB6SbaKoi7Y3XUQY9/QHoABAnShfFlyjuGq39c5NUthspi+7Yk8Zch02+qsb2DZepRlgcUfYkSRAx0H+/wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788011; c=relaxed/simple;
	bh=/pkglt/q8w1vrNMQOI5HJV5bM5zkySizvjv5NpMfbDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upkIC+W/1RRd1z/3huMZjDzCdB/jd5msJD1U+/HC6+EYyx4JV88nFPaSRp9CZ33nnxPrqqm3p/OtgYkPfjDm/nsEDdZS789ui6NoIQuItr+eOClBG3r+bRn7gkbFztsKf4Gr1KQM4g30YB4SBlJ2pP0bzbXb2cOmKwZwjPP9aJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssrSHtbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssrSHtbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A541F000FF;
	Wed, 30 Sep 2026 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788009;
	bh=zcxqBEn4T4VTdJGWkL8bj2Kb43qdHJiBZgqheITnobM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssrSHtbWkoZSost60fRSto6L0Ui2P2ITiKSiMgTg3dTlNQQmrxqRUSiqRuEFMTijd
	 qeEEcQhW7QtdeZEA8oiqQXliJOT1wAka3NaiYj7rYZkvE+Ulh3w8TfeZU3ywMEOQ6/
	 YuCFPfePlABnb9itogNPDylhOeznH+FjKkD8xmsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 431/457] xfs: drop dquot flush lock when we cant find a buffer to flush
Date: Wed, 30 Sep 2026 17:28:56 +0200
Message-ID: <20260930152355.293984652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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
@@ -1432,16 +1432,22 @@ xfs_qm_flush_one(
 
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
 	mutex_unlock(&dqp->q_qlock);
 	xfs_qm_dqrele(dqp);


