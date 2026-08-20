Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5801919F121;
	Thu, 20 Aug 2026 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239142; cv=none; b=BkmM8x70XgzK9oiUbq9pyIOUqcFYRF0kldhy3WSE1ZRxwjQ8uE3UtRHxvI7vY9YDTHbG01dEDHUx83w8llHRPmiqgRv+6Y7YXD+5qTs0xxBS2jXfNfNqE++A3+cbX4BLp7YZW7t0ZKd73GV8dxNS7dgwLmmAj8J41pPmC6b9aEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239142; c=relaxed/simple;
	bh=3a1ijGJjbIdl40uxyDHE1PyCe0TC/yDise2eTNbYa8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqIEgnW1umlOBuEDC0Fwqp4DefO0EUjzH6gljyheJUw25q/9yvy+j8oTx7LGFAFG2lI0xMqCyAuPa4dcmCrXxLeajIuXiYJzcyQCJaCQDRn1uLbx9Ec1NsNm0j7EEprrDKfIr3dRTuUMDUynkQxUUhRkUmBdIAnplq1Rv0RSM8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMtVvq2E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMtVvq2E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8E81F000E9;
	Thu, 20 Aug 2026 15:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239141;
	bh=LmG+pyD1ywma8mS3bFtIqaYZK3EzAVoLO1ggdUh95eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMtVvq2Ehl4Ovarwjb2R6PuNJ5Sijuv8Gc/C7iwyfqzrhd+LAnUmjiau4dN94LQpO
	 JmUo/Fs7Bhr4CjFbI7WhOuPpmuu6lPy4eDubavyYKWyFcYruyGEN/KMXHDQreNHOlE
	 dNs2zUhU0xPwu2Ef4mI1lkaOeM6y7M2sao5AjwfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 125/217] xfs: dont swallow dquot recovery verification errors
Date: Thu, 20 Aug 2026 16:54:53 +0200
Message-ID: <20260820145241.491721736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Long Li <leo.lilong@huawei.com>

commit e2b4a856085e9bd939bde2dee0d08b1d41babde9 upstream.

xlog_recover_dquot_commit_pass2() validates the recovered dquot with
xfs_dqblk_verify() and, on failure, sets error = -EFSCORRUPTED and jumps
to out_release.  But out_release unconditionally returns 0, so the
corruption error is discarded: the caller xlog_recover_items_pass2()
sees success, log recovery proceeds as if the dquot were valid, and the
corrupt quota buffer can be written back to disk.

Fixes: 9c235dfc3d3f ("xfs: dquot recovery does not validate the recovered dquot")
Cc: stable@vger.kernel.org # v6.8
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot_item_recover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -173,7 +173,7 @@ xlog_recover_dquot_commit_pass2(
 
 out_release:
 	xfs_buf_relse(bp);
-	return 0;
+	return error;
 }
 
 const struct xlog_recover_item_ops xlog_dquot_item_ops = {


