Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F82010E1
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 01:14:07 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1c1ff5b741cso2136425ad.2
        for <patches@lists.linux.dev>; Wed, 30 Aug 2023 18:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693444447; x=1694049247; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1sUp2yimFnL41Syp4fRWiGYEjv3jeQXhshgUbuWCXiU=;
        b=LVaPmdkY8WqwlBa8vwNWaslONOYY+nPpQI0K18oWaoZmoZWYbOuwPq1xvr1X/ru1Ra
         8v1iNkUgTZhQyc0b77flummWC9u1WomaxpfgdYPP6owmfZNYZLE/OLZhL1tHQ8Hccwin
         KBz8jhcLngSmIqs/PHKWVD0TBEStFDtHMKjxQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693444447; x=1694049247;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1sUp2yimFnL41Syp4fRWiGYEjv3jeQXhshgUbuWCXiU=;
        b=Z/+GYsXASXZbojdsAQFJz51NJ4srJICBQ+MdpAPPOAozs40ZOYJJpstwfMcq+XIWfq
         8sGcceHaZvblP1vjSl0t5DYh67nydoWsAvIsXCW2j6Cm1BV2TVBV3cP7GoPWgSLV4wt4
         885U663FDt2dQ+FExID6VyVSLQ7tGmNIVvcOE3/UlbGKQKJoBsaN7psNDEATiLK9aVHq
         aOhlewkLLOc9cgG/s0tLfWnvXIPo+j+pVpBNVZZ4X8Sl47sZ7Q416G7vE2E2WrsCJ/5N
         ZLAthAnahgb99BFfDpS+hbZM+ImZ/e5zw/ManLO0F5/h1KUrdA4Vtc9QtGdLBAryXhwi
         zi1A==
X-Gm-Message-State: AOJu0Yx79gSojdXisVIyhdfcqeR9CVIGk108e/TdZfh5G6rlJ8jjhjQT
	7+LffcvQgRq343w0oB3rt1K/1A==
X-Google-Smtp-Source: AGHT+IEsaxAUmzOWP3YLPRyIonJDP5ynhSyj/X3KF7NV/5+fcbROj48eTEq1IrBDZ7PjIKflMZop6Q==
X-Received: by 2002:a17:902:ea94:b0:1bc:2188:ef88 with SMTP id x20-20020a170902ea9400b001bc2188ef88mr3832312plb.3.1693444447266;
        Wed, 30 Aug 2023 18:14:07 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:248f:d364:b451:2bc0])
        by smtp.gmail.com with ESMTPSA id im23-20020a170902bb1700b001bbb7af4963sm132604plb.68.2023.08.30.18.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 18:14:06 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 0/3] platform/x86: intel_scu_ipc: Timeout fixes
Date: Wed, 30 Aug 2023 18:14:00 -0700
Message-ID: <20230831011405.3246849-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I recently looked at some crash reports on ChromeOS devices that call
into this intel_scu_ipc driver. They were hitting timeouts, and it
certainly looks possible for those timeouts to be triggering because of
scheduling issues. Once things started going south, the timeouts kept
coming. Maybe that's because the other side got seriously confused? I
don't know. I'll poke at it some more by injecting timeouts on the
kernel side.

The first two patches are only lightly tested (normal functions keep
working), while the third one is purely speculation. I was going to make
the interrupt delay for a long time to see if I could hit the timeout.

Stephen Boyd (3):
  platform/x86: intel_scu_ipc: Check status after timeouts in
    busy_loop()
  platform/x86: intel_scu_ipc: Check status upon timeout in
    ipc_wait_for_interrupt()
  platform/x86: intel_scu_ipc: Fail IPC send if still busy

 drivers/platform/x86/intel_scu_ipc.c | 59 ++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 17 deletions(-)


base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c
-- 
https://chromeos.dev

