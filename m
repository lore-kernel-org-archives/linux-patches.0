Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C0121D3DB;
	Wed,  4 Jun 2025 01:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998812; cv=none; b=taP8TW1qz4TnHxPitYBLheZyZ4SSARji3bAgwcbrjnhO4cxJZNDNkbqvzBFHiQDdnGO2gfeogX3JLu3KrvTDXkl47UTa6gjJynmfCmvoY7DL+mOVcuQiWK6u1Tzci8q9FAMqsMoMKh5iexRZ9bemnYxrAyrCBeDj6eAKtE/7GCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998812; c=relaxed/simple;
	bh=sEfRHmV+NRCWzUygQuXZ/GenIyopGW7nFv+s8EsM4sA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NcA1Rjj89bb+QDNgmoVhJWDbYrQeFu/vMrOv+VJ0UWGOomiGDf7mEBczgty6leT9nrT8XDj5zJrJWRyUmkxb2/2/EYjnHlFTIgjHLTJXkzW5B0syAxuJ/cUD+BYHrvVx/7JV91mv8azFfg1bfSbzGuzafDZQdSclNNROsd/TJcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bALethxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bALethxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E885AC4CEF1;
	Wed,  4 Jun 2025 01:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998811;
	bh=sEfRHmV+NRCWzUygQuXZ/GenIyopGW7nFv+s8EsM4sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bALethxBykgkidEVH1XX5RwNqxcCPqoU/kPzXIRRm3lSF+kUSxsBh2UOAimVQlQ56
	 GZ6X4F9ZpUPvKuNrZi1iawq+PDfBPCkNfOuyLMxGE13MWpFp5SCbEdd+3tWFbFbmlw
	 ictWmN7SzsIKp41Pcrin48fWUS+I/Xg+jcbO9fwk1fHAAeglOUIOcgM2BivP53Qene
	 qzGPlNA6JZyM1AgNe2Q9z7Tqrgu8haYGzmI1LH+E1GBQDWkFQihJLtLe6zkHZQvQ5A
	 qAvo47E/WPkam+X//VobmNmtNQ/07Dr5oojJwOvSn48wFn/KniaGPoSeJL8GjaY8+W
	 uV2XQb1hkMuRw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 6.12 26/93] iommu/amd: Allow matching ACPI HID devices without matching UIDs
Date: Tue,  3 Jun 2025 20:58:12 -0400
Message-Id: <20250604005919.4191884-26-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
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

