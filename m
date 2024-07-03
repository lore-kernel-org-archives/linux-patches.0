Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9814817DA30;
	Wed,  3 Jul 2024 11:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006130; cv=none; b=vAwpB0V51aeQ2j++3mmIaRtLjl4sUm0+PqeAueb4auYtAi1OvN4CgKlbjhEXAD2ygAi4ZBNFpwzOugdIcPQstDAR8axguVXV9T+vOQF0J5kW9a28kjKwIP14RvRJ/DK/oU0uHI5gJIF9CbBHZgijukLN3roytapjPe9FiGMoH6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006130; c=relaxed/simple;
	bh=ABWaIo7/8QfZixdcuWA68C6KYhnLx7cl716w2+RRGss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYJu+TaNiDSB9rdMb5gektICuW+BLo8PfK4ty7q7OZ49rEH6fPdkEqYEhAUDyWZttT7j30zUQ6X5o58TO/6N9aMlOnnNlie6dbyKig2jHMws1qBj5L/ty5RpY7mStKszuvHdNAy/8B9tAHN8U9Lew4xBzPZeS90+ImVcmArTakc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1PDVMbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1PDVMbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2128CC2BD10;
	Wed,  3 Jul 2024 11:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006130;
	bh=ABWaIo7/8QfZixdcuWA68C6KYhnLx7cl716w2+RRGss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1PDVMbQnY1Az2fyFu83yolpm1CDvOuNyHhF/oPvwhX1u8O9/+l4gCHZ8SHAnpVMp
	 ozR+mPykKjfBVzbHN+Yb0IZD+CfVse+wanprHd3VNYqxaDBv3HiF+CKHJ8gtvsnnRC
	 SzyUeBycJDrRtF6jh2/oZUHi0K0J7VhGJO4HqwRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 309/356] i2c: testunit: discard write requests while old command is running
Date: Wed,  3 Jul 2024 12:40:45 +0200
Message-ID: <20240703102924.804169518@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit c116deafd1a5cc1e9739099eb32114e90623209c ]

When clearing registers on new write requests was added, the protection
for currently running commands was missed leading to concurrent access
to the testunit registers. Check the flag beforehand.

Fixes: b39ab96aa894 ("i2c: testunit: add support for block process calls")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-slave-testunit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/i2c-slave-testunit.c b/drivers/i2c/i2c-slave-testunit.c
index 1beae30c418b8..cd0d87b089fec 100644
--- a/drivers/i2c/i2c-slave-testunit.c
+++ b/drivers/i2c/i2c-slave-testunit.c
@@ -121,6 +121,9 @@ static int i2c_slave_testunit_slave_cb(struct i2c_client *client,
 		break;
 
 	case I2C_SLAVE_WRITE_REQUESTED:
+		if (test_bit(TU_FLAG_IN_PROCESS, &tu->flags))
+			return -EBUSY;
+
 		memset(tu->regs, 0, TU_NUM_REGS);
 		tu->reg_idx = 0;
 		break;
-- 
2.43.0



