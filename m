Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1288A1487CA;
	Tue, 23 Jan 2024 00:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969155; cv=none; b=pb9Vis+g8XJWxz5Cr4YkRWxgul9Inbv+XRK8UFhhx2Jjum5YcLrEvE8ZjYk8aq2+yXVxPaLQQSrG5Su9hJLkCL/NBYOlK/T5yYExDkozLrVAwK0vIS79/1rnGnGJEM3Qwf7vwFFQwjCqyHvsZA1PRa/ayJg473USXOuqB/kTymg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969155; c=relaxed/simple;
	bh=eOoiuF+QrOvPWcaRIp3Iq+3tRoR7r8GYPDEF/eaM4j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEZhs7i77l9nJ6TeBkCagRkOPzDN2YK4yGw6AQd3lLOdkdg6HesS7OcxrcN6r2WVzSDtsJi8oatnPJQ69pdpkrLaTdB9gIziwo6gtsr7knAzIYFnJOD1a2xGCnU2+sl+j5VrTSg1R1LVoW9eFXGUrJRaMVN7GaFOG3r22Y9evOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2v6hJCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2v6hJCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC020C43394;
	Tue, 23 Jan 2024 00:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969154;
	bh=eOoiuF+QrOvPWcaRIp3Iq+3tRoR7r8GYPDEF/eaM4j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2v6hJCD/0bieLMts2MvlQio/n7w65utowagwDjgRDx1TBk04BbazIkofFJpjqEol
	 SSETEanF+grO3dyx89V+FpkY0C9/ibfgehaSnLUtMNXu+SWWTdxpPE0XapJcaAzYWp
	 14rEa2qQK1heC+bMQ73sfyD08+yris/RtZLwUEOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erwin Tsaur <erwin.tsaur@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 035/641] ACPI: extlog: Clear Extended Error Log status when RAS_CEC handled the error
Date: Mon, 22 Jan 2024 15:48:59 -0800
Message-ID: <20240122235819.177989392@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



