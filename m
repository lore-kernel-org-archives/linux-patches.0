Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B34D200DF
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 21:27:26 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-68fbd31d9ddso207882b3a.0
        for <patches@lists.linux.dev>; Wed, 13 Sep 2023 14:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694640446; x=1695245246; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NJ8fqic/uomWgpsKqJ7x61RUWZmvyUYZyTh0hpMJdiM=;
        b=iL3jSxwp2gV+FNdzNCroL1yiVy0ZgiLE7FrABjRBR/wJHuu4/cCszdSxj9DBNv8ieJ
         v6dzO+UqsfKFzXl2uLA5BhvP+wgveQCJUR4Sj85Cm7K1f1S8tu6dHAVxcg52klaggewO
         kH/4gzz/u9UO2J3w9P4mB8v2JQkFlabMhoiWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694640446; x=1695245246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NJ8fqic/uomWgpsKqJ7x61RUWZmvyUYZyTh0hpMJdiM=;
        b=I4txtnxujj3Ozd629V9M55ejBosKJ5A4jlAZVRNVfsyrnlg63BSSLhWd20FBhxxLBR
         7XGhONB3bJxsv3UKBJCoNcBEncIJkiHe0kjXZVPDfow4/4k9uzPA2hF3hn14XoQV6gLZ
         U1lzEdn+sh4V3aOshbtUonc5kvLpfma+TFyt/uTy+9TOIebOTBxey+JaqreYUg6Kpe9+
         vTOm/+2R9/lLoqyyD+K3oj5TNw2YYUspbdSrZzw82gzQSPdCjaeDyvqLQ+xfaOo4/H/D
         yjcqSRC4o5yb119scY2UHSfPCnq94LQrKx8nBwsmP3W2o0jvGrz1iUBqpmUk+GDE+5Or
         pDqQ==
X-Gm-Message-State: AOJu0Yz4UvgJKhmSr9K/IT8KVs47FTsYJssPdxwkz91FnqbNWErgdSZT
	8kff6DeVajH01AK9mz2nfySFlA==
X-Google-Smtp-Source: AGHT+IGyI6LR0X+sTt85Dc5hyaU3kiSenLO/6Xn71Ljenu4d72Yi/579Xsvyp40g93KRVbpEbnHMVA==
X-Received: by 2002:a05:6a20:1445:b0:144:5d5b:8e24 with SMTP id a5-20020a056a20144500b001445d5b8e24mr4250764pzi.24.1694640445852;
        Wed, 13 Sep 2023 14:27:25 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:ae97:c6dc:1d98:494f])
        by smtp.gmail.com with ESMTPSA id a10-20020a17090ad80a00b0025bdc3454c6sm1923976pjv.8.2023.09.13.14.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 14:27:25 -0700 (PDT)
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
Subject: [PATCH v4 0/4] platform/x86: intel_scu_ipc: Timeout fixes
Date: Wed, 13 Sep 2023 14:27:18 -0700
Message-ID: <20230913212723.3055315-1-swboyd@chromium.org>
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

I couldn't really test the last patch because forcing a timeout or
returning immediately wasn't fast enough to trigger the second
transaction to run into the first one being processed.

Changes from v3 (https://lore.kernel.org/r/20230911193937.302552-1-swboyd@chromium.org):
 * Use readx_poll_timeout() to shorten a line

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

