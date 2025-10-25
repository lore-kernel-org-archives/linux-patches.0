Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4E4305976;
	Sat, 25 Oct 2025 16:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408895; cv=none; b=G6FZ4laYzzhIxddHXH3Y0HggXDgxOvWmHjlW3DIeg3274rHOVqHQ/m+gM/fash2Ecy23c1OEAQ9+Tu4Tvi0Ormk9wufZXbNRkROkhDzny75WwU2M+UU5CBLausirtSAg06pNZjBLjWgz/NtCeZzf+G6nc4UWqpFa2PMwWrksjwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408895; c=relaxed/simple;
	bh=tcamB+9hatZ3BmRnUV96afch00ZCkk8rlOOhM3ZXNxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fywIg8rYE3JRpOcLUycxqTiPmk7U+OWX+WvwcEtCSoPpQopjUjF0C6Nr5UNSA1FkZZwdCm2zw5wBvPXc8ALStptstE8jzWguNwqyVkiNHWxQjRQl6cEqV9Dmf6uNPJACQK65Bhi2Yo6bjoxeVCeXBcXKis633jiKGBoxzGW0vcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pCHcA7QC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pCHcA7QC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7011CC4CEF5;
	Sat, 25 Oct 2025 16:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408895;
	bh=tcamB+9hatZ3BmRnUV96afch00ZCkk8rlOOhM3ZXNxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCHcA7QC+gp8bSpjXrus9WkOzZhG8/EnQETYqQqSmnynbPRlVvDL+K6CbPRpMW03a
	 HPijPD2jMd0ypvqTzZHyfFeBTTfjwefDvL24qo57yBTSF33k9AGeCE5FAOa8U1I8Ql
	 /TuStSl1NhDft1A8WbXiEgBzyajX4rC4XdexolGX4K3xd+qlap1ArDwLkRwFCe9z0D
	 9/6ilexuVtVfIYg5WUmuQ0lBDcnRXy06S5YZ6Ncc9xLkUeMoMOARwg6lHTICmx8RvK
	 vMdgqlJhstJ9ABMZZa9+bKSEP/00zDJNy69rawK7Sm/oP8TuQvEPXKP3M9qU/qXws4
	 dLuYnf4K6XegA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/xe/configfs: Enforce canonical device names
Date: Sat, 25 Oct 2025 11:55:50 -0400
Message-ID: <20251025160905.3857885-119-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 400a6da1e967c4f117e4757412df06dcfaea0e6a ]

While we expect config directory names to match PCI device name,
currently we are only scanning provided names for domain, bus,
device and function numbers, without checking their format.
This would pass slightly broken entries like:

  /sys/kernel/config/xe/
  ├── 0000:00:02.0000000000000
  │   └── ...
  ├── 0000:00:02.0x
  │   └── ...
  ├──  0: 0: 2. 0
  │   └── ...
  └── 0:0:2.0
      └── ...

To avoid such mistakes, check if the name provided exactly matches
the canonical PCI device address format, which we recreated from
the parsed BDF data. Also simplify scanf format as it can't really
catch all formatting errors.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250722141059.30707-3-michal.wajdeczko@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**Why It’s A Bug**
- Current code accepts any string that scans into
  domain/bus/slot/function, even if not in canonical PCI BDF format. See
  parsing in drivers/gpu/drm/xe/xe_configfs.c:264.
- The driver later looks up the configfs group by constructing the
  canonical BDF name, so a misnamed directory cannot be found and
  settings silently don’t apply. See lookup formatting in
  drivers/gpu/drm/xe/xe_configfs.c:310-311.
- The in-file docs already prescribe canonical names (for example
  0000:03:00.0), reinforcing that non-canonical input is unintended; see
  example path in drivers/gpu/drm/xe/xe_configfs.c:41.

