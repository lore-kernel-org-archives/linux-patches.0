Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1654E1D1;
	Tue, 23 Jan 2024 00:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970565; cv=none; b=VNpXb1QJ39TFuxjgEt31a33TsC4s18OulUIaicJGp18yoWyFQk5ggDxC+i53MBLicrZj0+1GzbdUFV2TxVfA/abIoI2pyjBDRzJrrsQ40VBCEFe3PLA5qdNdyRoZTlenVttA3igWRAzos6Hw1IJiIp6IJJ9Tp+BWbm4T7G75o6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970565; c=relaxed/simple;
	bh=pbzTVdD8QJLXLFuXAnZm6SCP2rNIAPc3TC6iBMHtH1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imn05/DSRjazXwEoYlMWbAC9Agh+2O8o24rLPg+h+CrpGRwlvnZAXhj99hdXLH2+FM5K+fX8NCa+YQaCq4OnIEq9Y754vpjAz0KJ90mjGCTRWEyFFURPOjcrtfxCt3xfbJPjePnhY1OAbcipD5UJq7We4I1YLpZhihgk6XrQ6nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZdXVQWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZdXVQWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980C7C433C7;
	Tue, 23 Jan 2024 00:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970565;
	bh=pbzTVdD8QJLXLFuXAnZm6SCP2rNIAPc3TC6iBMHtH1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZdXVQWhRhS8lbq2CAuCVuKFxe09bLfyT38qXaL6K8diOfmk6BcizrVeHt/GlE1la
	 p0sGMhruhZ6JIXWQLpx3w/Jn4D2th2DEM7gkf/wEBWKnxIyruxpQBRysK3R1lOLLiu
	 QxwffOudETPzQD5SPJ9wnvvYVzMdoKrrxXMJHsLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Muhammad <osmtendev@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+da0fc229cc1ff4bb2e6d@syzkaller.appspotmail.com
Subject: [PATCH 6.1 053/417] gfs2: Fix kernel NULL pointer dereference in gfs2_rgrp_dump
Date: Mon, 22 Jan 2024 15:53:41 -0800
Message-ID: <20240122235753.512825209@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f602fb844951..dcaaa32efc4a 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2306,7 +2306,7 @@ void gfs2_rgrp_dump(struct seq_file *seq, struct gfs2_rgrpd *rgd,
 		       (unsigned long long)rgd->rd_addr, rgd->rd_flags,
 		       rgd->rd_free, rgd->rd_free_clone, rgd->rd_dinodes,
 		       rgd->rd_requested, rgd->rd_reserved, rgd->rd_extfail_pt);
-	if (rgd->rd_sbd->sd_args.ar_rgrplvb) {
+	if (rgd->rd_sbd->sd_args.ar_rgrplvb && rgd->rd_rgl) {
 		struct gfs2_rgrp_lvb *rgl = rgd->rd_rgl;
 
 		gfs2_print_dbg(seq, "%s  L: f:%02x b:%u i:%u\n", fs_id_buf,
-- 
2.43.0



