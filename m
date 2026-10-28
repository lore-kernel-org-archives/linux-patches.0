Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211194;
	b=Cl210pSpxOEATk/KBapJRGnoeigT4vwKu12gfx7c9BKBDAbO+KOpYQyE9G4hYFBYcsvs
	 KkvvfEaeM3aLFNBeMYyPiKzH+I2R74mT7wJQl13TqvW3qD8W9WHAqFgWYOCzlcIvO8igj
	 XN1E7M820W1s/ehGlBiSwFBctR7nEscTtXPo809ImTxCrbeKEvGjXo8PDZzdjs+yNX7dL
	 oMf/rcpsWeSt9mZ5BLWUt91U1EEHQLhG+dWkHBmlFg6T8M4yOPT9IuG+wfd6Hb9s1vLrp
	 N4knit+x0TDz2oiSoz4CiI/VQm6027HZHSTyf3PUtxhtYJdP/DDOujIGtU/r5spbO6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wE9AhFPXhu7xrmzMWO9dkefo3GKR8tVi7423CqssVZo=;
	b=vNRbGIvzYoLwENF1PetR0yv+UbrxD2P9WHdEZWDLFQH7ml1yTTgwRVTe5XGaoHbZ0W8I
	 YjjM/6x1JsH0rr0+VfVZ18/K5IDEMogiwsWdWKTnhuU51zePCq+IzhOaNlIt0u2euJSoe
	 0K+/ZaVV1r1khAllpcg4YIA2GU9lQ4rTKPqNMgqqfEIWM/lStTzPL+NFbJJBZdEDge3Sj
	 B/AiMsqTA/a9lqhZeH48TxBcVoEt/lVBf61H8u4PAyR0yh9o4An63qPVEnL20Led9UB4c
	 wW+YdzwMBGtDie0bwpuJdSbCQCRyogn7vDjyvXNlP/A9Nz9xTbSaRD6SVrIUrs1qudg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BIr/knJe";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C42606A948;
	Wed, 28 Oct 2026 18:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIr/knJe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD871F031E0;
	Wed, 28 Oct 2026 18:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211194;
	bh=wE9AhFPXhu7xrmzMWO9dkefo3GKR8tVi7423CqssVZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIr/knJeL8hgHrBwUluNwf5UXpQTN7UbyexNwmtMlCYL2sMgWChjJm2LBupJLYJFe
	 iTVXXFzAarOUlBikL7u/nltAWuCAMJLyEWXFegqU2Hk06vZMn2IiiNEaXy5aWCFNa+
	 /FwXP/yZu5091DEDdIblzzb7G2h1zHkRRVzaFiWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 292/571] perf: Require kernel access for text poke events
Date: Wed, 28 Oct 2026 17:57:19 +0100
Message-ID: <20261028170014.929605276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchuan Liang <zcliangcn@gmail.com>

[ Upstream commit 357e8a77a501d96c9517f01f4a211eed5e9c9184 ]

Perf events with exclude_kernel=1 can be opened without kernel perf
access. However, exclude_kernel does not suppress text-poke sideband
records. Every PERF_RECORD_TEXT_POKE is marked PERF_RECORD_MISC_KERNEL
and contains a raw kernel instruction address.

An unprivileged task can therefore open and mmap a task-local software
event with text_poke=1. Both opening a count-only tracepoint event and
configuring UDP GRO for ESP-in-UDP cause updates to inline static calls;
the observer receives the relocated addresses of the modified instructions.
For a known kernel image, any such address reveals the runtime kernel
text base despite KASLR.

Call perf_allow_kernel() whenever attr.text_poke is set, regardless of
exclude_kernel. Events that neither monitor kernel execution nor request
text-poke records retain their existing permissions.

Fixes: e17d43b93e54 ("perf: Add perf text poke event")
Assisted-by: LLM
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/99131354c41e23188f778b92f90363775b482395.1790573390.git.zcliangcn@gmail.com
[ sashal: Adjusted context because the existing exclude_kernel check lacks the callchain condition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e350e8d1fb188..fc2d2f2734459 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12427,7 +12427,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (err)
 		return err;
 
-	if (!attr.exclude_kernel) {
+	if (!attr.exclude_kernel || attr.text_poke) {
 		err = perf_allow_kernel(&attr);
 		if (err)
 			return err;
-- 
2.53.0



