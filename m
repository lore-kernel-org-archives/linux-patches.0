Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E612712CDBE;
	Wed,  7 Aug 2024 15:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043141; cv=none; b=rlRSt9RUTOw+HDj/JtE9762o1i3BKgJKXy5KzF0Eqjdbwt6hprJYWjUq2l3gSYCL2Lrk+v9Hd2Z7XArAfHIxzNuRLT10D+c6DFNHwpAHhZBunkWulrji/jMXhbg7O2nNymtQAdMJYPZm4bbXe3SwpLiCw5Gdhy74q2DOFlDtPvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043141; c=relaxed/simple;
	bh=7PmBBi/Vr4n0ucY9QtrsjRWAcCnRixPT2CdvfUoUxQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrPzmhvPFM4NyHwqDz85TA7rA0RhDCV0FWMPbFJg5E86Q9+Xi6DwrEp5rz56Ne/DRJdldudkzet2jjdnKTFmSd5rEELNbYsljfP0ncwVkvkEJ3+nKvYkx/sKpgKbtaioNyr7kXP/ZLfaYX1YN004+Ne4PU+u7oTTnTdpuhxSQg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkGiXW4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkGiXW4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E40C32781;
	Wed,  7 Aug 2024 15:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043140;
	bh=7PmBBi/Vr4n0ucY9QtrsjRWAcCnRixPT2CdvfUoUxQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkGiXW4VCDagqYkFvPt0OXNk59x8JIKPr2xOA+Nrf9zb8Pu3+NPS2Ctp1v342S6jw
	 pcEBJDTy3P/te9XSYoXwGq3w0F5y3qf48hEjdSjdzmG76ydn+8Ntu4Rh2cPechqKSY
	 eT4E7Ml7ah2ENxOBNtSfEtLw1rELXJxCoLATJyvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Lin <eric.lin@sifive.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Nikita Shubin <n.shubin@yadro.com>,
	Inochi Amaoto <inochiama@outlook.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 069/123] perf arch events: Fix duplicate RISC-V SBI firmware event name
Date: Wed,  7 Aug 2024 16:59:48 +0200
Message-ID: <20240807150023.035274793@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Lin <eric.lin@sifive.com>

[ Upstream commit 63ba5b0fb4f54db256ec43b3062b2606b383055d ]

Currently, the RISC-V firmware JSON file has duplicate event name
"FW_SFENCE_VMA_RECEIVED". According to the RISC-V SBI PMU extension[1],
the event name should be "FW_SFENCE_VMA_ASID_SENT".

Before this patch:
$ perf list

firmware:
  fw_access_load
       [Load access trap event. Unit: cpu]
  fw_access_store
       [Store access trap event. Unit: cpu]
....
 fw_set_timer
       [Set timer event. Unit: cpu]
  fw_sfence_vma_asid_received
       [Received SFENCE.VMA with ASID request from other HART event. Unit: cpu]
  fw_sfence_vma_received
       [Sent SFENCE.VMA with ASID request to other HART event. Unit: cpu]

After this patch:
$ perf list

firmware:
  fw_access_load
       [Load access trap event. Unit: cpu]
  fw_access_store
       [Store access trap event. Unit: cpu]
.....
  fw_set_timer
       [Set timer event. Unit: cpu]
  fw_sfence_vma_asid_received
       [Received SFENCE.VMA with ASID request from other HART event. Unit: cpu]
  fw_sfence_vma_asid_sent
       [Sent SFENCE.VMA with ASID request to other HART event. Unit: cpu]
  fw_sfence_vma_received
       [Received SFENCE.VMA request from other HART event. Unit: cpu]

Link: https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-pmu.adoc#event-firmware-events-type-15 [1]
Fixes: 8f0dcb4e7364 ("perf arch events: riscv sbi firmware std event files")
Fixes: c4f769d4093d ("perf vendor events riscv: add Sifive U74 JSON file")
Fixes: acbf6de674ef ("perf vendor events riscv: Add StarFive Dubhe-80 JSON file")
Fixes: 7340c6df49df ("perf vendor events riscv: add T-HEAD C9xx JSON file")
Fixes: f5102e31c209 ("riscv: andes: Support specifying symbolic firmware and hardware raw event")
Signed-off-by: Eric Lin <eric.lin@sifive.com>
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Nikita Shubin <n.shubin@yadro.com>
Reviewed-by: Inochi Amaoto <inochiama@outlook.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Link: https://lore.kernel.org/r/20240719115018.27356-1-eric.lin@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/arch/riscv/andes/ax45/firmware.json       | 2 +-
 tools/perf/pmu-events/arch/riscv/riscv-sbi-firmware.json        | 2 +-
 tools/perf/pmu-events/arch/riscv/sifive/u74/firmware.json       | 2 +-
 .../perf/pmu-events/arch/riscv/starfive/dubhe-80/firmware.json  | 2 +-
 .../perf/pmu-events/arch/riscv/thead/c900-legacy/firmware.json  | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/pmu-events/arch/riscv/andes/ax45/firmware.json b/tools/perf/pmu-events/arch/riscv/andes/ax45/firmware.json
