Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA4A3C2D;
	Sat, 14 Feb 2026 21:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104299; cv=none; b=JoW5DYf1ZeGn+tBhTky8+Oxr1ks68IXzcHhYDp6iFOdhs/S4/812vmfBpJPmv9zgEBinDXvRubD39Z/9IekavQB0Nb+UmrFjYgrIdNkPmXH2eOwTPZyo8WoOKxoaZSsDKe6gpYDqQlz+w2isHW2ZEFAaThyhf0xsNMN5yNBNRFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104299; c=relaxed/simple;
	bh=5WmlLR1ZsEQCtJFKRU48Ql7qv4HCh319ycm8oSOdYXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qyu/uj0+ohYzYNZi8XIkMSHhT5m+u7ld3gt2/hUTDfLu134dZbv9okdVO6zwqBY79MW3Hv5zmmPlEAx+/8f9ftQ6UFyHhQYU9qfnkP3Qe/zLcKNkZocOhQHGE82dBAe0Qv1thPXMBgeKyamRpifwqC+pkEsoglotsseelEW9tdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWWRUliX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWWRUliX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F1DC19422;
	Sat, 14 Feb 2026 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104299;
	bh=5WmlLR1ZsEQCtJFKRU48Ql7qv4HCh319ycm8oSOdYXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWWRUliXq1MwGxmM/xM5SZWRVKlfmnrYVmLKHr1L4za79Jmh2ZMmdWd29xUtLOBzy
	 66CGUR/xf+3q1W34QKth5/c09UTIiEZSaSGvLgumu1JsRYhxWKmQG22bqEpTdwnl0n
	 voHvyctpWVVNyaq25nnT0iHsedsUGcMIAeQBf2EPk79iu7wq1OPJPMjpSaIVUQv+5/
	 dDeFRPiDYs+QGkz6WxjiMc28+1LEYZl3jdVpaPQjBCzUjeSPPenVs/VqB7k9/9QiY8
	 HaYeZiMA/pS9mm4wNY2Wc0ZIqqnnkZRzduLpF11W8bNiHrGfA4dKcYrkxhoogfX+yA
	 VXw6pa1YwCsHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@kernel.org,
	neil.armstrong@linaro.org,
	tglx@kernel.org,
	bhelgaas@google.com,
	giovanni.cabiddu@intel.com,
	yelangyan@huaqin.corp-partner.google.com,
	lukas@wunner.de,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] myri10ge: avoid uninitialized variable use
Date: Sat, 14 Feb 2026 16:22:28 -0500
Message-ID: <20260214212452.782265-3-sashal@kernel.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit fd24173439c033ffb3c2a2628fcbc9cb65e62bdb ]

While compile testing on less common architectures, I noticed that gcc-10 on
s390 finds a bug that all other configurations seem to miss:

drivers/net/ethernet/myricom/myri10ge/myri10ge.c: In function 'myri10ge_set_multicast_list':
drivers/net/ethernet/myricom/myri10ge/myri10ge.c:391:25: error: 'cmd.data0' is used uninitialized in this function [-Werror=uninitialized]
  391 |  buf->data0 = htonl(data->data0);
      |                         ^~
drivers/net/ethernet/myricom/myri10ge/myri10ge.c:392:25: error: '*((void *)&cmd+4)' is used uninitialized in this function [-Werror=uninitialized]
  392 |  buf->data1 = htonl(data->data1);
      |                         ^~
drivers/net/ethernet/myricom/myri10ge/myri10ge.c: In function 'myri10ge_allocate_rings':
drivers/net/ethernet/myricom/myri10ge/myri10ge.c:392:13: error: 'cmd.data1' is used uninitialized in this function [-Werror=uninitialized]
  392 |  buf->data1 = htonl(data->data1);
drivers/net/ethernet/myricom/myri10ge/myri10ge.c:1939:22: note: 'cmd.data1' was declared here
 1939 |  struct myri10ge_cmd cmd;
      |                      ^~~
drivers/net/ethernet/myricom/myri10ge/myri10ge.c:393:13: error: 'cmd.data2' is used uninitialized in this function [-Werror=uninitialized]
  393 |  buf->data2 = htonl(data->data2);
drivers/net/ethernet/myricom/myri10ge/myri10ge.c:1939:22: note: 'cmd.data2' was declared here
 1939 |  struct myri10ge_cmd cmd;

It would be nice to understand how to make other compilers catch this as
well, but for the moment I'll just shut up the warning by fixing the
undefined behavior in this driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260205162935.2126442-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### Understanding the Bug

The analysis reveals this is a **real, meaningful bug**, not just a
compiler warning cleanup:

1. **`struct myri10ge_cmd`** has three `u32` fields: `data0`, `data1`,
   `data2`
