Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8544431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB771C433EF;
	Wed, 15 Mar 2023 12:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678882725;
	bh=TbzaiUbnacWv/2xLOlSIwhgHsJaQkf2e3bpnId7P8RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJ2zMcobTdFqowVDhgmEdRHIHtJiSy7JylrMIWochL7vrSIob9qHUDRY64shxmUc5
	 6Ur9IEXXLkdvPk7IsCJoLC0LplHsOWuV8FnFkNA7/7AK0gWnkwfUjJGncteUWwhGyZ
	 eypFtp3FaspxfcIFYuQtL//QTBNflGYUdonForpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ilia.Gavrilov" <Ilia.Gavrilov@infotecs.ru>,
	Kim Phillips <kim.phillips@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/68] iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter
Date: Wed, 15 Mar 2023 13:12:10 +0100
Message-Id: <20230315115726.725394910@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

[ Upstream commit b6b26d86c61c441144c72f842f7469bb686e1211 ]

The 'acpiid' buffer in the parse_ivrs_acpihid function may overflow,
because the string specifier in the format string sscanf()
has no width limitation.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: ca3bf5d47cec ("iommu/amd: Introduces ivrs_acpihid kernel parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
Reviewed-by: Kim Phillips <kim.phillips@amd.com>
Link: https://lore.kernel.org/r/20230202082719.1513849-1-Ilia.Gavrilov@infotecs.ru
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_init.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 71e4a8eac3c92..4a9feff340da7 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -3049,15 +3049,26 @@ static int __init parse_ivrs_hpet(char *str)
 	return 1;
 }
 
+#define ACPIID_LEN (ACPIHID_UID_LEN + ACPIHID_HID_LEN)
+
 static int __init parse_ivrs_acpihid(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
 	char *hid, *uid, *p, *addr;
-	char acpiid[ACPIHID_UID_LEN + ACPIHID_HID_LEN] = {0};
+	char acpiid[ACPIID_LEN] = {0};
 	int i;
 
 	addr = strchr(str, '@');
 	if (!addr) {
+		addr = strchr(str, '=');
+		if (!addr)
+			goto not_found;
+
+		++addr;
+
+		if (strlen(addr) > ACPIID_LEN)
+			goto not_found;
+
 		if (sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid) == 4 ||
 		    sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid) == 5) {
 			pr_warn("ivrs_acpihid%s option format deprecated; use ivrs_acpihid=%s@%04x:%02x:%02x.%d instead\n",
@@ -3070,6 +3081,9 @@ static int __init parse_ivrs_acpihid(char *str)
 	/* We have the '@', make it the terminator to get just the acpiid */
 	*addr++ = 0;
 
+	if (strlen(str) > ACPIID_LEN + 1)
+		goto not_found;
+
 	if (sscanf(str, "=%s", acpiid) != 1)
 		goto not_found;
 
-- 
2.39.2



