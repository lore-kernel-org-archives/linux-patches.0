Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEAB26A0B0;
	Tue,  8 Apr 2025 11:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110127; cv=none; b=qXFUx2j8mEZEAQQvb2oa/wPPWVl/I0K8mZGNKPOfr99rWn2qLEvwc41xtbfJ4m9F0Z6Wu+NfVmScBxronxA+vGHctQ5QUmGRYHZB+YeEalvvojn7vQmp3xdtA7IuGtIilK7yB9EG41/nfThSKeGNys3u9N34ONYxmEuoxNkL0JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110127; c=relaxed/simple;
	bh=p2oLZ+rKFl48JIRVQrhK9pWjsiIxlHt9Gs6UdEnsTGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckNGIoW9wqS+H9HlcQePTJHv2b1hz7C9zGULPxuQkK8T+5rZM2o9YlHU2/tS9XP3Tg38mCZebCdziYUzt2TtqcxJ2Df6oU7iWqFoDjEHaq1X4Dy+iD4w8pbyrxOJE7fM5Z1+eUptesrwjPvj9wppkDutKArS0RhGOMTavpUKJd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XzfNyz5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XzfNyz5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C64EC4CEE5;
	Tue,  8 Apr 2025 11:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110126;
	bh=p2oLZ+rKFl48JIRVQrhK9pWjsiIxlHt9Gs6UdEnsTGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XzfNyz5esdcr1wqDo8tnjqvOKlkTB0kneTwC0wv6HqfMkVpqz1Qx7EROm3BE+aqND
	 ofq7MD+A/tLw0b3hnMkJpGv7ZyHU4SAh3FJTssTUcIXAOTV1givzqwlQxzcN+B74PN
	 YJCTkZaCRACXIv/B+2A7SQ24B4a+6aNJfbWJCTXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Gherdovich <ggherdovich@suse.cz>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/227] ACPI: processor: idle: Return an error if both P_LVL{2,3} idle states are invalid
Date: Tue,  8 Apr 2025 12:49:16 +0200
Message-ID: <20250408104825.655545706@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ae07927910ca0..42c7bdb352d20 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -270,6 +270,10 @@ static int acpi_processor_get_power_info_fadt(struct acpi_processor *pr)
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



