Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2B5303A19;
	Sat, 25 Oct 2025 16:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408857; cv=none; b=N8kPTZ+f4eOOTcVmQsocqiD+hpwSsVjPyBR9KCGbFPmOveh1L7CR0tLBf9wE3E0IrmflWtxwB9wgA1mzqVpYkOsCXk4rSrzy3YZIqO4tuJ45ne4wityIyhWW5+nnXG0B//qspGBJ6yIbnhZX/miJOqVfjiif5vxUbJphcdWKi94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408857; c=relaxed/simple;
	bh=VmHH8lIgYDVip/MM6JyFqO9yzxs69j23XNtCYR/PGSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C4Yyjgj1GhZyNHcRhYMVsVmqDiaxrdr4Yiq3O2yBkCSIZF2T4ooRJfMpuEFIsjZRfPUXj6mhM82DSVXPcqdX1I5ZzIpfi8S5aUkQq88K2HxJm74c7DVJDVGr8ZTzWjwnHxg9PsNdP3x0LN2E9Z3GVAMwD8SIKNQ5g1BphJHRor0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p/N6y/KG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p/N6y/KG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481F0C4CEF5;
	Sat, 25 Oct 2025 16:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408857;
	bh=VmHH8lIgYDVip/MM6JyFqO9yzxs69j23XNtCYR/PGSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/N6y/KG1kaBy2HCAMjKVgj+KAh/5zc1P1/Pmhjl54RN/RWP79LGnmy9NeLBjwLAh
	 AuRrHQ8H7oX4qYtO/fIapR55W8x/UcP21yYGmYPp2YEgnXyAxLLOVUouIe3GM1t8/J
	 EIvSPWrhikeLQ579ViQFZYashV3WpAanDpwWqlBSOBEk5Hw+mbynALoOf0THQpvYB2
	 aeENZnqURu9k4QHU1GgeejsFfO6CriQ2JHHumK0OrOb6FixSHHkDcI4DM54rj4TTwE
	 fmifdoX+IsVr5OtDvSnpVwmkJndd+bpRlR62Zr1EaHnsOQ2gxdNdb6RF8f4Y6bSIsX
	 EJZH8iqoiYmKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Colin Foster <colin.foster@in-advantage.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	steve.glendinning@shawell.net,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] smsc911x: add second read of EEPROM mac when possible corruption seen
Date: Sat, 25 Oct 2025 11:55:34 -0400
Message-ID: <20251025160905.3857885-103-sashal@kernel.org>
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

From: Colin Foster <colin.foster@in-advantage.com>

[ Upstream commit 69777753a8919b0b8313c856e707e1d1fe5ced85 ]

When the EEPROM MAC is read by way of ADDRH, it can return all 0s the
first time. Subsequent reads succeed.

This is fully reproduceable on the Phytec PCM049 SOM.

Re-read the ADDRH when this behaviour is observed, in an attempt to
correctly apply the EEPROM MAC address.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Link: https://patch.msgid.link/20250903132610.966787-1-colin.foster@in-advantage.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - In `drivers/net/ethernet/smsc/smsc911x.c:2162`,
    `smsc911x_read_mac_address()` now re-reads the MAC high register
    (`ADDRH`) once if the first read returns 0, then uses the second
    value: `drivers/net/ethernet/smsc/smsc911x.c:2168`,
    `drivers/net/ethernet/smsc/smsc911x.c:2174-2177`.
  - The function still reads `ADDRL` once and programs `dev->dev_addr`
    via `eth_hw_addr_set()`:
    `drivers/net/ethernet/smsc/smsc911x.c:2169`,
    `drivers/net/ethernet/smsc/smsc911x.c:2179-2185`.
  - A trace message is added for visibility when the re-read path is
    taken: `drivers/net/ethernet/smsc/smsc911x.c:2175`.

- Why it matters (user-visible bug)
  - The commit fixes a real-world, reproducible issue where reading the
    EEPROM-backed MAC via `ADDRH` can spuriously return all zeros on the
    first attempt (commit message), leading to an incorrect MAC or
    fallback to a random MAC during probe.
  - This behavior is seen on the Phytec PCM049 SoM; without the fix,
    users may get an invalid or non-persistent MAC at boot.

- Scope and containment
  - Change is confined to a single driver and a single function
    (`smsc911x_read_mac_address()`), only affecting initialization-time
    MAC retrieval.
  - Callers invoke this function under `mac_lock` (e.g., pre-reset save
    path `drivers/net/ethernet/smsc/smsc911x.c:2308-2311`, and post-
    registration selection path
    `drivers/net/ethernet/smsc/smsc911x.c:2533-2547`), matching the
    expectation of `smsc911x_mac_read()` that the lock is held
    (`drivers/net/ethernet/smsc/smsc911x.c:492-520`).

- Safety and regression risk
  - The re-read only occurs when `ADDRH` initially returns 0. If a
    device legitimately has a MAC with 0 in the upper two bytes (ending
    in “:00:00”), the second read is harmless and preserves the same
    value.
  - No timing changes beyond one extra register read in a rare path; no
    sleeps are introduced; locking discipline remains unchanged.
  - `smsc911x_mac_read()` returns `0xFFFFFFFF` on busy/error (not 0), so
    the new check won’t mask those failures; the new logic specifically
    addresses the “all zeros on first `ADDRH` read” quirk.
  - No API, UAPI, or architectural changes; only driver-internal logic.
    Minimal chance of regression.

- Impacted flows
  - Early pre-reset MAC preservation when `SMSC911X_SAVE_MAC_ADDRESS` is
    set: `drivers/net/ethernet/smsc/smsc911x.c:2308-2311`.
  - Normal probe-time MAC selection when none is preconfigured:
    `drivers/net/ethernet/smsc/smsc911x.c:2533-2559`, where
    `smsc_get_mac(dev)` invokes the updated function
    `drivers/net/ethernet/smsc/smsc911x.h:404`.

- Stable backport criteria
  - Fixes an initialization-time correctness bug affecting real
    hardware.
  - Small, targeted change with trivial logic and very low risk.
  - No new features or architectural shifts; contained to one driver
    file.
  - Improves reliability in a way users will notice (correct MAC vs.
    random/invalid).

Given the user-visible bug, minimal risk, and tight scope, this is a
good candidate for stable backport.

 drivers/net/ethernet/smsc/smsc911x.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 6ca290f7c0dfb..3ebd0664c697f 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -2162,10 +2162,20 @@ static const struct net_device_ops smsc911x_netdev_ops = {
 static void smsc911x_read_mac_address(struct net_device *dev)
 {
 	struct smsc911x_data *pdata = netdev_priv(dev);
-	u32 mac_high16 = smsc911x_mac_read(pdata, ADDRH);
-	u32 mac_low32 = smsc911x_mac_read(pdata, ADDRL);
+	u32 mac_high16, mac_low32;
 	u8 addr[ETH_ALEN];
 
+	mac_high16 = smsc911x_mac_read(pdata, ADDRH);
+	mac_low32 = smsc911x_mac_read(pdata, ADDRL);
+
+	/* The first mac_read in some setups can incorrectly read 0. Re-read it
+	 * to get the full MAC if this is observed.
+	 */
+	if (mac_high16 == 0) {
+		SMSC_TRACE(pdata, probe, "Re-read MAC ADDRH\n");
+		mac_high16 = smsc911x_mac_read(pdata, ADDRH);
+	}
+
 	addr[0] = (u8)(mac_low32);
 	addr[1] = (u8)(mac_low32 >> 8);
 	addr[2] = (u8)(mac_low32 >> 16);
-- 
2.51.0

