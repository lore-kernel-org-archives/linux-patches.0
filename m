Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E27191F98;
	Mon, 25 Aug 2025 12:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756124120; cv=none; b=EWkVJJlKoA5pKVo47/fhSIqTcDg2n2DBY80yAQQSatJjxlS9oW1Jobn16Gs8XOu2LngVFn1gQImiiCjvPL58y1m7FIIeHUO9RKC6/4YgdOKVMDn7VO2abg4ZIPB8bdoO4BTQoMgL0cha1ceXwJQhqqPn1rGv5gET/kisJixi8Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756124120; c=relaxed/simple;
	bh=1QGRsEo66IOLAl27ZYz4WbYkww2GeOt4TDdgKWpNGTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/0kih/7HIVcDj1BJ44uKftRnikNPjwcOqaFJa5AyFm81FHkDvv/Zr0OmFWGtpBvRiAnave9yVO0hSRrslM2wEJkVNR7jYN8ffJ2H/Jbwwdk5gc1abtMcqLMdQuFrL+q58rDQJhppUFfkEzTzKsQEDdp9ClUtBKtm9SmbvXSgrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJC5W7ZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJC5W7ZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38128C113D0;
	Mon, 25 Aug 2025 12:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756124120;
	bh=1QGRsEo66IOLAl27ZYz4WbYkww2GeOt4TDdgKWpNGTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJC5W7ZXM/uDSwfhN+HhpVeD0fYyRFSY0003x06OBx30tqqFvf+Ypd/adjg+zmcmo
	 KYCw6fHPDJPH46/Uzwdje8SvnH7C543mKonPwqz8NFB4kDV65ewZRYBftvJHtT7q6g
	 zJ76FPvZGG307NVPW1/Qlo4tl7jj1/LTTkfM8isFK1RHUZrMjbbJumiqVpT6ZVyqpt
	 lPKoWDFsSedCJcncBGKPTsXlxfxdSrWG4oF0WvUI3CNspkOSnf/WDEdUIDLCpFO5yq
	 R9gVIT1fIYfZT4cyUEvcbDYULR2jxsxNVvmqCNi1Z3zbl2HVi5D21pVTNkY9+cTdwe
	 M/QEOdiHyoYOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.1] Bluetooth: hci_sync: Avoid adding default advertising on startup
Date: Mon, 25 Aug 2025 08:14:58 -0400
Message-ID: <20250825121505.2983941-9-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250825121505.2983941-1-sashal@kernel.org>
References: <20250825121505.2983941-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Li <yang.li@amlogic.com>

[ Upstream commit de5d7d3f27ddd4046736f558a40e252ddda82013 ]

list_empty(&hdev->adv_instances) is always true during startup,
so an advertising instance is added by default.

Call trace:
  dump_backtrace+0x94/0xec
  show_stack+0x18/0x24
  dump_stack_lvl+0x48/0x60
  dump_stack+0x18/0x24
  hci_setup_ext_adv_instance_sync+0x17c/0x328
  hci_powered_update_adv_sync+0xb4/0x12c
  hci_powered_update_sync+0x54/0x70
  hci_power_on_sync+0xe4/0x278
  hci_set_powered_sync+0x28/0x34
  set_powered_sync+0x40/0x58
  hci_cmd_sync_work+0x94/0x100
  process_one_work+0x168/0x444
  worker_thread+0x378/0x3f4
  kthread+0x108/0x10c
  ret_from_fork+0x10/0x20

Link: https://github.com/bluez/bluez/issues/1442
Signed-off-by: Yang Li <yang.li@amlogic.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Analysis

The commit fixes a **logic error** in `hci_powered_update_adv_sync()`
that causes unnecessary default advertising instance creation during
Bluetooth startup. The problematic code at line 3290 uses an OR
condition:

```c
if (hci_dev_test_flag(hdev, HCI_ADVERTISING) ||
    list_empty(&hdev->adv_instances))
```

This condition is **always true** during startup because
`list_empty(&hdev->adv_instances)` returns true when the advertising
instances list is initially empty. This causes the code block to execute
unconditionally, creating a default advertising instance even when not
needed.

## The Fix

The patch changes the OR (`||`) to AND (`&&`):

```c
if (hci_dev_test_flag(hdev, HCI_ADVERTISING) &&
    list_empty(&hdev->adv_instances))
```

This ensures the default advertising setup only occurs when:
1. The HCI_ADVERTISING flag is explicitly set, AND
2. There are no advertising instances configured

## Why This Should Be Backported

1. **Clear Bug Fix**: This is a straightforward logic error that causes
   incorrect behavior during Bluetooth initialization. The stack trace
   in the commit message shows this happens during normal startup flow
   (`hci_power_on_sync` → `hci_powered_update_sync` →
   `hci_powered_update_adv_sync`).

2. **Small and Contained**: The fix is a single character change (|| to
   &&) that only affects the conditional logic. No architectural changes
   or new features are introduced.

3. **Prevents Resource Waste**: The bug causes unnecessary advertising
   instance creation on every Bluetooth startup, which wastes system
   resources and may interfere with user-configured advertising
   settings.

4. **Low Risk**: The change is minimal and only affects the specific
   condition for creating default advertising. The same pattern
   (checking both flags with AND) is already used in other parts of the
   codebase (e.g., `reenable_adv_sync()` function).

5. **User-Visible Impact**: The issue has an associated BlueZ bug report
   (#1442), indicating real users are affected by this problem.

6. **Long-Standing Issue**: The problematic code was introduced in
   commit cf75ad8b41d2a (October 2021), meaning this bug has been
   affecting users for an extended period across multiple kernel
   versions.

The fix follows stable kernel rules perfectly: it's a important bugfix
with minimal code change and very low regression risk, making it an
ideal candidate for stable backporting.

 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 7938c004071c..795952d5f921 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3344,7 +3344,7 @@ static int hci_powered_update_adv_sync(struct hci_dev *hdev)
 	 * advertising data. This also applies to the case
 	 * where BR/EDR was toggled during the AUTO_OFF phase.
 	 */
-	if (hci_dev_test_flag(hdev, HCI_ADVERTISING) ||
+	if (hci_dev_test_flag(hdev, HCI_ADVERTISING) &&
 	    list_empty(&hdev->adv_instances)) {
 		if (ext_adv_capable(hdev)) {
 			err = hci_setup_ext_adv_instance_sync(hdev, 0x00);
-- 
2.50.1

