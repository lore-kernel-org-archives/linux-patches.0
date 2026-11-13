Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585390;
	b=yzXkCMDWsfzI0LZatS4wbSF4lK3wZVFcwYO11N8JUp9W5uHjtEOzqt/6A7n8zBfjNLZa
	 ZVhP3EeUgQKGoS8Lt/MDs7r59aVOqBtSvuPfzYtXng23FUBQkk3lotiG0mfrj64M2Jran
	 WyHXX0Kn7Qc3J7w043VBtNVW3NNdMjojJ5SacwBG02sylcoy4xS29trSbpkagOzt0NgNi
	 VM3wmh3RDxaKxNGJdJATK36PV6jA0gOsfsJr6zfOi31CjVxiJb3iHk+mBPNNG1nH/9hGe
	 /yOGXwA2nwTHlPjjM7jciYlG9dNIus7+QT5Gnrt3KcPGBFKk8/sSuBt+6NpvzpgalCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=s4GISVEZiUHu1eOYOBsZeBlM3+azUzLb75ojadsZj0w=;
	b=gRiqOlpMOoYd3aPKJhWU/1Qdh9i0HHJxisbSCVOYd9qhojWSNwT45+tuQGsem2a4WPjh
	 opMsttc+XEJRpUx2c7sf1vlCMg0+WWcKpECpnEj5DtTr7XHKVluP6nFCYb8EpKZAAkmfr
	 uo9LnPCaI/32QfZ1MG3wABkYRVt3Loya+GjrOOyvUSzgf9K0CPVeObBaK0/3aOZftgxqu
	 PXMVtCr99mlbtuI1hJRUXsUjTVmNwoBHi2peHUYCb28poE2if8IF8hddEH6NzoTfdTro7
	 yrT9JCTTP8kgajV53bzMcJJOISbfuyIvtoyI/lWvSUVrp/44Q6ibgGLMvwUQTgjQlwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z41LHglW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96F56070FC5;
	Fri, 13 Nov 2026 15:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z41LHglW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954FB1F000C4;
	Fri, 13 Nov 2026 15:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585389;
	bh=s4GISVEZiUHu1eOYOBsZeBlM3+azUzLb75ojadsZj0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z41LHglWUcMHm/KlytAgk8GmptDoiU/rv5EPS4bSHw2ad6HVALDLjeAVzlRhYhvYV
	 nh78joiietVwfi7i2bleZiSJ4ED0fXm3EvsB+lyHfNc7sX6hULD6WTOxkeum+5DDMw
	 cLFNatz4IDfb4zFi4ZrOPCE/yYujsawuuyf4BRGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Philipp Stanner <phasta@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 062/507] drm/drm_crtc: fix race with dma_fence_signal() in ::get_driver_name()
Date: Fri, 13 Nov 2026 10:46:06 -0500
Message-ID: <20261113153755.654539977@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit cb104d395da48d965665fefe8502f71b6e7e3733 ]

Since commit 541c8f2468b9 ("dma-buf: detach fence ops on signal v3"),
I'm seeing the BUG_ON() triggering in drm_crtc's fence_to_crtc() via
drm_crtc_fence_get_driver_name() regularly:

    Call trace:
     panic+0x58/0x5c
     die+0x160/0x178
     bug_brk_handler+0x70/0xa4
     call_el1_break_hook+0x3c/0x1a0
     do_el1_brk64+0x24/0x74
     el1_brk64+0x34/0x54
     el1h_64_sync_handler+0x80/0xfc
     el1h_64_sync+0x84/0x88
     drm_crtc_fence_get_driver_name+0x60/0x68 (P)
     sync_file_get_name+0x184/0x45c
     sync_file_ioctl+0x404/0xf70
     __arm64_sys_ioctl+0x124/0x1dc

This looks to be caused by a code flow similar to the following:

+++ snip +++
thread A                             thread B

                                     ioctl(SYNC_IOC_FILE_INFO)
                                     sync_file_ioctl()
                                     sync_file_get_name()
dma_fence_signal_timestamp_locked()  dma_fence_driver_name()
                                       ops = rcu_dereference(fence->ops)
                                       if (!dma_fence_test_signaled_flag())
                                         ops->get_driver_name(fence) i.e.
                                         drm_crtc_fence_get_driver_name()
test_and_set_bit(SIGNALED)
RCU_INIT_POINTER(fence->ops, NULL)
                                     drm_crtc_fence_get_driver_name()
                                       BUG_ON(rcu_access_pointer(fence->ops)
                                              != &drm_crtc_fence_ops)
+++ snap +++

In other words, a fence's ops pointer can now change to NULL on signal,
which wasn't the case before the culprit commit and hence the BUG_ON()
triggers.

Simply drop the BUG_ON() as it's usage of fence ops is invalid now, and
because using BUG_ON() and friends to take down the system is an
unacceptable way to handle a failure.

Note that the adjacent drm_crtc_fence_get_timeline_name() has the same
problem and is fixed by this patch as well.

Fixes: 541c8f2468b9 ("dma-buf: detach fence ops on signal v3")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Reviewed-by: Philipp Stanner <phasta@kernel.org>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20260721-linux-drm_crtc_fix2-v3-2-afa8c71506e6@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_crtc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index e8e80c9368529..5295ec122e0d1 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -154,11 +154,8 @@ static void drm_crtc_crc_fini(struct drm_crtc *crtc)
 #endif
 }
 
-static const struct dma_fence_ops drm_crtc_fence_ops;
-
 static struct drm_crtc *fence_to_crtc(struct dma_fence *fence)
 {
-	BUG_ON(rcu_access_pointer(fence->ops) != &drm_crtc_fence_ops);
 	return container_of(fence->extern_lock, struct drm_crtc, fence_lock);
 }
 
-- 
2.53.0



