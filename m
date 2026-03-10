Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E60F38E100;
	Tue, 10 Mar 2026 11:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142021; cv=none; b=bMjqKR4u5L+jzkA2wI8y7SM30uxXZN1NpKaeM3s9SJ1tMEoBuWg42+3pc61+IJTHmjZ7pSnuHH6Sq+t7Nsy6s6hmdrQlGXkNo6hHEfeYr66+ZRBu0Vr4Kr3iVZTQtuPtMLOYwJogzI0Y7NerJ5iva5SODszR/wIkK6fmTf1JTxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142021; c=relaxed/simple;
	bh=2pPWkafpi+YBDiCbZW/4MEOkpfB+X4nUw2i7lZU/KqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mv7xx30oyqZf40mPeNXE7PEnPl8XErnlIpyr4ZDkfbW6YOJoS8FavJkkbWxIz0ImO9E+doD7BIgXD8r5F/sOwZ/Mw3KfZ4rHPW/u+9+Rdoh92riPcf0WAuTMSHPh7JCktgvtZUKrITj4C0hlodyN3JqbpiT4302mHSaUs+dLov0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=szJrWlMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szJrWlMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0271DC2BCB0;
	Tue, 10 Mar 2026 11:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142020;
	bh=2pPWkafpi+YBDiCbZW/4MEOkpfB+X4nUw2i7lZU/KqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szJrWlMCwzFhOCjwEYD/UrEWt6xjOXqrJMA6yBI2+YWSaH5yHiNVmxYVWdv1ENdew
	 Xf+k/8QHILgqVn/eHtlgYJWeKoTv2u6Ojr+o+ZhfNZN3fbuSBesF4yf+whSnWwj4Gb
	 UZlZsHmdL3slfmAoN7yA9fkZhC3T51aSlzPpdjFFs9t5Ap1UZ+Cu08A49nuNgKOmMI
	 fDKTViVMxiubZa2gR2v1MVdweoyw1QNFF4jvYPoNQIR0grhp8j2HiiHVVZIUwHUsKX
	 fsshAQODEW05Q0YUBb3a6Nh1jhSSaTjzLiMOkd6J4Ui+Cm6pY3+34ulEy8P6n7Dx8X
	 OFIydxP5Sn+mA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zide Chen <zide.chen@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 147/314] perf/x86/intel/uncore: Add per-scheduler IMC CAS count events
Date: Tue, 10 Mar 2026 07:16:46 -0400
Message-ID: <e5beb58d2e865c7cba61c22e131f5fd013bc6851.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zide Chen <zide.chen@intel.com>

commit 6a8a48644c4b804123e59dbfc5d6cd29a0194046 upstream.

IMC on SPR and EMR does not support sub-channels.  In contrast, CPUs
that use gnr_uncores[] (e.g. Granite Rapids and Sierra Forest)
implement two command schedulers (SCH0/SCH1) per memory channel,
providing logically independent command and data paths.

Do not reuse the spr_uncore_imc[] configuration for these CPUs.
Instead, introduce a dedicated gnr_uncore_imc[] with per-scheduler
events, so userspace can monitor SCH0 and SCH1 independently.

On these CPUs, replace cas_count_{read,write} with
cas_count_{read,write}_sch{0,1}.  This may break existing userspace
that relies on cas_count_{read,write}, prompting it to switch to the
per-scheduler events, as the legacy event reports only partial
traffic (SCH0).

Fixes: 632c4bf6d007 ("perf/x86/intel/uncore: Support Granite Rapids")
Fixes: cb4a6ccf3583 ("perf/x86/intel/uncore: Support Sierra Forest and Grand Ridge")
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260210005225.20311-1-zide.chen@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snbep.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index e1f370b8d065f..a338ee01bb242 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -6610,6 +6610,32 @@ static struct intel_uncore_type gnr_uncore_ubox = {
 	.attr_update		= uncore_alias_groups,
 };
 
+static struct uncore_event_desc gnr_uncore_imc_events[] = {
+	INTEL_UNCORE_EVENT_DESC(clockticks,      "event=0x01,umask=0x00"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read_sch0,  "event=0x05,umask=0xcf"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read_sch0.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read_sch0.unit, "MiB"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read_sch1,  "event=0x06,umask=0xcf"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read_sch1.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read_sch1.unit, "MiB"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write_sch0, "event=0x05,umask=0xf0"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write_sch0.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write_sch0.unit, "MiB"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write_sch1, "event=0x06,umask=0xf0"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write_sch1.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write_sch1.unit, "MiB"),
+	{ /* end: all zeroes */ },
+};
+
+static struct intel_uncore_type gnr_uncore_imc = {
+	SPR_UNCORE_MMIO_COMMON_FORMAT(),
+	.name			= "imc",
+	.fixed_ctr_bits		= 48,
+	.fixed_ctr		= SNR_IMC_MMIO_PMON_FIXED_CTR,
+	.fixed_ctl		= SNR_IMC_MMIO_PMON_FIXED_CTL,
+	.event_descs		= gnr_uncore_imc_events,
+};
+
 static struct intel_uncore_type gnr_uncore_pciex8 = {
 	SPR_UNCORE_PCI_COMMON_FORMAT(),
 	.name			= "pciex8",
@@ -6657,7 +6683,7 @@ static struct intel_uncore_type *gnr_uncores[UNCORE_GNR_NUM_UNCORE_TYPES] = {
 	NULL,
 	&spr_uncore_pcu,
 	&gnr_uncore_ubox,
-	&spr_uncore_imc,
+	&gnr_uncore_imc,
 	NULL,
 	&gnr_uncore_upi,
 	NULL,
-- 
2.51.0

