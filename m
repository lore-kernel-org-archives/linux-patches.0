Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062523;
	b=RQfLgn0H0d1Z19V7Rj3zj4Xkn5H+Iciel41/X3gGoced475GbxEP3VPLj9uDcuWW4KQ2
	 0t3sXsGL+DaKJEOhr3gInC1K9DqZ1eAC8iIesPTggRH059boTMFirJ5cQH27a2x21jNRl
	 jZQ2BUl6s3HDy9XpAsYOlngNVC9BRyhO1Vg6lQOekmsApKMrQGeT139Qer7xlqxHfF1nA
	 wrZ9Csp4v/Be0t11/zsnHxnvJWv53MwH8vz354dBxss9hff4Kwjgj+T8THminTrKRCv7M
	 ymNcEpJjRVrfow8UqYMEYq5ZkiAaSpA1t6uaWlBF6hQRTgb20f1Ba6QGM9/Fro7hGSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ADCOOl4KleEm/VZSZ0GMwLItK1mBw1tj2i+GHyzJCIk=;
	b=Jw52Aeaodpbq/aKdV62pqRD95DIA3BCfRXptRejpPliRfwDffw/1CG7GB5CDJACNmQtu
	 MKG2ge25qelHvG3rv04kWpFUmMfJanhfzsksts7JHD10D+Twp5VcZxaU89J1WZf+7QSVi
	 wNhDmDe1FfnazzYk+8ydHPHVnKyrRbxB88tqBwxZUlpc27aQ9sn1P2ozBlfFjsHJS8jWc
	 3gct9wmdggijC9k/v+D/ntmO+AfyRcCmXl4aiolB1tE97amiNzUpAPw6x3OkJFvZ42THz
	 An4ctwUlWnO8kI84tz6I7ZB2R2wzkqtYFYmMsxqCxWFoTnrv0h4ew7CMH+73ckItTgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sc8JLeXl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE3E60A382D;
	Sat,  7 Nov 2026 14:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sc8JLeXl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD531F008A2;
	Sat,  7 Nov 2026 14:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062523;
	bh=ADCOOl4KleEm/VZSZ0GMwLItK1mBw1tj2i+GHyzJCIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sc8JLeXlhUsLX4SK2Yp9uA4KI3qIG/C3r7bnp6N4+2CJq6bbV+XqitRARjqA0SInD
	 M9aZVdK+2jUQ8VR0ymJnhzFO7IPTTLfOOCUiQUinl2i0Aof77DgN7Rug/8rmICtqY1
	 8mtkYW9H+IxNZjVV7PCFwDw5fHnmSMp3GWAWZz9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1417/1536] i2c: designware: queue only one read command for block reads
Date: Sat,  7 Nov 2026 08:57:13 -0500
Message-ID: <20261107135037.627683123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Navon John Lukose <navonjohnlukose@gmail.com>

[ Upstream commit 73dae605cad7921800677d982bfaeb81cc930dec ]

i2c_dw_xfer_msg() pre-queues up to rx_fifo_depth read commands based
on the initial msg.len. For I2C_M_RECV_LEN transfers the real length
is unknown until the first byte arrives and i2c_dw_recv_len() runs.
When a large initial length is passed, the surplus pre-queued reads
leave rx_outstanding non-zero after i2c_dw_recv_len() adjusts
msg.len, so the completion condition is never met and the transfer
times out. In a loop, this repeatedly times out the controller and
disrupts unrelated driver-bound devices on the same adapter.

Queue only one read command while I2C_M_RECV_LEN is pending.
i2c_dw_recv_len() re-enables TX_EMPTY, and the rest are queued once
the device-reported length is known.

Fixes: c3ae106050b9 ("i2c: designware: Implement support for SMBus block read and write")
Signed-off-by: Navon John Lukose <navonjohnlukose@gmail.com>
Cc: <stable@vger.kernel.org> # v4.10+
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-master.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
index 196bb073c6bcc..b2e916ebb5a77 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -495,6 +495,14 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 				if (dev->rx_outstanding >= dev->rx_fifo_depth)
 					break;
 
+				/*
+				 * For block reads, queue only the length
+				 * byte until i2c_dw_recv_len() runs.
+				 */
+				if ((flags & I2C_M_RECV_LEN) &&
+				    buf_len < msgs[dev->msg_write_idx].len)
+					break;
+
 				regmap_write(dev->map, DW_IC_DATA_CMD,
 					     cmd | 0x100);
 				rx_limit--;
-- 
2.53.0



