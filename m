Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD3A200DF
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 21:27:28 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-68fc081cd46so252977b3a.0
        for <patches@lists.linux.dev>; Wed, 13 Sep 2023 14:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694640448; x=1695245248; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/kiTus1GQ2wpWYv2hiScbkUesx/S4YRwA/TTSZ+SSL4=;
        b=FlcSwsKajzCMr0VQJX8/9SKcpNV4SlT9eOotbzTNiKO90/9QEgHOwmxezRTA/SceSc
         gZHYKDKfBz3zu0qLMrYADY/mnTsfXgL7ncWRY1umYc/pCKmsX0SPYZ9EdgIASN59joty
         r+Hn7HRr+HZYVhprLhi7KeQfzOoaKItvuQZwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694640448; x=1695245248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/kiTus1GQ2wpWYv2hiScbkUesx/S4YRwA/TTSZ+SSL4=;
        b=stzO3oXpsIV/euoG0NqZRjpgUliaTg5F16P7y0H3vfJAYDryBlm6bqojHmSj8u4PBo
         05OZi8vQojjqKGtyWDqWM9WiBqhTnJQ568soxzrKSJO7uvheN+OEcmcDFenz1GxWGTHJ
         coYOMG0ilqXTdAr/RNfiDhgi3I6tABdH05YIKRzbMLLPZLo/ANffFP5qnnCx3DCkjpCN
         IPP9D2ohtctBX31p3a7MJmPfuWmttDB4PLHGzatCA2+HER9kchUrh1stOvSxG1rQiWTm
         K+GJvNbuIcBsNs+tn5yyk5VBq4uGARA1IlEScNwdmzz/Qop8hUIwl17phnRiIvpk3rDJ
         K0UQ==
X-Gm-Message-State: AOJu0Ywr35/PrUkKkmfa0yRDK3Y8vwGE6mcyP+7vjEdfVCuEF+QivjC0
	tsFSPdeLMAIZS31XKJEWeutpNA==
X-Google-Smtp-Source: AGHT+IHkCpRGY5eNNzziS4Z0x0tJxKnxzcDaYv5kyCx0kSSKkvJ4n+5d/Sy4MX6b0nbFhT8NwHTsbg==
X-Received: by 2002:a05:6a20:561a:b0:147:d861:50e4 with SMTP id ir26-20020a056a20561a00b00147d86150e4mr3072141pzc.33.1694640448396;
        Wed, 13 Sep 2023 14:27:28 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:ae97:c6dc:1d98:494f])
        by smtp.gmail.com with ESMTPSA id a10-20020a17090ad80a00b0025bdc3454c6sm1923976pjv.8.2023.09.13.14.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 14:27:27 -0700 (PDT)
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
Subject: [PATCH v4 2/4] platform/x86: intel_scu_ipc: Check status upon timeout in ipc_wait_for_interrupt()
Date: Wed, 13 Sep 2023 14:27:20 -0700
Message-ID: <20230913212723.3055315-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230913212723.3055315-1-swboyd@chromium.org>
References: <20230913212723.3055315-1-swboyd@chromium.org>
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
  [TIMEOUT]                                             status[IPC_STATUS_BUSY]=0

Fix this problem by reading the status bit in all cases, regardless of
the timeout. If the completion times out, we'll assume the problem was
that the IPC_STATUS_BUSY bit was still set, but if the status bit is
cleared in the meantime we know that we hit some scheduling delay and we
should just check the error bit.

Cc: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Fixes: ed12f295bfd5 ("ipc: Added support for IPC interrupt mode")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 4c774ee8bb1b..299c15312acb 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -248,10 +248,12 @@ static inline int ipc_wait_for_interrupt(struct intel_scu_ipc_dev *scu)
 {
 	int status;
 
-	if (!wait_for_completion_timeout(&scu->cmd_complete, IPC_TIMEOUT))
-		return -ETIMEDOUT;
+	wait_for_completion_timeout(&scu->cmd_complete, IPC_TIMEOUT);
 
 	status = ipc_read_status(scu);
+	if (status & IPC_STATUS_BUSY)
+		return -ETIMEDOUT;
+
 	if (status & IPC_STATUS_ERR)
 		return -EIO;
 
-- 
https://chromeos.dev

