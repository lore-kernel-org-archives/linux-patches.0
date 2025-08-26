Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1849216E1B;
	Tue, 26 Aug 2025 13:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215799; cv=none; b=uuvrBPS50wdVsBBGmXkdNWdZJ92vIrk+y2xhcVFfhzxc4opvwPLtrwKRbeJO0ve4akha/kxP1ieb+GEwLt7VTCpDLTDbeuN4kG0Bh3kwhe3NUAHG0166zDsV7DK1GK7gwLf5pau9ap6HmkPnkcFg8ASlUVPctqQ3dMEWXMOGEJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215799; c=relaxed/simple;
	bh=PFqgUBLEftF9miZpRs7xTWE+f3Y7MLB2CVUedC2QpLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0c6m3czXf0GS/K/ujFizsfW4iiO9GTX5FXDrgrV8PgdkbODyfjBJrqKwpiXZ7Wbq1vdi+Is9GmtgcO8se800tV1oeUH7uFADVX9TF9WOFG2y4VkcH3z9/Ed7ffHhKTurDVhlHEWnxCXzXlac2bw1Tu/4do42y5/QmWtWXCuLho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvPgtfnd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvPgtfnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6D3C4CEF1;
	Tue, 26 Aug 2025 13:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215799;
	bh=PFqgUBLEftF9miZpRs7xTWE+f3Y7MLB2CVUedC2QpLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvPgtfndvwPfFNYvW0KnMcdbriuIVtnmxUA23YNBqMbpkDyVOxPq4v1PpZkT02rJe
	 gDSOImVKXWbMtNKWsaNVSIBHbJmHL/QOxC5OSqnv2aodgeNgzOlayWgtXbgTCWfDBB
	 r/638ghsGkbq1UmwVqTA8wuyRcHf+ba+D8fne020=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/644] power: supply: cpcap-charger: Fix null check for power_supply_get_by_name
Date: Tue, 26 Aug 2025 13:04:22 +0200
Message-ID: <20250826110950.712667053@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit d9fa3aae08f99493e67fb79413c0e95d30fca5e9 ]

In the cpcap_usb_detect() function, the power_supply_get_by_name()
function may return `NULL` instead of an error pointer.
To prevent potential null pointer dereferences, Added a null check.

Fixes: eab4e6d953c1 ("power: supply: cpcap-charger: get the battery inserted infomation from cpcap-battery")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20250519024741.5846-1-hanchunchao@inspur.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-charger.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/cpcap-charger.c b/drivers/power/supply/cpcap-charger.c
index 60e0ce105a29..5c9e3784ed47 100644
--- a/drivers/power/supply/cpcap-charger.c
+++ b/drivers/power/supply/cpcap-charger.c
@@ -689,9 +689,8 @@ static void cpcap_usb_detect(struct work_struct *work)
 		struct power_supply *battery;
 
 		battery = power_supply_get_by_name("battery");
-		if (IS_ERR_OR_NULL(battery)) {
-			dev_err(ddata->dev, "battery power_supply not available %li\n",
-					PTR_ERR(battery));
+		if (!battery) {
+			dev_err(ddata->dev, "battery power_supply not available\n");
 			return;
 		}
 
-- 
2.39.5



