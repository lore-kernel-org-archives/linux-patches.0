Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B2250278;
	Tue, 23 Jan 2024 01:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974093; cv=none; b=iPPCM7cVj4HWrX6pNptxrczgdqRty0f6cmliUp0EXIPsQ28+Tc2IEBB1K/ob/Xemvc7J8Gk60+wSv3WyLrjvhOYew7UsTHNN2gym20Qn++0wWLSGCZIIWfe8OLBh8ATQoz6vZEuLJI+k4mBUYxzxj4ip5oacBGM8SWzZPDc31Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974093; c=relaxed/simple;
	bh=JAhp0lXK5r6OapOOtPN5UC894HqEZOQQ4lJpHYi206s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3dLVYZ45YgHux3IRSsZt+Nx1ylxpzFkIfTejGTgxt86gZBQFmz3/kd8Xmoujh5Bv8MrtgWVgTGRzZ76OM8QurzU+b2GfzfQaPkiHs9PNvxu7OkGmvMe5w/5g2G7YTt1KIgEs7ckNBhHqASE7uWR9qOVlcV/AhyqqyG6N9upWeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbBVNrdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbBVNrdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0824FC43390;
	Tue, 23 Jan 2024 01:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974093;
	bh=JAhp0lXK5r6OapOOtPN5UC894HqEZOQQ4lJpHYi206s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbBVNrdpkpamGJByYGAL7LhyyW2I5V83o9seoUwRCtqjAAwTTDjFtwsupWSFT0x37
	 q92bUBAKpnvK9LYTXHUOjJiKELYJNzVG5/PBN4K7Q53kEjKBDqdyx7SNRpncNmhTmy
	 3lSoPPFG83og69lNsy2JRZ4l30KwUb608hq2lBBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erwin Tsaur <erwin.tsaur@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/583] ACPI: extlog: Clear Extended Error Log status when RAS_CEC handled the error
Date: Mon, 22 Jan 2024 15:51:26 -0800
Message-ID: <20240122235813.236919452@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 38c872a9e96f72f2947affc0526cc05659367d3d ]

When both CONFIG_RAS_CEC and CONFIG_ACPI_EXTLOG are enabled, Linux does
not clear the status word of the BIOS supplied error record for corrected
errors. This may prevent logging of subsequent uncorrected errors.

Fix by clearing the status.

Fixes: 23ba710a0864 ("x86/mce: Fix all mce notifiers to update the mce->kflags bitmask")
Reported-by: Erwin Tsaur <erwin.tsaur@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index e120a96e1eae..71e8d4e7a36c 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -145,9 +145,14 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 	static u32 err_seq;
 
 	estatus = extlog_elog_entry_check(cpu, bank);
-	if (estatus == NULL || (mce->kflags & MCE_HANDLED_CEC))
+	if (!estatus)
 		return NOTIFY_DONE;
 
+	if (mce->kflags & MCE_HANDLED_CEC) {
+		estatus->block_status = 0;
+		return NOTIFY_DONE;
+	}
+
 	memcpy(elog_buf, (void *)estatus, ELOG_ENTRY_LEN);
 	/* clear record status to enable BIOS to update it again */
 	estatus->block_status = 0;
-- 
2.43.0



