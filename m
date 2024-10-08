Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE3E1DACBE;
	Tue,  8 Oct 2024 12:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389871; cv=none; b=V9Dp7VR83+eTVsTK4Fbvre40QtE8VUqX4IlaIESW/BRgr2cDs8H4Mi/wnPTLkdeqz2PxiQXc4fPjVy3xrizyAJbLpyYjQfW/UlcZtE45EcLX2Hw5zrLDBHPmT1/Hic9vumHD5ab2WUd9p6SvAjrDJCPoTI4kHdT4Iq52BPuuox4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389871; c=relaxed/simple;
	bh=4SEkgro3Jl+ikGotn7Uzzh5nAdi8jdQBJdaVQ5USLGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcLluoMrYBjL5GmrcSaDyr2Y+8C5cEaCyxeJ5fubtiRkvxAUoZ5MfAMMm463y64iYGtFvDpscRZSIay6JKxRqEd3nhEUiUJAnpPos4wjRdK7ou4K1AI2Jk0JgjB4lg6Yyemzi/z3CX1tZgDqImPlL2Bf2g+rC2Rv0D+sImnh8bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/bn//a4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/bn//a4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4450C4CEC7;
	Tue,  8 Oct 2024 12:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389871;
	bh=4SEkgro3Jl+ikGotn7Uzzh5nAdi8jdQBJdaVQ5USLGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/bn//a4zTTaoWC0K24r9Wa2vpJwKTZ0t83g9+8SE46dIqBhuYPbaH2iG8JeXs9DV
	 VCUN8cE21s4iAVq2xDLnYFQhmZiL4rQLYmX53IPyseidCxKz1+z2UAEDB9q9y0PaHn
	 F9TbrdzZRocZBuyCBebtF5+8rgB6XTqDZMT84ouA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamim Khan <tamim@fusetak.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 090/482] ACPI: resource: Skip IRQ override on Asus Vivobook Go E1404GAB
Date: Tue,  8 Oct 2024 14:02:33 +0200
Message-ID: <20241008115651.853466706@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Tamim Khan <tamim@fusetak.com>

[ Upstream commit 49e9cc315604972cc14868cb67831e3e8c3f1470 ]

Like other Asus Vivobooks, the Asus Vivobook Go E1404GAB has a DSDT
that describes IRQ 1 as ActiveLow, while the kernel overrides to Edge_High.

This override prevents the internal keyboard from working.

Fix the problem by adding this laptop to the table that prevents the kernel
from overriding the IRQ.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219212
Signed-off-by: Tamim Khan <tamim@fusetak.com>
Link: https://patch.msgid.link/20240903014317.38858-1-tamim@fusetak.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index cb2aacbb93357..8a4726e2eb693 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -503,6 +503,13 @@ static const struct dmi_system_id irq1_level_low_skip_override[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "B2502FBA"),
 		},
 	},
+	{
+		/* Asus Vivobook Go E1404GAB */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "E1404GAB"),
+		},
+	},
 	{
 		/* Asus Vivobook E1504GA */
 		.matches = {
-- 
2.43.0



