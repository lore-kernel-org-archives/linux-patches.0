Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826F93B42FC;
	Thu, 16 Jul 2026 13:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210351; cv=none; b=iKGOMMH5A8FybybZ053MGwEBKTmu4QDWYm4vsJHX3yJUA0tIFEe7gHab4jvu/sIQAueHdG8yqVJlQGAS+Io8STAk6AG/WlVZJAYjlBFxfkiUBI6VLnhIChFX1hf5Hfx5GteDWqRbaHRYGg+juzRshwQRozqawaIQ1a4wRcBk4zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210351; c=relaxed/simple;
	bh=+Ti+yhV4/iFq1KpUENhb6IW9inzU+pONWlZwW3CHfZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrzJsF1HxTbaL9oKG4/lF5p+sAm2fuFSf0KWDVMnbn9ZPQCkM+Dhafq/BKKwlHX7zW6PfOvHGtYO0j3BUZmsHnNq4ZVA9adN6xi2Rf+1ACKC7B7R3smuHq419XG0Z4FCzBIMfUTu264gIVdHbCW0O8utCWLZPwCWfUD6+Bgr+w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckeaBnK/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckeaBnK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C951F000E9;
	Thu, 16 Jul 2026 13:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210350;
	bh=sKh2toCKqUKen1p5IvZn5SdFY6i81b+MNIkrixbI3p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckeaBnK/BwqX4NKiqNLnAjLomb533OfEm6H21sWJ9vQl+lu7VPezL6DZb5Kf9tA5Q
	 kb/87aegr7PebwShJkwPbOagi529x+9am2NBbUtv7uTa/ODQ+EMdHZ+I1xEG5UtCKt
	 mehpdFPAahQq5EmU/vuC2dJG7AiDGX/FBCWKNW7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/480] f2fs: use memalloc_retry_wait() as much as possible
Date: Thu, 16 Jul 2026 15:26:02 +0200
Message-ID: <20260716133045.021456522@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 30a8496694f1a93328e5d7f19206380346918b5a ]

memalloc_retry_wait() is recommended in memory allocation retry logic,
use it as much as possible.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 8712353ed80f ("f2fs: fix to do sanity check on f2fs_get_node_folio_ra()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/segment.c |    2 +-
 fs/f2fs/super.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -234,7 +234,7 @@ retry:
 	err = f2fs_get_dnode_of_data(&dn, index, ALLOC_NODE);
 	if (err) {
 		if (err == -ENOMEM) {
-			f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
+			memalloc_retry_wait(GFP_NOFS);
 			goto retry;
 		}
 		return err;
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3128,7 +3128,7 @@ retry:
 							&folio, &fsdata);
 		if (unlikely(err)) {
 			if (err == -ENOMEM) {
-				f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
+				memalloc_retry_wait(GFP_NOFS);
 				goto retry;
 			}
 			set_sbi_flag(F2FS_SB(sb), SBI_QUOTA_NEED_REPAIR);


