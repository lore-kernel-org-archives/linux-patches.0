Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41673154AE
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 19:39:43 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5774750a6efso1463196a12.1
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 12:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694461183; x=1695065983; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kZYrHnobXTh0OSmcxOutmTVdFw75ZwDUd6CgfQDQ3MU=;
        b=C6gQ/Qp27P5poCXmdmil2CV0hXWSvp1kP+wuAgnqXyGE/J5ybJtBBNO8KE0cU3P/+J
         XNzs8lL726NCBFU8RItqV9PUMtC3TGMIEhASdeMR+YrTRzag/OZpc7ryCDxtOxn4k0Z+
         kHan749Qjbszy1fK9uOLYKXB6XRDQetYMnpLk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694461183; x=1695065983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kZYrHnobXTh0OSmcxOutmTVdFw75ZwDUd6CgfQDQ3MU=;
        b=sEvWiV3fOPwQNyNF4qhQ65FaKVU6zPnCdI2fQM0ZWQ3e6S1/j+sKAjPCP78ZTrEiWb
         LCKYxwOEjILPmkQ0OWjUszodCpl62IxYJz6GSpSzVALMfTmF7iIphYJkxujIZUkRhyUi
         uLIstZ8Ff2o61q2cZx0Q1HUXvoULPSxwGx4caycYLjTEb7y1AheEO2zD85pqVC7vTIt8
         id9KacubkFyL3e2LJ9MdAaXYMuo4DSJoxyOykS5HnBxMpRX7tlJ+SeWTHk2PUTXvyNbN
         hBcuntzl8We4ku06fCuSFF71bfpGUxQFNj9016GKZ8x63r3JCJlgYqFPwFaNTLfG+c3U
         CukA==
X-Gm-Message-State: AOJu0Yz+QXEUHXwXqaJ2mkWjjtJ8JjHeJZl1IaCBiFuZVQP4Yobfmelt
	n9DJEgC04pydbYfgonzLG700WA==
X-Google-Smtp-Source: AGHT+IGOfdGvbw1wwt4Gf9ldbs/gHOpAtrlGyNreNjdfdz8lCBCPYU+3AOX6Bw9QrL5rSH9U2KMdvA==
X-Received: by 2002:a17:90a:3481:b0:268:557e:1848 with SMTP id p1-20020a17090a348100b00268557e1848mr8154453pjb.2.1694461183460;
        Mon, 11 Sep 2023 12:39:43 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d487:5e33:6656:3711])
        by smtp.gmail.com with ESMTPSA id fu8-20020a17090ad18800b00262e485156esm7736543pjb.57.2023.09.11.12.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 12:39:42 -0700 (PDT)
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
Subject: [PATCH v3 2/4] platform/x86: intel_scu_ipc: Check status upon timeout in ipc_wait_for_interrupt()
Date: Mon, 11 Sep 2023 12:39:34 -0700
Message-ID: <20230911193937.302552-3-swboyd@chromium.org>
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
Fixes: ed12f295bfd5 ("ipc: Added support for IPC interrupt mode")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 5a37becc65aa..8be1686e22e9 100644
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

