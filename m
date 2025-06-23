Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58E42C9D;
	Mon, 23 Jun 2025 21:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713699; cv=none; b=PirrTgy8p3Yspf7jYh746oMvPJ7RzL+a6Oc3CmZiW40HAiF151Z4IAP0LwqD0ydP1JCFYA/K4TTjsBVIuRihN2Hv3JbH3UYNjyzL/MIRHHNc1jdQ+jP+rblgPsVkKWRT4PUPPh0msG+kcGEgMwQyJEUyF/m51emrZd1poRIyy6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713699; c=relaxed/simple;
	bh=w+aEoiREZE0nQSEIHLCafoCe0PF/UuWwq/b8ZyPRnGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ag9QSQjZX3UjamQQgn1gzQW4uHJNrvW3nim/Zp9v1KMLf1oDd8clt/cqLtrvboMWJW8ADd1KV+/vtIBqjaN4+hgMp2eGa69TfIOsR3nIuZTu11AZMA3zCJ5j74SgaBFzS2rdUwEKx2qbDqjBr68e101Nd872H08L6RvsOXhm6fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+wGpSj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+wGpSj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6992BC4CEEA;
	Mon, 23 Jun 2025 21:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713699;
	bh=w+aEoiREZE0nQSEIHLCafoCe0PF/UuWwq/b8ZyPRnGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+wGpSj6gWX7cR36+ZF7lIA5z/K8IoNlW2Vx5MotShDSVG5/9xxyqHM0Yh8c3GwiD
	 p7e9oSSeyCkRT8canvORChnzo+KVyqAC2hiw7iSEqgBn4d6y+TZxyAkpc24fI/yv/3
	 MtbciNhG16BUdsqAK8GONsTckBPfJWr93f/18lco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 342/592] iommu/amd: Allow matching ACPI HID devices without matching UIDs
Date: Mon, 23 Jun 2025 15:05:00 +0200
Message-ID: <20250623130708.585545204@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index f34209b08b4c5..a05e0eb1729bf 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -241,7 +241,9 @@ static inline int get_acpihid_device_id(struct device *dev,
 					struct acpihid_map_entry **entry)
 {
 	struct acpi_device *adev = ACPI_COMPANION(dev);
-	struct acpihid_map_entry *p;
+	struct acpihid_map_entry *p, *p1 = NULL;
+	int hid_count = 0;
+	bool fw_bug;
 
 	if (!adev)
 		return -ENODEV;
@@ -249,12 +251,33 @@ static inline int get_acpihid_device_id(struct device *dev,
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



