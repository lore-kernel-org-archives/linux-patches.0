Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF05148FF0;
	Tue, 23 Jan 2024 00:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969170; cv=none; b=GAHt3zbGQR5ruTYeI3KILqNpoPe82KnbuAPLT3iA2Fz8HUG2BGA38tvzDMAB2cMO1Lhuw3WCYBav9aXRKIB/UD7QcQ2G6FQE4ZI8rxAXx7dLYppDx5V1UnnjSjzwTjT2Js6vL5gJKiJfmDq5bio0jn/2daJ/Ks9/LSEEh4gHdTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969170; c=relaxed/simple;
	bh=RrYC75jwtZLLWeHF+ZJHNnx3XnxTO8GPD7CeZCF2sWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kz6Y1uQuOoKJRyMRgZMTvl8DswHIWXnWzmkkyYkaEOknqSnB9+xcgRbCToaQYsfHgCtedJGlSY5ohq90wwSZS/BtHENdERuugmKbAahhAI4bFSy5/8Y37SCnRMOA90gGIbpP9qizQ8J6XhRS0GkGnCUKdV6zf7BZL3fOGgBPd4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHUcKr0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHUcKr0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617DBC433F1;
	Tue, 23 Jan 2024 00:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969170;
	bh=RrYC75jwtZLLWeHF+ZJHNnx3XnxTO8GPD7CeZCF2sWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHUcKr0i/g8PfI/AebL28nRv44A1PAlmoyhmeQZ9bBboCISL+WfIRuqBfvpZFdh39
	 3eMHkPo+soIXNrLZkzEgWTgPhZM59l5QoLKiZ+72yfT0JVpRzZjtctuS9fM5Cx4PVM
	 ZceyW6UYx4x039CSKgS56QcJvSGb9IGuHrJ5ERaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Muhammad <osmtendev@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+da0fc229cc1ff4bb2e6d@syzkaller.appspotmail.com
Subject: [PATCH 6.7 071/641] gfs2: Fix kernel NULL pointer dereference in gfs2_rgrp_dump
Date: Mon, 22 Jan 2024 15:49:35 -0800
Message-ID: <20240122235820.264037098@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index c2060203b98a..396d0f4a259d 100644
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



