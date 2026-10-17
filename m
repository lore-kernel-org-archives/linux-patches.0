Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DD134B437;
	Sat, 17 Oct 2026 18:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260663; cv=none; b=hwuuHVnGPtBgLDaEwna3eaHwUhmpaPoymvpgyy+4bcg0S7BXCQINDl7BPyy7MTFuoe6JArPUUqMIs1WuOc1X9NtUccVBA6qBolyOoiOoDwygs+2jJefy/lvIb2xuVCp3i0t77dzpuTrGMZqKSeAiwlN8dvVx0FNZQu7axwUFsrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260663; c=relaxed/simple;
	bh=bsGY6iez6miE+jxhTad/aoDYS0GPFapcNjQxNxD9qr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0movxS6vDzKnbe2KziEH+aQIfSVWEnZXQ5vygH1uQmyQq42WhmlS5n48R5YYaeqPrbjMmS5ToemvpZUkqqMnnHskiaVUT22Vn+9JRdMG0xA0UL8+PI2LOnqo1wWgdDu6pU1rrIdcFdIX2cefrBZ81tCuWW+dnZNVYjt12sPesc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRh8tYEY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRh8tYEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54A51F000C4;
	Sat, 17 Oct 2026 18:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260662;
	bh=Wf2TyM+T8kgPl/Sv2ykJTnPvlWZc0izgYWNrgnk/yn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zRh8tYEYDxHbOPQYtqFr/rnh1+E2i5ZO+fX3I0iRYacUI9Wr59tMJ18ELiPkOVdsC
	 7+kBxVzyVpda2sAqL2xtblYcaUHzD1wfOsBOs5g3vYvmwgdpo2xZAgNYnBRsDJyXbC
	 anAmQJrRfVKhnbqsyYOZYSlLEkzcPeI0fRgrLmAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1618/1674] vduse: validate virtqueue alignment
Date: Sat, 17 Oct 2026 18:04:50 +0200
Message-ID: <20261017160512.614794034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit fa2c25b4add57888acfa89e398389e267bff3dcf ]

vduse_validate_config() only checks the upper bound of vq_align. Invalid
values can therefore reach vring_create_virtqueue_map(). The split-ring
helpers use align - 1 as a bit mask, so the alignment must be a non-zero
power of two. A zero value makes vring_size() drop the descriptor and
available-ring part and vring_init() leave the used ring pointer NULL.

The VIRTIO spec requires the used ring to start at an address
aligned to at least 4 bytes. Reject values below VRING_USED_ALIGN_SIZE as
well as non-power-of-two values before they reach the virtio ring helpers.

Opening a virtio-net device created with vq_align=0 triggered:

BUG: KASAN: null-ptr-deref in virtqueue_kick_prepare_split+0xe3/0x100
Read of size 2 at addr 0000000000000000 by task systemd-network/1062

Call Trace (relevant frames):
 dump_stack_lvl
 print_report
 kasan_report
 __asan_load2
 virtqueue_kick_prepare_split+0xe3/0x100
 virtqueue_kick_prepare+0x40/0x60
 try_fill_recv+0x857/0x1250
 virtnet_open+0x189/0x460
 __dev_open+0x225/0x390
 __dev_change_flags+0x368/0x3b0
 netif_change_flags+0x56/0xc0
 do_setlink.isra.0+0x68c/0x1e30

Validate the value before it reaches the virtio ring helpers.

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260830023354.115333-1-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 85f9bbb563c5e..7838c54c8e6ac 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1708,7 +1708,9 @@ static bool vduse_validate_config(struct vduse_dev_config *config)
 			 sizeof(config->reserved)))
 		return false;
 
-	if (config->vq_align > PAGE_SIZE)
+	if (config->vq_align < VRING_USED_ALIGN_SIZE ||
+	    !is_power_of_2(config->vq_align) ||
+	    config->vq_align > PAGE_SIZE)
 		return false;
 
 	if (config->config_size > PAGE_SIZE)
-- 
2.53.0



