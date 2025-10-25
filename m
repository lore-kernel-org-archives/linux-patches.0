Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A503112AD;
	Sat, 25 Oct 2025 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409704; cv=none; b=LSJIuT8jLscz26RtS0zMuR+l1SI6V92rt7Gb/Ag1VZpKoJ+UXyMDr2ZatrQI5LP271YJyNZ4HDyytIFgMDGbRdLE4E/8oxyapqIuctbJ9H2ymQ2dHomPS2unvyoiDQzWo3653ZK3Qy5lZDuhUMhbeGhTbO7uOFvAiePHuC9wppM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409704; c=relaxed/simple;
	bh=NxAJjRQ5XZukhLLPW9DdM8UWn1dj4M611C9t9qZPwcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgwaQ2xCKYhqw0d7vsHVVMgwzir0/w9ILgjpNsUmfngv4Z2kOOYIAYUEuxTHDeuC545Ie+GLkloxuC3Jrea8P+6K7SGeX6oAbm0JKqpi9r9EyjgB09KbJz3X5UBmsbks2F5Ve8vHpc6dWHT2U9jxzeUSe56BD24GYM0DC0VXb8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oXeB67PS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oXeB67PS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D30C4CEFB;
	Sat, 25 Oct 2025 16:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409704;
	bh=NxAJjRQ5XZukhLLPW9DdM8UWn1dj4M611C9t9qZPwcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXeB67PS5rCwGDqvwlHXIRk7PmWMAUPXmCgyGAQqpsx3ftmP4BmqOKOCA6jgnWOVc
	 k7QfsjtNDbhas4/uaMB9uhMlk5lQO55jFP0GluYcBRMwml+MfKImwm1TnnjYvPIxqJ
	 zJ0ezQhNG9UTtLKJ++8t9BFkVoLpjcVhILaDwWJTNwXkVSzPAHY+gaRhKOMusYyWRj
	 lZQIeIFRVW/u8sO8QATXFZqSjT43QaXXJ1G6f9yPaMtPKNut4uMeTNSssARxyGdnjW
	 faTeZtXuUYXSto7a4MBpXyFbeXDK/pSEPUpaEon5bZWxGiIoUBjtZlt1wEBBcx9IuJ
	 Ye5CaN03Q5IcA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vernon Yang <yanglincheng@kylinos.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	mahesh@linux.ibm.com,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.17] PCI/AER: Fix NULL pointer access by aer_info
Date: Sat, 25 Oct 2025 12:00:59 -0400
Message-ID: <20251025160905.3857885-428-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Vernon Yang <yanglincheng@kylinos.cn>

[ Upstream commit 0a27bdb14b028fed30a10cec2f945c38cb5ca4fa ]

The kzalloc(GFP_KERNEL) may return NULL, so all accesses to aer_info->xxx
will result in kernel panic. Fix it.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250904182527.67371-1-vernon2gm@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**Why It Matters**
- Prevents a NULL pointer dereference and kernel panic during device
  enumeration when `kzalloc(GFP_KERNEL)` fails in AER initialization.
  This is a real bug users can hit under memory pressure and affects any
  kernel with `CONFIG_PCIEAER` enabled.

**Change Details**
- Adds a NULL check after allocating `dev->aer_info` and returns early
  on failure, resetting `dev->aer_cap` to keep state consistent:
  - drivers/pci/pcie/aer.c:395
  - drivers/pci/pcie/aer.c:396
  - drivers/pci/pcie/aer.c:397
- The dereferences that would otherwise panic immediately follow the
  allocation (ratelimit initialization), so without this guard, OOM
  leads to instant crash:
  - drivers/pci/pcie/aer.c:401
  - drivers/pci/pcie/aer.c:403

**Consistency With AER Flows**
- Resetting `dev->aer_cap` to 0 on allocation failure is correct and
  keeps all AER-related code paths coherent:
  - Save/restore explicitly no-op when `aer_cap == 0`, avoiding config
    space accesses:
    - drivers/pci/pcie/aer.c:349
    - drivers/pci/pcie/aer.c:371
  - AER enablement and ECRC setup get skipped because AER is treated as
    unavailable:
    - drivers/pci/pcie/aer.c:417 (enable reporting)
    - drivers/pci/pcie/aer.c:420 (ECRC)
    - ECRC helpers themselves also gate on `aer_cap`:
      - drivers/pci/pcie/aer.c:164
      - drivers/pci/pcie/aer.c:188
- Sysfs attributes that unconditionally dereference `pdev->aer_info` are
  already hidden when `aer_info == NULL`:
  - Visibility gating for stats attrs checks `pdev->aer_info`:
    - drivers/pci/pcie/aer.c:632
  - Visibility gating for ratelimit attrs checks `pdev->aer_info`:
    - drivers/pci/pcie/aer.c:769
- AER initialization is called during capability setup for every device;
  avoiding a panic here is critical:
  - drivers/pci/probe.c:2671

**Risk and Side Effects**
- Impact is limited and defensive:
  - On allocation failure, AER features are disabled for that device
    (graceful degradation) instead of panicking.
  - No architectural changes; no ABI changes; minimal lines touched.
  - All later AER users already handle `aer_info == NULL` and/or
    `aer_cap == 0` via existing guards.
- Side effects are intentional and safe:
  - Port driver IRQ message number programming for AER is skipped if
    `aer_cap == 0`, consistent with AER being unavailable:
    - drivers/pci/pcie/portdrv.c:81
    - drivers/pci/pcie/portdrv.c:242

**Stable Criteria**
- Fixes a real crash bug that can affect users (OOM during enumeration
  or hotplug).
- Small, contained change in a single function.
- No new features or interfaces; no architectural churn.
- Very low regression risk due to consistent gating on
  `aer_cap`/`aer_info`.

Given the clear correctness and robustness benefits with minimal risk,
this is a strong candidate for backporting to stable trees.

 drivers/pci/pcie/aer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 9d23294ceb2f6..3dba9c0c6ae11 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -383,6 +383,10 @@ void pci_aer_init(struct pci_dev *dev)
 		return;
 
 	dev->aer_info = kzalloc(sizeof(*dev->aer_info), GFP_KERNEL);
+	if (!dev->aer_info) {
+		dev->aer_cap = 0;
+		return;
+	}
 
 	ratelimit_state_init(&dev->aer_info->correctable_ratelimit,
 			     DEFAULT_RATELIMIT_INTERVAL, DEFAULT_RATELIMIT_BURST);
-- 
2.51.0

