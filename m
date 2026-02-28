Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E5E347FCC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302466; cv=none; b=FKGXJsBNcJUl4ks0POAD9vZzH8o6Qm96RKULnZWT/pXyLJ5IyaWt3DtPeaYHjGQuJ382u4uKwJ1LLqEv0ODq3/lHtlL2TL0KVuJZ/M7lzSw4X4bbcJy7dSaLe5qhK4HOGr/CbEIPiq58PoN/QXA/CUOxBhZHljpyAMQ5siwDm4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302466; c=relaxed/simple;
	bh=p4tHaeILD0sPId4YCyPzLlDr66vfEo8TkOhqJ8Vh7Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npwKNUZtnZ3XmxGgZw5+IgdJItA3miOWfRlF9h2vuo4Uhouw26k4Dt4sTyu64Syb1woI4PxKMdEryitAZdo+yqzfrVd0qAJjdHOgWXH0rxwtkUqAGuzfJOniQ/OACKKh08sFOIFFtKftHXFeghdZyuCW40F7m5ybV21pu5rJWL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=usCUfIa2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="usCUfIa2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9543C19423;
	Sat, 28 Feb 2026 18:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302466;
	bh=p4tHaeILD0sPId4YCyPzLlDr66vfEo8TkOhqJ8Vh7Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usCUfIa29+0opKkajaHbhu/eMatH/TCWSp6eEtRXFWy3Krn7POnlIMgnIJTA9l5Q+
	 fFDYseLOv6zYOG0edtMfsFjebi8WI/Rzbl81VHjokM1Lot75u+JHn22UTvAvQO331e
	 jiemCbkkj0dOTlmtwV3Dlf1Ya8UovilCbVczFzNgrToXCrMY36gV6gT2lf56V129oM
	 zNr8Ejrnjc3XTohmpTFlaSOP49SETQvJpccas1O8z7LLgu+1PN/PDLXI8RxJMERdA+
	 5b2lKniDJa5lHUN0SS9Tm/265Tl/i7AaDM966P9spLd7pukNmLUSBcJCyPGFsnKMlv
	 aMXOY6ygbW4fg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sean V Kelley <skelley@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 210/232] ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs
Date: Sat, 28 Feb 2026 13:11:03 -0500
Message-ID: <20260228181127.1592657-210-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sean V Kelley <skelley@nvidia.com>

[ Upstream commit 56eb0c0ed345da7815274aa821a8546a073d7e97 ]

per_cpu(cpc_desc_ptr, cpu) object is initialized for only the online
CPUs via acpi_soft_cpu_online() --> __acpi_processor_start() -->
acpi_cppc_processor_probe().

However, send_pcc_cmd() and acpi_get_psd_map() still iterate over all
possible CPUs. In acpi_get_psd_map(), encountering an offline CPU
returns -EFAULT, causing cppc_cpufreq initialization to fail.

This breaks systems booted with "nosmt" or "nosmt=force".

Fix by using for_each_online_cpu() in both functions.

Fixes: 80b8286aeec0 ("ACPI / CPPC: support for batching CPPC requests")
Signed-off-by: Sean V Kelley <skelley@nvidia.com>
Link: https://patch.msgid.link/20260211212254.30190-1-skelley@nvidia.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index c763c25424663..4382340fd9778 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -342,7 +342,7 @@ static int send_pcc_cmd(int pcc_ss_id, u16 cmd)
 end:
 	if (cmd == CMD_WRITE) {
 		if (unlikely(ret)) {
-			for_each_possible_cpu(i) {
+			for_each_online_cpu(i) {
 				struct cpc_desc *desc = per_cpu(cpc_desc_ptr, i);
 
 				if (!desc)
@@ -504,7 +504,7 @@ int acpi_get_psd_map(unsigned int cpu, struct cppc_cpudata *cpu_data)
 	else if (pdomain->coord_type == DOMAIN_COORD_TYPE_SW_ANY)
 		cpu_data->shared_type = CPUFREQ_SHARED_TYPE_ANY;
 
-	for_each_possible_cpu(i) {
+	for_each_online_cpu(i) {
 		if (i == cpu)
 			continue;
 
-- 
2.51.0

