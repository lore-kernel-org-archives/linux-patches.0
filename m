Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D81179DA;
	Tue,  8 Jul 2025 00:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932955; cv=none; b=mDcEV1N6Vm2OnxhJ3//5TTelpN89h+EOUlcBgjaDHb82ayb12hXzf/o8aou2uOTk67gTzTIIRvLuTOo5+xrW4MB3ftUV00A766e2K5l5DRlTwttO6qS048G2S62mL8PTRjGY3JrqCMNRGlgbKnnFWpuAdSAEudn142kqi+BFPgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932955; c=relaxed/simple;
	bh=amaBfhxhq9g2AYE6DhKBw6AfiPJFDociuNjRttU9LVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ETkIiMuBIPrHvSoCli/oFB1GhRxWNESredCRDDDYOpjR8AIYr0Xg1Dv59WqBTkmB3ivaNziw5Luio06p8/PkJQnjkidjPHkXS07s354QAnvl1QuBslj79yKu21Gmii+GqKmKhjKy6k0YZ8172L6mzBJOF3ZoE/Z60ipCsCJ6/R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwvTI3mR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwvTI3mR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD34C4CEF1;
	Tue,  8 Jul 2025 00:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751932955;
	bh=amaBfhxhq9g2AYE6DhKBw6AfiPJFDociuNjRttU9LVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwvTI3mRQXfRmkoz1Ucl4MjYV5KG8grL9ctyhYB1HCDtCdQVQ8Rd7JSyMN4gIrLLF
	 WEf+mv4uolZYL3UquwgcBQVFHru3OSRmM3S62zjSR7E8IMXS3TB7jFUfyzsNwemY+X
	 9WSs94P9BBxtOSSCUSqhv8vqPUqUbBISwPdBXIuiNJHcr5Y9p/lVIZd4dxJCq/gkFF
	 Vboukv2g+FPpOukx6gQGo9ik4M1YdKuLpE/ajmpk6yzZoO+x8VBXQIAFi30nLSiHwt
	 FYdLLMdiRV9ln5SKxpduL6Tb3f8e+CJMPwjoZ7PBQ6n4FafwJx6D587CapmJU4LBsd
	 hqTxTuaMYfrCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Laurent Vivier <lvivier@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 2/6] virtio_net: Enforce minimum TX ring size for reliability
Date: Mon,  7 Jul 2025 20:02:26 -0400
Message-Id: <20250708000230.793347-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250708000230.793347-1-sashal@kernel.org>
References: <20250708000230.793347-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.36
Content-Transfer-Encoding: 8bit

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit 24b2f5df86aaebbe7bac40304eaf5a146c02367c ]

The `tx_may_stop()` logic stops TX queues if free descriptors
(`sq->vq->num_free`) fall below the threshold of (`MAX_SKB_FRAGS` + 2).
If the total ring size (`ring_num`) is not strictly greater than this
value, queues can become persistently stopped or stop after minimal
use, severely degrading performance.

A single sk_buff transmission typically requires descriptors for:
- The virtio_net_hdr (1 descriptor)
- The sk_buff's linear data (head) (1 descriptor)
- Paged fragments (up to MAX_SKB_FRAGS descriptors)

This patch enforces that the TX ring size ('ring_num') must be strictly
greater than (MAX_SKB_FRAGS + 2). This ensures that the ring is
always large enough to hold at least one maximally-fragmented packet
plus at least one additional slot.

Reported-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20250521092236.661410-4-lvivier@redhat.com
Tested-by: Lei Yang <leiyang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## 1. **Critical Bug Fix**
The commit fixes a severe bug where TX queues can become permanently
stopped, causing complete network transmission failure. Looking at the
code change, it adds a crucial validation in `virtnet_tx_resize()`:

```c
if (ring_num <= MAX_SKB_FRAGS + 2) {
    netdev_err(vi->dev, "tx size (%d) cannot be smaller than %d\n",
               ring_num, MAX_SKB_FRAGS + 2);
    return -EINVAL;
}
```

This prevents a configuration that would make the network interface
essentially unusable.

## 2. **Root Cause Analysis**
The bug occurs because the `tx_may_stop()` logic (used throughout
virtio_net for flow control) stops the TX queue when free descriptors
fall below `MAX_SKB_FRAGS + 2`. If the total ring size is not strictly
greater than this threshold, the queue can:
- Stop after transmitting just one packet
- Never have enough free slots to wake up again
- Result in a permanently stalled TX queue

## 3. **User Impact**
This affects real users who:
- Use virtio_net in virtualized environments (very common in cloud/VM
  deployments)
- Configure TX ring sizes via ethtool or other management tools
- May unknowingly set ring sizes that trigger this bug

The commit message explicitly mentions a report from Lei Yang at Red
Hat, indicating this was discovered through real-world usage.

## 4. **Minimal and Safe Fix**
The fix is:
- **Small**: Only 6 lines of code added
- **Contained**: Only affects ring resize operations
- **Safe**: Adds validation without changing existing behavior for valid
  configurations
- **Clear**: Returns -EINVAL with a descriptive error message

## 5. **Meets Stable Criteria**
According to stable kernel rules, this commit qualifies because it:
- Fixes a bug that affects users (network stalls)
- Is relatively small and contained
- Has no major side effects
- Doesn't introduce new features
- Has been tested (by Lei Yang) and reviewed by maintainers (Jason Wang,
  Michael S. Tsirkin)

## 6. **Comparison with Similar Commits**
Looking at the historical commits:
- Similar commit #3 (virtio_net: ensure netdev_tx_reset_queue) was
  backported because it fixed TX queue handling issues
- This commit is even more critical as it prevents complete TX failure
- The fix is simpler than commit #3 (just validation vs. callback
  handling)

## 7. **No Architectural Changes**
Unlike commits #1 and #2 which made architectural changes to ring
sizing, this commit:
- Only adds input validation
- Doesn't change data structures
- Doesn't modify existing workflows
- Simply prevents an invalid configuration

The fact that experienced maintainers like Jason Wang and Michael S.
Tsirkin acked this change further supports its importance for stable
backporting. This is a textbook example of a fix that should go to
stable: it addresses a real bug with minimal risk.

 drivers/net/virtio_net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 6d36cb204f9bc..384aabca39964 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3231,6 +3231,12 @@ static int virtnet_tx_resize(struct virtnet_info *vi, struct send_queue *sq,
 {
 	int qindex, err;
 
+	if (ring_num <= MAX_SKB_FRAGS + 2) {
+		netdev_err(vi->dev, "tx size (%d) cannot be smaller than %d\n",
+			   ring_num, MAX_SKB_FRAGS + 2);
+		return -EINVAL;
+	}
+
 	qindex = sq - vi->sq;
 
 	virtnet_tx_pause(vi, sq);
-- 
2.39.5

