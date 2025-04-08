Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214C0268FDD;
	Tue,  8 Apr 2025 11:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111802; cv=none; b=sVT2aXdOx/UNK20dGLj26P9eXg0/kfUcVNxaCDaF1hVLayaPUnOUbyLnDsryVbGfMVgmVn0ZUCxUBukukbt/1wf8GTtqrM0tJ02gnc3OFpHq6aRsZR9JtGs3XLeYr7ISB+9F6Y5RdU+oKAdX/xPFCxUzf6r63fu1zO2KOPJuW8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111802; c=relaxed/simple;
	bh=YiDHeRNsgueMiLU7cp67Cn8tabVDnnGh65qpVMX8YvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOmW5yBhqLbdzAJsdqxot7Y0khryt8+Bi6jThkc6+HkJhy/BD4M6p+W9QX3uN4D1AoEG+7bbH+fCOxWkacXQh+CbPQdFi+x+Z9NZD98F6fxCQgARq0rJ+xzfiwOJFp63jJJ7HyBQ2wc3f6QzAx3N5+dXfHJ/fkSL/JSGK1dm76g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUaHrfKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUaHrfKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A445AC4CEE5;
	Tue,  8 Apr 2025 11:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111802;
	bh=YiDHeRNsgueMiLU7cp67Cn8tabVDnnGh65qpVMX8YvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUaHrfKn8d20u644iYt1GGyNG3BWICqS2EvSd6g46LbnX02BX51mB8/e96veZPNJW
	 BxQoSx7HE2ECvCdF+Ftd6RaFyMYpo1vVSNMV4V5aNbJHFbHspgxmqiTHxbUYJkksaE
	 WgmYoL4KtpM3Gtb85vQItD4TzWENy5E063xfaQPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Gherdovich <ggherdovich@suse.cz>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 566/731] ACPI: processor: idle: Return an error if both P_LVL{2,3} idle states are invalid
Date: Tue,  8 Apr 2025 12:47:43 +0200
Message-ID: <20250408104927.439953176@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Gherdovich <ggherdovich@suse.cz>

[ Upstream commit 9e9b893404d43894d69a18dd2fc8fcf1c36abb7e ]

Prior to commit 496121c02127 ("ACPI: processor: idle: Allow probing on
platforms with one ACPI C-state"), the acpi_idle driver wouldn't load on
systems without a valid C-State at least as deep as C2.

The behavior was desirable for guests on hypervisors such as VMWare
ESXi, which by default don't have the _CST ACPI method, and set the C2
and C3 latencies to 101 and 1001 microseconds respectively via the FADT,
to signify they're unsupported.

Since the above change though, these virtualized deployments end up
loading acpi_idle, and thus entering the default C1 C-State set by
acpi_processor_get_power_info_default(); this is undesirable for a
system that's communicating to the OS it doesn't want C-States (missing
_CST, and invalid C2/C3 in FADT).

Make acpi_processor_get_power_info_fadt() return -ENODEV in that case,
so that acpi_processor_get_cstate_info() exits early and doesn't set
pr->flags.power = 1.

Fixes: 496121c02127 ("ACPI: processor: idle: Allow probing on platforms with one ACPI C-state")
Signed-off-by: Giovanni Gherdovich <ggherdovich@suse.cz>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Link: https://patch.msgid.link/20250328143040.9348-1-ggherdovich@suse.cz
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 698897b29de24..2df1296ff44d5 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -268,6 +268,10 @@ static int acpi_processor_get_power_info_fadt(struct acpi_processor *pr)
 			 ACPI_CX_DESC_LEN, "ACPI P_LVL3 IOPORT 0x%x",
 			 pr->power.states[ACPI_STATE_C3].address);
 
+	if (!pr->power.states[ACPI_STATE_C2].address &&
+	    !pr->power.states[ACPI_STATE_C3].address)
+		return -ENODEV;
+
 	return 0;
 }
 
-- 
2.39.5



