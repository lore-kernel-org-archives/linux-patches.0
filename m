Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8370C43152;
	Tue,  2 Jul 2024 17:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940813; cv=none; b=lJcRHBDs7oo5uFPSTpDwPHYQsi5mwJ3XVzjLoAzHi26xtdzhpCAPUMAJhXHAWfwEFtGJ5P/T8iISV4unmrqmumpZobuZV58CGd2W9n+3D2KYmGvcmyBpLMjU20Y9i/JjqDsJmKIeoYU2ycN67lOMdznYzCYy1TBdW5BFMzjIMLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940813; c=relaxed/simple;
	bh=ByR2asmIGYtwYysblBZVDKlF+fnE2fyOjw5cQO4Q+3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABELu3gQpqQ6lu9dLuN7o+1qEGFOaB9x1wVkkmhDVXs802h/Pki5pIcjZV8Ssf6FmTSvWdXjFu+njRt+bktREiMDtXprQbnyCAP3TdoI8PpBphzkTw53GfRPAoNJAHV3wkSML8SyJ8jXe/REqI8F3tKDLZ2VhjHmiaII7Y5c43M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=un+kMp5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="un+kMp5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728E6C116B1;
	Tue,  2 Jul 2024 17:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940813;
	bh=ByR2asmIGYtwYysblBZVDKlF+fnE2fyOjw5cQO4Q+3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=un+kMp5RZu1XmSHeRqackf1YXiABMB5Qn+BlbQm65EejulePMg4G8TcTrVvFV+F4G
	 YMlatiQlNYemhVQJzYUvEmHhZJMpt8QxouLqPmO/c7ktKtkyrcIztthY5HAH4jLcP7
	 KYYrzCiQA3ySM3bLMr5eLAcNXZQH83NA2QMqwUe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/163] xdp: Remove WARN() from __xdp_reg_mem_model()
Date: Tue,  2 Jul 2024 19:02:30 +0200
Message-ID: <20240702170234.426226163@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit 7e9f79428372c6eab92271390851be34ab26bfb4 ]

syzkaller reports a warning in __xdp_reg_mem_model().

The warning occurs only if __mem_id_init_hash_table() returns an error. It
returns the error in two cases:

  1. memory allocation fails;
  2. rhashtable_init() fails when some fields of rhashtable_params
     struct are not initialized properly.

The second case cannot happen since there is a static const rhashtable_params
struct with valid fields. So, warning is only triggered when there is a
problem with memory allocation.

Thus, there is no sense in using WARN() to handle this error and it can be
safely removed.

WARNING: CPU: 0 PID: 5065 at net/core/xdp.c:299 __xdp_reg_mem_model+0x2d9/0x650 net/core/xdp.c:299

CPU: 0 PID: 5065 Comm: syz-executor883 Not tainted 6.8.0-syzkaller-05271-gf99c5f563c17 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
RIP: 0010:__xdp_reg_mem_model+0x2d9/0x650 net/core/xdp.c:299

Call Trace:
 xdp_reg_mem_model+0x22/0x40 net/core/xdp.c:344
 xdp_test_run_setup net/bpf/test_run.c:188 [inline]
 bpf_test_run_xdp_live+0x365/0x1e90 net/bpf/test_run.c:377
 bpf_prog_test_run_xdp+0x813/0x11b0 net/bpf/test_run.c:1267
 bpf_prog_test_run+0x33a/0x3b0 kernel/bpf/syscall.c:4240
 __sys_bpf+0x48d/0x810 kernel/bpf/syscall.c:5649
 __do_sys_bpf kernel/bpf/syscall.c:5738 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5736 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:5736
 do_syscall_64+0xfb/0x240
 entry_SYSCALL_64_after_hwframe+0x6d/0x75

Found by Linux Verification Center (linuxtesting.org) with syzkaller.

Fixes: 8d5d88527587 ("xdp: rhashtable with allocator ID to pointer mapping")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Link: https://lore.kernel.org/all/20240617162708.492159-1-d.dulov@aladdin.ru
Link: https://lore.kernel.org/bpf/20240624080747.36858-1-d.dulov@aladdin.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/xdp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index a70670fe9a2dc..5fe4c099f30a3 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -294,10 +294,8 @@ static struct xdp_mem_allocator *__xdp_reg_mem_model(struct xdp_mem_info *mem,
 		mutex_lock(&mem_id_lock);
 		ret = __mem_id_init_hash_table();
 		mutex_unlock(&mem_id_lock);
-		if (ret < 0) {
-			WARN_ON(1);
+		if (ret < 0)
 			return ERR_PTR(ret);
-		}
 	}
 
 	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
-- 
2.43.0



