Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F138BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC8CC433EF;
	Tue,  7 Mar 2023 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211728;
	bh=ptUXAPSvKVdNzlGHldFCM5Ift2vs69raehMY7ZpgmEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSwcAljtVCelNj3t81kQ840qY5sECGmgcd9TK1No3HwBWSUwfseNWsWmM1rD+0d46
	 5v8k5A2/IhLoBBsU9QHGHmXufzUoqhH/myfipiLz3cpVIqbtCOkJX68+49PEX0xPk0
	 gqbKwcW7LnD0URQmlKaRpo5U9C0d6KmIEtH8oEBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ilia.Gavrilov" <Ilia.Gavrilov@infotecs.ru>,
	Kim Phillips <kim.phillips@amd.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.2 0955/1001] iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter
Date: Tue,  7 Mar 2023 18:02:07 +0100
Message-Id: <20230307170103.602024359@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

commit b6b26d86c61c441144c72f842f7469bb686e1211 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3475,15 +3475,26 @@ found:
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
@@ -3496,6 +3507,9 @@ static int __init parse_ivrs_acpihid(cha
 	/* We have the '@', make it the terminator to get just the acpiid */
 	*addr++ = 0;
 
+	if (strlen(str) > ACPIID_LEN + 1)
+		goto not_found;
+
 	if (sscanf(str, "=%s", acpiid) != 1)
 		goto not_found;
 


