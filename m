Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552D43446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302114; cv=none; b=TbCVhj2KrYFDjE/RiOFl3TBMmVDs5sud5/dN03P11+Y+uikVPFMb7XcXDZE0p+QZLl/BvR9MlnyZbNZcQdOdYkU7oFLFJS9MAgg/e4MJJLpp/EKsSTVl9F/8qkQ1uj+e3AOI5mW3uCap5Wy9fMe35Qu0f3ZA0Yp5oPf3C9WMK5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302114; c=relaxed/simple;
	bh=CSaT2j1UG4Iqo9SlO+p0XxC0+JRFwnnk3jdZVNYi18s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsBSG0cGplEOw120+/BbE01pFR4jPqGM7ESeNjSM2ahRSAvwTL0mKw8bGYSbIwIYy/25pUKK916XQwCJMzG7PJZHKAgfvomf7Q6QrhG3JPbE3FtpjB9E4+wblhFjVrCBpM9p/pszyGDPycuVWukKCdVBr/5lMaHoJmOyXDscDIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hp77RvYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hp77RvYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66AAC19423;
	Sat, 28 Feb 2026 18:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302114;
	bh=CSaT2j1UG4Iqo9SlO+p0XxC0+JRFwnnk3jdZVNYi18s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hp77RvYmEwG4PZoaKZtAQc4LMT6AoEb/kbZuf8Ejb8FQlIL3VvqL3AnezsSOrdf2T
	 monDlgW4GmyYJdXCS/mOLgJfeobCQWCGL7dwWg6xPBjHPzzeEKNtGU6Rh3KdRj4mnt
	 BSAtNd6DG3bnuJ5sRcmJg1sKBDbdJRKJhq1X8T4Z6VAsHAnOw7sJ9KIWNtEJqm53/E
	 6MT15YMODQAkt6+R+UjXbo0Sjy1vLxJF7QeirBuQGKjcVpRJk98ODsbHOwP/+3/fM3
	 PhtcUapSiIB7Zng+5dOtZhonJFKQPLM4nlYV11MvjYRXJpvfE6wUyNYMo0yO0vnCdE
	 6iwNxhINr7hMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Brian Norris <briannorris@google.com>,
	Brian Norris <briannorris@chromium.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/283] PCI/PM: Avoid redundant delays on D3hot->D3cold
Date: Sat, 28 Feb 2026 13:04:05 -0500
Message-ID: <20260228180709.1583486-103-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Brian Norris <briannorris@google.com>

[ Upstream commit 4d982084507d663df160546c4c48066a8887ed89 ]

When transitioning to D3cold, __pci_set_power_state() first transitions to
D3hot. If the device was already in D3hot, this adds excess work:

  (a) read/modify/write PMCSR; and
  (b) excess delay (pci_dev_d3_sleep()).

For (b), we already performed the necessary delay on the previous D3hot
entry; this was extra noticeable when evaluating runtime PM transition
latency.

Check whether we're already in the target state before continuing.

Note that __pci_set_power_state() already does this same check for other
state transitions, but D3cold is special because __pci_set_power_state()
converts it to D3hot for the purposes of PMCSR.

This seems to be an oversight in commit 0aacdc957401 ("PCI/PM: Clean up
pci_set_low_power_state()").

Fixes: 0aacdc957401 ("PCI/PM: Clean up pci_set_low_power_state()")
Signed-off-by: Brian Norris <briannorris@google.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
[bhelgaas: reverse test to match other "dev->current_state == state" cases]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251003154008.1.I7a21c240b30062c66471329567a96dceb6274358@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 9a3f6bb60eb4d..2f6c5bf2ae2f5 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1427,6 +1427,9 @@ static int pci_set_low_power_state(struct pci_dev *dev, pci_power_t state, bool
 	   || (state == PCI_D2 && !dev->d2_support))
 		return -EIO;
 
+	if (dev->current_state == state)
+		return 0;
+
 	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
 	if (PCI_POSSIBLE_ERROR(pmcsr)) {
 		pci_err(dev, "Unable to change power state from %s to %s, device inaccessible\n",
-- 
2.51.0

