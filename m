Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9D5223DD4;
	Wed, 10 Dec 2025 06:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765348494; cv=none; b=GFdZ4/NXUvCiyiwsHwIh7jyHApQqRofeqqtTUAQrVvIGZ/q+KR6pbQiBVZanVjoV03Ls9wmE0aHs6XgLqyupQ0DvfUCc0HhSRHQSJVonsHt2sdih6Jrm6b9s79rg7WkbJ44vu4Ye9gAw++GBstXR1tjyyF3e5wsAqO1g+KrGIBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765348494; c=relaxed/simple;
	bh=ZH4YdGyQ7nSGgopFfMsrD+QsvtYlpA+/5hKuVaIbQjc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CUn34Nzez5Mq+/1n7Z5UN/C9H0RERQEFbxa6uK2+BD0tFe8N+dVVFz++ZNmkvY4VLETwXk1YDRcpubxeEOgiYbzn3HofEp79AO9kfkEjiI6qnO7PcxcaRKyiDN22ReDctElZIJG9JHI6xzfKL8PQgUhcB4P7r1OQMYv32xPsvgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OURO3F+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OURO3F+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE31C4CEF1;
	Wed, 10 Dec 2025 06:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765348493;
	bh=ZH4YdGyQ7nSGgopFfMsrD+QsvtYlpA+/5hKuVaIbQjc=;
	h=From:To:Cc:Subject:Date:From;
	b=OURO3F+Hitl5MDc1daabAWKd9FahiWD/+6N1D8SkejzrYZBzYT0EsxPlotZneUuOu
	 tQtXnp8o7EEfQoIf4yoaSNOU67PJYoAn3wGVu6++zds5mH2SGWfTLaD3OBC+CXnCXw
	 CniC5+vf3HJOZQjukqtWNTLoCRCXncYzVELkaSCIY3oIJrYWhGmozRp3W6oVols7yL
	 dWmXHIA4lPFk0EqyVqJr1bh6kcQlNYUs9FGTWJ498VCj42tMIZkKsmLWHThbbgat14
	 olclaVXT55a7dW5w9SMqIf3j3vTDMRaUUtqbt6G1of8UwBnLOH/yOh51T/zlBc6IwT
	 iBIDIxa4PLcGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wenhua Lin <Wenhua.Lin@unisoc.com>,
	Cixi Geng <cixi.geng@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	orsonzhai@gmail.com
Subject: [PATCH AUTOSEL 6.18-5.10] serial: sprd: Return -EPROBE_DEFER when uart clock is not ready
Date: Wed, 10 Dec 2025 01:34:30 -0500
Message-ID: <20251210063446.2513466-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wenhua Lin <Wenhua.Lin@unisoc.com>

[ Upstream commit 29e8a0c587e328ed458380a45d6028adf64d7487 ]

In sprd_clk_init(), when devm_clk_get() returns -EPROBE_DEFER
for either uart or source clock, we should propagate the
error instead of just warning and continuing with NULL clocks.

Currently the driver only emits a warning when clock acquisition
fails and proceeds with NULL clock pointers. This can lead to
issues later when the clocks are actually needed. More importantly,
when the clock provider is not ready yet and returns -EPROBE_DEFER,
we should return this error to allow deferred probing.

This change adds explicit checks for -EPROBE_DEFER after both:
1. devm_clk_get(uport->dev, uart)
2. devm_clk_get(uport->dev, source)

When -EPROBE_DEFER is encountered, the function now returns
-EPROBE_DEFER to let the driver framework retry probing
later when the clock dependencies are resolved.

Signed-off-by: Wenhua Lin <Wenhua.Lin@unisoc.com>
Link: https://patch.msgid.link/20251022030840.956589-1-Wenhua.Lin@unisoc.com
Reviewed-by: Cixi Geng <cixi.geng@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: serial: sprd: Return -EPROBE_DEFER when uart clock
is not ready

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: Fixes incorrect handling of `-EPROBE_DEFER` error from
`devm_clk_get()`

**Key observations**:
- No `Cc: stable@vger.kernel.org` tag present
- No `Fixes:` tag pointing to when the bug was introduced
- Has `Reviewed-by:` from Cixi Geng
- Accepted by Greg Kroah-Hartman (serial subsystem maintainer)

### 2. CODE CHANGE ANALYSIS

The change adds two checks in `sprd_clk_init()`:

