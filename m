Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC94747DFBE;
	Thu, 20 Aug 2026 17:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246980; cv=none; b=fXcZUOo8WL472X5NhdYqK1R0RiskoCZiESRaIW8Sp0pcWGTId1VkKJHUaZrAvZC8NMkq/z7RrixHLBH9VqiNIyVfGE02l8NU43FP7ntVDa4c+M0jaXhUsYLCR27xFGptocGpfCAfuhj22H5d7KqCDVaOVNtZrQoaT1JoD3zZ8cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246980; c=relaxed/simple;
	bh=m7IJRCi+Nl3LbNeeqpCTiR5D++UwkPr0vRk0x3Ag8fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfDA76e/h9jqNup0Ezq79HE8rnyttHSxGeSUtUJcgUvdHfv/MVKt5r1la/UTY6ET6howq7ocwmMTAm6GUTtZ/VoO+3EjWSYm8+ndXnDk1VoJ7i6bEMuezMkD/GeY2MQn2fbWca8ti08xQJ4vWEoW/pvqc/F/Toa+Ef4SWCBCTw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/4dir1q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/4dir1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5671F000E9;
	Thu, 20 Aug 2026 17:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246978;
	bh=gaiesHFGJ+pWpTA/1ZsJmXmZLSGN7eaQyC53MGtq4Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/4dir1qpGlb1SnUH4CyGetC40Wu8EL22Gj33yLkRz6+wOHYbplffavEFYBA1uQXZ
	 UQmGTG6TFrg7W9wikZ2fy4PL5Hyc9slBm4iaRtKkjYlZ6x0k0EXMZocF61HqX/wrAB
	 t/hH57ijDCMEWfSP6DkVQ16OJ0wj6ObfxiCqPyJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 108/220] xfs: dont swallow dquot recovery verification errors
Date: Thu, 20 Aug 2026 16:54:58 +0200
Message-ID: <20260820145226.723173785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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


