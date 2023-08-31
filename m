Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609A410EB
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 01:14:09 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1bf3a2f4528so1988565ad.2
        for <patches@lists.linux.dev>; Wed, 30 Aug 2023 18:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693444448; x=1694049248; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yi6iDn2wgjxe+kNysUVpTjdo2oBFvbwTmlzECQzPgK4=;
        b=gvnJkSo/Sz+oty6pqxHPyQNeTIWFYkH+JyWrrr+xYXXKkNh0TuFyVjkY71hCMSjFwZ
         +BriA94tXE2VxOrja2FM42pE0mnCxTwQPWV5e7WoQJELql/PCJbkfeNvMxKThvgudjej
         GAkFMyLY3EOBBV14MumiLI6D6C752iB+jSpto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693444448; x=1694049248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yi6iDn2wgjxe+kNysUVpTjdo2oBFvbwTmlzECQzPgK4=;
        b=NIyKym+UKpCqZ1d/8pStlQvZ/mT/9lVK3kNnRyEvri1bh8qJSg4+scveJ/o0DSS90L
         YLrd7AJvdKi6L3xmh34fj/PI8Fl5q00m8iFsYO4nXCfF31PqGBVxkoc5qjj+b02hmrEA
         QQbd6y0Yjp1TdFmj/ZoC9PkRy6/CQAAj0SpEtRz5y7FBZ6bqGg7/ddyyBt6magiwg8NW
         aI2IhR/a+W+le+wcW3FBKH+9l03MZHO/AfXPeP+SCYK+TbyrYge4BreIymwfOFxnk0dO
         9mRUPrAyuUliYmJg3qjqE4nhfcZYPv4ZbN3VghRVYUEsbfruM1NqZI/5gU7zMj6VYWwy
         KmyA==
X-Gm-Message-State: AOJu0YwxlZdrIGndtQWCZ3Ji50gbf6yTDOZDI9KFguLJv0Q0QVSOfQBb
	YdbwXYtU53RR3N20bca9m+lsXQ==
X-Google-Smtp-Source: AGHT+IHew80vJT+8xJZut5mz37IpFi9RdN3+DaIDAboblAp+7f8qYSDoSaiqwxvec94o5LPnr5OQKA==
X-Received: by 2002:a17:902:8e89:b0:1c0:b7f4:5b86 with SMTP id bg9-20020a1709028e8900b001c0b7f45b86mr3639342plb.65.1693444448598;
        Wed, 30 Aug 2023 18:14:08 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:248f:d364:b451:2bc0])
        by smtp.gmail.com with ESMTPSA id im23-20020a170902bb1700b001bbb7af4963sm132604plb.68.2023.08.30.18.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 18:14:08 -0700 (PDT)
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
Subject: [PATCH 1/3] platform/x86: intel_scu_ipc: Check status after timeouts in busy_loop()
Date: Wed, 30 Aug 2023 18:14:01 -0700
Message-ID: <20230831011405.3246849-2-swboyd@chromium.org>
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

It's possible for the polling loop in busy_loop() to get scheduled away
for a long time.

  status = ipc_read_status(scu);
  <long time scheduled away>
  if (!(status & IPC_STATUS_BUSY))

If this happens, then the status bit could change and this function
would never test it again after checking the jiffies against the timeout
limit. Polling code should check the condition one more time after the
timeout in case this happens.

The read_poll_timeout() helper implements this logic, and is shorter, so
simply use that helper here.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: e7b7ab3847c9 ("platform/x86: intel_scu_ipc: Sleeping is fine when polling")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 6851d10d6582..5a37becc65aa 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
@@ -231,19 +232,15 @@ static inline u32 ipc_data_readl(struct intel_scu_ipc_dev *scu, u32 offset)
 /* Wait till scu status is busy */
 static inline int busy_loop(struct intel_scu_ipc_dev *scu)
 {
-	unsigned long end = jiffies + IPC_TIMEOUT;
-
-	do {
-		u32 status;
-
-		status = ipc_read_status(scu);
-		if (!(status & IPC_STATUS_BUSY))
-			return (status & IPC_STATUS_ERR) ? -EIO : 0;
+	u8 status;
+	int err;
 
-		usleep_range(50, 100);
-	} while (time_before(jiffies, end));
+	err = read_poll_timeout(ipc_read_status, status, !(status & IPC_STATUS_BUSY),
+				100, jiffies_to_usecs(IPC_TIMEOUT), false, scu);
+	if (err)
+		return err;
 
-	return -ETIMEDOUT;
+	return (status & IPC_STATUS_ERR) ? -EIO : 0;
 }
 
 /* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
-- 
https://chromeos.dev

