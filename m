Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215236;
	b=OOKcYHbtFRu2OWBSPKXDwzfSpiBS12MSxvgZh3DQtdTZZ03Sz4iTR9SFmh52Lhej/Qfu
	 3pwzch75d0bXREs0DoLmhpuTv4kUbgnD1hTw6vMo7Iw4I2eqKT0FONTkvxAetb/IuVsZ8
	 wjpZL+q0UZ3CdqthY3rwZJPX4FmRFLuqV/zZXnf8QSPBEEwNUfeE3NJiwu++ad0NMBNJi
	 bu0l4zNlSEZ9DuYFjcVJ6Jv9S/situ7gsxqv/yzq8besr4sy9PncL79Kc/oENanSL6rsn
	 LSMyHzdjO36AxOza2Uwj/qvVqFtZl1TJFLCi+e6eylim0SVEv04d8dPcCYS4XVltl/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YU/6XzeQATk03oR6H0bJNkMyxANBwB07p6QsGe/Lwdg=;
	b=jni1twFNcovBloghIq54tJw7WnWOgQnkdJxRPJIAnAnMgGhm2ua9QqGDC8BQjDBl86XB
	 4QsAreebNv054KbW8O8nN/SVzCf8xGvCRn3n+S1pTVhxjRpc+V6egZNuhFqh5k4M7WndX
	 hQloF3zExkX+ConQtfzH5l02ykq5by9yDHvXLQLhgDi6b08A6MCyNfPnxo+Mp6FliMS/x
	 5cYilqhCL3GIV7oXVhSuD4UWwcRb1FgsHMNdXd3zBdv0+M08HbEtbyPqYn0vO1l2z2W/c
	 x9xb/4GXI/gkjDEgQd0viPfnjD7M8Der/K4jzLyV1eEorGpHAXYPA1TqmhJ1t2snwLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PJh0mA9i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6647606A31A;
	Wed, 28 Oct 2026 19:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PJh0mA9i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D4A1F01828;
	Wed, 28 Oct 2026 19:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215235;
	bh=YU/6XzeQATk03oR6H0bJNkMyxANBwB07p6QsGe/Lwdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJh0mA9iwWoa/wrBwqqaaRMScKzbvRz2Bb7617+4jOATHYPxEXCVRV08O1RHQCi2l
	 z6DJNBSFBgn1USlvzE9B1wiizv80KiPTRFF26mAWewQ3aL+3xPA0ogdMln1Rhk9mI7
	 TI4bagDthHAuNuL+e/KlG/AlwTtOgmecKaWmLiz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1086/1887] bpf: Fix RCU stall in bpf_fd_array_map_clear()
Date: Wed, 28 Oct 2026 17:53:02 +0100
Message-ID: <20261028170524.118831853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sechang Lim <rhkrqnwk98@gmail.com>

[ Upstream commit 4406942e65ca128c56c67443832988873c21d2e9 ]

Add a missing cond_resched() in bpf_fd_array_map_clear() loop.

For PROG_ARRAY maps with many entries this loop calls
prog_array_map_poke_run() per entry which can be expensive, and
without yielding this can cause RCU stalls under load:

  rcu: Stack dump where RCU GP kthread last ran:
  CPU: 0 UID: 0 PID: 30932 Comm: kworker/0:2 Not tainted 6.14.0-13195-g967e8def1100 #2 PREEMPT(undef)
  Workqueue: events prog_array_map_clear_deferred
  RIP: 0010:write_comp_data+0x38/0x90 kernel/kcov.c:246
  Call Trace:
   <TASK>
   prog_array_map_poke_run+0x77/0x380 kernel/bpf/arraymap.c:1096
   __fd_array_map_delete_elem+0x197/0x310 kernel/bpf/arraymap.c:925
   bpf_fd_array_map_clear kernel/bpf/arraymap.c:1000 [inline]
   prog_array_map_clear_deferred+0x119/0x1b0 kernel/bpf/arraymap.c:1141
   process_one_work+0x898/0x19d0 kernel/workqueue.c:3238
   process_scheduled_works kernel/workqueue.c:3319 [inline]
   worker_thread+0x770/0x10b0 kernel/workqueue.c:3400
   kthread+0x465/0x880 kernel/kthread.c:464
   ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:153
   ret_from_fork_asm+0x19/0x30 arch/x86/entry/entry_64.S:245
   </TASK>

Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
Fixes: da765a2f5993 ("bpf: Add poke dependency tracking for prog array maps")
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
Link: https://lore.kernel.org/r/20260407103823.3942156-1-rhkrqnwk98@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arraymap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 220df952aeabe..6fc07a983dd0c 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -940,8 +940,10 @@ static void bpf_fd_array_map_clear(struct bpf_map *map)
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	int i;
 
-	for (i = 0; i < array->map.max_entries; i++)
+	for (i = 0; i < array->map.max_entries; i++) {
 		fd_array_map_delete_elem(map, &i);
+		cond_resched();
+	}
 }
 
 static void prog_array_map_seq_show_elem(struct bpf_map *map, void *key,
-- 
2.53.0



