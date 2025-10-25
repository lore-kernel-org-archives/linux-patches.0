Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70483043C9;
	Sat, 25 Oct 2025 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408764; cv=none; b=KqM0BmUttoJe/nykXp3BG4SRXzCArTO0auBLWicSBuGqNPL5Kv1wX6NMZ+tprnCyK+RW3uPv9sNpdDyMdwjAwaOxCcWKFhYeJWub2Rth5tf5Xdwaho5H7oo13E6cQB6ibhrdNFBSqClewl9/2F/fsZIRXyXhyo5xMUIG0ZuxDs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408764; c=relaxed/simple;
	bh=3LXAiF2JtBMwwxpZP8qUy/JTlv3WWQEh4ANzwTdOu3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bTDEKAnKSEzkDcE72VR+6gjyKgD2ChmODBCqi6Vvb+rkMR8d78dB0aZPbdS8Jmw0KXdGuDYP9SMc5pVUyWWGthAtQDS8xTgCF07jJALDDuiVbjna/7zR656RKuqQJvDQUs3mLZ0gEa56RaraxIp3fHqcyCgy2KrT09wP/3NlSik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uIYjjUr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uIYjjUr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB82C4CEFF;
	Sat, 25 Oct 2025 16:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408764;
	bh=3LXAiF2JtBMwwxpZP8qUy/JTlv3WWQEh4ANzwTdOu3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIYjjUr6AJEX19HjXyEp4NdKEcVuhDmkdPRWxd/7lbWpOfcHctEFCH+29GkUV/w7y
	 2wlZ8GDViVJqxLa8wR3C2ZnN5R08FVJU8gkQeBvXpHYOG/Ixy9+SNwDQHTSZ3VtPdC
	 0T5O3U9lZjaDz2w7OoRLH3xDeincXh93at9k9JpNiDUWGX11hSAwdgwdDWoCJfAgKo
	 eYLo4uGO8u7Q+AQ2rupTowWqV/AR/lfcpP1RCbPvraxvXxskFkoSlY3cDRNubabada
	 n6WQAYlfJFbOZgBLC2KLghX5baADw9urffSKeKhJdVbAsywjMAZxIqOX20XgqlErDH
	 ymDCxshzQ9xHQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.6] char: misc: Make misc_register() reentry for miscdevice who wants dynamic minor
Date: Sat, 25 Oct 2025 11:54:55 -0400
Message-ID: <20251025160905.3857885-64-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 52e2bb5ff089d65e2c7d982fe2826dc88e473d50 ]

For miscdevice who wants dynamic minor, it may fail to be registered again
without reinitialization after being de-registered, which is illustrated
by kunit test case miscdev_test_dynamic_reentry() newly added.

There is a real case found by cascardo when a part of minor range were
contained by range [0, 255):

1) wmi/dell-smbios registered minor 122, and acpi_thermal_rel registered
   minor 123
2) unbind "int3400 thermal" driver from its device, this will de-register
   acpi_thermal_rel
3) rmmod then insmod dell_smbios again, now wmi/dell-smbios is using minor
   123
4) bind the device to "int3400 thermal" driver again, acpi_thermal_rel
   fails to register.

Some drivers may reuse the miscdevice structure after they are deregistered
If the intention is to allocate a dynamic minor, if the minor number is not
reset to MISC_DYNAMIC_MINOR before calling misc_register(), it will try to
register a previously dynamically allocated minor number, which may have
been registered by a different driver.

One such case is the acpi_thermal_rel misc device, registered by the
int3400 thermal driver. If the device is unbound from the driver and later
bound, if there was another dynamic misc device registered in between, it
would fail to register the acpi_thermal_rel misc device. Other drivers
behave similarly.

Actually, this kind of issue is prone to happen if APIs
misc_register()/misc_deregister() are invoked by driver's
probe()/remove() separately.

