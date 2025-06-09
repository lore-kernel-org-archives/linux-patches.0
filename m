Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86404258CF5;
	Mon,  9 Jun 2025 13:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476799; cv=none; b=Gz6CZuHozTm90VBEWhP7m1hh5dxFnZXQLXxWMcr7h+E1gfuFXx4uuevR/YojUFojjWZ9Cy5UW9MjG9oq/IsbOLMs68wI1kJXzF57iPSRJB4EAaBxCensJtmDGxq7G/xvVBxvVFjXFn30Z7oClhhAaPbwWfqUnIwh30gDVIdBCNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476799; c=relaxed/simple;
	bh=tl5GZsoSVZ/4GDIUYzPPrgy/wLJ/e74zBOa2Y2/bxwU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eV16FBkRXqcY3/pfIrmen1ubmeFvormsIC2O48hUQKS2ApdxU9g4moZSC470lg3xvjDozX/QV57NLMgtqxGZxXbRJzSRYLCWc5hbeVygWRTgxkoVbmf2s0JD4E4LKYg+E8Fm9jEA/ZE0Nu3S3fXVWX3DvxNnbSYx51sOiLxKMNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rhs1geHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rhs1geHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F92C4CEED;
	Mon,  9 Jun 2025 13:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476799;
	bh=tl5GZsoSVZ/4GDIUYzPPrgy/wLJ/e74zBOa2Y2/bxwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rhs1geHddGWHc7SQaBmtkGDWsKff7X1b4l4pHMPC499zhrEaTuwnVwYMJh41vJi+f
	 HKJ4LdzOQ8GbdWUurHwSHQnsvUeWVPmJbZ8ZTDGngFBw10MsCMUvhz4uNssrKHNYBH
	 FQNgV43rMcGKus4+TL4SQtmeDbyZQq5gCii2EgOKq7ocSi3NDCRr/iyXtiE5e0sNVh
	 1Caa182KwKomr+7ycQZpptE72ksgTRTqHg8zSQx7Ev2G7+LTYao1+9TtBKDP8fqlRs
	 RLU7e3+WX1CQnKXDDZ0oucBcTR/+70xwx3gqL6NkZCMjQvjPIuEfzHLLEVK9t2DdgM
	 pbTpmOqcceo3w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Lewalski <jakub.lewalski@nokia.com>,
	Elodie Decerle <elodie.decerle@nokia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jacmet@sunsite.dk,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 17/23] tty: serial: uartlite: register uart driver in init
Date: Mon,  9 Jun 2025 09:46:04 -0400
Message-Id: <20250609134610.1343777-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134610.1343777-1-sashal@kernel.org>
References: <20250609134610.1343777-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.32
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Lewalski <jakub.lewalski@nokia.com>

[ Upstream commit 6bd697b5fc39fd24e2aa418c7b7d14469f550a93 ]

When two instances of uart devices are probing, a concurrency race can
occur. If one thread calls uart_register_driver function, which first
allocates and assigns memory to 'uart_state' member of uart_driver
structure, the other instance can bypass uart driver registration and
call ulite_assign. This calls uart_add_one_port, which expects the uart
driver to be fully initialized. This leads to a kernel panic due to a
null pointer dereference:

[    8.143581] BUG: kernel NULL pointer dereference, address: 00000000000002b8
[    8.156982] #PF: supervisor write access in kernel mode
[    8.156984] #PF: error_code(0x0002) - not-present page
[    8.156986] PGD 0 P4D 0
...
[    8.180668] RIP: 0010:mutex_lock+0x19/0x30
[    8.188624] Call Trace:
[    8.188629]  ? __die_body.cold+0x1a/0x1f
[    8.195260]  ? page_fault_oops+0x15c/0x290
[    8.209183]  ? __irq_resolve_mapping+0x47/0x80
[    8.209187]  ? exc_page_fault+0x64/0x140
[    8.209190]  ? asm_exc_page_fault+0x22/0x30
[    8.209196]  ? mutex_lock+0x19/0x30
[    8.223116]  uart_add_one_port+0x60/0x440
[    8.223122]  ? proc_tty_register_driver+0x43/0x50
[    8.223126]  ? tty_register_driver+0x1ca/0x1e0
[    8.246250]  ulite_probe+0x357/0x4b0 [uartlite]

To prevent it, move uart driver registration in to init function. This
will ensure that uart_driver is always registered when probe function
is called.

Signed-off-by: Jakub Lewalski <jakub.lewalski@nokia.com>
Signed-off-by: Elodie Decerle <elodie.decerle@nokia.com>
Link: https://lore.kernel.org/r/20250331160732.2042-1-elodie.decerle@nokia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my comprehensive analysis, I can now provide a definitive
assessment:

**YES**

## Extensive Analysis

This commit **should be backported** to stable kernel trees. Here's my
detailed analysis:

### **1. Critical Bug Fix Nature**

The commit fixes a **serious race condition** that causes kernel panics
with NULL pointer dereferences. The stack trace in the commit message
shows:

```
[    8.143581] BUG: kernel NULL pointer dereference, address:
00000000000002b8
[    8.180668] RIP: 0010:mutex_lock+0x19/0x30
[    8.223116]  uart_add_one_port+0x60/0x440
```

This is a **critical system stability issue** that can crash the kernel
during device initialization.

### **2. Race Condition Analysis**

**The Problem:**
- **Before the fix:** `uart_register_driver()` was called in
  `ulite_probe()` (lines 883-891 in current code)
