Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DD710E1
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 01:14:11 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1bd9b4f8e0eso1833785ad.1
        for <patches@lists.linux.dev>; Wed, 30 Aug 2023 18:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693444451; x=1694049251; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mEJrJjFBjmTqZTkw0c+MWJuIIZBtJEhPZv34AHJkSns=;
        b=bsGspSmiStGG0C8BemwhLWpI7Y8FmBCPx+FVHf4rvNxke5bgbKdngrwGBO3cuhPq7D
         kbntQKJ5lIAUozdEAjK/qR9LcCvzNLgnDxLcfDgeNi+Ym+LKSeZg24pYKwae+ftmRqdS
         q9zSVb4rUBL26hWPdmPdSsnsx+nfLy9k5MeUQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693444451; x=1694049251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mEJrJjFBjmTqZTkw0c+MWJuIIZBtJEhPZv34AHJkSns=;
        b=Y5UC6ZWIFK3PdCTs5m0KUBRUI2v3pirZ89Ax2KupUo+CGOQZJ6Ds51OXl/F24yoQFR
         B/L6ctkauYW8g1DbOFyJH5a9VHFZfg93ga56aS2nx6pV46rfVUQEaRSDqPLQ0rKartFA
         XgaYpMVyD/TGxK27QU1Z1sJsBeHMS0VAFt5nBDj6i7iIEhJ9jhVjsYVqNOOrNs+68bXb
         e4fvkXVP0y02Hzir4/rHFlEeJANYFm6R9dx4sJcdW1Mlrl9hoNTtXJ1lXx/tAkpL5ZrW
         Wttfxdi/fglCA3nXu3If6zYnHMZvG5g7ged5wg/CPOO9jm1qNX1bc/kdDHEK0Umgxo1D
         tGXg==
X-Gm-Message-State: AOJu0Yw99D5CKCPb8T6gCBZOWRh0z1yyGyUI7s02kqTgevelqJjxpu+V
	gCGyOkOM51sUDNBHVvCV7ae9i2AfbqZibNqbH6g=
X-Google-Smtp-Source: AGHT+IGHRduua6XQHeyDpp5hHrYBbEi8NumNCWTxbmxfFd2rZUkD/waUAals2TVmFzvmYy5Ipr4rAA==
X-Received: by 2002:a17:902:6b47:b0:1c0:ec0a:316a with SMTP id g7-20020a1709026b4700b001c0ec0a316amr3353964plt.36.1693444451091;
        Wed, 30 Aug 2023 18:14:11 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:248f:d364:b451:2bc0])
        by smtp.gmail.com with ESMTPSA id im23-20020a170902bb1700b001bbb7af4963sm132604plb.68.2023.08.30.18.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 18:14:10 -0700 (PDT)
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
Subject: [PATCH 3/3] platform/x86: intel_scu_ipc: Fail IPC send if still busy
Date: Wed, 30 Aug 2023 18:14:03 -0700
Message-ID: <20230831011405.3246849-4-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
In-Reply-To: <20230831011405.3246849-1-swboyd@chromium.org>
References: <20230831011405.3246849-1-swboyd@chromium.org>
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
 drivers/platform/x86/intel_scu_ipc.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 2a21153e3bf3..5a56be319f0e 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -266,6 +266,19 @@ static int intel_scu_ipc_check_status(struct intel_scu_ipc_dev *scu)
 	return scu->irq > 0 ? ipc_wait_for_interrupt(scu) : busy_loop(scu);
 }
 
+static bool intel_scu_ipc_busy(struct intel_scu_ipc_dev *scu)
+{
+	u8 status;
+
+	status = ipc_read_status(scu);
+	if (status & IPC_STATUS_BUSY) {
+		dev_err(&scu->dev, "device is busy\n");
+		return true;
+	}
+
+	return false;
+}
+
 /* Read/Write power control(PMIC in Langwell, MSIC in PenWell) registers */
 static int pwr_reg_rdwr(struct intel_scu_ipc_dev *scu, u16 *addr, u8 *data,
 			u32 count, u32 op, u32 id)
@@ -285,6 +298,10 @@ static int pwr_reg_rdwr(struct intel_scu_ipc_dev *scu, u16 *addr, u8 *data,
 		mutex_unlock(&ipclock);
 		return -ENODEV;
 	}
+	if (intel_scu_ipc_busy(scu)) {
+		mutex_unlock(&ipclock);
+		return -EBUSY;
+	}
 
 	for (nc = 0; nc < count; nc++, offset += 2) {
 		cbuf[offset] = addr[nc];
@@ -445,6 +462,10 @@ int intel_scu_ipc_dev_simple_command(struct intel_scu_ipc_dev *scu, int cmd,
 		return -ENODEV;
 	}
 	scu = ipcdev;
+	if (intel_scu_ipc_busy(scu)) {
+		mutex_unlock(&ipclock);
+		return -EBUSY;
+	}
 	cmdval = sub << 12 | cmd;
 	ipc_command(scu, cmdval);
 	err = intel_scu_ipc_check_status(scu);
@@ -490,6 +511,10 @@ int intel_scu_ipc_dev_command_with_size(struct intel_scu_ipc_dev *scu, int cmd,
 		mutex_unlock(&ipclock);
 		return -ENODEV;
 	}
+	if (intel_scu_ipc_busy(scu)) {
+		mutex_unlock(&ipclock);
+		return -EBUSY;
+	}
 
 	memcpy(inbuf, in, inlen);
 	for (i = 0; i < inbuflen; i++)
-- 
https://chromeos.dev

