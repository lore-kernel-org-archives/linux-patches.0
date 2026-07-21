Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8665823C368;
	Tue, 21 Jul 2026 20:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665221; cv=none; b=eOh+unpbjWXyVdTCWA4mh6qQCW6K9SgUtAvpdlUdKLn2cyqr19CdGD1swH47vVM/8pN4hi/Y5mk1WlClhbAFTnGUBx01rDaR6ZmEonSxjz5ggG9QWfXmFMXtFlfLyaX+eo9+cY0Zv8FOLWpMGRD7EwFqaqQCCCXcMe41SQ8D58A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665221; c=relaxed/simple;
	bh=MRiYbn9dA0DaY8YEipbMvU67YQ6a9cPbjS4ubcKcVs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8dDA9A6KoY+y2C5whtJfYGEpJqEhzhXXGPI9yrH8X9W//Swo5Dga0f2DQ7Pi4vIqlI1xJw9PqLbi8QAfnIl1kA4JUy2VTUY3ePGdS5BoxRlx9cXEannA5J+I/sFNNs2WtV3cXtzMF+3pvd5yuaPjXReCFejIkFn0D0SLfUTyUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQLbgVyQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQLbgVyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2A21F000E9;
	Tue, 21 Jul 2026 20:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665220;
	bh=yKdLw1gReK7MYXB21Goqz82d4W8lVdRy/TNLXr5gYMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQLbgVyQqVxwxZ/1saV++iLjm3l+NbAmBA1pi/aJQHeq+ata/3HoaEpqUtT/nPGSf
	 I8UskSeeAvN97jGvfM10uLFa+ci75YPwWcwLlEDV4Q5ea6Xf2D6NL398WikSLCHq3z
	 Sz9DB61kBnOqRm7M2mInEvBaZu2d2rcrPPn38frw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0220/1266] xfs: use null daddr for unset first bad log block
Date: Tue, 21 Jul 2026 17:10:57 +0200
Message-ID: <20260721152446.741475131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -3555,4 +3556,3 @@ xlog_recover_cancel(
 	if (xlog_recovery_needed(log))
 		xlog_recover_cancel_intents(log);
 }
-


