Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F147286328;
	Wed,  4 Jun 2025 00:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998320; cv=none; b=iH6Lz9ppZyMw2+7iDRzLmRoM5nm0e+k9vWWqFcUvEmoqqQLBvrNNmjecKpboZ4OsZ3sYZJ8gypfOurCTT6n7FQIejVuI7tcpkNikfbdtqjlHNLvjgojrwoFnRtBq69xC4r9n/7e5C+Td7kyl8WVpdrdaSUFauXQygaynRW05K/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998320; c=relaxed/simple;
	bh=12V3mgGoydDHGp6/It/EApY1PdSxhUb+qsQYrIeBCTc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xq8jGSt4EpgBfIev1bt5nCCdXebds549K+gVIDrZQJE2znjmK/RTBM/2+0/l8ArdSx1Wy/UEjJR4uWUd+felImko/v+vCY+mPXbZuwOKDIDQCigTS3GrE9oR49Vbbb7ZuKlk3pgJ9ZarpFhiTyUKtOz6vJ+dMZ0xSuBASsIat+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NjIYtrCw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NjIYtrCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82960C4CEEF;
	Wed,  4 Jun 2025 00:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998319;
	bh=12V3mgGoydDHGp6/It/EApY1PdSxhUb+qsQYrIeBCTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjIYtrCwrsDMHzj9rVSpvodp1yx/shNQHuIk46E1b5YnlBQ25rk4ALdkn+YxClMXm
	 o6K8rEgvXZ6XGPABSOU5GBfZDxrEOXGENh/oaBQWuJRwtGs5Ku3KOfcj/L0Y06u3et
	 zaczNLOaxT+1xfAyoKzwpEMj+/drWhS6OC6I5gutjy7PV8l5sib5B+yq60L3gLzqCI
	 behyEan1Y7zLTCJLs5yKjjfw80wMEocZrMu/tCkS2PAIZIhAb2nTtstg57eRiUPq7o
	 y7n3/loh16ZHuUeuwsfSqgw46XpZJvxpC2RVNM+2qs6MrZ8zfq6jnXJJFVJrUJJAQY
	 x7DAZX1Je6oag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 6.15 033/118] iommu/amd: Allow matching ACPI HID devices without matching UIDs
Date: Tue,  3 Jun 2025 20:49:24 -0400
Message-Id: <20250604005049.4147522-33-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

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

Based on my analysis of the commit, the code changes, and the context
from similar commits, here is my assessment: **YES** This commit should
be backported to stable kernel trees for the following reasons: ## Bug
Fix Analysis 1. **Real-world hardware compatibility issue**: The commit
addresses a concrete problem where BIOS upgrades change IVRS DTE UIDs
that no longer match the UIDs in SSDT, causing ACPI HID device matching
to fail. This is a genuine hardware compatibility issue affecting real
systems. 2. **Minimal, targeted change**: The modification is confined
to a single function (`get_acpihid_device_id()`) in
`drivers/iommu/amd/iommu.c`. The change adds fallback logic without
altering the primary matching path, making it low-risk. 3.
**Conservative approach**: The fix only allows UID mismatch when there's
exactly one HID match (`hid_count == 1`), preventing ambiguous matches.
It maintains strict validation by returning `-EINVAL` for multiple HID
matches. 4. **Follows established patterns**: Similar to the reference
commits (all marked "YES"), this addresses ACPI device matching issues
in the AMD IOMMU subsystem, a pattern we've seen consistently
backported. ## Code Change Analysis The modification transforms the
original simple loop: ```c list_for_each_entry(p, &acpihid_map, list) {
if (acpi_dev_hid_uid_match(adev, p->hid, p->uid[0] ? p->uid : NULL)) {
if (entry) *entry = p; return p->devid; } } return -EINVAL; ``` Into a
more robust matching algorithm that: - First attempts exact HID+UID
matching (preserving original behavior) - Falls back to HID-only
matching when exactly one device matches - Logs firmware bugs
appropriately with `FW_BUG` - Rejects ambiguous multi-device scenarios
## Risk Assessment - **Low regression risk**: The primary matching path
remains unchanged - **Backward compatibility**: Systems with correct
BIOS behavior continue working identically - **Forward compatibility**:
Handles broken BIOS scenarios gracefully - **Contained scope**: Changes
are isolated to AMD IOMMU ACPI device identification ## Comparison with
Reference Commits This commit follows the same pattern as the "YES"
reference commits: - **Similar scope**: ACPI HID device matching in AMD
IOMMU (like commits #1, #2, #3, #4) - **Bug fix nature**: Addresses real
hardware compatibility issues - **Minimal code changes**: Small,
contained modifications - **Critical subsystem**: IOMMU functionality is
essential for system operation The commit contrasts with reference
commit #5 (marked "NO") which introduced new kernel parameters - a
feature addition rather than a bug fix. This commit represents exactly
the type of important bug fix that stable kernels are designed to
include: it resolves real-world hardware compatibility issues with
minimal risk and follows established successful patterns in the same
subsystem.

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