**Fix Details**
- Parsing is relaxed to read numbers generically, then the code
  synthesizes the canonical BDF string and requires an exact match:
  - Replace strict-width `sscanf(name, "%04x:%02x:%02x.%x", ...)` with
    `sscanf(name, "%x:%x:%x.%x", ...)` to get the values.
  - Build the canonical name and enforce exact equality via
    `scnprintf(canonical, ..., "%04x:%02x:%02x.%d", ...)` and
    `strcmp(name, canonical) == 0`. Returns `-EINVAL` if it differs.
- The canonical composition uses `PCI_SLOT(PCI_DEVFN(slot, function))`
  and `PCI_FUNC(...)`, implicitly constraining slot/function to valid
  bit widths and preventing odd encodings from slipping through.
- The change is localized to group creation in
  drivers/gpu/drm/xe/xe_configfs.c:256 (the function where the new
  `canonical` buffer, `scnprintf`, and `strcmp` checks are added).

**User Impact Fixed**
- Prevents creating “broken” directories like 0000:00:02.0000000000000,
  0000:00:02.0x, 0:0:2.0, or with spaces/uppercase hex. Previously these
  were accepted, but the driver’s later lookup (by canonical name) would
  not find them, so configfs settings were ignored.
- With this patch, such inputs fail fast with `-EINVAL` instead of
  failing silently later.

**Risk and Scope**
- Small, contained change to a single function in the Xe configfs code;
  no architectural changes or core subsystem impact.
- Maintains existing error behavior for non-existent devices (`-ENODEV`
  remains).
- Behavior change is strictly tighter validation; correct canonical
  names continue to work. Scripts relying on non-canonical names would
  not have worked reliably anyway (lookups failed), so rejecting them is
  safer.

**Stable Backport Considerations**
- Meets stable criteria: fixes a real user-visible misbehavior (silent
  no-op config), minimal patch size, confined to the Xe driver’s
  configfs path, no API/ABI changes.
- No dependency on other features; headers used (`string.h`, PCI macros)
  are already present. Applies cleanly around
  drivers/gpu/drm/xe/xe_configfs.c:256-266.
- Applicable to stable series that include Xe configfs (the file and
  functions present in this tree: drivers/gpu/drm/xe/xe_configfs.c:256
  and drivers/gpu/drm/xe/xe_configfs.c:310).

In summary, this is a low-risk input validation fix that prevents silent
misconfiguration and aligns behavior with documented usage. It is
suitable for backporting to stable kernels that ship the Xe configfs
interface.

 drivers/gpu/drm/xe/xe_configfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_configfs.c b/drivers/gpu/drm/xe/xe_configfs.c
index 58c1f397c68c9..797508cc6eb17 100644
--- a/drivers/gpu/drm/xe/xe_configfs.c
+++ b/drivers/gpu/drm/xe/xe_configfs.c
@@ -259,12 +259,19 @@ static struct config_group *xe_config_make_device_group(struct config_group *gro
 	unsigned int domain, bus, slot, function;
 	struct xe_config_device *dev;
 	struct pci_dev *pdev;
+	char canonical[16];
 	int ret;
 
-	ret = sscanf(name, "%04x:%02x:%02x.%x", &domain, &bus, &slot, &function);
+	ret = sscanf(name, "%x:%x:%x.%x", &domain, &bus, &slot, &function);
 	if (ret != 4)
 		return ERR_PTR(-EINVAL);
 
+	ret = scnprintf(canonical, sizeof(canonical), "%04x:%02x:%02x.%d", domain, bus,
+			PCI_SLOT(PCI_DEVFN(slot, function)),
+			PCI_FUNC(PCI_DEVFN(slot, function)));
+	if (ret != 12 || strcmp(name, canonical))
+		return ERR_PTR(-EINVAL);
+
 	pdev = pci_get_domain_bus_and_slot(domain, bus, PCI_DEVFN(slot, function));
 	if (!pdev)
 		return ERR_PTR(-ENODEV);
-- 
2.51.0

