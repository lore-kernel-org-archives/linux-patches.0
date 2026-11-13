Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585830;
	b=Z9EaUVnNqaOKV2UuUoR+gCp0wfD2llgc0JpWSmDq7uE4cetTMzpNNAOK9anLmFOpMkdE
	 rkV2mFdy90UJxQwOHxIDl4CxpoTEsEJaIQLHRwnFFyCA3p6IMt9zyfolnpEgoZSFvtBPK
	 ukVQw/LXWdBON1hc9AhMTkvzBSryShjoFFKrju8uLKQ7LJbHe+0bTTcPY/PZyD2EXvRLL
	 5Zferup/lmWfQG35eJ7PW45wujqZ0sG1JDlP6JN91K7l7EW7uhwr/fQGV2dd/drqtSCdz
	 lVxnxcYC/SBQs+Napww3y00So6XsGuS+E57AH4PDoxta/z1WeFO/6ba6LiMQ5RvS5IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q/H3MXQmJzFCskwy8tbURjvW0MSpZVO6lgq9RQgq+gs=;
	b=LjmRMmS855raOi5Wgu9bovQO+sWYZIfntbDCTJh0RevjlJPNJprfe8q0KCFzKQHNxLVj
	 LaI66hT1nOvVlQNc1xm9mzp2fmfy8FfuzSA3xPj38P+8PPzMDKfHERBAyPb7hphphWcy+
	 JRvyn8c6sFXhVky0Vy1hL/b6bljlzHWoI6PCkpfPsgXrwB291yelpgzFTymUeY4nAb1+1
	 pwV4PE8YJ01sLl/SeEu5xtp8Q9/niiye78NHAYEupvN+aj1MMpkLv58nWEIH/7wvwCfVc
	 LAdBFPFX6pTk+yh2BOs0+fpTqoqzS/tbCBH407p4qIVrzkD1QKH9b1gpVNpvPxTzAbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeqZGgbr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA1760A6F4B;
	Fri, 13 Nov 2026 16:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeqZGgbr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F591F000C4;
	Fri, 13 Nov 2026 16:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585830;
	bh=Q/H3MXQmJzFCskwy8tbURjvW0MSpZVO6lgq9RQgq+gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zeqZGgbrkGUYnZwnAd+4UN2jZgS0i2HTtK8YqiqMVHBs6RFL1a7bdRliYot8CLLi4
	 h5H1lQ6emOWWW2kwcsSY1g/7V4OXe5Zv0maUw4/8F5tQj1N167Pp4JlzhfV+K5xD57
	 l2TqveH3iKQJWXVIcQenI2DJtyID481VPQYK/Xyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 408/507] drm/etnaviv: Flush the tile status cache through both the PE and BLT
Date: Fri, 13 Nov 2026 10:51:52 -0500
Message-ID: <20261113153810.561792847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Gmeiner <cgmeiner@igalia.com>

[ Upstream commit c1a757f8df1363032623fa9b1baaba0dcf34de6d ]

Since commit f232d9ec029c ("drm/etnaviv: fix TS cache flushing on GPUs
with BLT engine"), jobs on GPUs with a BLT engine use a BLT command to
flush the tile status cache instead of TS_FLUSH_CACHE, which is broken
on most of these GPUs.

GC7000 r6008/r6009 and GC8200 r6401 are the other way around:
TS_FLUSH_CACHE works, but the BLT command does not flush the cache.
The vendor driver handles these GPUs using TS_FLUSH_CACHE, but the
etnaviv kernel driver has no way to identify them.

As a result, dirty tile status cache lines survive the end of a job.
They are written back by the next cache flush, using the page table of
the job issuing it. If that job belongs to another process, the write
goes to the wrong address space.

On GC7000 r6009 this causes MMU faults and GPU recoveries blamed on an
innocent process. I see around 1100 per run of a multisample
depth/stencil test running alongside two other GPU clients.

Emit both flushes at the end of every job on GPUs with a BLT engine.
Whichever does not work on a given GPU is a no-op. Since dirty lines
are only written back once, this costs one additional state load per
job.

Fixes: f232d9ec029c ("drm/etnaviv: fix TS cache flushing on GPUs with BLT engine")
Cc: stable@vger.kernel.org
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://patch.msgid.link/20261102-etna-pe-ts-flush-v1-1-e4454ed86f85@igalia.com
Signed-off-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c | 40 +++++++++++-------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
index 03b2576af67fd..99c91a9eecf1f 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -168,6 +168,17 @@ u16 etnaviv_buffer_config_pta(struct etnaviv_gpu *gpu, unsigned short id)
 	return buffer->user_size / 8;
 }
 
