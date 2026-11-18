Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037894;
	b=DTTF5hsq4/FK3mB/2jdFNsi8aM7/x9GZ0SWzcLGA9d8ZWTeI0jFMrNMNYN6/nuz/Cgu2
	 cz3CueNRQaU5SsN5b558Jnwu1eL7nTCN8VYC5ZeiDxx52SX2Mp++XNYIX18mDufq1+YZ1
	 LgDqDJ9MZrS1FucKi8Hlr/1TidM/QpzO+Gsu0daGvUSWDdK+48QWW0cXmeCsg/iBJFeHu
	 F+ZFnUgqQFhhbeKUyKIUxwWi3QF+9UaBWB78EMzM9HhqbTNqCUrx4lYsJtbjpgNLLFk74
	 3qPs6tmrgF2x1VCwEEvaP7Li6deXw8Cxht/5xbxxz9GoaAQN3XPLD4+oK/H5Uu4/STg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I7w7ZMFkVoK0vNqM2gwcIDVEqfinI5pZITRKr6CJvq8=;
	b=QXK2blk5rbsYWXEyEQM2FTJTQGkYqvksDRxWpH4gVqzYUyjVLzM/huONg4yj6ZIDApYt
	 cqtwUWDUexJBipO29mTxiwUFNvvHHCaDgQ3gRJwv+eY9iSeFYTjNk7KCfLhUH3qM+Vt23
	 eLZtNfS/ESoiJIBrnIKkl2HTu7WyoAIEjYZfqU8UZDqEkrKR2TOoaLBORpz3v+rbBn/zh
	 S/wqRjjnpfFyJDuNpjGdnS61dCRMa4W+d2xtsOnfPjoNjbWDqO/WZDBPwXKIg2TgTB8n+
	 yj6fkaMSnZOs/ntLVDYNpkEQrkakL2NcSwbWc+a+2xrnmvuzxJvbNjBiUXrL1Nre1og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m47UEyaM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9379C606A31C;
	Wed, 18 Nov 2026 21:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m47UEyaM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93601F000C4;
	Wed, 18 Nov 2026 21:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037894;
	bh=I7w7ZMFkVoK0vNqM2gwcIDVEqfinI5pZITRKr6CJvq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m47UEyaMJ3IULlOIi/KdZuZ2s5iLkxkmnC6PNdqESKT9XswBCue0mVbgDI6M/KfPC
	 /aHINX3s2ikNeLGZIvUvKst6i9PKOIJ/I4h+pEFJqrNmQuWHMypogpy/pA0a1i0Rtv
	 F2KyQlfLXDaZTEmdgae2hbBGS8+Yy0TG34x4z8I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1553/3318] drm/etnaviv: Flush the tile status cache through both the PE and BLT
Date: Wed, 18 Nov 2026 15:36:15 +0100
Message-ID: <20261118150407.605253109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 88385dc3b30d8..4f22e373ed346 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_buffer.c
@@ -230,6 +230,17 @@ u16 etnaviv_buffer_config_pta(struct etnaviv_gpu *gpu, unsigned short id)
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
@@ -253,7 +264,7 @@ void etnaviv_buffer_end(struct etnaviv_gpu *gpu)
 		unsigned int dwords = 7;
 
 		if (has_blt)
-			dwords += 10;
+			dwords += 11;
 
 		link_target = etnaviv_buffer_reserve(gpu, buffer, dwords);
 
@@ -266,16 +277,8 @@ void etnaviv_buffer_end(struct etnaviv_gpu *gpu)
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
@@ -462,12 +465,12 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, u32 exec_state,
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
@@ -484,14 +487,7 @@ void etnaviv_buffer_queue(struct etnaviv_gpu *gpu, u32 exec_state,
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



