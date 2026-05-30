Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5913E29B78B;
	Sat, 30 May 2026 18:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164199; cv=none; b=JIjVlwblC7YJM9EgIVmJGupWdVWdJ8Znh+wVx5VJUmexTLNrRPZUg4GIDGKV0OUc9COTv3VibLmvDDt532wzmr+EiVXio3by8PNbnxBNoPjYXS7HFD73ws2igSWYgo0GlgnafktnDUBQ3gfIA3W1roLxRIKofK8NEHedlozhuHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164199; c=relaxed/simple;
	bh=6wSOeGwNdqKiohV2FeG0jS8+3cDbJMpc66t2l/dquA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uodqh+1XS4P82UcoZOji7SSL3HuWKIM2wWelDLPmCDP+Jfnv/kApVfdLz2TK18SzMGdpNBsgxJInlaJdQQzSDHAbYZ2idW/6whcjCWcNeJtFjm7gZ2Pan1R4Ods40VLsiuuI5q5MbMMiOQZcQtifpI2ey1zau6y2EuynGuVmumQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jg3kjdfT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jg3kjdfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9431F00893;
	Sat, 30 May 2026 18:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164198;
	bh=VevRnWcs8jHQnwiYnQQmIq83qAL13HrXnGWbsSVTLSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jg3kjdfTxp2qhRiyBF8fyauQ3ZLWL8twrLZgx1xmhF3L81pkMNxuUKX1OO+FCtFMq
	 023dyHGYiPErKLLNix0xYhEDXBzrv//wzdb3wqsndRc6ErMg9Ni2xjWfXUhrlazjQC
	 U+IIqxc2FoKQGkx4dgUXSht7HRss9xV/raVgGvZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 483/776] gfs2: prevent NULL pointer dereference during unmount
Date: Sat, 30 May 2026 18:03:17 +0200
Message-ID: <20260530160252.819636337@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 74b4dbb946060a3233604d91859a9abd3708141d ]

When flushing out outstanding glock work during an unmount, gfs2_log_flush()
can be called when sdp->sd_jdesc has already been deallocated and sdp->sd_jdesc
is NULL.  Commit 35264909e9d1 ("gfs2: Fix NULL pointer dereference in
gfs2_log_flush") added a check for that to gfs2_log_flush() itself, but it
missed the sdp->sd_jdesc dereference in gfs2_log_release().  Fix that.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202604071139.HNJiCaAi-lkp@intel.com/
Fixes: 35264909e9d1 ("gfs2: Fix NULL pointer dereference in gfs2_log_flush")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/log.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index e19b09620a0b7..354362c7c4f99 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -470,8 +470,9 @@ void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
 {
 	atomic_add(blks, &sdp->sd_log_blks_free);
 	trace_gfs2_log_blocks(sdp, blks);
-	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
-				  sdp->sd_jdesc->jd_blocks);
+	gfs2_assert_withdraw(sdp, !sdp->sd_jdesc ||
+			atomic_read(&sdp->sd_log_blks_free) <=
+			sdp->sd_jdesc->jd_blocks);
 	if (atomic_read(&sdp->sd_log_blks_needed))
 		wake_up(&sdp->sd_log_waitq);
 }
-- 
2.53.0



