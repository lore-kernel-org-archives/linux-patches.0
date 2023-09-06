Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88B51097D
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 18:09:50 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-56b0c5a140dso148997a12.0
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 11:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694023790; x=1694628590; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4wi6bhruWz0hbXHukGopFEWiMps+cu8JOpx7s5KKUhM=;
        b=oCDUMSOjn6KkSNkhNbLHfj/OpH/JCYel/+eL8JyniiH/zIQI3SRQuo4h+fyIyBYlNy
         JYICsBvxrXGZb731FLfdhazVb2j0ZbsqKg/oP2pjPTWvuVU8zNK8Lz3VUp6PS+4wV7p+
         /qK6OdrFFPUmVwyAHXC8yw3Y+UrZjaPrTPyng=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694023790; x=1694628590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4wi6bhruWz0hbXHukGopFEWiMps+cu8JOpx7s5KKUhM=;
        b=IRryZD2haQxNryxjIc3XRXNiAmBzUm7UGsqGoMvJi6yrC97EDPfh2ccrO3qt7vAe/j
         sJntCHymO2uFkvct4altb0V2Dcd1cthWJFQhyjvqS3ycM/fAc6vOMvh1qB1+IlxtPIts
         yLWDf7MmaHtMuu/0aPVgj1AEGbmWobGaZxp9yzGGbkN4GQ/0pTeC1cwaLbJ0wvrjPdiD
         srOaRZtAhzMW/gz+uSGwnB6BoISENFf78L9W0aoGum6O8606vm92m2qNHg2UJOMPEuqS
         MZr4fD+ZsrMbEVJifa5ot/eV4IQNcqd0bGoHa4QHslVWjkfg0vP2MgRG3i7QCVbI//4g
         Mrjg==
X-Gm-Message-State: AOJu0YxASi+QR0uqxbbvUEk4eLOJ0HgqIoouoehPoQaVPxriwuSHvEKc
	fOSckEnBk2+ir0YsvUjImzqHMg==
X-Google-Smtp-Source: AGHT+IGRoSyy5prcv7s6aCNDx4HYofOxt/2GfTUCB8Kos+5pU7v9KRLevtDFB4w6cibWsZB6VVxy4A==
X-Received: by 2002:a17:902:e5c3:b0:1c3:52ed:1905 with SMTP id u3-20020a170902e5c300b001c352ed1905mr6467512plf.28.1694023790329;
        Wed, 06 Sep 2023 11:09:50 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:a404:ed4a:5a1e:3b4a])
        by smtp.gmail.com with ESMTPSA id ix5-20020a170902f80500b001bc675068e2sm11363996plb.111.2023.09.06.11.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 11:09:49 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: [PATCH v2 3/3] platform/x86: intel_scu_ipc: Fail IPC send if still busy
Date: Wed,  6 Sep 2023 11:09:43 -0700
Message-ID: <20230906180944.2197111-4-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230906180944.2197111-1-swboyd@chromium.org>
References: <20230906180944.2197111-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Fixes: ed12f295bfd5 ("ipc: Added support for IPC interrupt mode")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 29 ++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 3cea701d2bbd..8be24f48a0fa 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -271,6 +271,19 @@ static int intel_scu_ipc_check_status(struct intel_scu_ipc_dev *scu)
 	return scu->irq > 0 ? ipc_wait_for_interrupt(scu) : busy_loop(scu);
 }
 
+static int intel_scu_ipc_busy(struct intel_scu_ipc_dev *scu)
+{
+	u8 status;
+
+	status = ipc_read_status(scu);
+	if (status & IPC_STATUS_BUSY) {
+		dev_dbg(&scu->dev, "device is busy\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
 /* Read/Write power control(PMIC in Langwell, MSIC in PenWell) registers */
 static int pwr_reg_rdwr(struct intel_scu_ipc_dev *scu, u16 *addr, u8 *data,
 			u32 count, u32 op, u32 id)
@@ -290,6 +303,11 @@ static int pwr_reg_rdwr(struct intel_scu_ipc_dev *scu, u16 *addr, u8 *data,
 		mutex_unlock(&ipclock);
 		return -ENODEV;
 	}
+	err = intel_scu_ipc_busy(scu);
+	if (err) {
+		mutex_unlock(&ipclock);
+		return err;
+	}
 
 	for (nc = 0; nc < count; nc++, offset += 2) {
 		cbuf[offset] = addr[nc];
@@ -450,6 +468,12 @@ int intel_scu_ipc_dev_simple_command(struct intel_scu_ipc_dev *scu, int cmd,
 		return -ENODEV;
 	}
 	scu = ipcdev;
+	err = intel_scu_ipc_busy(scu);
+	if (err) {
+		mutex_unlock(&ipclock);
+		return err;
+	}
+
 	cmdval = sub << 12 | cmd;
 	ipc_command(scu, cmdval);
 	err = intel_scu_ipc_check_status(scu);
@@ -495,6 +519,11 @@ int intel_scu_ipc_dev_command_with_size(struct intel_scu_ipc_dev *scu, int cmd,
 		mutex_unlock(&ipclock);
 		return -ENODEV;
 	}
+	err = intel_scu_ipc_busy(scu);
+	if (err) {
+		mutex_unlock(&ipclock);
+		return err;
+	}
 
 	memcpy(inbuf, in, inlen);
 	for (i = 0; i < inbuflen; i++)
-- 
https://chromeos.dev

