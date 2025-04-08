Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65321269825;
	Tue,  8 Apr 2025 12:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114450; cv=none; b=da9JO8rCTfbaBKk8XHMpEKa+y1/cd+qKImSbBFbdQBebtmaDhUHROSW12zzrzNY8QZe9nNJ1HBvUr/BSbKeQsghO4g4zBtWFK82dUlTy8tGL0mjr6/0TK+ZnPsNuqXaQ96zjK0CcnUSSAi5oFlUccjtiT2y7k1UwST+hLYYUWLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114450; c=relaxed/simple;
	bh=o7kqmC3vJWWfzSVKlWjZE2pb/Lm3A+uRzn6qbqYBObk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mGwS9Z9kEpDbMHbo//B6GA8nMMRW118oi4vbolGi/iK8OEvdsgJUTg+qXyhGMJSp+KO2hxHfeeuFHosLaPikPbmSbUm5bxEJA2yndfZsjM8/h7Hl21hxqq1gWNnGCXrcHbEl8UYFv2BHSSCAK+Kv1p2BcbI7mEDvqa7YUnz0G9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q49QwLNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q49QwLNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E026EC4CEE5;
	Tue,  8 Apr 2025 12:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114450;
	bh=o7kqmC3vJWWfzSVKlWjZE2pb/Lm3A+uRzn6qbqYBObk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q49QwLNyL8xpC15woCq+v/nouxZGyT8f2L32LqIXzZGUGMaVW6UyzHnM7ZKG2HY9N
	 ta0nkXx+m5UNm0TkRlAZANac+Ua1K+BxGRnQdgH2BnDivBCu1xUlVDcptfsZdZJT/A
	 ukZ4tzzUJ9082DuupOdb9xe+uehHYqpoQTRUCK2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 111/499] PCI: pciehp: Dont enable HPIE when resuming in poll mode
Date: Tue,  8 Apr 2025 12:45:23 +0200
Message-ID: <20250408104853.972049725@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 527664f738afb6f2c58022cd35e63801e5dc7aec ]

PCIe hotplug can operate in poll mode without interrupt handlers using a
polling kthread only.  eb34da60edee ("PCI: pciehp: Disable hotplug
interrupt during suspend") failed to consider that and enables HPIE
(Hot-Plug Interrupt Enable) unconditionally when resuming the Port.

Only set HPIE if non-poll mode is in use. This makes
pcie_enable_interrupt() match how pcie_enable_notification() already
handles HPIE.

Link: https://lore.kernel.org/r/20250321162114.3939-1-ilpo.jarvinen@linux.intel.com
Fixes: eb34da60edee ("PCI: pciehp: Disable hotplug interrupt during suspend")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index bb5a8d9f03ad9..28ab393af1c04 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -842,7 +842,9 @@ void pcie_enable_interrupt(struct controller *ctrl)
 {
 	u16 mask;
 
-	mask = PCI_EXP_SLTCTL_HPIE | PCI_EXP_SLTCTL_DLLSCE;
+	mask = PCI_EXP_SLTCTL_DLLSCE;
+	if (!pciehp_poll_mode)
+		mask |= PCI_EXP_SLTCTL_HPIE;
 	pcie_write_cmd(ctrl, mask, mask);
 }
 
-- 
2.39.5