- **Race scenario:** When two UART devices probe simultaneously:
  1. Thread 1 calls `uart_register_driver()` and starts allocating
     `uart_driver.state`
  2. Thread 2 sees `!ulite_uart_driver.state` as false, bypasses
     registration, and calls `ulite_assign()`
  3. Thread 2's `ulite_assign()` calls `uart_add_one_port()` (line 678)
     expecting a fully initialized driver
  4. Thread 1's registration hasn't completed, causing NULL pointer
     dereference in `uart_add_one_port()`

**The Fix:**
- **After the fix:** `uart_register_driver()` is moved to `ulite_init()`
  ensuring:
  1. Driver registration completes **before** any platform driver
     registration
  2. **No race window** exists between driver registration and device
     probing
  3. All probe calls find a **fully initialized** uart driver

### **3. Code Changes Analysis**

**Changes in `ulite_init()`:**
```c
static int __init ulite_init(void)
{
+   int ret;
+
+   pr_debug("uartlite: calling uart_register_driver()\n");
+   ret = uart_register_driver(&ulite_uart_driver);
+   if (ret)
+       return ret;

    pr_debug("uartlite: calling platform_driver_register()\n");
- return platform_driver_register(&ulite_platform_driver);
+   ret = platform_driver_register(&ulite_platform_driver);
+   if (ret)
+       uart_unregister_driver(&ulite_uart_driver);
+
+   return ret;
}
```

**Changes in `ulite_probe()`:**
```c
// REMOVED the problematic race-prone code:
- if (!ulite_uart_driver.state) {
- dev_dbg(&pdev->dev, "uartlite: calling uart_register_driver()\n");
- ret = uart_register_driver(&ulite_uart_driver);
- if (ret < 0) {
- dev_err(&pdev->dev, "Failed to register driver\n");
- clk_disable_unprepare(pdata->clk);
- return ret;
- }
- }
```

**Changes in `ulite_exit()`:**
```c
static void __exit ulite_exit(void)
{
    platform_driver_unregister(&ulite_platform_driver);
- if (ulite_uart_driver.state)
- uart_unregister_driver(&ulite_uart_driver);
+   uart_unregister_driver(&ulite_uart_driver);
}
```

### **4. Follows Kernel Best Practices**

The fix aligns with **established kernel patterns**. My analysis of
other UART drivers shows that well-architected drivers like 8250,
altera, atmel, and liteuart all register their uart drivers in `__init`
functions, not probe functions. This architectural pattern:

- **Separates concerns:** Driver registration (what) vs device binding
  (when)
- **Eliminates races:** Driver available before any device probing
- **Improves reliability:** Predictable initialization order

### **5. Stable Tree Suitability Criteria**

✅ **Fixes important bug:** Kernel panic with NULL pointer dereference
✅ **Small and contained:** Moves existing code, no new functionality
✅ **Minimal risk:** Follows established kernel patterns
✅ **Clear side effects:** Better initialization order, no regressions
expected
✅ **Confined to subsystem:** Only affects uartlite driver
✅ **Important for users:** Prevents boot crashes on Xilinx platforms

### **6. Similar Historical Pattern**

This fix is very similar to **Similar Commit #5** (Status: YES) which
also fixed race conditions in TTY/serial code by ensuring proper
initialization order. Both commits:
- Fix race conditions in serial/TTY subsystem
- Make architectural improvements to initialization order
- Prevent NULL pointer dereferences
- Have clear stable tree value

### **7. Low Regression Risk**

The change is **architecturally sound** because:
- It ensures `uart_register_driver()` completes before any
  `uart_add_one_port()` calls
- Proper error handling ensures cleanup if platform driver registration
  fails
- The exit sequence properly reverses the initialization sequence
- No functional behavior changes, only timing/ordering improvements

### **Conclusion**

This commit fixes a **critical kernel panic** caused by a race condition
in the uartlite driver. The fix is **small, contained, and follows
established kernel patterns**. It has **minimal regression risk** and
provides **significant stability improvements** for users of Xilinx UART
devices. The architectural change from probe-time to init-time driver
registration is a **best practice** that eliminates the race condition
entirely.

 drivers/tty/serial/uartlite.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 68357ac8ffe3c..71890f3244a0f 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -880,16 +880,6 @@ static int ulite_probe(struct platform_device *pdev)
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	if (!ulite_uart_driver.state) {
-		dev_dbg(&pdev->dev, "uartlite: calling uart_register_driver()\n");
-		ret = uart_register_driver(&ulite_uart_driver);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "Failed to register driver\n");
-			clk_disable_unprepare(pdata->clk);
-			return ret;
-		}
-	}
-
 	ret = ulite_assign(&pdev->dev, id, res->start, irq, pdata);
 
 	pm_runtime_mark_last_busy(&pdev->dev);
@@ -929,16 +919,25 @@ static struct platform_driver ulite_platform_driver = {
 
 static int __init ulite_init(void)
 {
+	int ret;
+
+	pr_debug("uartlite: calling uart_register_driver()\n");
+	ret = uart_register_driver(&ulite_uart_driver);
+	if (ret)
+		return ret;
 
 	pr_debug("uartlite: calling platform_driver_register()\n");
-	return platform_driver_register(&ulite_platform_driver);
+	ret = platform_driver_register(&ulite_platform_driver);
+	if (ret)
+		uart_unregister_driver(&ulite_uart_driver);
+
+	return ret;
 }
 
 static void __exit ulite_exit(void)
 {
 	platform_driver_unregister(&ulite_platform_driver);
-	if (ulite_uart_driver.state)
-		uart_unregister_driver(&ulite_uart_driver);
+	uart_unregister_driver(&ulite_uart_driver);
 }
 
 module_init(ulite_init);
-- 
2.39.5

