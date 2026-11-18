Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036911;
	b=ZlvWw08INpLuhXaP9VGFnLnuBGXPZ6DUiCUeq5levldpDQ33NLhTnaJl634d8bjgmRkz
	 tPg8hMVY7UrmzLCuJgO0hrLEx7Vbnz8RuU2qLlAzcP1/TKpI4rwaf9y3/YjjHRp6+4EZo
	 0YqhrevMElPPRZQrWGKsPW9rkYQSDeYQNHGiAbHtYo5oIHvC9WxONu3dMCsuGXlPaXYJs
	 jjR0eq/i1SV4HC0Shw9HOZsKNDfrtcRMjd5Te4DrDRUCL9qybL8t2BJm2HGSfIyNxEr/I
	 T3cKFMSv8SFoSNomq3IK/28wpRPXxjlLh3BxgM6pnuRay8zW9ItlmmVCouX/iZz0cmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v5kYhpCWcW+xA2dtf59mm4eBKuuKmb2mWDYR4yZ8WLY=;
	b=FqghK2cTlkjhpQUAZXQOE+g+oUNdbLW1CHFSUF8valTC7rOvVFNde+N6V4ovwyqkMQtW
	 XLq9Npju+XvHmg+RSXx8Jt3Gss3xpvOSJ2O9ah6K8WP5iBwTxdZHLxTCbXVn6KSR71R33
	 4G8qYYavQtzga72Saa4dfwNeOYvtP4yj+xemma2Vzne2q+bWtjgmUPk6EloN00rluXT8H
	 QyYydeY1FcMqD5349LOiH9Wfrg028Wp4iTmKhRVJdCyZRAQOQzgzgpGpxvk/gcVQCaH0E
	 mjcSs1jOcV5Up/LgZ1cKdRBAsgYmxa5LKJrBu1OxNTh2cL5L2T/a0+SovVqea07BCIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CfYWcAFH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB296606A31C;
	Wed, 18 Nov 2026 21:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CfYWcAFH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8C11F000C4;
	Wed, 18 Nov 2026 21:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036911;
	bh=v5kYhpCWcW+xA2dtf59mm4eBKuuKmb2mWDYR4yZ8WLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfYWcAFHQ+pmR0cDOaWupZJbjtVTTJytrtkZQrqcVmFwt14FZ6ktUbONEkbccNqNq
	 BNcoUyErmJBXHVkQsXxL7gdA15txrr+3pGswOyQN/GmxGgi4Gfn/af96HSGpxiOfQP
	 odhIU53daxqRmJDbb2Pq0StX9oT6s3n0LBEz8Flo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1200/3318] i2c: designware: queue only one read command for block reads
Date: Wed, 18 Nov 2026 15:30:22 +0100
Message-ID: <20261118150356.170674448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 56f124f32cac6..f02802e547042 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -539,6 +539,14 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
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



