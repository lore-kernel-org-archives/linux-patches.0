Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BDF2F5B;
	Sat, 25 Oct 2025 16:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408657; cv=none; b=u1p5xD4ISaPr2+z+thrNfFWsZ0W7EbzaZg6AAfHphBY0nwRCjLnM8x2kVjwfldgmhbJ6ajPMEwhXJJPLizF7Q+diaCli9KQmqu2KsZS2HVJqOxXeTek3VOSgSe7V9fwYvGqBUTyFO41QNxVTEjD7buNn0uRNX4kTG5P3OpKmWWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408657; c=relaxed/simple;
	bh=aZXq0N3f/J8JZOmgJigNLCe89ekNcwrs/zIsNRx6T3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YbSiF1gR/8xey/4UHUiMiY1tLJoGg1Lq1yNPTqSL7JwbhH/r1ivcv9MtX10n+bc/XXqXIMJ1gSctSe/ioIIubGb9cCFZ66nt3tPkzXKu6wZOg1Yg5wUEIGn6N/ZuExescCa1Q+i85QYfdwiGEPPsu1l/c95w3DvGPMAH6TX6nlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIJAwX/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIJAwX/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37109C4CEFB;
	Sat, 25 Oct 2025 16:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408656;
	bh=aZXq0N3f/J8JZOmgJigNLCe89ekNcwrs/zIsNRx6T3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIJAwX/lfrEaVxGZahIufFaRdS4j0sMyaaK+au4UPy2X7/yh6FEJFiyxvBQp18zHR
	 /dUXG8l4/W1hqWNMD92re/epwVeQ29vinpFO/dA2+MLhLcnUr3bOZE/D22D1LE1C78
	 +DzWd9ScIQMvHe/jUm+9Q+ZGYVJ3Z+rcP0aZINPPgtnLRp6YlQ7c19dI1s07WAah1x
	 IZnys4HLc39/ctUTXy1t8iBXU8aVazhr9EetyX98Y9I9ojpffUWDg2FForIimZTytm
	 CJNm25tTjAjlu9niMYUxbe3MvLImyyYrwz2PTUKwmezmmBMT5/sNJR9Vf/x8hQbliY
	 RQL+nZnHsDgLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Palmer <daniel@thingy.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hkallweit1@gmail.com,
	alexander.deucher@amd.com,
	horms@kernel.org,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.10] eth: 8139too: Make 8139TOO_PIO depend on !NO_IOPORT_MAP
Date: Sat, 25 Oct 2025 11:54:24 -0400
Message-ID: <20251025160905.3857885-33-sashal@kernel.org>
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

From: Daniel Palmer <daniel@thingy.jp>

[ Upstream commit 43adad382e1fdecabd2c4cd2bea777ef4ce4109e ]

When 8139too is probing and 8139TOO_PIO=y it will call pci_iomap_range()
and from there __pci_ioport_map() for the PCI IO space.
If HAS_IOPORT_MAP=n and NO_GENERIC_PCI_IOPORT_MAP=n, like it is on my
m68k config, __pci_ioport_map() becomes NULL, pci_iomap_range() will
always fail and the driver will complain it couldn't map the PIO space
and return an error.

NO_IOPORT_MAP seems to cover the case where what 8139too is trying
to do cannot ever work so make 8139TOO_PIO depend on being it false
and avoid creating an unusable driver.

Signed-off-by: Daniel Palmer <daniel@thingy.jp>
Link: https://patch.msgid.link/20250907064349.3427600-1-daniel@thingy.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - With `CONFIG_8139TOO_PIO=y`, the driver prefers mapping the I/O port
    BAR via `pci_iomap()` in `rtl8139_init_board()` and errors out if it
    fails, without falling back from a PIO failure:
    - Mapping call and failure path:
      drivers/net/ethernet/realtek/8139too.c:754
    - `pci_iomap()` delegates to `pci_iomap_range()` which uses
      `__pci_ioport_map()` for IO BARs: drivers/pci/iomap.c:29 and
      drivers/pci/iomap.c:51
    - On architectures where `CONFIG_HAS_IOPORT_MAP=n` and
      `CONFIG_NO_GENERIC_PCI_IOPORT_MAP=n`, `__pci_ioport_map()` is a
      NULL macro, making IO BAR mapping always fail: include/asm-
      generic/pci_iomap.h:28
    - Result: driver logs “cannot map PIO” and returns `-ENODEV` when
      PIO is selected (no fallback from a PIO failure), making the
      driver unusable on those platforms.

- What the change does
  - Kconfig change: `8139TOO_PIO` now depends on `!NO_IOPORT_MAP` so the
    PIO option is hidden when the architecture declares no I/O-port
    mapping at all:
    - Changed line: drivers/net/ethernet/realtek/Kconfig:61
  - This avoids creating an impossible configuration (PIO on platforms
    that cannot map PCI IO space), ensuring the driver uses the MMIO
    path instead (which is the default when `CONFIG_8139TOO_PIO` is not
    set).

- Why it’s a good stable candidate
  - Bug impact: Prevents a user-facing driver init failure (unusable
    NIC) on several architectures (e.g., m68k, arm64, etc.) that set
    `NO_IOPORT_MAP` or otherwise disable I/O port mapping.
  - Scope: One-line Kconfig dependency change; no code or architectural
    changes.
  - Risk: Minimal. On platforms with I/O port mapping, behavior is
    unchanged. On platforms without it, the broken PIO option is simply
    not selectable, and the driver will use MMIO.
  - Compatibility: On older stable trees lacking `NO_IOPORT_MAP`, the
    dependency becomes a no-op (`!NO_IOPORT_MAP` evaluates true if
    undefined), so it won’t break Kconfig.

- Technical linkage to the failure
  - `pci_iomap_range()` returns `__pci_ioport_map()` for IO BARs:
    drivers/pci/iomap.c:51
  - `__pci_ioport_map()` is NULL when `!CONFIG_HAS_IOPORT_MAP &&
    !CONFIG_NO_GENERIC_PCI_IOPORT_MAP`: include/asm-
    generic/pci_iomap.h:28
  - 8139too sets `bar = !use_io;` so when PIO is selected it maps the IO
    BAR first and fails without PIO→MMIO fallback:
    drivers/net/ethernet/realtek/8139too.c:754

Given this is a small, contained Kconfig fix preventing an unusable
configuration and enabling a working MMIO fallback, it fits stable
backport criteria.

 drivers/net/ethernet/realtek/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/Kconfig b/drivers/net/ethernet/realtek/Kconfig
index fe136f61586fe..272c83bfdc6ce 100644
--- a/drivers/net/ethernet/realtek/Kconfig
+++ b/drivers/net/ethernet/realtek/Kconfig
@@ -58,7 +58,7 @@ config 8139TOO
 config 8139TOO_PIO
 	bool "Use PIO instead of MMIO"
 	default y
-	depends on 8139TOO
+	depends on 8139TOO && !NO_IOPORT_MAP
 	help
 	  This instructs the driver to use programmed I/O ports (PIO) instead
 	  of PCI shared memory (MMIO).  This can possibly solve some problems
-- 
2.51.0

