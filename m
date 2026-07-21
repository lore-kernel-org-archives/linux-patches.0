Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBFB43B48C;
	Tue, 21 Jul 2026 22:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674754; cv=none; b=KVT5IcgBzHCn7nsoXcyd5neEuCM/ySnO0xkHizGJAo/WOlRUnT8f8eKihgXC0bk8ZaxvxP45BzjYGxqZuUC4lDKUNCYQ5Ed2L3u1ePgh6qmkZTQurJaB5ZRAnn6S3F6APHXI/mSHoqWy7di2Qx2b950G/FX8nfmlvN1byTvb4Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674754; c=relaxed/simple;
	bh=fsvefGqXBbNYPGCSN2mcYCoRCx9sizxJ6hgxGdjv9ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+CBv6p1Y0SP+1tUdq/fbe+5dxyIiDA6TzBXKvcZsTpRgO8LD9zXDz3hmyh8lUA796IOR9t9rWAX74CNIpNwtZdTfHIEGGtoEaKhMzMuY3c9gPUlTGuIXFp4qH9v2kc8ASHf1zp9Nv3mvzedAy50G/1yHucnVX3KtpmIarlKa+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihZUm+du; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihZUm+du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E6B1F000E9;
	Tue, 21 Jul 2026 22:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674753;
	bh=cFJqfb9Z5IbXCo6yu41Qd59pJhIjBCAOB83UveszrnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihZUm+dugIxDvhATJkoIZUiccFl/Uj1BBiaCEYS9wu0F8kcoDv2NVDU4e5hcsdkpr
	 i8K0UKYqFmNccwWIWqcO3RfT5OQ/a3NES2AtQLHtP27o7Cv3BPnkVFsSzkLJO3ARM6
	 kz+sny33cu+XGCg3Jrq5O8jkPfEnx+KBV+xnIhY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	syzbot+b7dfbed0c6c2b5e9fd34@syzkaller.appspotmail.com,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 660/699] xfs: use null daddr for unset first bad log block
Date: Tue, 21 Jul 2026 17:26:59 +0200
Message-ID: <20260721152410.653965417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit cc9af5e461ea5f6e37738f3f1e41c45a9b7f45d6 ]

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
[ adjusted hunk offsets for context drift and dropped an inapplicable whitespace-only end-of-file hunk whose context doesn't exist in 5.10 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1034,7 +1034,7 @@ xlog_verify_head(
 {
 	struct xlog_rec_header	*tmp_rhead;
 	char			*tmp_buffer;
-	xfs_daddr_t		first_bad;
+	xfs_daddr_t		first_bad = XFS_BUF_DADDR_NULL;
 	xfs_daddr_t		tmp_rhead_blk;
 	int			found;
 	int			error;
@@ -1063,7 +1063,8 @@ xlog_verify_head(
 	 */
 	error = xlog_do_recovery_pass(log, *head_blk, tmp_rhead_blk,
 				      XLOG_RECOVER_CRCPASS, &first_bad);
-	if ((error == -EFSBADCRC || error == -EFSCORRUPTED) && first_bad) {
+	if ((error == -EFSBADCRC || error == -EFSCORRUPTED) &&
+	    first_bad != XFS_BUF_DADDR_NULL) {
 		/*
 		 * We've hit a potential torn write. Reset the error and warn
 		 * about it.


