Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B6213A26F;
	Tue, 27 Feb 2024 14:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042983; cv=none; b=PGQuXz1QSPSSx5tnf51WFVWICf+cWplHeju0+ajihx52fbVeI+WkUe9WWbZts0lypgwMU9KunPEsM5iiJfzJ18JCMCo/0jUk+5SAwZUC+VxEIWOeXaOuM8uvUWRutixGNGV+6Zft6syo/qkup7MINvsdRR56fIYPxzqbWHPJSTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042983; c=relaxed/simple;
	bh=TR4jiJI5p0bc3FWLVmoEdY8FwHuPqfeCOAYzBoNDhjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSCZA+Q6mz2KqGK4yNbSCxhVyQHQJ0UnI4wsAvKugurTNUaOjtoKV1SjOs6o/WMzvNw5DQTEQ0EoFsiU2VreOlgEaP1zGYL4ehKbaDwzBJnCXO+e12Ki30ND0iiFHgmiCvXVHa/vuc3XMkJwUSYtNkiyueYKuGsEonubXV05tz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xiMvo751; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xiMvo751"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C54C433F1;
	Tue, 27 Feb 2024 14:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042983;
	bh=TR4jiJI5p0bc3FWLVmoEdY8FwHuPqfeCOAYzBoNDhjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xiMvo751flljTOYS4ZaYvjRfgrJGtklpxapxtXiY2i4aPlJCOErvDfvXMFJ0NHP9o
	 dcAh9QIiOo97s3LYo2xYaUBf4sbJRLeSANhOwa5H7Y5zV0nRRvYHc8ya11XXl5mKH3
	 GMgpFQtUC1Z7gUIHIVukKP5nTgstmtevJW+dFXDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zelenat <zelenat@gmail.com>,
	Tamim Khan <tamim@fusetak.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/245] ACPI: resource: Skip IRQ override on Asus Expertbook B2402CBA
Date: Tue, 27 Feb 2024 14:26:20 +0100
Message-ID: <20240227131621.431601694@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamim Khan <tamim@fusetak.com>

[ Upstream commit 77c7248882385397cd7dffe9e1437f59f32ce2de ]

Like the Asus Expertbook B2502CBA and various Asus Vivobook laptops,
the Asus Expertbook B2402CBA has an ACPI DSDT table that describes IRQ 1
as ActiveLow while the kernel overrides it to Edge_High. This prevents the
keyboard from working. To fix this issue, add this laptop to the
skip_override_table so that the kernel does not override IRQ 1.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216864
Tested-by: zelenat <zelenat@gmail.com>
Signed-off-by: Tamim Khan <tamim@fusetak.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index a5d2a81902038..6c5873f552e5e 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -435,6 +435,13 @@ static const struct dmi_system_id asus_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "S5602ZA"),
 		},
 	},
+	{
+		.ident = "Asus ExpertBook B2402CBA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "B2402CBA"),
+		},
+	},
 	{
 		.ident = "Asus ExpertBook B2502",
 		.matches = {
-- 
2.43.0



