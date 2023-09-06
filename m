Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D06210953
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 18:09:47 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1c337aeefbdso963365ad.0
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 11:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694023786; x=1694628586; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hfge2hDwlOnuvbsvyOLoD+YvP18zPU7WvIEwehrqKHk=;
        b=gFINW8F+Yx9dS8GYWPFyjS2N8dhNDhltI0UGhDbNyiu4G3DwU1mWTglqvFDd8GiuGv
         6LY5NA8WrMVg+LDPgG5HLaVopHwnUBda3JTtYk7TtGE+uLvdWTWZtVR1IcSyr0XpxgAl
         7h30Z2DQ6uVfxIMjyTbJtQcOZzgp6gfZeoptg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694023786; x=1694628586;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hfge2hDwlOnuvbsvyOLoD+YvP18zPU7WvIEwehrqKHk=;
        b=CcKcGJn+xmVku/ISFVTLgoM94LaaESTO2FgzBhQwK7pIaYld+Xuzd2/nA1wOsZCeEd
         TYKwDCECRFzhGhokcFjZ7fRDeb55MbfwMxVa5iC71VDb9Jp91PepKiLzhwek8hVtftAW
         /J7NZvAk5rjoZmc4wfvaK0m81xX28hLiQM8xQF7Xvh/exoO3iwze/UonjJhr5ZfbFgrH
         LR588n/26dDgk+6fGWpN4v2vBnrk6EfqJfbjqNE1URqcL4DpoLdIkjwB29Ybjr7xDBvP
         EMQxipcvLgOOhuyqP1+vm35Da6U4CqNP3fdmvnWurfTvwOF22Ler4nD+YK3YOWO2x1ew
         nNqA==
X-Gm-Message-State: AOJu0YweYJjao7t31YD+jY6I4eUOxD9Zwi1Cg0X5gqpRBv0NPJbuoeKD
	Ng/90epIOMJfKE4Eo3pHeMTjjw==
X-Google-Smtp-Source: AGHT+IGEWt7kOo14wpNAeLzr6FMlgqv4mRIgD302poha4etKupnWdwTn/RcwVsCuVVT1a9ygw1DuZg==
X-Received: by 2002:a17:903:495:b0:1bb:8e13:deba with SMTP id jj21-20020a170903049500b001bb8e13debamr15183394plb.11.1694023786555;
        Wed, 06 Sep 2023 11:09:46 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:a404:ed4a:5a1e:3b4a])
        by smtp.gmail.com with ESMTPSA id ix5-20020a170902f80500b001bc675068e2sm11363996plb.111.2023.09.06.11.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 11:09:46 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH v2 0/3] platform/x86: intel_scu_ipc: Timeout fixes
Date: Wed,  6 Sep 2023 11:09:40 -0700
Message-ID: <20230906180944.2197111-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
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
don't know.

I added some sleeps to these paths to trigger the timeout behavior to
make sure the code works. Simply sleeping for a long time in busy_loop()
hits the timeout, which could happen if the system is scheduling lots of
other things at the time.

I couldn't really test the third patch because forcing a timeout or
returning immediately wasn't fast enough to trigger the second
transaction to run into the first one being processed.

Changes from v1 (https://lore.kernel.org/r/20230831011405.3246849-1-swboyd@chromium.org):
 * Don't use read_poll_timeout() helper in patch 1, just add code
 * Rewrite patch 2 to be simpler
 * Make intel_scu_ipc_busy() return -EBUSY when busy
 * Downgrade dev_err() to dev_dbg() in intel_scu_ipc_busy()

Stephen Boyd (3):
  platform/x86: intel_scu_ipc: Check status after timeout in busy_loop()
  platform/x86: intel_scu_ipc: Check status upon timeout in
    ipc_wait_for_interrupt()
  platform/x86: intel_scu_ipc: Fail IPC send if still busy

 drivers/platform/x86/intel_scu_ipc.c | 46 ++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 6 deletions(-)


base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c
-- 
https://chromeos.dev

