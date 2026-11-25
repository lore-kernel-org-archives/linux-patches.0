Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621317;
	b=4MohY3+pgnNZGJYGQqGMVn9Ejmv5I4p+lRfesrFNL+X95yXMWXLAuXTT6GfzE1zNsbSy
	 npVBW1Npj7Kpm1vADulJ/6JgDZRqEmyujgj4zbbuKBDqSo4OFgeXcvAkmQhWSUIq7wPip
	 /rFIAHkQaSb/RIsKCVuLsJbxW1DkVo/oA6KRleyODyG8KbYlOEef5ecMNrU5BNgviIZsB
	 w7v2/WNrCPeFNNR1VSToxLUb50RRF2WoV0BwSU6H+JrKBaoW7vv5/ClSHqPBN9L/LBg5Y
	 rayAuKl9PxbpVTWpK2H7im1E3LNpPK1YeI94awxJ6aAcbM46N5timhgabQgK3qXx7eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BOuIVO2p9dtULNCfGJdBxH9d/+r24NXjTfHK1k1QwNE=;
	b=MVqooj91EoP38ZS/9gr7WxpcN5tAYFOcbaw5alRzb3jYh1KwgmrI9tWtyaiRYD1HDH6G
	 B2uhKe/IZd/Ah6RaP5E2lKNQvYwcjgSKojObWcdzT6Vk+aI8sndBZUUeuaAQmCYduEl+T
	 2UdY3JKr38i/4/iLTgSafLHkZJd7xIdeKLC2zNFXrzTXIW2yg1QLp/eFuwbHLcuCX1IJN
	 xMSCBCL4Ccb+n1unbp8UDK+VmG6OpuYYBWLYPx0OQvakune6lBhPztxd4JhVLWQpmT7wx
	 u7wcATbCZwsUWfaeEkCgyE4c+9FtC7pEIg2S5OVo3oWxpLS24WrK+bSkszfIJ43CBsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B5veBgX3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78013606A338;
	Wed, 25 Nov 2026 15:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B5veBgX3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D001F000D0;
	Wed, 25 Nov 2026 15:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621316;
	bh=BOuIVO2p9dtULNCfGJdBxH9d/+r24NXjTfHK1k1QwNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B5veBgX3Zz4A8mGqCzyg/fmEGhZ2TtB1pyOaDz7Ou2S5nPHw8Mb6k+hJCPq7StmJR
	 tjjOakpbrg9qamdqE+mMXkHjwtAV0mxbGrypc+iEH2d1mEuEpG+tHj71SSzD96Uxaq
	 lqPwlV+TR7Fn/EFBO01PcZ3YhAGG2UGT0AX3FgyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/990] vduse: avoid infinite loop when no affinity CPU is online
Date: Wed, 25 Nov 2026 15:25:28 +0100
Message-ID: <20261125143825.865351509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit cf0a5805d43236e308f14188f9737ddcf83fb53a ]

If all CPUs in vq->irq_affinity are offline, cpumask_next() walks to the
end of the mask, and the loop then resets the cursor to IRQ_UNBOUND and
restarts the scan. When VDUSE_VQ_INJECT_IRQ is issued, the intersection of
vq->irq_affinity and cpu_online_mask is empty, so the caller busy-loops in
kernel context on its current CPU (e.g. CPU2).

Replace the while loop in vduse_vq_update_effective_cpu() with
cpumask_next_and_wrap() to find the intersection of vq->irq_affinity and
cpu_online_mask in a single wrapped scan. If the intersection is empty, set
curr_cpu to IRQ_UNBOUND and let the existing unbound workqueue handle
injection, avoiding repeated rescans when all CPUs in the affinity are
offline. Use cpus_read_lock()/cpus_read_unlock() to keep the selected CPU
online.

Fixes: 28f6288eb63d ("vduse: Support set_vq_affinity callback")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260919083933.104437-1-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index f9547ede71be7..d68858acc5d9c 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/cdev.h>
 #include <linux/device.h>
+#include <linux/cpu.h>
 #include <linux/eventfd.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
@@ -1239,14 +1240,10 @@ static void vduse_vq_update_effective_cpu(struct vduse_virtqueue *vq)
 {
 	int curr_cpu = vq->irq_effective_cpu;
 
-	while (true) {
-		curr_cpu = cpumask_next(curr_cpu, &vq->irq_affinity);
-		if (cpu_online(curr_cpu))
-			break;
-
-		if (curr_cpu >= nr_cpu_ids)
-			curr_cpu = IRQ_UNBOUND;
-	}
+	curr_cpu = cpumask_next_and_wrap(curr_cpu, &vq->irq_affinity,
+					 cpu_online_mask);
+	if (curr_cpu >= nr_cpu_ids)
+		curr_cpu = IRQ_UNBOUND;
 
 	vq->irq_effective_cpu = curr_cpu;
 }
@@ -1427,10 +1424,12 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
 		ret = 0;
 		index = array_index_nospec(index, dev->vq_num);
 		if (!vduse_vq_signal_irqfd(dev->vqs[index])) {
+			cpus_read_lock();
 			vduse_vq_update_effective_cpu(dev->vqs[index]);
 			ret = vduse_dev_queue_irq_work(dev,
 						&dev->vqs[index]->inject,
 						dev->vqs[index]->irq_effective_cpu);
+			cpus_read_unlock();
 		}
 		break;
 	}
-- 
2.53.0