index 9b4a032186a7b..7149caec4f80e 100644
--- a/tools/perf/pmu-events/arch/riscv/andes/ax45/firmware.json
+++ b/tools/perf/pmu-events/arch/riscv/andes/ax45/firmware.json
@@ -36,7 +36,7 @@
     "ArchStdEvent": "FW_SFENCE_VMA_RECEIVED"
   },
   {
-    "ArchStdEvent": "FW_SFENCE_VMA_RECEIVED"
+    "ArchStdEvent": "FW_SFENCE_VMA_ASID_SENT"
   },
   {
     "ArchStdEvent": "FW_SFENCE_VMA_ASID_RECEIVED"
diff --git a/tools/perf/pmu-events/arch/riscv/riscv-sbi-firmware.json b/tools/perf/pmu-events/arch/riscv/riscv-sbi-firmware.json
index a9939823b14b5..0c9b9a2d2958a 100644
--- a/tools/perf/pmu-events/arch/riscv/riscv-sbi-firmware.json
+++ b/tools/perf/pmu-events/arch/riscv/riscv-sbi-firmware.json
@@ -74,7 +74,7 @@
   {
     "PublicDescription": "Sent SFENCE.VMA with ASID request to other HART event",
     "ConfigCode": "0x800000000000000c",
-    "EventName": "FW_SFENCE_VMA_RECEIVED",
+    "EventName": "FW_SFENCE_VMA_ASID_SENT",
     "BriefDescription": "Sent SFENCE.VMA with ASID request to other HART event"
   },
   {
diff --git a/tools/perf/pmu-events/arch/riscv/sifive/u74/firmware.json b/tools/perf/pmu-events/arch/riscv/sifive/u74/firmware.json
index 9b4a032186a7b..7149caec4f80e 100644
--- a/tools/perf/pmu-events/arch/riscv/sifive/u74/firmware.json
+++ b/tools/perf/pmu-events/arch/riscv/sifive/u74/firmware.json
@@ -36,7 +36,7 @@
     "ArchStdEvent": "FW_SFENCE_VMA_RECEIVED"
   },
   {
-    "ArchStdEvent": "FW_SFENCE_VMA_RECEIVED"
+    "ArchStdEvent": "FW_SFENCE_VMA_ASID_SENT"
   },
   {
     "ArchStdEvent": "FW_SFENCE_VMA_ASID_RECEIVED"
diff --git a/tools/perf/pmu-events/arch/riscv/starfive/dubhe-80/firmware.json b/tools/perf/pmu-events/arch/riscv/starfive/dubhe-80/firmware.json
index 9b4a032186a7b..7149caec4f80e 100644
--- a/tools/perf/pmu-events/arch/riscv/starfive/dubhe-80/firmware.json
+++ b/tools/perf/pmu-events/arch/riscv/starfive/dubhe-80/firmware.json
@@ -36,7 +36,7 @@
     "ArchStdEvent": "FW_SFENCE_VMA_RECEIVED"
   },
   {
-    "ArchStdEvent": "FW_SFENCE_VMA_RECEIVED"
+    "ArchStdEvent": "FW_SFENCE_VMA_ASID_SENT"
   },
   {
     "ArchStdEvent": "FW_SFENCE_VMA_ASID_RECEIVED"
diff --git a/tools/perf/pmu-events/arch/riscv/thead/c900-legacy/firmware.json b/tools/perf/pmu-events/arch/riscv/thead/c900-legacy/firmware.json
index 9b4a032186a7b..7149caec4f80e 100644
--- a/tools/perf/pmu-events/arch/riscv/thead/c900-legacy/firmware.json
+++ b/tools/perf/pmu-events/arch/riscv/thead/c900-legacy/firmware.json
@@ -36,7 +36,7 @@
     "ArchStdEvent": "FW_SFENCE_VMA_RECEIVED"
   },
   {
-    "ArchStdEvent": "FW_SFENCE_VMA_RECEIVED"
+    "ArchStdEvent": "FW_SFENCE_VMA_ASID_SENT"
   },
   {
     "ArchStdEvent": "FW_SFENCE_VMA_ASID_RECEIVED"
-- 
2.43.0



