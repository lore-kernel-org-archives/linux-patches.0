Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A793A15AC2
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 19:39:42 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-564af0ac494so3442244a12.0
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 12:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694461182; x=1695065982; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gdCNmE4TQzaUVGYBpjExxVlAWo5NcVTWN45t1mLK2Kw=;
        b=Cfsjidkmz2XBbC0jVqaxpYn1OyN+rjkWCtTSqTmNQ1gnEb3u4NwuqDLfHKPjPQMAPA
         BtVerUqtIPIfjY3L4mx5has1NMAeJeYHy0CuPGTJoYIjEw3AJqnjgn0lv1kP1Y1LtTvV
         lD5PWf7KugDa21Nx7VwfULjpaSBQ0T6XKb38U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694461182; x=1695065982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gdCNmE4TQzaUVGYBpjExxVlAWo5NcVTWN45t1mLK2Kw=;
        b=PbOVY90GmCfumi0d2MXR/dsutufmNdiVgdFJ/ktqHtXvjP6nAT3n+Yp/8rnkB2IoI6
         DDW8tTTgdLB8eEvS0C3cObvTj692Yc3TgTk8lKTI+SPxYEHUFEj8lQnECGvOlEnU+ldl
         xrXIbpEjDllrNmRydVBiNbOBtZ5kNLO/mJvTUajYILj3d4J3g+Ihqlo0E7Wl1CobqBuN
         fzeVfYAJ6hgU52QOqTxCOeoP9o5nMjsT/CJbNxiVCXzwbiiJAb7kktkMz35ugZEosSvN
         /Nv9Hy5QbqVSM54voXl/UD33dV+H2CYxel5WnnS+j1TucCjytaRt4qBxKXEuLFwV7921
         8YOA==
X-Gm-Message-State: AOJu0YzsvtbCJAYfxA8XjY98wNg/sqXuCOpiD0E7Yc+964QoAW7bTxBO
	ujIO4hOQdmSBnIkVZ9U7KT5EpA==
X-Google-Smtp-Source: AGHT+IGGvlqWnCd6FgKie+c4RBzySbl2Wtfy49TuNcsKhZkbb20DCZlYeRe7ju+YlMJNU0euA/ADjA==
X-Received: by 2002:a17:90a:c246:b0:263:ebab:a152 with SMTP id d6-20020a17090ac24600b00263ebaba152mr8240717pjx.19.1694461181946;
        Mon, 11 Sep 2023 12:39:41 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d487:5e33:6656:3711])
        by smtp.gmail.com with ESMTPSA id fu8-20020a17090ad18800b00262e485156esm7736543pjb.57.2023.09.11.12.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 12:39:41 -0700 (PDT)
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
Subject: [PATCH v3 1/4] platform/x86: intel_scu_ipc: Check status after timeout in busy_loop()
Date: Mon, 11 Sep 2023 12:39:33 -0700
Message-ID: <20230911193937.302552-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230911193937.302552-1-swboyd@chromium.org>
References: <20230911193937.302552-1-swboyd@chromium.org>
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
The read_poll_timeout() macro implements all of this, and it is
shorter, so use that macro here to consolidate code and fix this.

There were some concerns with using read_poll_timeout() because it uses
timekeeping, and timekeeping isn't running early on or during the late
stages of system suspend or early stages of system resume, but an audit
of the code concluded that this code isn't called during those times so
it is safe to use the macro.

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
+	u8 status;
+	int err;
 
-	do {
-		u32 status;
+	err = read_poll_timeout(ipc_read_status, status, !(status & IPC_STATUS_BUSY),
+				100, jiffies_to_usecs(IPC_TIMEOUT), false, scu);
+	if (err)
+		return err;
 
-		status = ipc_read_status(scu);
-		if (!(status & IPC_STATUS_BUSY))
-			return (status & IPC_STATUS_ERR) ? -EIO : 0;
-
-		usleep_range(50, 100);
-	} while (time_before(jiffies, end));
-
-	return -ETIMEDOUT;
+	return (status & IPC_STATUS_ERR) ? -EIO : 0;
 }
 
 /* Wait till ipc ioc interrupt is received or timeout in 10 HZ */
-- 
https://chromeos.dev

