Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3429C154AE
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 19:39:40 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-273d10d3df3so2972579a91.3
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 12:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694461180; x=1695065980; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U3kmuOgV1MqL70eyPKBwPx+gEeRsYvUgeQvC+nXxSq0=;
        b=FMlg+XHo1Ua/SOe1Mf7JCqAg9msZEg0u+M3Zr4LHB9TbgpAcvbC7nSJSNhmEwb9R9w
         CKrAUihGFlA0ILbaTOwg9OL9mB+ny4PS+PL1Xjtlc+XYLGBPxlQQn4P+pL+/6oZjbCp0
         DFbDiUmj0nFoh3zTyv+SVLOnCVDsaN3p+J/G4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694461180; x=1695065980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U3kmuOgV1MqL70eyPKBwPx+gEeRsYvUgeQvC+nXxSq0=;
        b=QayBndT5qZPLhHSsYXplH5DzUMWz2ez3ANCXnvEuah5L/RIYA/hktAc3aJCgV7gD/t
         WSQ3KW/tbjk+NeWnkJa3O4HlKPUR1LQTSXHFz5iYsY2IjbTehngwXRaiyiWWy8lrRuO9
         4b64v5XAJ3owgYI07Kq5y7JNhtF7VLfRrvhqtnTu6kEuGf4qvTh7EjtkldXdhAPww8bZ
         wQkt7mFg0I5hixZnuZfjZcw1T1IVtrmM3gYOO5k1xCz1xdT7L0Qc4GllXjpt4J1dSPxP
         +cjYX2kQZoNwh4No8l6BF9QizIMlUrnMRF9HFFIX78ovDsl24ju3w3U4rb/Gt7EpLO8T
         lgdw==
X-Gm-Message-State: AOJu0Ywo4xIzyroNq4kKBFT2NguNJyHB0EGzlNW742SFEw5nJMoAU4qA
	+RUWmCAPDBhf/G1OYbll6BZkCg==
X-Google-Smtp-Source: AGHT+IE1KCz2PPBtztjQa6r5F5mW8DpeJaFNItpLjTVRsOtt8Oshgk1XrqynXDOck4L9xWpjZ39/nw==
X-Received: by 2002:a17:90a:7003:b0:273:fa72:ba83 with SMTP id f3-20020a17090a700300b00273fa72ba83mr4056419pjk.47.1694461180415;
        Mon, 11 Sep 2023 12:39:40 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d487:5e33:6656:3711])
        by smtp.gmail.com with ESMTPSA id fu8-20020a17090ad18800b00262e485156esm7736543pjb.57.2023.09.11.12.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 12:39:39 -0700 (PDT)
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
Subject: [PATCH v3 0/4] platform/x86: intel_scu_ipc: Timeout fixes
Date: Mon, 11 Sep 2023 12:39:32 -0700
Message-ID: <20230911193937.302552-1-swboyd@chromium.org>
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

Changes from v2 (https://lore.kernel.org/r/20230906180944.2197111-1-swboyd@chromium.org):
 * Use read_poll_timeout() helper in patch #1 (again)
 * New patch #3 to fix bug pointed out by Andy
 * Consolidate more code into busy check in patch #4

Changes from v1 (https://lore.kernel.org/r/20230831011405.3246849-1-swboyd@chromium.org):
 * Don't use read_poll_timeout() helper in patch 1, just add code
 * Rewrite patch 2 to be simpler
 * Make intel_scu_ipc_busy() return -EBUSY when busy
 * Downgrade dev_err() to dev_dbg() in intel_scu_ipc_busy()

Stephen Boyd (4):
  platform/x86: intel_scu_ipc: Check status after timeout in busy_loop()
  platform/x86: intel_scu_ipc: Check status upon timeout in
    ipc_wait_for_interrupt()
  platform/x86: intel_scu_ipc: Don't override scu in
    intel_scu_ipc_dev_simple_command()
  platform/x86: intel_scu_ipc: Fail IPC send if still busy

 drivers/platform/x86/intel_scu_ipc.c | 66 +++++++++++++++++-----------
 1 file changed, 40 insertions(+), 26 deletions(-)

Cc: Prashant Malani <pmalani@chromium.org>

base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c
-- 
https://chromeos.dev

