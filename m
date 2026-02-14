Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90E827B353;
	Sat, 14 Feb 2026 21:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104326; cv=none; b=DxLhHDVQPlY22fo+zBxzgDuip3LUwIxSQXgLvJL2OhH8nXi2kRfpapElKISOvkcLlXcg2UnBfaLv8mXsMXsUhA0d55lE+zZ6QHa+99zxmYUU9B32ZLxHubjzzbcowS8sWVaMc/ESj6MyI7RjFqnGGmIsyp43M4EwfXklU43YjSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104326; c=relaxed/simple;
	bh=qQi4cKET8P1ejnoqtou0oEXuI4aZk8+q61dw8XPwE1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W9ZGUk0ESQRKsz6xNPLd3odXWM155haHxZPcp5FjcKolzLjoGgpoMW2mz8xdYxq/+wkRXbEdGIDyWtgIG/FW3FbNkZxBGoWygJIC6oELidBGcif8c0FOFJii2B7kH4q2jXnaq1g5Ewkjip8qTMfE6ozCWupxNbqBueMIZzPLAqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hzghBr1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hzghBr1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B606AC19423;
	Sat, 14 Feb 2026 21:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104326;
	bh=qQi4cKET8P1ejnoqtou0oEXuI4aZk8+q61dw8XPwE1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzghBr1OxcMTgj6TiXvGQ3B9yX10w/B8ctC4CJCEmHwuVhXTIKuiburFB72Bc9+2C
	 2eMQ6WavST9Q40ZvEV5UMYHl0rylDO88DduDv0TNBfth1NYcWtQ+E3qeDYb5EVjCMo
	 focRDgSYwkwdS6CGKAZtZHd4CvFDJ/SXfCOw6FaJgOJEK94G17S5QAU4DXeCsQ+mvU
	 8ki6cwCR5Q4gyfkPYhL69mi6tmDl9R9TnD8Hcsfsbj+GTkr9pxCXXMKrq0RibaGKMb
	 +Kxc4xG9c2zGW2c9CpX7rfq5zXeSqv1lmZYqtGFImLl+kyiWTk43FNbwKhxyrispup
	 ST4VRTW0NfMrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mingj Ye <insyelu@gmail.com>,
	Hayes Wang <hayeswang@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pabeni@redhat.com,
	neil.armstrong@linaro.org,
	gustavoars@kernel.org,
	andriy.shevchenko@linux.intel.com,
	kees@kernel.org,
	senozhatsky@chromium.org,
	rawal.abhishek92@gmail.com,
	phahn-oss@avm.de,
	yicong@kylinos.cn,
	yelangyan@huaqin.corp-partner.google.com,
	ebiggers@google.com,
	enelsonmoore@gmail.com,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] net: usb: r8152: fix transmit queue timeout
Date: Sat, 14 Feb 2026 16:22:43 -0500
Message-ID: <20260214212452.782265-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mingj Ye <insyelu@gmail.com>

[ Upstream commit 833dcd75d54f0bf5aa0a0781ff57456b421fbb40 ]

When the TX queue length reaches the threshold, the netdev watchdog
immediately detects a TX queue timeout.

This patch updates the trans_start timestamp of the transmit queue
on every asynchronous USB URB submission along the transmit path,
ensuring that the network watchdog accurately reflects ongoing
transmission activity.

Signed-off-by: Mingj Ye <insyelu@gmail.com>
Reviewed-by: Hayes Wang <hayeswang@realtek.com>
Link: https://patch.msgid.link/20260120015949.84996-1-insyelu@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of commit: "net: usb: r8152: fix transmit queue timeout"

### 1. COMMIT MESSAGE ANALYSIS

The subject explicitly says **"fix transmit queue timeout"** — this is a
clear bug fix. The commit message explains:
- **Bug**: When the TX queue length reaches a threshold, the netdev
  watchdog immediately detects a TX queue timeout (spurious timeout).
- **Root cause**: The `trans_start` timestamp of the transmit queue is
  not being updated when USB URBs are successfully submitted
  asynchronously.
