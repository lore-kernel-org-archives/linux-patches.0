Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB4A364
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 00:22:13 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id 17so21892018pll.0
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 16:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yDLd/c7sffLZEFLE9eRRXtPje9jgj2d5fJUXABkKQP0=;
        b=LpjSq/Kastw9Uyx7f/r+AXRPp75VX1xPSml8w1HOfumTaSgX7Xs9RsbvsIteXr691a
         PvgtLM027UA7L5VjfdjU8Pk4kFOUF/8BrFWFSiQwIS8PEVk/CY3TRIgds4VX8JWsbCIQ
         /duk64ketG1O8Sh7/btJxqHc1xiTUw73+XzcQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yDLd/c7sffLZEFLE9eRRXtPje9jgj2d5fJUXABkKQP0=;
        b=lzBLulHshNwgU2ln404yh7ROrPEOuF4He0Y7OPCthJ0R1eIzRKqS5S66PODa0jgPbe
         f0XZhXrUH0b+sLmEp2Rvw4KmBnCmfHurZyTYS9m1pkJVVkG0jQmtQdPUMMLoL5fJhi9S
         F1jLJsOrcFMg3IrQ4I3uas+BT+lQVXq9lFnQu0iW3T8tLLFh1h5cKw5zuf7oa6yAFeWA
         bb/dTKQLrIc8PNURS/zhVtJ4U9oNH39EzTrrE9RMA49tz8MxaswasIvhqJZTlYB3+M7U
         Ar58bFudCeAOzomOq1Wto120BtA4KBdMHpTVm0N5pgvygj0xseWjnxlEHtPg+tSXb1QY
         3yKg==
X-Gm-Message-State: AFqh2kpEZ/hw2KFo+9DDj1zCUs2iqcGtpcyInkv+zTZBbz2JfxTdRGcN
	MhTE8dempl9CmlArw6qj18MxWw==
X-Google-Smtp-Source: AMrXdXuOub6bFjrixZ9Yum9HR7iFKmh6XA9lU5NIhjWUIaxx11yMdgosFzluiiWICG9PJeRTO7i3nQ==
X-Received: by 2002:a05:6a20:6707:b0:af:9538:ec5c with SMTP id q7-20020a056a20670700b000af9538ec5cmr9033204pzh.51.1673569332751;
        Thu, 12 Jan 2023 16:22:12 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:11a:201:4652:3752:b9b7:29f9])
        by smtp.gmail.com with ESMTPSA id 75-20020a63074e000000b004b5fb50aa6dsm4748931pgh.83.2023.01.12.16.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 16:22:12 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: stable@vger.kernel.org
Cc: Denis Nikitin <denik@chromium.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.15.y] KVM: arm64: nvhe: Fix build with profile optimization
Date: Thu, 12 Jan 2023 16:22:10 -0800
Message-Id: <20230113002210.3984665-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Denis Nikitin <denik@chromium.org>

commit bde971a83bbff78561458ded236605a365411b87 upstream.

Kernel build with clang and KCFLAGS=-fprofile-sample-use=<profile> fails with:

error: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o: Unexpected SHT_REL
section ".rel.llvm.call-graph-profile"

Starting from 13.0.0 llvm can generate SHT_REL section, see
https://reviews.llvm.org/rGca3bdb57fa1ac98b711a735de048c12b5fdd8086.
gen-hyprel does not support SHT_REL relocation section.

Filter out profile use flags to fix the build with profile optimization.

Signed-off-by: Denis Nikitin <denik@chromium.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221014184532.3153551-1-denik@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

I need this to properly compile 5.15.y stable kernels in the chromeos build
system.

 arch/arm64/kvm/hyp/nvhe/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 8d741f71377f..964c2134ea1e 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -83,6 +83,10 @@ quiet_cmd_hypcopy = HYPCOPY $@
 # Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
 # This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
+# Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profile'
+# when profile optimization is applied. gen-hyprel does not support SHT_REL and
+# causes a build failure. Remove profile optimization flags.
+KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=% -fprofile-use=%, $(KBUILD_CFLAGS))
 
 # KVM nVHE code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
https://chromeos.dev