Instead of fixing all the drivers, just reset the minor member to
MISC_DYNAMIC_MINOR in misc_deregister() in case it was a dynamically
allocated minor number, as error handling of misc_register() does.

Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250714-rfc_miscdev-v6-5-2ed949665bde@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Dynamic-minor misc devices that reuse their `struct miscdevice`
    across probe/remove or unbind/rebind can fail to re-register if
    another device grabs the old dynamically allocated minor in the
    interim. On re-register, the stale `misc->minor` value is treated as
    a static request, returning -EBUSY instead of allocating a fresh
    dynamic minor. This is exactly the failure described for
    `acpi_thermal_rel` when raced with `dell_smbios`.
  - In this tree, `misc_register()` decides dynamic vs. static solely by
    checking `misc->minor == MISC_DYNAMIC_MINOR`
    (drivers/char/misc.c:177). If a previously dynamic device calls
    `misc_register()` with a leftover non-255 minor, it is treated as
    static, and the duplicate check can fail if the number is taken.

- Why the change is correct and minimal
  - The patch resets `misc->minor` back to `MISC_DYNAMIC_MINOR` during
    deregistration, but only if the device had a dynamically allocated
    minor. In the posted diff this appears as:
    - After freeing the minor: `misc_minor_free(misc->minor);`
    - Then reset: `if (misc->minor > MISC_DYNAMIC_MINOR) misc->minor =
      MISC_DYNAMIC_MINOR;`
  - This mirrors existing error handling already present in
    `misc_register()` that restores `misc->minor = MISC_DYNAMIC_MINOR`
    on registration failure (drivers/char/misc.c:214). Making
    deregistration symmetrical is consistent and expected.
  - The change is tiny (two lines), touches only `drivers/char/misc.c`,
    and does not alter any API or architecture.

- Evidence the bug exists here
  - Deregistration frees the dynamic minor bit but does not reset
    `misc->minor` (drivers/char/misc.c:241–251). Thus, the stale minor
    persists across lifecycles.
  - There are in-tree users that reuse a static `struct miscdevice` with
    `.minor = MISC_DYNAMIC_MINOR` across add/remove. Example:
    `acpi_thermal_rel` registers/deregisters a static miscdevice
    (drivers/thermal/intel/int340x_thermal/acpi_thermal_rel.c:359, 369,
    373–375). Unbind/rebind without module unload leaves the static
    object in memory with the old minor value, triggering the re-
    register failure described in the commit message.

- Backport notes
  - Older trees (like this one) use a 64-bit dynamic minor bitmap with
    indices mapped via `i = DYNAMIC_MINORS - misc->minor - 1` and
    `clear_bit(i, misc_minors)` (drivers/char/misc.c:241–250), not
    `misc_minor_free()`. The equivalent backport should reset
    `misc->minor = MISC_DYNAMIC_MINOR` only if the minor was dynamically
    allocated, which can be inferred by the same range check already
    used before clearing the bit:
    - If `i < DYNAMIC_MINORS && i >= 0` then it was a dynamic minor;
      after `clear_bit(i, misc_minors);` set `misc->minor =
      MISC_DYNAMIC_MINOR;`.
  - Newer trees using `misc_minor_free()` may use a different condition
    (as in the diff). Adjust the condition to the tree’s semantics; the
    intent is “if this was a dynamically allocated minor, reset it.”

- Risk assessment
  - Very low risk:
    - Static-minor devices are unaffected.
    - Dynamic-minor devices now always behave as “dynamic” on re-
      register, which is the intended contract.
    - Change is localized, under the same mutex as the rest of the
      deregistration path.
  - Positive impact:
    - Fixes real user-visible failures on unbind/rebind or probe/remove
      cycles.
    - Consistent with `misc_register()` error path behavior
      (drivers/char/misc.c:214).

- Stable criteria
  - Fixes a real bug that affects users (unbind/rebind failures).
  - Small, contained change in a well-scoped subsystem.
  - No new features or architectural changes.
  - Signed-off-by by Greg Kroah-Hartman, matching subsystem ownership.

Given the above, this is a strong candidate for stable backport.

 drivers/char/misc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 558302a64dd90..255a164eec86d 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -282,6 +282,8 @@ void misc_deregister(struct miscdevice *misc)
 	list_del(&misc->list);
 	device_destroy(&misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	misc_minor_free(misc->minor);
+	if (misc->minor > MISC_DYNAMIC_MINOR)
+		misc->minor = MISC_DYNAMIC_MINOR;
 	mutex_unlock(&misc_mtx);
 }
 EXPORT_SYMBOL(misc_deregister);
-- 
2.51.0

