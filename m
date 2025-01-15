Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD32248BD1;
	Wed, 15 Jan 2025 10:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938329; cv=none; b=T/6Vyg0sGVrWT/GnGzpVJ4BtImhIpZYP9PNAdrbOthqnr5b9ih2yAdgWcciLTDSs3kfK0AqyIM/Tt8pd1T5mBGFHAHtgDl3Y/Gy7+KFF+G2a09gpXnCycH65BWwLGxuheovX1jX7BSO50XYnhxhvGJ4CSLvncJ+nXxaC9j1LGK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938329; c=relaxed/simple;
	bh=QPjDHaWGvcuMH39m4dyEsTzetNdWZj+hR2TIelvxRs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6NtU1yJYD3fjCmT7xj+6esff7iMDW9oq3ZnYUUtx0xz5KCr8kwTzq19p1k8bCgAQEqiyfpnV/mJKldXF/7zJoKjztMYQS1BOHStOFWE5bFJvkb0p83QB0EHvImCH2al4wPDgEuEVVb/oTihtRMYOKNOL+t4y3ImO69xLT3miow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwktRgbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwktRgbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27769C4CEE2;
	Wed, 15 Jan 2025 10:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938329;
	bh=QPjDHaWGvcuMH39m4dyEsTzetNdWZj+hR2TIelvxRs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwktRgbNZnDtUqafd0tzMN7KJTUwfPWvVYGTbxSuXD8x070R2SdoNwbLp4mkGG4qo
	 NtJxhJ3RkNlsdalfASQ5iJwhhpdMTLr6O5b9JY1+2ilY0pXJIGKmWnvq/kv1up+be/
	 7fCUnQk1Ohe5Var+dkXsUIsQyYkCOT60gkdUcR0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.12 150/189] usb: typec: tcpci: fix NULL pointer issue on shared irq case
Date: Wed, 15 Jan 2025 11:37:26 +0100
Message-ID: <20250115103612.400190842@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 862a9c0f68487fd6ced15622d9cdcec48f8b5aaa upstream.

The tcpci_irq() may meet below NULL pointer dereference issue:

[    2.641851] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
[    2.641951] status 0x1, 0x37f
[    2.650659] Mem abort info:
[    2.656490]   ESR = 0x0000000096000004
[    2.660230]   EC = 0x25: DABT (current EL), IL = 32 bits
[    2.665532]   SET = 0, FnV = 0
[    2.668579]   EA = 0, S1PTW = 0
[    2.671715]   FSC = 0x04: level 0 translation fault
[    2.676584] Data abort info:
[    2.679459]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    2.684936]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    2.689980]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    2.695284] [0000000000000010] user address but active_mm is swapper
[    2.701632] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[    2.707883] Modules linked in:
[    2.710936] CPU: 1 UID: 0 PID: 87 Comm: irq/111-2-0051 Not tainted 6.12.0-rc6-06316-g7f63786ad3d1-dirty #4
[    2.720570] Hardware name: NXP i.MX93 11X11 EVK board (DT)
[    2.726040] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    2.732989] pc : tcpci_irq+0x38/0x318
[    2.736647] lr : _tcpci_irq+0x14/0x20
[    2.740295] sp : ffff80008324bd30
[    2.743597] x29: ffff80008324bd70 x28: ffff800080107894 x27: ffff800082198f70
[    2.750721] x26: ffff0000050e6680 x25: ffff000004d172ac x24: ffff0000050f0000
[    2.757845] x23: ffff000004d17200 x22: 0000000000000001 x21: ffff0000050f0000
[    2.764969] x20: ffff000004d17200 x19: 0000000000000000 x18: 0000000000000001
[    2.772093] x17: 0000000000000000 x16: ffff80008183d8a0 x15: ffff00007fbab040
[    2.779217] x14: ffff00007fb918c0 x13: 0000000000000000 x12: 000000000000017a
[    2.786341] x11: 0000000000000001 x10: 0000000000000a90 x9 : ffff80008324bd00
[    2.793465] x8 : ffff0000050f0af0 x7 : ffff00007fbaa840 x6 : 0000000000000031
[    2.800589] x5 : 000000000000017a x4 : 0000000000000002 x3 : 0000000000000002
[    2.807713] x2 : ffff80008324bd3a x1 : 0000000000000010 x0 : 0000000000000000
[    2.814838] Call trace:
[    2.817273]  tcpci_irq+0x38/0x318
[    2.820583]  _tcpci_irq+0x14/0x20
[    2.823885]  irq_thread_fn+0x2c/0xa8
[    2.827456]  irq_thread+0x16c/0x2f4
[    2.830940]  kthread+0x110/0x114
[    2.834164]  ret_from_fork+0x10/0x20
[    2.837738] Code: f9426420 f9001fe0 d2800000 52800201 (f9400a60)

