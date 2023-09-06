Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B942010953
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 18:09:49 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1bf078d5f33so744605ad.3
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694023789; x=1694628589; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6I+Tnbz1nPfP3u0q6UcUVaPekp7QP+Ha1f/com8FTBk=;
        b=X8IFMcMEL3kSl1eBVfULEKuKP9WLJac85EvFBM8bwy1LTUtcSzGaxKwCi8WUg94pvY
         VOQOHcPOa6L5PONsG3Ga/R4ae9pKU9Vzu0m3sDQN5Qv8fKNiRR+4ZJ0KunyGVrdv/pXG
         4aSIkcmwgVk4V5/1XwLx+4RWUh8kFJnJxd4NE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694023789; x=1694628589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6I+Tnbz1nPfP3u0q6UcUVaPekp7QP+Ha1f/com8FTBk=;
        b=X69goxzDUrkcg+6LHk96SNVnTCPFMGWrpmuy5sSW1BOtiXWb83dGTVewksI4fKNcEh
         Wvz2hrgsxhKBhUdLmgshlmJWKX6OTtF1d6V4/e9uCTGzCWEaep0gtvFFDiygP6VtkDob
         H4Kmy+6FGFxczSTAtk8DeVWAI0wr3k1gJQTwhd6rUWz0lj9g5qaJGwiopHYOfzcZqtVY
         BSvT1RA5gE+FI9f0BX2HmMx45KXOCxpgN4RzZXdno3DpyGfNeVkjnFNVEeOlWu4EQP8y
         t6llwb326mHzsWgFxIMSEGfNbmlVsDVFjCx3DNADmWgmuL2nk7ggjoE3KKyl2fcbW8XB
         j54Q==
X-Gm-Message-State: AOJu0YwXWTydw5S/EydypCrqcdncc20Sj3MBfMTnXmQiSxoy7bvN9vAl
	h+znEnCjngPDE3+IoIiHe995lQ==
X-Google-Smtp-Source: AGHT+IF5QfGMo/sdxsUVNrZNDBPSiLKBWoNHf8pn6Nyc2pLXvbO3iCoWpR8ZwyEMaWKmKkYHkX0yew==
X-Received: by 2002:a17:902:d504:b0:1c0:ec66:f2b5 with SMTP id b4-20020a170902d50400b001c0ec66f2b5mr20873803plg.57.1694023789107;
        Wed, 06 Sep 2023 11:09:49 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:a404:ed4a:5a1e:3b4a])
        by smtp.gmail.com with ESMTPSA id ix5-20020a170902f80500b001bc675068e2sm11363996plb.111.2023.09.06.11.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 11:09:48 -0700 (PDT)
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
Subject: [PATCH v2 2/3] platform/x86: intel_scu_ipc: Check status upon timeout in ipc_wait_for_interrupt()
Date: Wed,  6 Sep 2023 11:09:42 -0700
Message-ID: <20230906180944.2197111-3-swboyd@chromium.org>
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
Fixes: ed12f295bfd5 ("ipc: Added support for IPC interrupt mode")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index b2a2de22b8ff..3cea701d2bbd 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -254,10 +254,12 @@ static inline int ipc_wait_for_interrupt(struct intel_scu_ipc_dev *scu)
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