- **Fix**: Call `netif_trans_update()` after each successful
  `usb_submit_urb()` to keep the watchdog informed that transmission
  activity is ongoing.

The commit is reviewed by the Realtek maintainer (Hayes Wang) and merged
by the network maintainer (Jakub Kicinski). Strong trust indicators.

### 2. CODE CHANGE ANALYSIS

The diff is **+2 lines** — extremely small and surgical:

```c
ret = usb_submit_urb(agg->urb, GFP_ATOMIC);
if (ret < 0)
    usb_autopm_put_interface_async(tp->intf);
+else
+    netif_trans_update(tp->netdev);
```

This adds an `else` branch after the `usb_submit_urb()` call. On
successful URB submission (`ret >= 0`), it calls
`netif_trans_update(tp->netdev)`, which updates the `trans_start`
timestamp of the network device's transmit queue.

**What `netif_trans_update()` does**: It's a standard kernel helper that
sets `txq->trans_start = jiffies`, telling the network watchdog "we are
actively transmitting." Without this update, the watchdog timer thinks
the queue has been idle since the last update and fires a spurious TX
timeout.

### 3. BUG SEVERITY

A **TX queue timeout** in a network driver is a significant user-visible
bug:
- The watchdog fires, potentially calling the driver's `ndo_tx_timeout`
  handler
- This can cause the network interface to reset or go down
- Results in **network connectivity loss** or **severe performance
  degradation**
- The r8152 driver is for **Realtek USB Ethernet adapters**, which are
  extremely common (used in USB-to-Ethernet dongles, docking stations,
  etc.)

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 2 (adding an else branch with one function call)
- **Files touched**: 1 (`drivers/net/usb/r8152.c`)
- **Risk**: Extremely low. `netif_trans_update()` is a well-known,
  lightweight inline function. It simply updates a jiffies timestamp. It
  cannot cause crashes, data corruption, or any side effects.
- **Regression potential**: Near zero. This only affects the TX watchdog
  timer behavior and only updates the timestamp on *successful* URB
  submission.

### 5. USER IMPACT

- **HIGH impact** — r8152 is one of the most widely used USB Ethernet
  drivers. Realtek RTL8152/RTL8153 chips are in millions of USB Ethernet
  adapters.
- Users experience **spurious TX timeouts** that disrupt network
  connectivity.
- Affects any user with a Realtek USB Ethernet adapter under sufficient
  TX load.

### 6. STABLE KERNEL CRITERIA

| Criterion | Met? |
|-----------|------|
| Obviously correct and tested | YES — reviewed by Realtek maintainer,
simple logic |
| Fixes a real bug | YES — spurious TX queue timeouts |
| Important issue | YES — network connectivity loss |
| Small and contained | YES — 2 lines in one file |
| No new features | YES — just a watchdog timestamp update |
| No new APIs | YES |

### 7. DEPENDENCY CHECK

`netif_trans_update()` has been available in the kernel for a very long
time (since 4.7+). The r8152 driver and the `r8152_tx_agg_fill()`
function have been in stable trees for many kernel versions. This patch
applies cleanly with no dependencies on other commits.

### 8. CONCLUSION

This is a textbook stable backport candidate:
- Fixes a real, user-visible bug (spurious TX timeouts causing network
  disruption)
- Affects a widely-used USB Ethernet driver (Realtek r8152)
- Extremely small and surgical (2-line change)
- Zero regression risk (just updates a jiffies timestamp)
- Reviewed by the hardware vendor's maintainer
- No dependencies on other patches

**YES**

 drivers/net/usb/r8152.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2f3baa5f6e9c9..6b107cf5f37bd 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2449,6 +2449,8 @@ static int r8152_tx_agg_fill(struct r8152 *tp, struct tx_agg *agg)
 	ret = usb_submit_urb(agg->urb, GFP_ATOMIC);
 	if (ret < 0)
 		usb_autopm_put_interface_async(tp->intf);
+	else
+		netif_trans_update(tp->netdev);
 
 out_tx_fill:
 	return ret;
-- 
2.51.0

