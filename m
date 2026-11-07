Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063590;
	b=242Cz1IaCkj004ph+8eknitdk+5cMzdEhYBh7EoDXtJfzAIT0E6shXQfWC3B6Uocxbb6
	 Z/O4y1Ed6eKLJgfB7fbKu8uPF80nCdEBM+CWkL9g7iZKBUm01odGTpXA9PTbE7oc4Swzn
	 rV8WJ6qNt2EuCzAXYfDWlq6aM5BIuu+e3d1XCqrVKvfBoxuu5S84A1hoODxZkb6Curve9
	 wNfthky/5ClZGmCwJAbyi6cj0G8bEmHJ8ThSdVFqEsRrDZddLkkcUgqt8cSLpxb8bR/ib
	 CXS/X/Ud0z+YGfzBfiKCH4DwsEYHRVactcezLwrPJE9hoHJklDP4ZoD3mCag1qVIjYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v5CFYE+Dz2EF0TzzwHKf44xmr0o9Ec3YGk6PxXt9mb0=;
	b=FghhOOYnzRkXgUgcF6SdFUwKzblITwRnPQym04m1+7Gd+8ETAnF5xGzNhHWjfC2O+HKR
	 9APzYvltrNs3dyd4Jw1axF/F8qwWhuaRoJ74/l/B8UdymK+9UmyF5m5F2P/+E+drTXuKH
	 vE4MDSXcOh4CGfisdzyUHqrpFZOuzxZ9XGxidAX7q9MGr5+OuPl8aZoXIEtBJPnJi4nxz
	 OcHL3ihtBj5zghE9Wl7bHzk0zKdvsHdnezXE74ivPdAglpkoqhhKrMYcbuHcWw7FPUKNd
	 Aqc9u+2Ynrp74CxmIjrNq9BONwgXGXoUb4HUH1kBQ6Ond4A07z97ent3Sl1Gb77/fzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnST9E+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFAF606D826;
	Sat,  7 Nov 2026 14:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnST9E+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10E61F008A1;
	Sat,  7 Nov 2026 14:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063590;
	bh=v5CFYE+Dz2EF0TzzwHKf44xmr0o9Ec3YGk6PxXt9mb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnST9E+DyLETDyq4j1gDDnps6VRTwVMAOqpvGxWz1HJeVJrrbldJAcuFQ7c+xL6yT
	 fWmiDqTZDKdFEhb0a8tRFjfsbO+/TKPtxcYOfE+OEGcUXSf0zHw2YMKceXZ5GX25RN
	 iLdQ4v4OhQ6U/xhrdPYnh7l4ZpZgZCMXrwzY8rJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 716/869] i2c: designware: queue only one read command for block reads
Date: Sat,  7 Nov 2026 08:56:38 -0500
Message-ID: <20261107134917.131457095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index c4bab532eed1e..593ddec3c40ee 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -515,6 +515,14 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
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



