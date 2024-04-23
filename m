Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDFA143C6C;
	Tue, 23 Apr 2024 21:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908806; cv=none; b=tRqH9qKJRMfKt5nGiHyo4UM2SVKR+uDkhNXYCpl3dH2EJFUg06TQIz4jrT9rwHPbt15Js8MCbXergZMSGGXCfRtd6FleZAzQt6Guc5vU/isd6kneGzZ2rkah5DPGSkTfIpnetBgBFiaHDIDFtxh0aExEXgFcWLLEUd9swAhrvng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908806; c=relaxed/simple;
	bh=DTD1x/otQEnCUccEG3gKoJ/xhpOmhzkgpd6COGB8i64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNk5C354RBT84G+gPEM16J7Q9HG15ZVnPY7DIlQg5wl0baiq2bNwsjGWECfJ0t8lPnEGN5lE2d6UhrKaWIN0kUKGc5MUtjghUkBfQwKY2GXMRb4V8yHTWsEomUaf3tz+jEFd+OUww1/wQFi3sAvBy4OXk5bWA7DqXICEMID2pJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECrgNH91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECrgNH91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F2FC116B1;
	Tue, 23 Apr 2024 21:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908806;
	bh=DTD1x/otQEnCUccEG3gKoJ/xhpOmhzkgpd6COGB8i64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECrgNH91pPGStmfJo2AhQu7f/72tX1ATKOsrZ5/WaaNsO92vqYhq/x38G1lI6PwK/
	 uXI/08Nwzb9yuy57rHB3lakdaZM9DFA267Xuk5fQTX/JH+WLCTFyjz567tO35XVBh9
	 vfu5vZZkzB5Ane6FDOteNMsBk+fJM0HnAvw/yO9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@redhat.com>
Subject: [PATCH 5.15 66/71] nouveau: fix instmem race condition around ptr stores
Date: Tue, 23 Apr 2024 14:40:19 -0700
Message-ID: <20240423213846.480886974@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

From: Dave Airlie <airlied@redhat.com>

commit fff1386cc889d8fb4089d285f883f8cba62d82ce upstream.

Running a lot of VK CTS in parallel against nouveau, once every
few hours you might see something like this crash.

BUG: kernel NULL pointer dereference, address: 0000000000000008
PGD 8000000114e6e067 P4D 8000000114e6e067 PUD 109046067 PMD 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 7 PID: 53891 Comm: deqp-vk Not tainted 6.8.0-rc6+ #27
Hardware name: Gigabyte Technology Co., Ltd. Z390 I AORUS PRO WIFI/Z390 I AORUS PRO WIFI-CF, BIOS F8 11/05/2021
RIP: 0010:gp100_vmm_pgt_mem+0xe3/0x180 [nouveau]
Code: c7 48 01 c8 49 89 45 58 85 d2 0f 84 95 00 00 00 41 0f b7 46 12 49 8b 7e 08 89 da 42 8d 2c f8 48 8b 47 08 41 83 c7 01 48 89 ee <48> 8b 40 08 ff d0 0f 1f 00 49 8b 7e 08 48 89 d9 48 8d 75 04 48 c1
RSP: 0000:ffffac20c5857838 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 00000000004d8001 RCX: 0000000000000001
RDX: 00000000004d8001 RSI: 00000000000006d8 RDI: ffffa07afe332180
RBP: 00000000000006d8 R08: ffffac20c5857ad0 R09: 0000000000ffff10
R10: 0000000000000001 R11: ffffa07af27e2de0 R12: 000000000000001c
R13: ffffac20c5857ad0 R14: ffffa07a96fe9040 R15: 000000000000001c
FS:  00007fe395eed7c0(0000) GS:ffffa07e2c980000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 000000011febe001 CR4: 00000000003706f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:

...

 ? gp100_vmm_pgt_mem+0xe3/0x180 [nouveau]
 ? gp100_vmm_pgt_mem+0x37/0x180 [nouveau]
 nvkm_vmm_iter+0x351/0xa20 [nouveau]
 ? __pfx_nvkm_vmm_ref_ptes+0x10/0x10 [nouveau]
 ? __pfx_gp100_vmm_pgt_mem+0x10/0x10 [nouveau]
 ? __pfx_gp100_vmm_pgt_mem+0x10/0x10 [nouveau]
 ? __lock_acquire+0x3ed/0x2170
 ? __pfx_gp100_vmm_pgt_mem+0x10/0x10 [nouveau]
 nvkm_vmm_ptes_get_map+0xc2/0x100 [nouveau]
 ? __pfx_nvkm_vmm_ref_ptes+0x10/0x10 [nouveau]
 ? __pfx_gp100_vmm_pgt_mem+0x10/0x10 [nouveau]
 nvkm_vmm_map_locked+0x224/0x3a0 [nouveau]

Adding any sort of useful debug usually makes it go away, so I hand
wrote the function in a line, and debugged the asm.

Every so often pt->memory->ptrs is NULL. This ptrs ptr is set in
the nv50_instobj_acquire called from nvkm_kmap.

If Thread A and Thread B both get to nv50_instobj_acquire around
the same time, and Thread A hits the refcount_set line, and in
lockstep thread B succeeds at refcount_inc_not_zero, there is a
chance the ptrs value won't have been stored since refcount_set
is unordered. Force a memory barrier here, I picked smp_mb, since
we want it on all CPUs and it's write followed by a read.

v2: use paired smp_rmb/smp_wmb.

Cc: <stable@vger.kernel.org>
Fixes: be55287aa5ba ("drm/nouveau/imem/nv50: embed nvkm_instobj directly into nv04_instobj")
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240411011510.2546857-1-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/instmem/nv50.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/nv50.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/instmem/nv50.c
@@ -221,8 +221,11 @@ nv50_instobj_acquire(struct nvkm_memory
 	void __iomem *map = NULL;
 
 	/* Already mapped? */
-	if (refcount_inc_not_zero(&iobj->maps))
+	if (refcount_inc_not_zero(&iobj->maps)) {
+		/* read barrier match the wmb on refcount set */
+		smp_rmb();
 		return iobj->map;
+	}
 
 	/* Take the lock, and re-check that another thread hasn't
 	 * already mapped the object in the meantime.
@@ -249,6 +252,8 @@ nv50_instobj_acquire(struct nvkm_memory
 			iobj->base.memory.ptrs = &nv50_instobj_fast;
 		else
 			iobj->base.memory.ptrs = &nv50_instobj_slow;
+		/* barrier to ensure the ptrs are written before refcount is set */
+		smp_wmb();
 		refcount_set(&iobj->maps, 1);
 	}
 