2. **`myri10ge_send_cmd()`** unconditionally copies ALL THREE fields to
   hardware via:
  ```c
  buf->data0 = htonl(data->data0);
  buf->data1 = htonl(data->data1);
  buf->data2 = htonl(data->data2);
  ```
  Then sends them to the NIC via `myri10ge_pio_copy()`.

3. In many call sites, the `cmd` struct is declared on the stack but
   **not all fields are initialized** before being passed to
   `myri10ge_send_cmd()`. This means **random stack garbage is sent to
   hardware**.

### Bug Impact

- **Undefined behavior**: Uninitialized stack variables being used is
  undefined behavior in C
- **Hardware commands with garbage data**: The NIC firmware receives
  commands with random data in unused fields, which could cause
  unpredictable behavior depending on firmware implementation
- **Potential data corruption or connectivity issues**: If the firmware
  interprets garbage values in unexpected ways
- **Build failure**: On gcc-10 on s390 with `-Werror`, this prevents
  compilation entirely

### Scope of Changes

The fix is purely additive — it adds zero-initialization of `cmd.data0`,
`cmd.data1`, `cmd.data2` at each call site where they were previously
uninitialized. The changes span **one file** with simple, repetitive
initialization statements. There's also a minor cleanup moving the `cmd`
variable declaration to a narrower scope in `myri10ge_close()`.

Functions fixed:
- `myri10ge_get_firmware_capabilities()`
- `myri10ge_update_mac_address()`
- `myri10ge_change_pause()`
- `myri10ge_change_promisc()`
- `myri10ge_allocate_rings()`
- `myri10ge_get_txrx()`
- `myri10ge_open()`
- `myri10ge_close()`
- `myri10ge_set_multicast_list()`

### Stable Kernel Criteria Assessment

| Criterion | Assessment |
|-----------|-----------|
| Obviously correct? | Yes — initializing variables to zero before use
is trivially correct |
| Fixes a real bug? | Yes — undefined behavior (uninitialized data sent
to hardware) and build failure on s390 |
| Small and contained? | Yes — single file, simple initialization
additions |
| No new features? | Correct — purely a bug fix |
| Risk of regression? | Very low — adding zero-initialization cannot
break correct code |

### Risk vs Benefit

- **Risk**: Extremely low. Zero-initializing struct fields before
  passing them to a function is the safest possible change. The only
  conceivable risk is if the hardware somehow relied on receiving
  specific non-zero garbage values, which would be absurd.
- **Benefit**: Fixes undefined behavior, prevents hardware from
  receiving garbage command data, and fixes a build failure on s390 with
  gcc-10.

### Concerns

- The myri10ge driver is for Myricom 10-Gigabit Ethernet adapters, which
  are older hardware (Myricom was acquired by CSPI years ago). However,
  users with this hardware in stable kernels still benefit from correct
  behavior.
- No dependency on other commits — this is fully self-contained.
- Note the use of commas instead of semicolons in some initializations
  (e.g., `cmd.data0 = 0,` instead of `cmd.data0 = 0;`) — this is
  syntactically valid C (comma operator) but unusual. It won't cause
  issues.

### Conclusion

This commit fixes real undefined behavior where uninitialized stack data
is sent to network hardware. It's a textbook example of a safe,
contained bug fix: zero-initializing variables before use in a single
driver file. The fix prevents both runtime undefined behavior and a
build failure on certain architectures. The risk of regression is
negligible.

**YES**

 .../net/ethernet/myricom/myri10ge/myri10ge.c  | 28 ++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 7be30a8df2685..2f0cdbd4e2ac9 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -688,6 +688,9 @@ static int myri10ge_get_firmware_capabilities(struct myri10ge_priv *mgp)
 
 	/* probe for IPv6 TSO support */
 	mgp->features = NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_TSO;
