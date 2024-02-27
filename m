Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B76713A259;
	Tue, 27 Feb 2024 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043058; cv=none; b=AkGmt6VXSvwYyuJjPGuI5m7cTpkBrwY6TzwEwidOSuKKkudjJe66Jvgecydembs5ldlwSbf+xWU5vlJWRKriFwL3u6MOGyren1CJSuiZVBR15dMcjY3IKvImKI9xmEvRgP8fVaUwDQFBTtIwJ+YWz6SzS0QrhLnEgmxW+DB7SYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043058; c=relaxed/simple;
	bh=B5Sledx1v2Mp3YWDl5ddsiSrnwlkbAnZUGVv9gq0EVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ah+ZVG5TsZlkQCafw4Opm7SmhAVmVdpStikiDt+ubPuUS2fES6Hctc/p8a2aSr5y2S/Uy3hL47vG2jMdDCLXd1ecKDBV2NB4H5WRpGEsJb+ovowrf5vg4nX37Bg6vUah2EgUFCBX8FESUvyOYbvsYAghtnn+wPexZ3gHZiNqmXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6UPjU14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6UPjU14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBD1C433F1;
	Tue, 27 Feb 2024 14:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043058;
	bh=B5Sledx1v2Mp3YWDl5ddsiSrnwlkbAnZUGVv9gq0EVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6UPjU140DpOkdKsQnxIIsmthiabvvgrrkgiE+VhMwcrDdC9+L9UR8Rm96xYWCe4A
	 EQOuBeN+HBpfl6RNczF40qKDtT0IGazeA7z7xnozRmN4IPMzw//g70j50Mgdw3JpIj
	 gNheDaQBeEmZZnNvlc/Atvp5qse7k13mgxDSgN+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry <wrkedm@gmail.com>,
	Tamim Khan <tamim@fusetak.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/245] ACPI: resource: Skip IRQ override on Asus Vivobook S5602ZA
Date: Tue, 27 Feb 2024 14:26:18 +0100
Message-ID: <20240227131621.368873707@linuxfoundation.org>
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

[ Upstream commit b5f9223a105d9b56954ad1ca3eace4eaf26c99ed ]

Like the Asus Vivobook K3402ZA/K3502ZA/S5402ZA Asus Vivobook S5602ZA
has an ACPI DSDT table the describes IRQ 1 as ActiveLow while the kernel
overrides it to Edge_High. This prevents the keyboard on this laptop
from working. To fix this add this laptop to the skip_override_table so
that the kernel does not override IRQ 1.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216579
Tested-by: Dzmitry <wrkedm@gmail.com>
Signed-off-by: Tamim Khan <tamim@fusetak.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 4d1db2def7ae4..5f56839ed71df 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -428,6 +428,13 @@ static const struct dmi_system_id asus_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "S5402ZA"),
 		},
 	},
+	{
+		.ident = "Asus Vivobook S5602ZA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "S5602ZA"),
+		},
+	},
 	{ }
 };
 
-- 
2.43.0



