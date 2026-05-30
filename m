Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB5533FE15;
	Sat, 30 May 2026 17:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161354; cv=none; b=mV7S9268Ct5dGL3+KekB3fE93PWreWBJryLjaa9ziN9+nyiXP6njGCj7HlwOCQ0JpheNJspTljuKa4VFsAIyESj5YG0oEi8757bfxOjPdKWz9anYIQgDzDr06iM098F8nqjuaL/zugta4/vvnvMzWi5bp602471iaw3raGrNnnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161354; c=relaxed/simple;
	bh=+pdVr9bYkv5QwCkPSEfY18qMuhZ4R/HqrFC8jkjervc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGE6GxhXjARcf5ARtI5Hf4kKQrWexfg4rRFODmnb4Hh0wJ+evTryLaD2xp1iqVhO9cbcAKVA2ChBQP1aAo6xaakyx/fm9ozsNEdmJ2MBOEXq42EQW/6CpfVg9DsV8n8gnKfldmnhpFMKPp6WbEKFptcF9nref/BPRReU4rHLA/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFpbk89i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFpbk89i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F57E1F00893;
	Sat, 30 May 2026 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161353;
	bh=uNPT6xSI19bQy88gAhrPs6DvRPIOEBZKJFV8pXVN1ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFpbk89iMFCrJgQVJ0vZYpCGyr7ZCUzOPXpDXglSQ9p2EDFNFvcypil+DWpdV6Tfw
	 TAbKkDjEhxUrvmpMfMTHoGNYZrUBrHPQd0jcQ8sNmGOIS4S4nIJAXGdxVie+ClnzBr
	 qnP6fwMZSoU8sKwqcn0arbPXzs3ubLq5aTeltoCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 569/969] gfs2: prevent NULL pointer dereference during unmount
Date: Sat, 30 May 2026 18:01:33 +0200
Message-ID: <20260530160316.109681881@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index de6f38523db33..229ceed689f69 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -478,8 +478,9 @@ void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
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