This may happen on shared irq case. Such as two Type-C ports share one
irq. After the first port finished tcpci_register_port(), it may trigger
interrupt. However, if the interrupt comes by chance the 2nd port finishes
devm_request_threaded_irq(), the 2nd port interrupt handler will run at
first. Then the above issue happens due to tcpci is still a NULL pointer
in tcpci_irq() when dereference to regmap.

  devm_request_threaded_irq()
				<-- port1 irq comes
  disable_irq(client->irq);
  tcpci_register_port()

This will restore the logic to the state before commit (77e85107a771 "usb:
typec: tcpci: support edge irq").

However, moving tcpci_register_port() earlier creates a problem when use
edge irq because tcpci_init() will be called before
devm_request_threaded_irq(). The tcpci_init() writes the ALERT_MASK to
the hardware to tell it to start generating interrupts but we're not ready
to deal with them yet, then the ALERT events may be missed and ALERT line
will not recover to high level forever. To avoid the issue, this will also
set ALERT_MASK register after devm_request_threaded_irq() return.

Fixes: 77e85107a771 ("usb: typec: tcpci: support edge irq")
Cc: stable <stable@kernel.org>
Tested-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20241218095328.2604607-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index ed32583829be..24a6a4354df8 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -700,7 +700,7 @@ static int tcpci_init(struct tcpc_dev *tcpc)
 
 	tcpci->alert_mask = reg;
 
-	return tcpci_write16(tcpci, TCPC_ALERT_MASK, reg);
+	return 0;
 }
 
 irqreturn_t tcpci_irq(struct tcpci *tcpci)
@@ -923,22 +923,27 @@ static int tcpci_probe(struct i2c_client *client)
 
 	chip->data.set_orientation = err;
 
+	chip->tcpci = tcpci_register_port(&client->dev, &chip->data);
+	if (IS_ERR(chip->tcpci))
+		return PTR_ERR(chip->tcpci);
+
 	err = devm_request_threaded_irq(&client->dev, client->irq, NULL,
 					_tcpci_irq,
 					IRQF_SHARED | IRQF_ONESHOT,
 					dev_name(&client->dev), chip);
 	if (err < 0)
-		return err;
+		goto unregister_port;
 
-	/*
-	 * Disable irq while registering port. If irq is configured as an edge
-	 * irq this allow to keep track and process the irq as soon as it is enabled.
-	 */
-	disable_irq(client->irq);
-	chip->tcpci = tcpci_register_port(&client->dev, &chip->data);
-	enable_irq(client->irq);
+	/* Enable chip interrupts at last */
+	err = tcpci_write16(chip->tcpci, TCPC_ALERT_MASK, chip->tcpci->alert_mask);
+	if (err < 0)
+		goto unregister_port;
 
-	return PTR_ERR_OR_ZERO(chip->tcpci);
+	return 0;
+
+unregister_port:
+	tcpci_unregister_port(chip->tcpci);
+	return err;
 }
 
 static void tcpci_remove(struct i2c_client *client)
-- 
2.48.0



