Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACA21097D
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 18:09:48 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1c1f8aaab9aso777075ad.1
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 11:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694023788; x=1694628588; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQ60R3rHW7RtCo/8VNaTl4hpFxxt5nZxG1tJ6/+yqfY=;
        b=kOrkbjlGbxL3Que/RC3W/UqcTjl4nZIqkC9hGWwIPi4SXu9XoxUDh5VISK6JOlLBju
         vW4qvhYifJQxay/3GK7LOzltEyCD46ev7/GeXHfQoPs1+RVQO92OLvVY7+LzbMObwoG2
         ryHZv97pXQeTlOTeUikGO/ofV/Z0XvIG9zKKY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694023788; x=1694628588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nQ60R3rHW7RtCo/8VNaTl4hpFxxt5nZxG1tJ6/+yqfY=;
        b=VVfZ4qGa+TU00Mk45QGMrxjnRR4IKsGdmQQhgOhQWysezfzvxzyFo6AUsSdxtf6pBM
         yF368Kgrqw3KHB4avVfMANnZ3q9GzqIvU1jfRM3TJIigmv3ZyiZQ1JnrjThtzL4zgBAk
         2RhSzNkqj0sbhxMGjnFrbi6mlKAnoxARughNXNgz9Ddaqm7OSjMlg5C4VLzd+7g63jK7
         T2eUudPNrbRPGpVnB5ElHcBswIoFruwGQp7yHl9vSBFuhb6t1M8bqO3Jgez64r/ys01m
         6Onyi/1G11R6aHKP9tOptIGwReD1AbQ2alquOURDEsw4EwvvF2mCuZMN1RXnJQZvZ1zS
         hdXw==
X-Gm-Message-State: AOJu0YxgKhnlRokeBj9FVCZdjBNjsoFM4pdnLSGE/g/nNKzOTGj5e67a
	WCbSQDoG9Aw/yXrF6AkqCzZ+Hw==
X-Google-Smtp-Source: AGHT+IFTy5AW0hEg/3ypp2wUfruRPqHHSv6/9h119PwBpNp6mPHXIi/XqQfMzExiQ7wVnyux07tFkA==
X-Received: by 2002:a17:903:24c:b0:1bc:2d43:c747 with SMTP id j12-20020a170903024c00b001bc2d43c747mr20299220plh.38.1694023787823;
        Wed, 06 Sep 2023 11:09:47 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:a404:ed4a:5a1e:3b4a])
        by smtp.gmail.com with ESMTPSA id ix5-20020a170902f80500b001bc675068e2sm11363996plb.111.2023.09.06.11.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 11:09:47 -0700 (PDT)
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
Subject: [PATCH v2 1/3] platform/x86: intel_scu_ipc: Check status after timeout in busy_loop()
Date: Wed,  6 Sep 2023 11:09:41 -0700
Message-ID: <20230906180944.2197111-2-swboyd@chromium.org>
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

It's possible for the polling loop in busy_loop() to get scheduled away
for a long time.

  status = ipc_read_status(scu); // status = IPC_STATUS_BUSY
  <long time scheduled away>
  if (!(status & IPC_STATUS_BUSY))

If this happens, then the status bit could change while the task is
scheduled away and this function would never read the status again after
timing out. Instead, the function will return -ETIMEDOUT when it's
possible that scheduling didn't work out and the status bit was cleared.
Bit polling code should always check the bit being polled one more time
after the timeout in case this happens.

Fix this by reading the status once more after the while loop breaks.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Fixes: e7b7ab3847c9 ("platform/x86: intel_scu_ipc: Sleeping is fine when polling")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

This is sufficiently busy so I didn't add any tags from previous round.

 drivers/platform/x86/intel_scu_ipc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 6851d10d6582..b2a2de22b8ff 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -232,18 +232,21 @@ static inline u32 ipc_data_readl(struct intel_scu_ipc_dev *scu, u32 offset)
 static inline int busy_loop(struct intel_scu_ipc_dev *scu)
 {
 	unsigned long end = jiffies + IPC_TIMEOUT;
+	u32 status;
 
 	do {
-		u32 status;
-
 		status = ipc_read_status(scu);
 		if (!(status & IPC_STATUS_BUSY))
-			return (status & IPC_STATUS_ERR) ? -EIO : 0;
+			goto not_busy;
 
 		usleep_range(50, 100);
 	} while (time_before(jiffies, end));
 
-	return -ETIMEDOUT;
+	status = ipc_read_status(scu);
+	if (status & IPC_STATUS_BUSY)
+		return -ETIMEDOUT;
+not_busy:
+	return (status & IPC_STATUS_ERR) ? -EIO : 0;
 }
 
 /* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
-- 
https://chromeos.dev

