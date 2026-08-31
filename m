Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F60569F04;
	Mon, 31 Aug 2026 13:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184096; cv=none; b=ez2DQ7ZvMhG8CRfqdA3sIm4W2DZaCtBm/v+TO9o2GY84sYbycyqYSS4f0iHUVgjox19PoYkWxbknXS8wEMYH8tnoXJV9eF64qb2nOOZ2pXaHBqbevNzSwnIaHobjZWu33FE7v1xdDBQiVm+rSidm56IJiirYMvaSfeaixt7L4J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184096; c=relaxed/simple;
	bh=fo6imM0kOQ9b6a47jD0yh3LdiTX6ixn4JSZbN5L6+e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fjRM3BG4hRIxdG1wRWvrFJ1HUxQZHJrb0w5suOWL7uBTgHCAjuWfm4Lyqt8juB2mnX/PADfMnyVVqTh0QyJqOc/IG02mAMgIO7clAwIdT1NyLgSkllKAyzMDs/OgDpN2CEV+Tdq9qk/vWCA3X3ZVspDPDTFTQJl582AvRSIBPVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gh/4OqGl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gh/4OqGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D081F000E9;
	Mon, 31 Aug 2026 13:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184094;
	bh=Z3tzq0qReqmXZj/+HwH5KtJrf3hrtJ1YIavqbcx2hI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gh/4OqGlWbGGN+p1CJcyCUByBWmU2/HIdHNsJ+S70UbZG0wkhC2TiHaWx220/SPxe
	 lYk/r7za3tGtoq0gtyHxEgaxsJYW6QnhWZy/3GJKwdDwEMSv7HIDkQJeecJDcQVf7e
	 qVb2iz6ZicCZ9KsagEnNhIaCutVEFIC/H/Eq3hLD6LMej9r3x3ghZ5EqZ4MEOfbktz
	 Msgvsgk/69S+yj4sNssT38r/f6oclbLNHoc1WL/gxXvGgH9zzqzHx4GLKr4hDyzM3+
	 /XlL96HDwPeEQbaNdvr7UYp4DIs7RphyIcZchMDMH/x15+nAx1gW+PjQ0ecqnNicNj
	 73kXdAdlUlcdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] PCI/sysfs: Add CAP_SYS_ADMIN check to __resource_resize_store()
Date: Mon, 31 Aug 2026 09:28:35 -0400
Message-ID: <20260831133314.4125787-487-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit 25ec7f57deceec633f27bc93b615f951e2ade814 ]

Currently, the __resource_resize_store() allows writing to the
resourceN_resize sysfs attribute to change a BAR's size without checking
for capabilities, currently relying only on the file access check.

Resizing a BAR modifies PCI device configuration and can disrupt active
drivers.  After the upcoming conversion to static attributes, it will also
trigger resource file updates via sysfs_update_groups().

Add a CAP_SYS_ADMIN check to prevent unprivileged users from performing BAR
resize operations.

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20260508043543.217179-6-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background searches finished. Here’s what they turned up:

- **`b4 dig`** — Exited successfully but produced no output. The fix
  isn’t in this checkout, and `b4 dig` needs a commit hash, so the lore
  thread wasn’t resolved that way. Patch context came from the local v7
  mbox and Patchwork mirrors instead.
- **Git history (`resourceN_resize` / `__resource_resize_store`)** — In
  this shallow 6.18.43 tree, both only surface as merge commit
  `5d324e5159d9e`; the original introduction isn’t reachable here. The
  ABI doc (September 2022) is the best dating we have for when the sysfs
  interface landed.

That doesn’t change the earlier conclusion: the missing `CAP_SYS_ADMIN`
check is present in this tree, the fix is small and standalone, and the
backport recommendation remains **YES** for 6.18.y.

 drivers/pci/pci-sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index edb9bc34c0c58..990994db752ab 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1575,6 +1575,9 @@ static ssize_t __resource_resize_store(struct device *dev, int n,
 	int ret;
 	u16 cmd;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (kstrtoul(buf, 0, &size) < 0)
 		return -EINVAL;
 
-- 
2.53.0