+	cmd.data0 = 0,
+	cmd.data1 = 0,
+	cmd.data2 = 0,
 	status = myri10ge_send_cmd(mgp, MXGEFW_CMD_GET_MAX_TSO6_HDR_SIZE,
 				   &cmd, 0);
 	if (status == 0) {
@@ -806,6 +809,7 @@ static int myri10ge_update_mac_address(struct myri10ge_priv *mgp,
 		     | (addr[2] << 8) | addr[3]);
 
 	cmd.data1 = ((addr[4] << 8) | (addr[5]));
+	cmd.data2 = 0;
 
 	status = myri10ge_send_cmd(mgp, MXGEFW_SET_MAC_ADDRESS, &cmd, 0);
 	return status;
@@ -817,6 +821,9 @@ static int myri10ge_change_pause(struct myri10ge_priv *mgp, int pause)
 	int status, ctl;
 
 	ctl = pause ? MXGEFW_ENABLE_FLOW_CONTROL : MXGEFW_DISABLE_FLOW_CONTROL;
+	cmd.data0 = 0,
+	cmd.data1 = 0,
+	cmd.data2 = 0,
 	status = myri10ge_send_cmd(mgp, ctl, &cmd, 0);
 
 	if (status) {
@@ -834,6 +841,9 @@ myri10ge_change_promisc(struct myri10ge_priv *mgp, int promisc, int atomic)
 	int status, ctl;
 
 	ctl = promisc ? MXGEFW_ENABLE_PROMISC : MXGEFW_DISABLE_PROMISC;
+	cmd.data0 = 0;
+	cmd.data1 = 0;
+	cmd.data2 = 0;
 	status = myri10ge_send_cmd(mgp, ctl, &cmd, atomic);
 	if (status)
 		netdev_err(mgp->dev, "Failed to set promisc mode\n");
@@ -1946,6 +1956,8 @@ static int myri10ge_allocate_rings(struct myri10ge_slice_state *ss)
 	/* get ring sizes */
 	slice = ss - mgp->ss;
 	cmd.data0 = slice;
+	cmd.data1 = 0;
+	cmd.data2 = 0;
 	status = myri10ge_send_cmd(mgp, MXGEFW_CMD_GET_SEND_RING_SIZE, &cmd, 0);
 	tx_ring_size = cmd.data0;
 	cmd.data0 = slice;
@@ -2238,12 +2250,16 @@ static int myri10ge_get_txrx(struct myri10ge_priv *mgp, int slice)
 	status = 0;
 	if (slice == 0 || (mgp->dev->real_num_tx_queues > 1)) {
 		cmd.data0 = slice;
+		cmd.data1 = 0;
+		cmd.data2 = 0;
 		status = myri10ge_send_cmd(mgp, MXGEFW_CMD_GET_SEND_OFFSET,
 					   &cmd, 0);
 		ss->tx.lanai = (struct mcp_kreq_ether_send __iomem *)
 		    (mgp->sram + cmd.data0);
 	}
 	cmd.data0 = slice;
+	cmd.data1 = 0;
+	cmd.data2 = 0;
 	status |= myri10ge_send_cmd(mgp, MXGEFW_CMD_GET_SMALL_RX_OFFSET,
 				    &cmd, 0);
 	ss->rx_small.lanai = (struct mcp_kreq_ether_recv __iomem *)
@@ -2312,6 +2328,7 @@ static int myri10ge_open(struct net_device *dev)
 	if (mgp->num_slices > 1) {
 		cmd.data0 = mgp->num_slices;
 		cmd.data1 = MXGEFW_SLICE_INTR_MODE_ONE_PER_SLICE;
+		cmd.data2 = 0;
 		if (mgp->dev->real_num_tx_queues > 1)
 			cmd.data1 |= MXGEFW_SLICE_ENABLE_MULTIPLE_TX_QUEUES;
 		status = myri10ge_send_cmd(mgp, MXGEFW_CMD_ENABLE_RSS_QUEUES,
@@ -2414,6 +2431,8 @@ static int myri10ge_open(struct net_device *dev)
 
 	/* now give firmware buffers sizes, and MTU */
 	cmd.data0 = dev->mtu + ETH_HLEN + VLAN_HLEN;
+	cmd.data1 = 0;
+	cmd.data2 = 0;
 	status = myri10ge_send_cmd(mgp, MXGEFW_CMD_SET_MTU, &cmd, 0);
 	cmd.data0 = mgp->small_bytes;
 	status |=
@@ -2472,7 +2491,6 @@ static int myri10ge_open(struct net_device *dev)
 static int myri10ge_close(struct net_device *dev)
 {
 	struct myri10ge_priv *mgp = netdev_priv(dev);
-	struct myri10ge_cmd cmd;
 	int status, old_down_cnt;
 	int i;
 
@@ -2491,8 +2509,13 @@ static int myri10ge_close(struct net_device *dev)
 
 	netif_tx_stop_all_queues(dev);
 	if (mgp->rebooted == 0) {
+		struct myri10ge_cmd cmd;
+
 		old_down_cnt = mgp->down_cnt;
 		mb();
+		cmd.data0 = 0;
+		cmd.data1 = 0;
+		cmd.data2 = 0;
 		status =
 		    myri10ge_send_cmd(mgp, MXGEFW_CMD_ETHERNET_DOWN, &cmd, 0);
 		if (status)
@@ -2956,6 +2979,9 @@ static void myri10ge_set_multicast_list(struct net_device *dev)
 
 	/* Disable multicast filtering */
 
+	cmd.data0 = 0;
+	cmd.data1 = 0;
+	cmd.data2 = 0;
 	err = myri10ge_send_cmd(mgp, MXGEFW_ENABLE_ALLMULTI, &cmd, 1);
 	if (err != 0) {
 		netdev_err(dev, "Failed MXGEFW_ENABLE_ALLMULTI, error status: %d\n",
-- 
2.51.0

