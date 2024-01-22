Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766A712A167;
	Tue, 23 Jan 2024 00:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971043; cv=none; b=LbhUA9BBudvCH0erqSqOT3g0nvAifbgafhnd7Xok9hNyN5/XW6kAp53oH/4LGN/6DZ3uYE73ErccOuZMBoSPLnzRPU/Fli6+6NT2JSdRC7k90my7w2mzsC9cbffE4HHyRqLNDtzllZuVoWbqM2c1IWQHl0nfmQAUpVRcbsutyr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971043; c=relaxed/simple;
	bh=46K0gmTJWOg0c6hYpR4GL0x0w5y7JMrg7JKPyxa/ifk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRGa6bbyKa+b9XjBPoD6cct7N4G92un2eTqiLB+bqw504tD7RZFQ91ZvVl9LVi83woo2rOEkhoHPBTzS8oOkfL+pCQomeizScPK0ApppRXaftpLbDBp2XjLabaofpf9layqAO/4FzhSsBBkB0y8GNst/SC8NoLj/s07wMEtdLGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZT04I2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZT04I2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D20FC43390;
	Tue, 23 Jan 2024 00:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971043;
	bh=46K0gmTJWOg0c6hYpR4GL0x0w5y7JMrg7JKPyxa/ifk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZT04I2Tq/ouTBNB7z94scHMwCvUBx0lDxJ1soEh242h72LnG7ff1Npg8aSWVoOD2
	 wMfkS8xd0nuk+65+JSBjTHD7PHdHXj5ts4cfyFINLnQTdqnavssdSRT9NrAObxpOse
	 ll9BLW0qnUrSXZRYUVwiAmfDNtCsQLmjsD7/1qWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erwin Tsaur <erwin.tsaur@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/286] ACPI: extlog: Clear Extended Error Log status when RAS_CEC handled the error
Date: Mon, 22 Jan 2024 15:56:20 -0800
Message-ID: <20240122235734.881775860@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e648158368a7..088db2356998 100644
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



