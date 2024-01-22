Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920D74F616;
	Tue, 23 Jan 2024 01:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972181; cv=none; b=HocrjKgobV/+QIcGYifpK6/5iFNmdXrf8S08ECK3KFwQxHO/enAtc9dfbFm31cOToI8rfQC+/cbE3pcIei2R1cg9OJfOJQ+5v5TkKlCeErwajM0A+NFWhhkNwue3mBBVTlgfLTDQxmOdk5gQe57iT45c9ldXvgQt5vQ/b/MTC/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972181; c=relaxed/simple;
	bh=L3pepSqcZyV67CEoAoRTUdLXcYAWuJJ/DJ8jhk1aeqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EV9unwiIcEmdHoNoBWVyG2XkZW3sea/ydS37fb43nZImdngDD/WUy0YqDXAF5I5Wgdk5GiFI9agk+uU5+NkNZPtHdgk/rLMvFwJZSKh96n8Hff0ex3o3MglyzN97no6cJkNtADQlcsOFg9sKmQLL5Zajqkk3I6ee6j/J5GRGBL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxffePg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxffePg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC02C43390;
	Tue, 23 Jan 2024 01:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972181;
	bh=L3pepSqcZyV67CEoAoRTUdLXcYAWuJJ/DJ8jhk1aeqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxffePg4yARzEQ+TJ7Bzdq5UA2U9w9KhZbbu1bbhPHe+KmMAfUDgF8lF6cOtSteZD
	 WOAhlKYw2hBEYvcK0FUa2D4/qSS3iu3nrZG9OJ1Qq7QgKaRVwq9oVeHAkv/ZYAJ+8m
	 AsQ+40czTiPtSxL4/kRu55rqdq+Pg5bnL4Hc1R0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Muhammad <osmtendev@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+da0fc229cc1ff4bb2e6d@syzkaller.appspotmail.com
Subject: [PATCH 5.15 105/374] gfs2: Fix kernel NULL pointer dereference in gfs2_rgrp_dump
Date: Mon, 22 Jan 2024 15:56:01 -0800
Message-ID: <20240122235748.271373337@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Muhammad <osmtendev@gmail.com>

[ Upstream commit 8877243beafa7c6bfc42022cbfdf9e39b25bd4fa ]

Syzkaller has reported a NULL pointer dereference when accessing
rgd->rd_rgl in gfs2_rgrp_dump().  This can happen when creating
rgd->rd_gl fails in read_rindex_entry().  Add a NULL pointer check in
gfs2_rgrp_dump() to prevent that.

Reported-and-tested-by: syzbot+da0fc229cc1ff4bb2e6d@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=da0fc229cc1ff4bb2e6d
Fixes: 72244b6bc752 ("gfs2: improve debug information when lvb mismatches are found")
Signed-off-by: Osama Muhammad <osmtendev@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/rgrp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 6901cd85f1df..e4e85010ab5b 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2316,7 +2316,7 @@ void gfs2_rgrp_dump(struct seq_file *seq, struct gfs2_rgrpd *rgd,
 		       (unsigned long long)rgd->rd_addr, rgd->rd_flags,
 		       rgd->rd_free, rgd->rd_free_clone, rgd->rd_dinodes,
 		       rgd->rd_requested, rgd->rd_reserved, rgd->rd_extfail_pt);
-	if (rgd->rd_sbd->sd_args.ar_rgrplvb) {
+	if (rgd->rd_sbd->sd_args.ar_rgrplvb && rgd->rd_rgl) {
 		struct gfs2_rgrp_lvb *rgl = rgd->rd_rgl;
 
 		gfs2_print_dbg(seq, "%s  L: f:%02x b:%u i:%u\n", fs_id_buf,
-- 
2.43.0



