Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C847437F00E;
	Thu, 20 Aug 2026 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238549; cv=none; b=MQvxt56TnO5D4/uZPuxDe6bbl4eTee57L9tfXxcsNapZPWZ8r9T5dfyXHeIsfAC+2DSJcG+QfWb+Zugslc3m4RZx33yYrWJCrGPRNgh7w0JzXnbsF1DMpGsaV0ly+N7dg3up2WL+aXagjPIeLY5hYmk6ZiySk8XECWXXMToPyjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238549; c=relaxed/simple;
	bh=pQeQg/BM+2ZMjPFHlCBntyGJ6kbp5gRIvAUcF5T/Xis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+vrOcloN2nNV05CCIewf9eqWDnJJsV+rUsJJeds0O783qGh0CqVnQaiFeVyaSiKsxtbjMhB77mrvokKcww5kk4zLv8gCPQM3hpsQi80XFtaVwzwooXdSRhAhtX3GTOYTktCbM+dADloceMjlBHhUqBlscTjuzc99AEcTYYiYgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIGhGBv3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIGhGBv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF6B1F000E9;
	Thu, 20 Aug 2026 15:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238547;
	bh=YfNJ+5CxYv8RPBTezTufqqob0xwciHfxxid/EAxUYq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIGhGBv3ZRjuVct+X0XT8ZZFw7F91Xkq2aXYHUBE0OkzYKl54y70Wg26gH2USWkYn
	 g+cXvw/UJgGrMPUfQd0otN2oAf9RhYWGJIc4jpkhml2PiOI2Ixj6NQDBQIFo130tMN
	 GdtJ3qPISLK5aH5+UCQnJJMOTv9uYZiUU25IFzhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 147/228] xfs: dont swallow dquot recovery verification errors
Date: Thu, 20 Aug 2026 16:54:49 +0200
Message-ID: <20260820145249.086697874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


