Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D34139EF35;
	Fri,  7 Aug 2026 15:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117682; cv=none; b=ol+4bUMRysoELqNbyxVMtuPUxrlHn676tDsx05/0XcEbh0ZUf5aqfnivwZLKlFaFMzRhhC94tlFGpsqOp/JHqplAILNw5r+J7o0d/fxeIoj8mKUv92W9NwbHcZXyrItU7rb5dgY0QlxHmT8VG3w9yzlq+Ubii9Cvcc8XtPm6l70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117682; c=relaxed/simple;
	bh=ylauyv4kFA9G/4hw6DHYNw6lB1scJP8INVbxwriv3/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpRA6WBlrIB6Sy3RhyPVn7ec30F8rX456eHYJzsgTlCtamVTX87jd/3MAuKd1QXPTA3rl+3N6uhZcz/BNapKm8SiS7mf5S7eDc8/RTCzf9+MiXqO7e2+Z1SrNk4ku+W/n7gwdb0TMooPj8b6Tlqo7jHTgv29vNuPgKh0CGVD4V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLR5CfwU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLR5CfwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD9C1F000E9;
	Fri,  7 Aug 2026 15:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117680;
	bh=NSPamaI1KEPwsqWIDpGM4ID9VU0DZkr6Wbz6GlUfR7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLR5CfwUdRnGshC6roMqAbRZOtY0TenWPVLywcZTqD1zF8cJOP0K4IdzHI4SMHQ19
	 6lpaRLSo7N3lC2qyQCe6Sp3QvkWYIJ7+pyHpDE6xjPrKjRah0oIBgPr10ut2NTzHfH
	 P/Sg/xGR43K6l2XarnB2txtdSpVUN1OamMGI6u+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@bisdn.de>,
	Ray Jui <ray.jui@broadcom.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.1 359/438] i2c: iproc: reset bus after timeout if START_BUSY is stuck
Date: Fri,  7 Aug 2026 16:39:15 +0200
Message-ID: <20260807143435.627329733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@bisdn.de>

commit 98f2e9e6d6f91a6abb43f166b244b428ba85fa2b upstream.

If a transaction times out, the START_BUSY signal can stay up, and
subsequent transactaction attempts will fail as the bus is still
considered busy.

I can easily trigger this by attempting to read from an address with no
device, e.g. when running i2cdetect. After the first read times out, all
subsequent read attempts return busy.

To get to a working state again, the controller needs to be reset to
clear the START_BUSY signal. So check for START_BUSY still asserted on a
timeout, and do reset in case it is,

This is also done by the original non-upstream iproc-smbus driver
implementation [1].

Works around situations like:

    bcm-iproc-2c 1803b000.i2c: transaction timed out
    bcm-iproc-2c 1803b000.i2c: bus is busy
    bcm-iproc-2c 1803b000.i2c: bus is busy
    bcm-iproc-2c 1803b000.i2c: bus is busy
    bcm-iproc-2c 1803b000.i2c: bus is busy
    bcm-iproc-2c 1803b000.i2c: bus is busy
    ...

where the bus never recovers after a timeout.

[1] https://github.com/opencomputeproject/onie/blob/master/patches/kernel/3.2.69/driver-iproc-smbus.patch

Fixes: e6e5dd3566e0 ("i2c: iproc: Add Broadcom iProc I2C Driver")
Signed-off-by: Jonas Gorski <jonas.gorski@bisdn.de>
Cc: <stable@vger.kernel.org> # v4.0+
Acked-by: Ray Jui <ray.jui@broadcom.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260717085507.34209-1-jonas.gorski@bisdn.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-bcm-iproc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -803,6 +803,17 @@ static int bcm_iproc_i2c_xfer_wait(struc
 	}
 
 	if (!time_left && !iproc_i2c->xfer_is_done) {
+		/*
+		 * The controller may fail to clear START_BUSY after a timeout,
+		 * reset the controller to recover in that case.
+		 */
+		if (!!(iproc_i2c_rd_reg(iproc_i2c, M_CMD_OFFSET) &
+		       BIT(M_CMD_START_BUSY_SHIFT))) {
+			bcm_iproc_i2c_enable_disable(iproc_i2c, false);
+			bcm_iproc_i2c_init(iproc_i2c);
+			bcm_iproc_i2c_enable_disable(iproc_i2c, true);
+		}
+
 		/* flush both TX/RX FIFOs */
 		val = BIT(M_FIFO_RX_FLUSH_SHIFT) | BIT(M_FIFO_TX_FLUSH_SHIFT);
 		iproc_i2c_wr_reg(iproc_i2c, M_FIFO_CTRL_OFFSET, val);


