Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943AC1DF98B;
	Mon, 23 Jun 2025 21:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713260; cv=none; b=hUH56zTWHSIH71Vl3sqOLgdH87vqr0rWHJZSLcg/u5Mm7uFMhBAbdv61PcRhuneGRrKk3tS7GatJt6bNeuaIHMAEC5JOpFKopp7ztbNU6++OTA2E1nlgjnxWdMSCXk9qvHUnu/GHnc6elYo0olp3tfJY8xmdB/ZP96ol5Pwe+8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713260; c=relaxed/simple;
	bh=Grfgjx1K+dRsu/mH4+9hS1R63+Zzw5+sM1Bh/1j+4f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAF0dzuFhEuIgDNY9V5zbhOVSM++N/nqjmQVnp3J4vrH0bh/OBMFayJRFvObUpA8Oy1VFWMrUpASaAZhMAaUj6xacxkj9jJy7pHzAwEO1tpqLhhcMWGWtU2e3PF9NbJy4lIidZnFPJ7c5+4UaA0Ozk5fMOMqNquLSvl4bryIKT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoEzJ4sZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoEzJ4sZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACBEC4CEEA;
	Mon, 23 Jun 2025 21:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713260;
	bh=Grfgjx1K+dRsu/mH4+9hS1R63+Zzw5+sM1Bh/1j+4f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoEzJ4sZi1uUEwAQGg0FbGYwVM+CM2eodb1MDSXxVXJ36qgn6eRcv8+m3k++F1jjd
	 xT+bLfdANieu/X/XaOZEfSNEw9RanCCcNPEX09iHfZvHbYF2hhyegBvVrlIVmFOpwA
	 +o8TW8T606fVSf79LrJvAIFzqNi9iY7fOAE8wusg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tan En De <ende.tan@starfivetech.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 317/592] i2c: designware: Invoke runtime suspend on quick slave re-registration
Date: Mon, 23 Jun 2025 15:04:35 +0200
Message-ID: <20250623130707.968032852@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tan En De <ende.tan@starfivetech.com>

[ Upstream commit 2fe2b969d911a09abcd6a47401a3c66c38a310e6 ]

Replaced pm_runtime_put() with pm_runtime_put_sync_suspend() to ensure
the runtime suspend is invoked immediately when unregistering a slave.
This prevents a race condition where suspend was skipped when
unregistering and registering slave in quick succession.

For example, consider the rapid sequence of
`delete_device -> new_device -> delete_device -> new_device`.
In this sequence, it is observed that the dw_i2c_plat_runtime_suspend()
might not be invoked after `delete_device` operation.

This is because after `delete_device` operation, when the
pm_runtime_put() is about to trigger suspend, the following `new_device`
operation might race and cancel the suspend.

If that happens, during the `new_device` operation,
dw_i2c_plat_runtime_resume() is skipped (since there was no suspend), which
means `i_dev->init()`, i.e. i2c_dw_init_slave(), is skipped.
Since i2c_dw_init_slave() is skipped, i2c_dw_configure_fifo_slave() is
skipped too, which leaves `DW_IC_INTR_MASK` unconfigured. If we inspect
the interrupt mask register using devmem, it will show as zero.

Example shell script to reproduce the issue:
```
  #!/bin/sh

  SLAVE_LADDR=0x1010
  SLAVE_BUS=13
  NEW_DEVICE=/sys/bus/i2c/devices/i2c-$SLAVE_BUS/new_device
  DELETE_DEVICE=/sys/bus/i2c/devices/i2c-$SLAVE_BUS/delete_device

  # Create initial device
  echo slave-24c02 $SLAVE_LADDR > $NEW_DEVICE
  sleep 2

  # Rapid sequence of
  # delete_device -> new_device -> delete_device -> new_device
  echo $SLAVE_LADDR > $DELETE_DEVICE
  echo slave-24c02 $SLAVE_LADDR > $NEW_DEVICE
  echo $SLAVE_LADDR > $DELETE_DEVICE
  echo slave-24c02 $SLAVE_LADDR > $NEW_DEVICE

  # Using devmem to inspect IC_INTR_MASK will show as zero
```

Signed-off-by: Tan En De <ende.tan@starfivetech.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20250412023303.378600-1-ende.tan@starfivetech.com
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-slave.c b/drivers/i2c/busses/i2c-designware-slave.c
index 5cd4a5f7a472e..b936a240db0a9 100644
--- a/drivers/i2c/busses/i2c-designware-slave.c
+++ b/drivers/i2c/busses/i2c-designware-slave.c
@@ -96,7 +96,7 @@ static int i2c_dw_unreg_slave(struct i2c_client *slave)
 	i2c_dw_disable(dev);
 	synchronize_irq(dev->irq);
 	dev->slave = NULL;
-	pm_runtime_put(dev->dev);
+	pm_runtime_put_sync_suspend(dev->dev);
 
 	return 0;
 }
-- 
2.39.5



