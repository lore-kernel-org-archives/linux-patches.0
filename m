Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52FB45518E;
	Thu, 20 Aug 2026 17:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247500; cv=none; b=A4AsE4zCm6t958+SqyYMqAsGY0bS1U4eyDeq2/DLgDpf/h5HDVzOvCkitn1ZVFYWfL4Fl75xdLBrpXNC3w5mT5a6P4XesRTnSYM4j0x6iC2WJgr9p0N8dRT16OQ2pRnY8KC3PtGj7iZ93dqSDOZRNqf/Q+XYR+c/G+B/nJu2wgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247500; c=relaxed/simple;
	bh=dV2+J5nlVizrpwxC8u6AvLgHYyCPMXrxGtTlOX+yIQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gT1kI1Kb6QcoTViuw8+BXwxfcOkmqRx3uUhnvFIyvIkeLr2Sr5ALAFC11rQBFaezE/v/nF8huqKaK24qyQXDZ6AN46HuK6CTkV92ObDGPSiMYpynxRETUmowESd8ZhsX/ID0Ix6MqBmQfH8b3sAcLCLKktJArsWkU4pIcvppgTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsvJyhlC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsvJyhlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3F01F000E9;
	Thu, 20 Aug 2026 17:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247499;
	bh=6x/LiGeh5iZ6hfGwjxYFvDlSAXhIhyOO/FvbtJ/8a8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IsvJyhlC0+bcHr/OMNzRJe/z/GpENElSF48hMFczqj4GOYlAkwPcrRjblIGs1SahK
	 EvTEtU8TPoptbohrhe6xr93yLTMHJk7CYqk9/lbPcMvX7V4vqZk1ij+l7d9IWDfNzg
	 LdNqKjF+kXh5tukQGWlqZAQ4x+GsFC9PVquO0H+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 066/166] xfs: dont swallow dquot recovery verification errors
Date: Thu, 20 Aug 2026 16:55:25 +0200
Message-ID: <20260820145213.130767116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