```c
clk_uart = devm_clk_get(uport->dev, "uart");
if (IS_ERR(clk_uart)) {
+    if (PTR_ERR(clk_uart) == -EPROBE_DEFER)
+        return -EPROBE_DEFER;
    dev_warn(...);
    clk_uart = NULL;
}

clk_parent = devm_clk_get(uport->dev, "source");
if (IS_ERR(clk_parent)) {
+    if (PTR_ERR(clk_parent) == -EPROBE_DEFER)
+        return -EPROBE_DEFER;
    dev_warn(...);
    clk_parent = NULL;
}
```

**Technical bug mechanism**: When clock providers aren't ready yet,
`devm_clk_get()` returns `-EPROBE_DEFER`. The existing code ignores this
error, sets the clock pointer to NULL, and continues. This bypasses the
kernel's deferred probing mechanism which exists precisely to handle
this dependency ordering scenario.

**Existing pattern**: The function already has identical handling for
the "enable" clock (visible in the context lines). This fix makes the
handling consistent for all three clocks.

### 3. CLASSIFICATION

**Type**: Bug fix (not a feature addition)

This fixes incorrect error handling. The `-EPROBE_DEFER` mechanism is a
fundamental kernel feature for handling driver load order dependencies.
Not propagating this error is a bug.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 6 lines added (two 3-line checks)
- **Files touched**: 1 file (`drivers/tty/serial/sprd_serial.c`)
- **Complexity**: Very low - follows identical pattern already in the
  same function
- **Subsystem**: Hardware-specific serial driver for Spreadtrum/Unisoc
  UARTs

**Risk**: Very low
- Pattern is already established and proven in the same function
- Only affects error handling during probe
- No changes to normal operation when clocks are available
- Worst case: probe failure happens earlier/more explicitly

### 5. USER IMPACT

**Affected users**: Users of Spreadtrum/Unisoc UART hardware (embedded
devices, some Android phones)

**Severity**: Medium-High for affected users - without this fix, the
serial port may not work correctly on systems where clock providers load
after the serial driver. This is common in embedded systems with device
tree-based configurations.

**Real bug**: This is a practical issue in probe ordering scenarios. The
driver would proceed with NULL clocks instead of waiting for
dependencies to be ready.

### 6. STABILITY INDICATORS

- Reviewed-by tag indicates code review
- Maintainer accepted the change
- Simple, straightforward change following existing code patterns
- No complex logic introduced

### 7. DEPENDENCY CHECK

- **Dependencies**: None - self-contained fix
- **Code existence in stable**: The sprd_serial driver has existed since
  ~2015 (commit 3e1f2029a4b40), so it's present in all active stable
  trees

### SUMMARY

**What it fixes**: Incorrect handling of `-EPROBE_DEFER` from
`devm_clk_get()` for two clocks ("uart" and "source"), causing the
driver to proceed with NULL clocks instead of deferring probe when clock
providers aren't ready.

**Stable kernel criteria**:
- ✅ Obviously correct (follows identical pattern already in function)
- ✅ Fixes a real bug (broken deferred probing)
- ✅ Small and contained (6 lines, 1 file)
- ✅ No new features
- ✅ Low risk of regression

**Concerns**:
- No explicit `Cc: stable` tag (author/maintainer didn't flag for
  stable)
- Relatively niche driver (Spreadtrum hardware)

**Risk vs Benefit**: The fix is minimal risk (identical pattern to
existing code) and addresses a real bug that could leave serial hardware
non-functional on embedded systems. The benefit outweighs the minimal
risk.

The lack of `Cc: stable` tag is notable but not determinative - this is
a straightforward bug fix that meets all stable criteria. The fix is
small, obviously correct, and addresses a real probe ordering issue that
embedded system users could encounter.

**YES**

 drivers/tty/serial/sprd_serial.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index 8c9366321f8e7..092755f356836 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -1133,6 +1133,9 @@ static int sprd_clk_init(struct uart_port *uport)
 
 	clk_uart = devm_clk_get(uport->dev, "uart");
 	if (IS_ERR(clk_uart)) {
+		if (PTR_ERR(clk_uart) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
 		dev_warn(uport->dev, "uart%d can't get uart clock\n",
 			 uport->line);
 		clk_uart = NULL;
@@ -1140,6 +1143,9 @@ static int sprd_clk_init(struct uart_port *uport)
 
 	clk_parent = devm_clk_get(uport->dev, "source");
 	if (IS_ERR(clk_parent)) {
+		if (PTR_ERR(clk_parent) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
 		dev_warn(uport->dev, "uart%d can't get source clock\n",
 			 uport->line);
 		clk_parent = NULL;
-- 
2.51.0

