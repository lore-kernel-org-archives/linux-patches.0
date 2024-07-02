Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743ED1BD51B;
	Tue,  2 Jul 2024 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940076; cv=none; b=LPCWOwSwxY23MwAyCqxdv4q/VKeaC6U3UfnCPra2fV/qVWaJgSvT0zmnRuqUNj8biKUPbt80Z6ESExXqPn2d376vvMHmZ39P0lCb6RWG9m7HzrzFJMbCKCdhx2+STzPOZBbnebFtirRz+msKyJhm7+tw9tQqkPv0Z+cOqJAgAr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940076; c=relaxed/simple;
	bh=hsrr1maGcx5UbpHBr/tRDhSpEC9lCMu0BJk3KFJy9c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7LZnRAovd0F6A/hDup5eHsQ9TCbk4ZVqbJI+EH30GwPVGSRDXdyVhtJNADChdyEeGnf6abe9XmhIfrnHWAMPGf0s6jNHeJ8t2GPuPlip/Epw+uwq8erotII+CX0vueAUOihPsyc0eZJ5MgaqJacaz24gxcbuwrZlWcNETdS7A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKA2u+7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKA2u+7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE22C116B1;
	Tue,  2 Jul 2024 17:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940076;
	bh=hsrr1maGcx5UbpHBr/tRDhSpEC9lCMu0BJk3KFJy9c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKA2u+7ByDdp07jO/BPSXBL6l8HbWxb5JveuZ7fDeuYyZDjJYHYn675tFuuJuCt+0
	 gjjNzqBeXzWR/1XSS6MRHwV0pwpez/XPdxQZv/se5wbLfS3CIR2vcVmDiIJ2boVYwc
	 kx9ycemdRzS9Lk86rObGBNinUKVHtTvli3FBTcy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 044/222] xdp: Remove WARN() from __xdp_reg_mem_model()
Date: Tue,  2 Jul 2024 19:01:22 +0200
Message-ID: <20240702170245.660743418@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 41693154e426f..022c12059cf2f 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -295,10 +295,8 @@ static struct xdp_mem_allocator *__xdp_reg_mem_model(struct xdp_mem_info *mem,
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



