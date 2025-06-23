Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8812B1FC0E3;
	Mon, 23 Jun 2025 21:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715863; cv=none; b=JZzxmz2IsAQU/6p7RAWEDoMuUeDeNNL4cFYrY14K2jC649p1EXWKj9rS+oWDgKToEj6MlqyzBGwDtp2uEXWa6u8dD5XG82Qu5gKInz8xKv0QfciqfsUgSa7uDl5O+rVo8tcvS95oqY/cR5ykVbWLyvcIvK0Rs80ZUPSC2gRgRcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715863; c=relaxed/simple;
	bh=Ai7uRoDV7skqDb7G8lXdGNweu7bKetCo8z+wj7hQN6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnpjbyRpQHmqyhgnlDfAzLLbRCyvX34XPA1jtdvVDfVg17xACmZPKN2r70KQSaYUgguEqmp5XxJmgQ+Pq+BbdciuZsi0q7jjRnpbIr/0IO9EcO5F7evK8L2ZyjaUV0+xajOEoBTqMuxGvjeQQ847cCxqm4O1dfLciEpq9br03YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqCfO1he; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqCfO1he"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDE2C4CEEA;
	Mon, 23 Jun 2025 21:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715863;
	bh=Ai7uRoDV7skqDb7G8lXdGNweu7bKetCo8z+wj7hQN6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqCfO1hem46Z3E0jy1DkFE70mpWbToLR55EUo5mlYpVLeAN+FuEKhkjxUabQPtlcS
	 VjSkztyOqGYMZ4Whmwkvs0Dvegy+VqC/6d5Q5UY/J+I9GVeKhIGKwI1XxzDjMWGKfY
	 VpScid5DXxHDg24AqwNOyUOlx1wfgYqUmsXhxI28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/414] iommu/amd: Allow matching ACPI HID devices without matching UIDs
Date: Mon, 23 Jun 2025 15:05:52 +0200
Message-ID: <20250623130647.388657129@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 51c33f333bbf7bdb6aa2a327e3a3e4bbb2591511 ]

A BIOS upgrade has changed the IVRS DTE UID for a device that no
longer matches the UID in the SSDT. In this case there is only
one ACPI device on the system with that _HID but the _UID mismatch.

IVRS:
```
              Subtable Type : F0 [Device Entry: ACPI HID Named Device]
                  Device ID : 0060
Data Setting (decoded below) : 40
                 INITPass : 0
                 EIntPass : 0
                 NMIPass : 0
                 Reserved : 0
                 System MGMT : 0
                 LINT0 Pass : 1
                 LINT1 Pass : 0
                   ACPI HID : "MSFT0201"
                   ACPI CID : 0000000000000000
                 UID Format : 02
                 UID Length : 09
                        UID : "\_SB.MHSP"
```

SSDT:
```
Device (MHSP)
{
    Name (_ADR, Zero)  // _ADR: Address
    Name (_HID, "MSFT0201")  // _HID: Hardware ID
    Name (_UID, One)  // _UID: Unique ID
```

To handle this case; while enumerating ACPI devices in
get_acpihid_device_id() count the number of matching ACPI devices with
a matching _HID. If there is exactly one _HID match then accept it even
if the UID doesn't match. Other operating systems allow this, but the
current IVRS spec leaves some ambiguity whether to allow or disallow it.
This should be clarified in future revisions of the spec. Output
'Firmware Bug' for this case to encourage it to be solved in the BIOS.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Link: https://lore.kernel.org/r/20250512173129.1274275-1-superm1@kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index f61e48f237324..4428a9557f295 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -107,7 +107,9 @@ static inline int get_acpihid_device_id(struct device *dev,
 					struct acpihid_map_entry **entry)
 {
 	struct acpi_device *adev = ACPI_COMPANION(dev);
-	struct acpihid_map_entry *p;
+	struct acpihid_map_entry *p, *p1 = NULL;
+	int hid_count = 0;
+	bool fw_bug;
 
 	if (!adev)
 		return -ENODEV;
@@ -115,12 +117,33 @@ static inline int get_acpihid_device_id(struct device *dev,
 	list_for_each_entry(p, &acpihid_map, list) {
 		if (acpi_dev_hid_uid_match(adev, p->hid,
 					   p->uid[0] ? p->uid : NULL)) {
-			if (entry)
-				*entry = p;
-			return p->devid;
+			p1 = p;
+			fw_bug = false;
+			hid_count = 1;
+			break;
+		}
+
+		/*
+		 * Count HID matches w/o UID, raise FW_BUG but allow exactly one match
+		 */
+		if (acpi_dev_hid_match(adev, p->hid)) {
+			p1 = p;
+			hid_count++;
+			fw_bug = true;
 		}
 	}
-	return -EINVAL;
+
+	if (!p1)
+		return -EINVAL;
+	if (fw_bug)
+		dev_err_once(dev, FW_BUG "No ACPI device matched UID, but %d device%s matched HID.\n",
+			     hid_count, hid_count > 1 ? "s" : "");
+	if (hid_count > 1)
+		return -EINVAL;
+	if (entry)
+		*entry = p1;
+
+	return p1->devid;
 }
 
 static inline int get_device_sbdf_id(struct device *dev)
-- 
2.39.5



