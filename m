Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA6E15E8B;
	Mon, 30 Dec 2024 15:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573938; cv=none; b=LP59C20o9RHOIi1EFTC6JuxR26vNaVgusbjYdNAqHuSO+1NXvMsjTwQZkhEwVwZN2bcJk3slwk5BOXDUDCSeEGPXGOsaR/GYrvuOoxJG72zRz+0bu6wan5UzjsvJ67TbCh1I1jRqNu/YU4xX2o8rWukWSLgx+2IhSeIVhXaCttc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573938; c=relaxed/simple;
	bh=Zn2iLJMqLoSOiwy+AwROQcsZp0iDZKNsm+WG/O+70Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhVbjMmWCmA+m1BjMuavF+OGcJwY00J3ry0jNDX6Eu3r65Ujppq3NAZHL7RSAV0vqATTs0JYOh2Yz6Xm87gqNpzmv6Yu/ebOsSSNeEfVcmCgYCScDj8d8EH0DvqMUN3lePa+vncTdaDCRO8oo7CwmF+Hg74T8EtbcNMivA6J4TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuwtlTj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuwtlTj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E4BC4CED0;
	Mon, 30 Dec 2024 15:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573938;
	bh=Zn2iLJMqLoSOiwy+AwROQcsZp0iDZKNsm+WG/O+70Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuwtlTj+KrOIbiQ75LkRnl8mId0je/IFjNCJmxsqfDuVTg88gTbrAzWY3PIEJAx+r
	 czWgkSFEy/qlden+lwtdCwK/S/zVmucIzmvDbVny3+HNjV8K1cWX7s4nHKTHr8Pj28
	 JB0aSpyydlVZTjMsybsiWqna4miLpVeyihZey9c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 79/86] i2c: microchip-core: fix "ghost" detections
Date: Mon, 30 Dec 2024 16:43:27 +0100
Message-ID: <20241230154214.712568195@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit 49e1f0fd0d4cb03a16b8526c4e683e1958f71490 upstream.

Running i2c-detect currently produces an output akin to:
    0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:                         08 -- 0a -- 0c -- 0e --
10: 10 -- 12 -- 14 -- 16 -- UU 19 -- 1b -- 1d -- 1f
20: -- 21 -- 23 -- 25 -- 27 -- 29 -- 2b -- 2d -- 2f
30: -- -- -- -- -- -- -- -- 38 -- 3a -- 3c -- 3e --
40: 40 -- 42 -- 44 -- 46 -- 48 -- 4a -- 4c -- 4e --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: 60 -- 62 -- 64 -- 66 -- 68 -- 6a -- 6c -- 6e --
70: 70 -- 72 -- 74 -- 76 --

This happens because for an i2c_msg with a len of 0 the driver will
mark the transmission of the message as a success once the START has
been sent, without waiting for the devices on the bus to respond with an
ACK/NAK. Since i2cdetect seems to run in a tight loop over all addresses
the NAK is treated as part of the next test for the next address.

Delete the fast path that marks a message as complete when idev->msg_len
is zero after sending a START/RESTART since this isn't a valid scenario.

CC: stable@vger.kernel.org
Fixes: 64a6f1c4987e ("i2c: add support for microchip fpga i2c controllers")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20241218-outbid-encounter-b2e78b1cc707@spud
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-microchip-corei2c.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/i2c/busses/i2c-microchip-corei2c.c
+++ b/drivers/i2c/busses/i2c-microchip-corei2c.c
@@ -287,8 +287,6 @@ static irqreturn_t mchp_corei2c_handle_i
 		ctrl &= ~CTRL_STA;
 		writeb(idev->addr, idev->base + CORE_I2C_DATA);
 		writeb(ctrl, idev->base + CORE_I2C_CTRL);
-		if (idev->msg_len == 0)
-			finished = true;
 		break;
 	case STATUS_M_ARB_LOST:
 		idev->msg_err = -EAGAIN;


