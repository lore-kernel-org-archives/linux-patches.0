Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45433270EAF;
	Tue,  8 Apr 2025 12:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115936; cv=none; b=gfDzWQh5ewg8Wows1+knwm9I2QuYlITyEyJ8fMReCH+YbapMaSdJ3BI5JXb5O4uTKoTTV2/6fJU25Uy/Tn/81BfCaCQno/e7KQ8TKjy9UYsmlmjg1cebRzvNuR8wek319Sby0pkkel6HLgEoDV+H0QLWoK3x3HubIWpbYZiCjUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115936; c=relaxed/simple;
	bh=uAB7dR1puxLApt3hkHI2LzoJhVmfjUB6AtfE6n8UEiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrZbqgP7/L8sBCU2V+t7lTcwJS3aJEe+aYKGArdKyI/ztzL9WKEVBt8KBZFGsCs1fvny96uqKC+Sp3V2apzT8itKz3AvtyB4Z40bpgjzOwjizfQBsTLtsAXrbdWpgUWqHzBE2CkZysQ+sug/o6K+vP5wYhCIe9VhPpyk4pnvFz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eA+VlmNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eA+VlmNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2B6C4CEE7;
	Tue,  8 Apr 2025 12:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115935;
	bh=uAB7dR1puxLApt3hkHI2LzoJhVmfjUB6AtfE6n8UEiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eA+VlmNn613vWHCszSSrdIloJaKcUuS2ucQPC1VdAbSN7ZEPIjyIAoWl9DahlIvx7
	 pGD8HK6nBWtBbTOQWITnELbfF8nXEKv80zXU9Mm6N9SvbhNZkS3iWZyUBgs5lE9pfP
	 P5KZeaBMNFGGr+LVmYlfQWhq87Vl74g1v2yeK8oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Gherdovich <ggherdovich@suse.cz>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/204] ACPI: processor: idle: Return an error if both P_LVL{2,3} idle states are invalid
Date: Tue,  8 Apr 2025 12:50:50 +0200
Message-ID: <20250408104823.832761353@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 18f4334a96919..3386d01c1f157 100644
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



