Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210899;
	b=3WXb8uy2FlTi4Wa5Dd6sivfyUPHnFLGHdDK68JK95WzdoXzEowezZXMH/IdVXW7iAVRN
	 6ZJlfdFyyR/UEgFnZqWT9B+aCo7ybRcoBChap4MPkIZp6C3r7J5UvPlirTDR3zzrRgmB8
	 IqNqWl1q4/c7VtJQBtcYyAA9cyLWoYkRAPWupdHpfF3fTZciI2a+JAK6Kj+wxXfRvejtV
	 2dlMrDn2cZ88BJotVvgQlDzsr/W1mFuxYZ0NiHbDExxtxJ2aDr+ceTrVCJHmo/TinYshq
	 P3ZH2lltU/U10eEeiug8UJHqPdKE/80OBWginMDOzNBC7vi+fY5T/q/4k2Ihp/TJHGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gwi+RKfDMZcDqNHSly+kdBXR+fUmZ+SnIEUQjpwsOpY=;
	b=h0k47tBvekaZ8zjdbJkrWLVRE28oCV76VEoX0Oj/hE/DSFXyAkRMmW275viloJNh3iJE
	 UcTCIO2sQDZTswjM3xlfbu9PBJMOIm9QBeWDCY9pe+QxT2ngq0gtvumEJJNHNYZm5K8/X
	 3I9VhV6Ub0o1J7Om5Q7AkTMSWQ7B3meN9LZjLQHu6AZfycb2CeA1VW9vco/DDhOBYHtZW
	 PHwyLu4AOuoQno1do34or5kdx17ggAnJHf8rR9sbTc7bEgKhDqvwVv9yN38lRLZ4nYccM
	 okfcRDtAvRWJBHQe74fbtBhIa7ZmGwoLzKAbtrkUYq1uriv2zoXRceAmbWFKuQTx0kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbNFoSpS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6BF606A31A;
	Wed, 28 Oct 2026 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbNFoSpS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B88771F01825;
	Wed, 28 Oct 2026 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210899;
	bh=gwi+RKfDMZcDqNHSly+kdBXR+fUmZ+SnIEUQjpwsOpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbNFoSpSrETBDC2f/FVu7E6LNPE87dpmNHHZfzO/20AIw/Wo9Osaky8mjLLxRXsfw
	 KeAY9wnUcQBb+GLT4fNJlzX92CsdaPWiRgBIqBteVXX2YdIN+4/e24xSNV+zCVNSff
	 JsCosUsMahS5JNctx5JM3dbr0HcdOSe9/fI/lYvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun2@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/571] perf: Fix race between perf_event_exit_task() and perf_pending_task()
Date: Wed, 28 Oct 2026 17:55:36 +0100
Message-ID: <20261028170012.495509330@linuxfoundation.org>
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

From: Luo Gengkun <luogengkun2@huawei.com>

[ Upstream commit ffb684f2aa141eeb0caa6308422e7e05d1ded7c4 ]

A race condition exists between perf_event_exit_task() and
perf_pending_task() during begin_new_exec().

During begin_new_exec(), perf_event_exit_task() may be called, and the
PF_EXITING flag is not set on task. So perf_sigtrap() continues to execute
and triggers WARN_ON_ONCE(event->ctx->task != current).

Since both task exit and exec paths can call perf_event_exit_task() which
sets ctx->task to TASK_TOMBSTONE, fix this by explicitly checking if
event->ctx->task equals TASK_TOMBSTONE and dropping the redundant
PF_EXITING check.

Fixes: 97ba62b27867 ("perf: Add support for SIGTRAP on perf events")
Signed-off-by: Luo Gengkun <luogengkun2@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260920075026.990582-1-luogengkun2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 40d31c3e1eb7a..e350e8d1fb188 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6692,9 +6692,11 @@ static void perf_sigtrap(struct perf_event *event)
 {
 	/*
 	 * Both perf_pending_task() and perf_pending_irq() can race with the
-	 * task exiting.
+	 * task exiting or exec-ing. We can determine if such a race has
+	 * occurred by checking if perf_event_exit_task(), which will set
+	 * ctx->task to TASK_TOMBSTONE, has already been called.
 	 */
-	if (current->flags & PF_EXITING)
+	if (event->ctx->task == TASK_TOMBSTONE)
 		return;
 
 	/*
-- 
2.53.0



