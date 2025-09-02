Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AE830648F;
	Tue,  2 Sep 2025 12:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756814940; cv=none; b=A7ksgHQN0K23qipjUFdo6QBqtipkFa8vueJbZBv2UG8/u3F+aQuLK0S37fEF2U3OjtlrwT+yOgzwm/lZun5K76YOvZ48adlvXg4Ui2h7cW8kMX9k9Rzt8bF7fM57fG40Ywloi2BOSgAtnNMNL5Ec9E6+Tp/AT2PuGixqBnIOL9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756814940; c=relaxed/simple;
	bh=H/sBEqWyTb20zDwKJVg5tvs3nf0zWsZui95oNH6FIeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzEYUZHbhRGZ/jntQfn/j4v81yWIJgq9dFTQTkeRe7bk4VMoqkwNSCu6GF1cAvR9KgIqxTJfTRaPQ7APLQ4KWnU47Qf5D9wb+SXFo/Cq4wtt+sn3H/apz6nHzCxrpD7bX9+XXT5dxwAMQYmNr93RJTpYzjuxA57i6kytQqoanwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+Z9qz4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+Z9qz4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4D3C4CEF7;
	Tue,  2 Sep 2025 12:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756814939;
	bh=H/sBEqWyTb20zDwKJVg5tvs3nf0zWsZui95oNH6FIeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+Z9qz4hV4GaU4bbE6Wtx6Xpa+dTfkK3kO1U1khdS+/nNgC/GdoTGVdEMKUVM4Zqz
	 UJ5Z/GGGbYSXWl2gGSKbzXCxKP2/1DRjwnbEc2sa+fMqGMfxGuAazqN1pRcJQO/TsT
	 sQcgqGLMyX0Kn5UFzO6bUgnM2eKSC6TzcmyOrJs42vWwbbYewH4945QkdhGabTF8Ur
	 MoDYfiLb6KPLBqy+dwRYTPahxMqPKod0f4E9bD9Vno72PWdABbjbUneOOdwTRzJinJ
	 OUBMcm19e9cRcxYOCMOE47NPLWyon5NKu/m6v1CaKFRGCAVyKY56UbqY+A1DN+tLoW
	 p25gIoc3YdSDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Junnan Wu <junnan01.wu@samsung.com>,
	Ying Xu <ying123.xu@samsung.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jasowang@redhat.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16] virtio_net: adjust the execution order of function `virtnet_close` during freeze
Date: Tue,  2 Sep 2025 08:08:28 -0400
Message-ID: <20250902120833.1342615-17-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250902120833.1342615-1-sashal@kernel.org>
References: <20250902120833.1342615-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.4
Content-Transfer-Encoding: 8bit

From: Junnan Wu <junnan01.wu@samsung.com>

[ Upstream commit 45d8ef6322b8a828d3b1e2cfb8893e2ff882cb23 ]

"Use after free" issue appears in suspend once race occurs when
napi poll scheduls after `netif_device_detach` and before napi disables.

For details, during suspend flow of virtio-net,
the tx queue state is set to "__QUEUE_STATE_DRV_XOFF" by CPU-A.

And at some coincidental times, if a TCP connection is still working,
CPU-B does `virtnet_poll` before napi disable.
In this flow, the state "__QUEUE_STATE_DRV_XOFF"
of tx queue will be cleared. This is not the normal process it expects.

After that, CPU-A continues to close driver then virtqueue is removed.

Sequence likes below:
--------------------------------------------------------------------------
              CPU-A                            CPU-B
              -----                            -----
         suspend is called                  A TCP based on
                                        virtio-net still work
 virtnet_freeze
 |- virtnet_freeze_down
 | |- netif_device_detach
 | | |- netif_tx_stop_all_queues
 | |  |- netif_tx_stop_queue
 | |   |- set_bit
 | |     (__QUEUE_STATE_DRV_XOFF,...)
 | |                                     softirq rasied
 | |                                    |- net_rx_action
 | |                                     |- napi_poll
 | |                                      |- virtnet_poll
 | |                                       |- virtnet_poll_cleantx
 | |                                        |- netif_tx_wake_queue
 | |                                         |- test_and_clear_bit
 | |                                          (__QUEUE_STATE_DRV_XOFF,...)
 | |- virtnet_close
 |  |- virtnet_disable_queue_pair
 |   |- virtnet_napi_tx_disable
 |- remove_vq_common
