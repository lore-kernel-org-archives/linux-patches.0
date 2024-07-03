Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E88013B280;
	Wed,  3 Jul 2024 11:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006025; cv=none; b=lM9xnSWUuIVAO7yXvDulw8/PvkENgs4rMtySm74qp5vXrBulyVC3dsQGPS66TuCuukKVbmHlxr07D+GktyzncE9uvh73FevABqTPTOZoUN6aOStjOMbDi1OkbYWTVEBLm+q/9W30jIsz86T99p9efwNRLoB3Zhp2kH5bHsw4vJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006025; c=relaxed/simple;
	bh=QGCo6l8jOVSr1/1/q4aruzFWviIyeRifC5hobpLcMpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBpJqJGI5uuN0L6yzgRouksjkY4Uxv+lxq58Cfl506D4NHEoXm7O+7Z6/VX4Eot3datCp5iCpNiM7rVfUWmn1Lc66KBbdOj+PmFuesxMKOtFhhb9G0AAm4E4+CZ1HOt9AkATJhO2bW595fygiKtOQBiSPKeZRVc+LJRg6+rxirE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UauB5pWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UauB5pWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D641C2BD10;
	Wed,  3 Jul 2024 11:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006025;
	bh=QGCo6l8jOVSr1/1/q4aruzFWviIyeRifC5hobpLcMpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UauB5pWTp+3qsOnFYrwnE919jeaRAHMW1ubtatJRJmYxsc/xDr1zhvvt6YGJS4l2G
	 WEJLsabuslvZRPEmzQ8sCdA9KgpebKQhaf4r9vUutBNOeI+e+s6JUjP2upMfTLRjs8
	 ygMbot+ir7DoNf5Icqw35SB7gwNZxwoVhNufq5X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 274/356] xdp: Remove WARN() from __xdp_reg_mem_model()
Date: Wed,  3 Jul 2024 12:40:10 +0200
Message-ID: <20240703102923.479576211@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a3e3d2538a3a8..e9a9694c4fdcc 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -292,10 +292,8 @@ static struct xdp_mem_allocator *__xdp_reg_mem_model(struct xdp_mem_info *mem,
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



