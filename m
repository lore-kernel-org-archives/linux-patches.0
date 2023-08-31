Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709AF10E1
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 01:14:10 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1bf3a2f4528so1988625ad.2
        for <patches@lists.linux.dev>; Wed, 30 Aug 2023 18:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693444450; x=1694049250; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Evb7/BN7ItVli8O1MCLcSe5YscQaq6FblNFUqza6B98=;
        b=hWwghBnmpYdWM44Rt3ko7iI2NzZekO9PMsjK2QEGuA4USdLP2wP+SpK+qDu2IVOgqU
         sIqZWAl3duIvDeQ6zO2zFE3MyOi/mkcWccufPBWiCvBtNhkgBwhzOrkfb0jls9tIUsDH
         ZV/RVBod9PDd4JS4MDz4+aMqnausBGeYzxdMs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693444450; x=1694049250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Evb7/BN7ItVli8O1MCLcSe5YscQaq6FblNFUqza6B98=;
        b=AhjQy+fYT237Two9IcXMdpOXsoPC7ljJxgnGtC7SlPJqGH6n3Ai7kHGUh4vtaYRkHP
         t8cAcideBUAsiu73FRfeKT82jGge1bjnj/I90ecg50+BMEReHMcgZJnMX3VLFM13kRhr
         h51zt+xQzzNKxCQbPksGaBgaTapzlj4rY7PUfC27qUPPeOkm3JOmvj7/tOtLZM95DNbK
         75v9XsYPMjgYM3cqdqiQQqTuEdXCfivtqj5Dm+3XISbHXBuoq+awFCJjIM4TI5kgT5wB
         VvtMbKENrMG43O1taWX4rPrwecn+8mNVqwFIoRBYZ2O3DazMGwBtKI32ZSfAX98wi249
         rrgg==
X-Gm-Message-State: AOJu0Yzc+11BYYFV848+7pvnqkyamvXI3KvThptro8MSOwTg+WCM2m1/
	ZuAdCcYX8snQygzMtd5Uf6j2zg==
X-Google-Smtp-Source: AGHT+IFYusCNVLK7C29ZkzYj1eGJCKZt8+lyPCyvbxdXZnw6xYC4O8RV0ZX9Jg5wTDXLG27eEM/K/Q==
X-Received: by 2002:a17:902:db0c:b0:1b9:e81f:fb08 with SMTP id m12-20020a170902db0c00b001b9e81ffb08mr4163642plx.55.1693444449861;
        Wed, 30 Aug 2023 18:14:09 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:248f:d364:b451:2bc0])
        by smtp.gmail.com with ESMTPSA id im23-20020a170902bb1700b001bbb7af4963sm132604plb.68.2023.08.30.18.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 18:14:09 -0700 (PDT)
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
Subject: [PATCH 2/3] platform/x86: intel_scu_ipc: Check status upon timeout in ipc_wait_for_interrupt()
Date: Wed, 30 Aug 2023 18:14:02 -0700
Message-ID: <20230831011405.3246849-3-swboyd@chromium.org>
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

It's possible for the completion in ipc_wait_for_interrupt() to timeout,
simply because the interrupt was delayed in being processed. A timeout
in itself is not an error. This driver should check the status register
upon a timeout to ensure that scheduling or interrupt processing delays
don't affect the outcome of the IPC return value.

 CPU0                                                   SCU
 ----                                                   ---
 ipc_wait_for_interrupt()
  wait_for_completion_timeout(&scu->cmd_complete)
  [TIMEOUT]                                             status[IPC_BUSY]=0

Fix this problem by reading the status bit in all cases, regardless of
the timeout. If the completion times out, we'll assume the problem was
that the IPC_BUSY bit was still set, but if the status bit is cleared in
the meantime we know that we hit some scheduling delay and we should
just check the error bit.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Fixes: ed12f295bfd5 ("ipc: Added support for IPC interrupt mode")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 5a37becc65aa..2a21153e3bf3 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -246,16 +246,19 @@ static inline int busy_loop(struct intel_scu_ipc_dev *scu)
 /* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
 static inline int ipc_wait_for_interrupt(struct intel_scu_ipc_dev *scu)
 {
-	int status;
+	unsigned long time_left;
+	u8 status;
+	int err = 0;
 
-	if (!wait_for_completion_timeout(&scu->cmd_complete, IPC_TIMEOUT))
-		return -ETIMEDOUT;
+	time_left = wait_for_completion_timeout(&scu->cmd_complete, IPC_TIMEOUT);
+	if (!time_left)
+		err = -ETIMEDOUT;
 
 	status = ipc_read_status(scu);
-	if (status & IPC_STATUS_ERR)
-		return -EIO;
+	if (!(status & IPC_STATUS_BUSY))
+		err = (status & IPC_STATUS_ERR) ? -EIO : 0;
 
-	return 0;
+	return err;
 }
 
 static int intel_scu_ipc_check_status(struct intel_scu_ipc_dev *scu)
-- 
https://chromeos.dev

