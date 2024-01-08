Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3D14C3C9;
	Mon,  8 Jan 2024 15:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUvUUjT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09144C433C9;
	Mon,  8 Jan 2024 15:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726895;
	bh=F9Mk2oOzj8YTRsnXvz0JBZCZP7ABkvVEhbO8p4shPsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUvUUjT0wNR0nOhfF9fgItIy4+FZSFHi6o7/VXWA6h9k7IIwZjYYqvkEkqbY1aktT
	 JN4luTONbQoVGAdrB65AuprT1ZVeAs8n5psaUvmcBhC9knvJKOq+xeE96sB7/6ASPH
	 +SW//5DapZqi9D2yuESMcy7xXGooRjjYgjpOwZrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Bara <benjamin.bara@skidata.com>,
	Michael Walle <mwalle@kernel.org>,
	Tor Vic <torvic9@mailbox.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.6 112/124] i2c: core: Fix atomic xfer check for non-preempt config
Date: Mon,  8 Jan 2024 16:08:58 +0100
Message-ID: <20240108150608.116612109@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Bara <benjamin.bara@skidata.com>

commit a3368e1186e3ce8e38f78cbca019622095b1f331 upstream.

Since commit aa49c90894d0 ("i2c: core: Run atomic i2c xfer when
!preemptible"), the whole reboot/power off sequence on non-preempt kernels
is using atomic i2c xfer, as !preemptible() always results to 1.

During device_shutdown(), the i2c might be used a lot and not all busses
have implemented an atomic xfer handler. This results in a lot of
avoidable noise, like:

[   12.687169] No atomic I2C transfer handler for 'i2c-0'
[   12.692313] WARNING: CPU: 6 PID: 275 at drivers/i2c/i2c-core.h:40 i2c_smbus_xfer+0x100/0x118
...

Fix this by allowing non-atomic xfer when the interrupts are enabled, as
it was before.

Link: https://lore.kernel.org/r/20231222230106.73f030a5@yea
Link: https://lore.kernel.org/r/20240102150350.3180741-1-mwalle@kernel.org
Link: https://lore.kernel.org/linux-i2c/13271b9b-4132-46ef-abf8-2c311967bb46@mailbox.org/
Fixes: aa49c90894d0 ("i2c: core: Run atomic i2c xfer when !preemptible")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Benjamin Bara <benjamin.bara@skidata.com>
Tested-by: Michael Walle <mwalle@kernel.org>
Tested-by: Tor Vic <torvic9@mailbox.org>
[wsa: removed a comment which needs more work, code is ok]
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/i2c-core.h
+++ b/drivers/i2c/i2c-core.h
@@ -3,6 +3,7 @@
  * i2c-core.h - interfaces internal to the I2C framework
  */
 
+#include <linux/kconfig.h>
 #include <linux/rwsem.h>
 
 struct i2c_devinfo {
@@ -29,7 +30,8 @@ int i2c_dev_irq_from_resources(const str
  */
 static inline bool i2c_in_atomic_xfer_mode(void)
 {
-	return system_state > SYSTEM_RUNNING && !preemptible();
+	return system_state > SYSTEM_RUNNING &&
+	       (IS_ENABLED(CONFIG_PREEMPT_COUNT) ? !preemptible() : irqs_disabled());
 }
 
 static inline int __i2c_lock_bus_helper(struct i2c_adapter *adap)


