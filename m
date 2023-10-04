Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586E51D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD662C433C7;
	Wed,  4 Oct 2023 18:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442624;
	bh=sffHOMQNWgRyKyL9Qt3hFpRu46H95bJjj24r5rZMNJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnUUQGBOnsYySljNUSharVnFzS3zf65GDn7k1KRn0eYcN2IpuRaLcXjGplR9fNy10
	 GDNTzxbJ4XKbkLBlFmoUVQ6SEueCjtnLQdsUgL8QqaBbW6UqMeG9GRrby+uVBIb2lp
	 EtjvWlFn6kYDFOZcz7wd0FQPUaYWNr/pE+E5ieBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Stephen Boyd <swboyd@chromium.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/183] platform/x86: intel_scu_ipc: Fail IPC send if still busy
Date: Wed,  4 Oct 2023 19:54:42 +0200
Message-ID: <20231004175206.088619835@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 85e654c9f722853a595fa941dca60c157b707b86 ]

It's possible for interrupts to get significantly delayed to the point
that callers of intel_scu_ipc_dev_command() and friends can call the
function once, hit a timeout, and call it again while the interrupt
still hasn't been processed. This driver will get seriously confused if
the interrupt is finally processed after the second IPC has been sent
with ipc_command(). It won't know which IPC has been completed. This
could be quite disastrous if calling code assumes something has happened
upon return from intel_scu_ipc_dev_simple_command() when it actually
hasn't.

Let's avoid this scenario by simply returning -EBUSY in this case.
Hopefully higher layers will know to back off or fail gracefully when
this happens. It's all highly unlikely anyway, but it's better to be
correct here as we have no way to know which IPC the status register is
telling us about if we send a second IPC while the previous IPC is still
processing.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Fixes: ed12f295bfd5 ("ipc: Added support for IPC interrupt mode")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20230913212723.3055315-5-swboyd@chromium.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 40 +++++++++++++++++++---------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index dfe010f1ee084..189c5460edd81 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -266,6 +266,24 @@ static int intel_scu_ipc_check_status(struct intel_scu_ipc_dev *scu)
 	return scu->irq > 0 ? ipc_wait_for_interrupt(scu) : busy_loop(scu);
 }
 
+static struct intel_scu_ipc_dev *intel_scu_ipc_get(struct intel_scu_ipc_dev *scu)
+{
+	u8 status;
+
+	if (!scu)
+		scu = ipcdev;
+	if (!scu)
+		return ERR_PTR(-ENODEV);
+
+	status = ipc_read_status(scu);
+	if (status & IPC_STATUS_BUSY) {
+		dev_dbg(&scu->dev, "device is busy\n");
+		return ERR_PTR(-EBUSY);
+	}
+
+	return scu;
+}
+
 /* Read/Write power control(PMIC in Langwell, MSIC in PenWell) registers */
 static int pwr_reg_rdwr(struct intel_scu_ipc_dev *scu, u16 *addr, u8 *data,
 			u32 count, u32 op, u32 id)
@@ -279,11 +297,10 @@ static int pwr_reg_rdwr(struct intel_scu_ipc_dev *scu, u16 *addr, u8 *data,
 	memset(cbuf, 0, sizeof(cbuf));
 
 	mutex_lock(&ipclock);
-	if (!scu)
-		scu = ipcdev;
-	if (!scu) {
+	scu = intel_scu_ipc_get(scu);
+	if (IS_ERR(scu)) {
 		mutex_unlock(&ipclock);
-		return -ENODEV;
+		return PTR_ERR(scu);
 	}
 
 	for (nc = 0; nc < count; nc++, offset += 2) {
@@ -438,12 +455,12 @@ int intel_scu_ipc_dev_simple_command(struct intel_scu_ipc_dev *scu, int cmd,
 	int err;
 
 	mutex_lock(&ipclock);
-	if (!scu)
-		scu = ipcdev;
-	if (!scu) {
+	scu = intel_scu_ipc_get(scu);
+	if (IS_ERR(scu)) {
 		mutex_unlock(&ipclock);
-		return -ENODEV;
+		return PTR_ERR(scu);
 	}
+
 	cmdval = sub << 12 | cmd;
 	ipc_command(scu, cmdval);
 	err = intel_scu_ipc_check_status(scu);
@@ -483,11 +500,10 @@ int intel_scu_ipc_dev_command_with_size(struct intel_scu_ipc_dev *scu, int cmd,
 		return -EINVAL;
 
 	mutex_lock(&ipclock);
-	if (!scu)
-		scu = ipcdev;
-	if (!scu) {
+	scu = intel_scu_ipc_get(scu);
+	if (IS_ERR(scu)) {
 		mutex_unlock(&ipclock);
-		return -ENODEV;
+		return PTR_ERR(scu);
 	}
 
 	memcpy(inbuf, in, inlen);
-- 
2.40.1



