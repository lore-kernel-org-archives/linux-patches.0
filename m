Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248E93B3BE1;
	Wed, 30 Sep 2026 18:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791756; cv=none; b=OPDYxoJ9Asex2hjvaqWpxtuygpJ1syZXl9xHc9wh5EBmLidd3FWCg5O1Jz0jKRTFE6LAK+GbsHBtELmPMXmHv5gMIv++mQKdjVaspmJExb+oKudYDDEvW0A3g94AKmzwsw/7Y4FJZ65aTRyHlowdOwU3jjU2z/EDwbSJOXWaDBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791756; c=relaxed/simple;
	bh=lzh7Snq2l27ropdQPsM1MXazYGdFiOumQUP+C2PujKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jb5CdV31Rb2einuWosZe7TYeGeCPfJ1hhnyiOVFASqdIB0m+L50Laa/p8oBZWS9NAMaIDvc7zokHRWOQM232hYPQ36LehjQ57m1FfTkmzWXfF+ux1lcEQCrT9jzIvf+jSQ0nrmOQrKUwHOviKTrCh/gOB3sMsmXOWNg9oiBGcPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/e/HJTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/e/HJTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4931F00898;
	Wed, 30 Sep 2026 18:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791755;
	bh=raIRkwdH5yPi3tObci5g6pBHiXtbLyL1o9H3pJLJzFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/e/HJTcIMxRLJmkKEE8xqbJD67LjTLtRfILnbSQAEHYgC1ka9s0Yf6r4QyPI4CCY
	 Fz53HN69eMEYY5NTYhU16VldSWNrhc9GFjJ3FEet8r3IzpLJ+rb0ftjTem6iRiylA5
	 /z0DubtKNoZ+xz8mTHTKTVARNqe87uC4I0R5pR8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH 5.15 412/752] i2c: smbus: reject oversized block transfers in the common path
Date: Wed, 30 Sep 2026 17:24:42 +0200
Message-ID: <20260930152407.191557505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 3051cd060fa496df42954291fa2306ed2eab4ecc upstream.

The SMBus block transfer length data->block[0] is validated in
i2c_smbus_xfer_emulated() but that check runs too late for tracepoints
and is skipped entirely when the adapter provides a native smbus_xfer
implementation. This allows user-controlled oversized block lengths to
reach tracepoint memcpy calls and driver callbacks unchecked.

Add an early validation in __i2c_smbus_xfer() that rejects block
transfers whose caller-supplied length is zero or exceeds
I2C_SMBUS_BLOCK_MAX before any tracepoint fires or driver callback
runs. data->block[0] is filled in by the device on SMBus block reads,
so the check is scoped to operations where the length is actually
supplied by the caller. This is consistent with the existing -EINVAL
convention in the emulated path and protects all downstream consumers
at once: the smbus_write tracepoint, all native smbus_xfer driver
implementations, and the emulated path.

Two distinct bugs are fixed by this change:

Bug 1: smbus_write tracepoint OOB (include/trace/events/smbus.h)
  trace_smbus_write() fires before any validation and copies
  data->block[0]+1 bytes into a 34-byte event buffer. With
  block[0]=0xfe the tracepoint copies 255 bytes, overflowing by 221.

 BUG: KASAN: stack-out-of-bounds in trace_event_raw_event_smbus_write+0x27c/0x530
 Read of size 255 at addr ffff88800d98fcf8 by task poc_smbus/91
 Call Trace:
  <TASK>
  __asan_memcpy+0x23/0x80
  trace_event_raw_event_smbus_write+0x27c/0x530
  __i2c_smbus_xfer+0x43a/0xa40
  i2c_smbus_xfer+0x19e/0x340
  i2cdev_ioctl_smbus+0x38f/0x7f0
  i2cdev_ioctl+0x35e/0x680
  __x64_sys_ioctl+0x147/0x1e0
  do_syscall_64+0xcf/0x15a0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  </TASK>

Bug 2: i2c-stub I2C_SMBUS_I2C_BLOCK_DATA OOB (drivers/i2c/i2c-stub.c)
  stub_xfer() implements .smbus_xfer directly and only clamps
  block[0] against 256-command, not I2C_SMBUS_BLOCK_MAX. With
  block[0]=0xff and command=0 the loop accesses block[1+i] for
  i up to 254, far past the 34-byte union.

 UBSAN: array-index-out-of-bounds in drivers/i2c/i2c-stub.c:223:44
 index 34 is out of range for type '__u8 [34]'
 Call Trace:
  <TASK>
  __ubsan_handle_out_of_bounds+0xd7/0x120
  stub_xfer+0x1971/0x198f [i2c_stub]
  __i2c_smbus_xfer+0x306/0xa40
  i2c_smbus_xfer+0x19e/0x340
  i2cdev_ioctl_smbus+0x38f/0x7f0
  i2cdev_ioctl+0x35e/0x680
  __x64_sys_ioctl+0x147/0x1e0
  do_syscall_64+0xcf/0x15a0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  </TASK>

Both traces reproduced on v7.0-rc6+i2c/for-current with KASAN+UBSAN.

Fixes: 8a325997d95d ("i2c: Add message transfer tracepoints for SMBUS [ver #2]")
Fixes: 4710317891e4 ("i2c-stub: Implement I2C block support")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core-smbus.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/i2c/i2c-core-smbus.c
+++ b/drivers/i2c/i2c-core-smbus.c
@@ -565,6 +565,18 @@ s32 __i2c_smbus_xfer(struct i2c_adapter
 	if (res)
 		return res;
 
+	/* Reject invalid caller-supplied block lengths before any
+	 * tracepoint or native smbus_xfer callback runs.
+	 */
+	if (data &&
+	    (protocol == I2C_SMBUS_I2C_BLOCK_DATA ||
+	     protocol == I2C_SMBUS_BLOCK_PROC_CALL ||
+	     (protocol == I2C_SMBUS_BLOCK_DATA &&
+	      read_write == I2C_SMBUS_WRITE)) &&
+	    (data->block[0] == 0 ||
+	     data->block[0] > I2C_SMBUS_BLOCK_MAX))
+		return -EINVAL;
+
 	/* If enabled, the following two tracepoints are conditional on
 	 * read_write and protocol.
 	 */