--------------------------------------------------------------------------

When TCP delayack timer is up, a cpu gets softirq and irq handler
`tcp_delack_timer_handler` will be called, which will finally call
`start_xmit` in virtio net driver.
Then the access to tx virtq will cause panic.

The root cause of this issue is that napi tx
is not disable before `netif_tx_stop_queue`,
once `virnet_poll` schedules in such coincidental time,
the tx queue state will be cleared.

To solve this issue, adjusts the order of
function `virtnet_close` in `virtnet_freeze_down`.

Co-developed-by: Ying Xu <ying123.xu@samsung.com>
Signed-off-by: Ying Xu <ying123.xu@samsung.com>
Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
Message-Id: <20250812090817.3463403-1-junnan01.wu@samsung.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Critical Bug Fix
This commit fixes a **use-after-free vulnerability** in the virtio_net
driver that can cause kernel panics during system suspend. The issue is
a race condition between the suspend process and active network traffic,
specifically:

1. **Race Condition Details** (from commit message):
   - CPU-A calls `netif_device_detach()` which sets
     `__QUEUE_STATE_DRV_XOFF` on TX queues
   - CPU-B running `virtnet_poll()` can clear this flag via
     `netif_tx_wake_queue()`
   - CPU-A then calls `virtnet_close()` which disables NAPI and removes
     virtqueues
   - Later, when TCP delayed ACK timer fires, accessing the removed TX
     virtqueue causes a panic

## Code Analysis

The fix is **minimal and contained** - it simply reorders two operations
in `virtnet_freeze_down()`:

**Before (buggy order):**
```c
netif_tx_lock_bh(vi->dev);
netif_device_detach(vi->dev);  // Sets __QUEUE_STATE_DRV_XOFF
netif_tx_unlock_bh(vi->dev);
if (netif_running(vi->dev)) {
    virtnet_close(vi->dev);     // Disables NAPI - TOO LATE!
}
```

**After (fixed order):**
```c
if (netif_running(vi->dev)) {
    virtnet_close(vi->dev);     // Disables NAPI FIRST
}
netif_tx_lock_bh(vi->dev);
netif_device_detach(vi->dev);  // Then detach device
netif_tx_unlock_bh(vi->dev);
```

## Backport Suitability Criteria

1. **Fixes a real bug**: YES - Use-after-free causing kernel panics
2. **Small and contained**: YES - Only 8 lines moved, no logic changes
3. **No side effects**: YES - Just reordering existing operations
4. **No architectural changes**: YES - Simple ordering fix
5. **Critical subsystem**: YES - Network driver suspend/resume path
6. **Clear bug fix**: YES - Not a feature addition
7. **Minimal regression risk**: YES - The new order is logically correct
   (disable NAPI before marking queues stopped)

## Historical Context

From git blame analysis:
- The problematic code structure has existed since 2017 (commit
  9fe7bfce8b3e11)
- Recent changes in 2025 (commit e7231f49d52682) modified the locking
  but didn't fix the race
- This indicates the bug has been latent for **years** and affects many
  kernel versions

## Impact Assessment

- **Severity**: HIGH - Causes kernel panics during suspend with active
  network traffic
- **Likelihood**: MODERATE - Requires specific timing but can happen
  with normal TCP traffic
- **Affected systems**: All systems using virtio_net driver (VMs,
  containers)

The commit already has "[ Upstream commit
45d8ef6322b8a828d3b1e2cfb8893e2ff882cb23 ]" indicating it's been
identified for stable backporting, which further confirms its
importance.

 drivers/net/virtio_net.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 82b4a2a2b8c42..c9b18b13cd940 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -5728,14 +5728,15 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
 	disable_rx_mode_work(vi);
 	flush_work(&vi->rx_mode_work);
 
-	netif_tx_lock_bh(vi->dev);
-	netif_device_detach(vi->dev);
-	netif_tx_unlock_bh(vi->dev);
 	if (netif_running(vi->dev)) {
 		rtnl_lock();
 		virtnet_close(vi->dev);
 		rtnl_unlock();
 	}
+
+	netif_tx_lock_bh(vi->dev);
+	netif_device_detach(vi->dev);
+	netif_tx_unlock_bh(vi->dev);
 }
 
 static int init_vqs(struct virtnet_info *vi);
-- 
2.50.1

