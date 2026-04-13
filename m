Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C179225A38;
	Mon, 13 Apr 2026 16:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097875; cv=none; b=BBXQUOROkRbTrcDZsCkeMq0+BSLA9+VQvzieWn6rq8W5ZcAb6NQNOS8JwhjllRvkFXQtj6kWFaO4JsRqVBZnqrEAb4BVOkZikPGHee5+xd/fnLh60PczKJ165mLphh3Ps7eVrfvw500a8eXYeAdijFRFXuJXb9qbX6cCeTcYxvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097875; c=relaxed/simple;
	bh=eiOKB3nP1nysu9cAcPHFEJ4AOc+iMq/Kvj4fv6faSTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyMqvqqLHealSryNKp2WSZ8XigoYPivsh2ICjbc++Tf1hmnA6lUB1EKPH0D4RxoiUdEjrccwM4xIJHraweabdKSvWr+4LqdQqsABE3eOLmKtykd1SVU5Y5wkrt5mPzG55j7tInWaW2kxQw46h8YFzfX6llyxLqUdmuT/itRbKi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dd33uFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dd33uFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE9CC2BCAF;
	Mon, 13 Apr 2026 16:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097873;
	bh=eiOKB3nP1nysu9cAcPHFEJ4AOc+iMq/Kvj4fv6faSTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dd33uFe1S+7mtFuZGoWre7WllWr3xmLaBtZE1l1ESXck8sVj+FgaNOFfszScFwnh
	 sa/NG86zzCXsC6FpT69KgeB148sCsTFjI0DZGcswKov/yY0/z3aH29RL32AK3s41Wq
	 T0M1OK6SOOyoV6BjZ/U/L+asRngMwNpGP8aH8KyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Sioen <romain.sioen@microchip.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 306/570] HID: mcp2221: cancel last I2C command on read error
Date: Mon, 13 Apr 2026 17:57:17 +0200
Message-ID: <20260413155841.962116440@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Romain Sioen <romain.sioen@microchip.com>

[ Upstream commit e31b556c0ba21f20c298aa61181b96541140b7b9 ]

When an I2C SMBus read operation fails, the MCP2221 internal state machine
may not reset correctly, causing subsequent transactions to fail.

By adding a short delay and explicitly cancelling the last command,
we ensure the device is ready for the next operation.

Fix an issue where i2cdetect was not able to detect all devices correctly
on the bus.

Signed-off-by: Romain Sioen <romain.sioen@microchip.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-mcp2221.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index 589f13ff0b606..9fb98c8e1ffb7 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -319,6 +319,8 @@ static int mcp_i2c_smbus_read(struct mcp2221 *mcp,
 				usleep_range(90, 100);
 				retries++;
 			} else {
+				usleep_range(980, 1000);
+				mcp_cancel_last_cmd(mcp);
 				return ret;
 			}
 		} else {
-- 
2.51.0