+static void etnaviv_cmd_flush_ts(struct etnaviv_cmdbuf *buffer, bool has_blt)
+{
+	CMD_LOAD_STATE(buffer, VIVS_TS_FLUSH_CACHE, VIVS_TS_FLUSH_CACHE_FLUSH);
+
+	if (has_blt) {
+		CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x1);
+		CMD_LOAD_STATE(buffer, VIVS_BLT_SET_COMMAND, 0x1);
+		CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x0);
+	}
+}
+
 void etnaviv_buffer_end(struct etnaviv_gpu *gpu)
 {
 	struct etnaviv_cmdbuf *buffer = &gpu->buffer;
@@ -191,7 +202,7 @@ void etnaviv_buffer_end(struct etnaviv_gpu *gpu)
 		unsigned int dwords = 7;
 
 		if (has_blt)
-			dwords += 10;
+			dwords += 11;
 
 		link_target = etnaviv_buffer_reserve(gpu, buffer, dwords);
 
@@ -204,16 +215,8 @@ void etnaviv_buffer_end(struct etnaviv_gpu *gpu)
 			CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x0);
 		}
 		CMD_LOAD_STATE(buffer, VIVS_GL_FLUSH_CACHE, flush);
-		if (gpu->exec_state == ETNA_PIPE_3D) {
-			if (has_blt) {
-				CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x1);
-				CMD_LOAD_STATE(buffer, VIVS_BLT_SET_COMMAND, 0x1);
-				CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x0);
-			} else {
-				CMD_LOAD_STATE(buffer, VIVS_TS_FLUSH_CACHE,
-					       VIVS_TS_FLUSH_CACHE_FLUSH);
-			}
-		}
+		if (gpu->exec_state == ETNA_PIPE_3D)
+			etnaviv_cmd_flush_ts(buffer, has_blt);
 		CMD_SEM(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_PE);
 		CMD_STALL(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_PE);
 		if (has_blt) {
@@ -400,12 +403,12 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, u32 exec_state,
 	return_dwords = 7;
 
 	/*
-	 * When the BLT engine is present we need 6 more dwords in the return
+	 * When the BLT engine is present we need 7 more dwords in the return
 	 * target: 3 enable/flush/disable + 4 enable/semaphore stall/disable,
-	 * but we don't need the normal TS flush state.
+	 * on top of the normal TS flush state.
 	 */
 	if (has_blt)
-		return_dwords += 6;
+		return_dwords += 7;
 
 	return_target = etnaviv_buffer_reserve(gpu, buffer, return_dwords);
 	CMD_LINK(cmdbuf, return_dwords, return_target);
@@ -422,14 +425,7 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, u32 exec_state,
 				       VIVS_GL_FLUSH_CACHE_DEPTH |
 				       VIVS_GL_FLUSH_CACHE_COLOR |
 				       VIVS_GL_FLUSH_CACHE_SHADER_L1);
-		if (has_blt) {
-			CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x1);
-			CMD_LOAD_STATE(buffer, VIVS_BLT_SET_COMMAND, 0x1);
-			CMD_LOAD_STATE(buffer, VIVS_BLT_ENABLE, 0x0);
-		} else {
-			CMD_LOAD_STATE(buffer, VIVS_TS_FLUSH_CACHE,
-					       VIVS_TS_FLUSH_CACHE_FLUSH);
-		}
+		etnaviv_cmd_flush_ts(buffer, has_blt);
 	}
 	CMD_SEM(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_PE);
 	CMD_STALL(buffer, SYNC_RECIPIENT_FE, SYNC_RECIPIENT_PE);
-- 
2.53.0



