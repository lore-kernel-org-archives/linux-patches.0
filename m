Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89C6628
	for <patches@lists.linux.dev>; Thu,  2 Jun 2022 02:21:11 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id q123so3525837pgq.6
        for <patches@lists.linux.dev>; Wed, 01 Jun 2022 19:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GG12pRWYpCMhzTmvdu+AwDhBRPq3Mk8LSZ48yQuCcmg=;
        b=LbojSCdMywwboJsHvQBCV5gloK38NF3e45HPu/lbWImG7XctvRZbulCzhPCX0vDVfF
         7D5qg+qbh4OopNyx2h474m7+zYbil/P93rcOf4x5/U4K8/IQdtEV+U3vicJCJuY0hV8v
         SIzsmtEKrEtbUgmwdzaTytHMHhVSZHfj/n9uM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GG12pRWYpCMhzTmvdu+AwDhBRPq3Mk8LSZ48yQuCcmg=;
        b=548OFLQAJcCI/ernNS8Ddixt4t4cuh+x54SLgyVUIZMiB9UFPKFluVjiHBEWN3YI68
         BudDjwk95y+XU9obqGVooJZnitUxFz/Z9wlc+WVVMyZcX5Mvm1M0qeICVfbxEUOE2D8Z
         gIb9TdvTBbPeyzBBvVtkBHIkWA5a1g577xUTFOkL1F0Fg7oweY8n56WVTDEnfVPsqpQO
         Pap3vmEkWMPc/Zvv8vJIt0RHcHRLw1I3fOJrCZehhArMY0JV5HLRiERVvHLOaKqpBXzL
         YARts9Qe/AJ+J3+tOseKKHugz4SH0fdKNO1o0uKXGNRqPM6TvvDc7daMNrGrZr2qJHRC
         s+zQ==
X-Gm-Message-State: AOAM530CWikaO4AzXht++i26eiMub38nJUXRZ97UhuP8gIZFrPHGGSek
	sx9ipaIDs5zLmTOqy3VT063wMg==
X-Google-Smtp-Source: ABdhPJzQAc7yvw8IedDY62s8gx/hzC1m4lhhsL8fO37xa12t5NllgzfENMY9KSnYKyYm/DhztZJw6Q==
X-Received: by 2002:a05:6a00:10cc:b0:505:ada6:e03e with SMTP id d12-20020a056a0010cc00b00505ada6e03emr2569824pfu.45.1654136471309;
        Wed, 01 Jun 2022 19:21:11 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:6885:8b62:3875:9d55])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902cec900b0016378bfeb90sm2181299plg.227.2022.06.01.19.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 19:21:10 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH] arm64: Initialize jump labels before setup_machine_fdt()
Date: Wed,  1 Jun 2022 19:21:09 -0700
Message-Id: <20220602022109.780348-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A static key warning splat appears during early boot on arm64 systems
that credit randomness from devicetrees that contain an "rng-seed"
property. This is because setup_machine_fdt() is called before
jump_label_init() during setup_arch(). Let's swap the order of these two
calls so that jump labels are initialized before the devicetree is
unflattened and the rng seed is credited.

 static_key_enable_cpuslocked(): static key '0xffffffe51c6fcfc0' used before call to jump_label_init()
 WARNING: CPU: 0 PID: 0 at kernel/jump_label.c:166 static_key_enable_cpuslocked+0xb0/0xb8
 Modules linked in:
 CPU: 0 PID: 0 Comm: swapper Not tainted 5.18.0+ #224 44b43e377bfc84bc99bb5ab885ff694984ee09ff
 pstate: 600001c9 (nZCv dAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : static_key_enable_cpuslocked+0xb0/0xb8
 lr : static_key_enable_cpuslocked+0xb0/0xb8
 sp : ffffffe51c393cf0
 x29: ffffffe51c393cf0 x28: 000000008185054c x27: 00000000f1042f10
 x26: 0000000000000000 x25: 00000000f10302b2 x24: 0000002513200000
 x23: 0000002513200000 x22: ffffffe51c1c9000 x21: fffffffdfdc00000
 x20: ffffffe51c2f0831 x19: ffffffe51c6fcfc0 x18: 00000000ffff1020
 x17: 00000000e1e2ac90 x16: 00000000000000e0 x15: ffffffe51b710708
 x14: 0000000000000066 x13: 0000000000000018 x12: 0000000000000000
 x11: 0000000000000000 x10: 00000000ffffffff x9 : 0000000000000000
 x8 : 0000000000000000 x7 : 61632065726f6665 x6 : 6220646573752027
 x5 : ffffffe51c641d25 x4 : ffffffe51c13142c x3 : ffff0a00ffffff05
 x2 : 40000000ffffe003 x1 : 00000000000001c0 x0 : 0000000000000065
 Call trace:
  static_key_enable_cpuslocked+0xb0/0xb8
  static_key_enable+0x2c/0x40
  crng_set_ready+0x24/0x30
  execute_in_process_context+0x80/0x90
  _credit_init_bits+0x100/0x154
  add_bootloader_randomness+0x64/0x78
  early_init_dt_scan_chosen+0x140/0x184
  early_init_dt_scan_nodes+0x28/0x4c
  early_init_dt_scan+0x40/0x44
  setup_machine_fdt+0x7c/0x120
  setup_arch+0x74/0x1d8
  start_kernel+0x84/0x44c
  __primary_switched+0xc0/0xc8
 ---[ end trace 0000000000000000 ]---
 random: crng init done
 Machine model: Google Lazor (rev1 - 2) with LTE

Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Fixes: f5bda35fba61 ("random: use static branch for crng_ready()")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/kernel/setup.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index fea3223704b6..cf3a759f10d4 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -303,13 +303,14 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	early_fixmap_init();
 	early_ioremap_init();
 
-	setup_machine_fdt(__fdt_pointer);
-
 	/*
 	 * Initialise the static keys early as they may be enabled by the
-	 * cpufeature code and early parameters.
+	 * cpufeature code, early parameters, and DT setup.
 	 */
 	jump_label_init();
+
+	setup_machine_fdt(__fdt_pointer);
+
 	parse_early_param();
 
 	/*
-- 
https://chromeos.dev

