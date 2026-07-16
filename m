Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90757423EA0;
	Thu, 16 Jul 2026 14:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211039; cv=none; b=WQF2yl4YcTHle70uwl4sGK80AyFdcr+xCklM3Zxi8KyeByiPonBRCd3bG3NUHWtmLSa7s2yhs9WSDNYuDXmW46nEls8x+9m0uJmUHWRuKw5hacwGaWafqN+ajXlcyJM/0D49ydnSqTrnMVnYAPbmj4CMmsTGk/ipQh/hml9hBVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211039; c=relaxed/simple;
	bh=P7g6aljonxMT1lFg/oIBVtvfrPbPsQQtZHJQKd8K1wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhlClOmpOLa6OCBhCimQIDoVrymBksDzxtCFZcpkyBrtBKpXtz7KAcjj7WwzDnOWvphiTqNCE7VFp/3IC1FIk5g72HXTwKfXkqVI5Su2PeUPouJ6iMb+cz9U76MIuh9scXOmWBVtxsd/zM9spJnwi9KrqFyQ8yXyEmDzBHG9F8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2FKPt/A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2FKPt/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014E31F000E9;
	Thu, 16 Jul 2026 14:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211038;
	bh=W0Li9nfXZ0lPUWUafkC6J78U0D7TxyM/BN6NVEzKuUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2FKPt/AmqkuFfMfaLljSg5uLclem8UloLMMDtlXMt3kpo1WvMR6M1jMLXt+jBTNm
	 d/Ah3xFCp3IeDNNajprtOmxXvHpkmqcEpzv0aAzz3K9eW5lDPJnOyPa1zjKySdrkvM
	 dCsfkWaU+eLbfws0kTQMlXKr3oLgBKijYdlfi9cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 274/480] xfs: use null daddr for unset first bad log block
Date: Thu, 16 Jul 2026 15:30:21 +0200
Message-ID: <20260716133050.752559360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

commit cc9af5e461ea5f6e37738f3f1e41c45a9b7f45d6 upstream.

xlog_do_recovery_pass() may return before setting first_bad.  The caller
must distinguish that case from an error at a valid log block, including
block zero after the log wraps.

Initialize first_bad to XFS_BUF_DADDR_NULL and test it explicitly before
treating the error as a torn write.

Fixes: 7088c4136fa1 ("xfs: detect and trim torn writes during log recovery")
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Reported-by: syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b7dfbed0c6c2b5e9fd34
Cc: stable@vger.kernel.org # v4.5
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1028,7 +1028,7 @@ xlog_verify_head(
 {
 	struct xlog_rec_header	*tmp_rhead;
 	char			*tmp_buffer;
-	xfs_daddr_t		first_bad;
+	xfs_daddr_t		first_bad = XFS_BUF_DADDR_NULL;
 	xfs_daddr_t		tmp_rhead_blk;
 	int			found;
 	int			error;
@@ -1057,7 +1057,8 @@ xlog_verify_head(
 	 */
 	error = xlog_do_recovery_pass(log, *head_blk, tmp_rhead_blk,
 				      XLOG_RECOVER_CRCPASS, &first_bad);
-	if ((error == -EFSBADCRC || error == -EFSCORRUPTED) && first_bad) {
+	if ((error == -EFSBADCRC || error == -EFSCORRUPTED) &&
+	    first_bad != XFS_BUF_DADDR_NULL) {
 		/*
 		 * We've hit a potential torn write. Reset the error and warn
 		 * about it.
@@ -3582,4 +3583,3 @@ xlog_recover_cancel(
 	if (xlog_recovery_needed(log))
 		xlog_recover_cancel_intents(log);
 }
-


