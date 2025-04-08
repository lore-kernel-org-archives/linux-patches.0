Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233542641CC;
	Tue,  8 Apr 2025 11:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112838; cv=none; b=HVB/U5LNEp3Lp1RsYRdF1D9AuEWcROLY35ALdfuRNxz4s07DzFAwJnLh2m+BqZ3TPxErq/vC4JtemE3Ih9D2FL6+7C0TUIBjQuOwnqkYpgEdVcgNyfuyUgKdLi5J8/6FKH5M0ADWims4ylNq5GIbNX/0EZzTl5ibKalEeIlCqk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112838; c=relaxed/simple;
	bh=F6y2pJGgusOH3MCshmCv6R3E4cPAsu4O/zaZd8do5I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuZ7P+AIV3WT9zDgZW4ZFLam8QhBg+7XFyzNW9Hsk2PACDBJpJ+w4hW6cTVsRrP0H3PrOs6MAjT83YQyZ94lOu3cmsBXEslAVjr3DgzPbx+Dlsw0/UPCOIsJbclsSNZdQ29ZIfSvP4vTLxx7aLHsxw+Ep7xC18YY8CNDqvuIV7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVY4AbXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVY4AbXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B8FC4CEE5;
	Tue,  8 Apr 2025 11:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112838;
	bh=F6y2pJGgusOH3MCshmCv6R3E4cPAsu4O/zaZd8do5I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVY4AbXP/n1YJqyqRoJUDk7FRdYJCqJZsCJb54/mwMPL8rjvTY3GOTJ/+8ATkdmEH
	 AebHHFDySjwyftruQUZQOHjFAiLFOfuZHfp9aCGeA5Yg6FEIrEUHl/sXvhEzlzGNFF
	 rYiUfMhKeQ5R0kYddMHW0kNSZ5gN5TvqEhKhh0rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Gherdovich <ggherdovich@suse.cz>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 217/279] ACPI: processor: idle: Return an error if both P_LVL{2,3} idle states are invalid
Date: Tue,  8 Apr 2025 12:50:00 +0200
Message-ID: <20250408104832.212256214@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5289c344de900..469a2e5eb6e8c 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -265,6 +265,10 @@ static int acpi_processor_get_power_info_fadt(struct acpi_processor *pr)
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



