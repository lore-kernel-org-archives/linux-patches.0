Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D6F443A8A;
	Tue, 21 Jul 2026 21:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668398; cv=none; b=aUmbcbU7D5AYOdkQt0jtdP4xVfW1YjiJ6Aukj8kG8N5Q8uz01h7tP5MiK7gOeYYtDXHFGT5FBVedaqcQfDaeCsh6KTIM5ldJsxFtlkVb+klzQZdgpPPXJwvOK8AyZXyxQpvK4WMn9kgWNJhxbC/AnIYXkEPxuUI3R8SpAGeDXbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668398; c=relaxed/simple;
	bh=oZI0VOjdfajxsSD41+63elJIH2rp344YA/i9c5n/pS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiYy3x3+4zrSlS1fgHsIpMdCHBNK3Yq5itahXPfKmfRX7hxwndIcrIEzVB5ubBjMRpbz4XOM95hJn+pSHfOz3rjnR4NbTz2/XKoahc689jfVaPTsnH7O3636E5yZxlCVhFur4M8lVbsaTFMnzJ318+iRs28D65eSKfNj6c5qefY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fYwAmTmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fYwAmTmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3193A1F000E9;
	Tue, 21 Jul 2026 21:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668396;
	bh=amcWwGf47kkm1ip/3azSku3JZX40KLHZNjA7lzD55FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYwAmTmKXPc4z5UDsFgo9v96WSBI0WRLsMSTC1vrWptntsi2/e+KF4HwbXR4TWI8g
	 BMw/YyhuKSH8WZSBh56ViuvcVLK3iqb+Ts6y343B3m7SNDomFNH2Kf/jQkIdB7b5Ua
	 o9SEspMij1KekWq2TaSx7eKP2TfvnlH8BJOJIkBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0161/1067] xfs: use null daddr for unset first bad log block
Date: Tue, 21 Jul 2026 17:12:42 +0200
Message-ID: <20260721152428.189358008@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -3538,4 +3539,3 @@ xlog_recover_cancel(
 	if (xlog_recovery_needed(log))
 		xlog_recover_cancel_intents(log);
 }
-


