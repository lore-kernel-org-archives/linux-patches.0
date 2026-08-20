Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41CF3793D5;
	Thu, 20 Aug 2026 17:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247936; cv=none; b=WXO+YW/33UNOOF4hGFzoTJ2ULa0U1/yoebXZNQTpXJcNUp/DU78T9wtFrx6JGGdfyWoFX8rNx1Uuca9xOOkdwH0ITKViCuLFX2S4koLgLERdJYAWOWt6Wq/wKsStq3PzB7GqrFV8pjlMeFwa1ZQYuXo3wGDbHtwGHo5Xtjh3wg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247936; c=relaxed/simple;
	bh=KpTDOEe12aQdjSWMwTeoBy1PLkt9A72CIcMutGA2dbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2Y963M7eXAAKEZCC1SEUes2ZJXTBBczlOgf4V1rr9QS4WX6Vm2OLUuFtnaWksCykd6oWHm8IyA7OKdsAylKzI/qTswDNRMfCH7EKQAS/Yo8C8nJUkjjpVklA3E01U8dm0zUdMG8dsiEoZ4lnxyh9qWkB1jEQV5xlOF+CjTGbls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r73xCUKb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r73xCUKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B691F000E9;
	Thu, 20 Aug 2026 17:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247934;
	bh=NHK7yhxBVIj9mKExTvSapoi1o4YZH6a/xjJR1P1HN/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r73xCUKbkpRUhczjZJZH5RxVBSBvq9x69pm6RFOTYFACjS746wLoE++KF21oT/KYK
	 TcFlhIb51lQmN6xFYBD+imWdFLZI+6oPyr8mmSA8P5mqFBQZRrrqc4QePQXkUENDm9
	 HuC32y9vW3PuePLqo7i/yMM3IY76H6y4bPsHTDS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 052/303] xfs: dont swallow dquot recovery verification errors
Date: Thu, 20 Aug 2026 16:53:08 +0200
Message-ID: <20260820145254.735553647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


