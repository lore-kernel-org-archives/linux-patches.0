Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBD530BF69;
	Sat, 12 Sep 2026 14:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223205; cv=none; b=p5Wm4XRMFVFMWadKxYOp9YTFYlWmr2vB3H5smqc6FZTkUhVn9qVf40VpUDx0VZ0t7J/bZvPmJNmwUwivn+/q2PGQfPDoBBZSfHavsLqGH6X3z8yZkmuyKIeQn7kv9+ND0aFw2Lscyhy8jW4v97XP9W1xN+eb5gXwLRsji/rsE1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223205; c=relaxed/simple;
	bh=wlmP9rdbU0Smf3zE4KbG+KeOvRk/PtIYn4qzMjQxRrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cT92Q8vN/Hhf2asRC+1gNHSVw9P0wxcTbOqJeZsw7dUm6PyDPjkKNGdQS3JotNz5mkdRP5prX00qzCebywe3HIIbS21rceOS/dL+FDvfN4izZXd4+5P0SfkmaJPxoqiuhVVdcKFx1JHatBUVf6Rmmwkw/OxG/oRrHAOp658ZC2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKeLZeIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKeLZeIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1781F000FF;
	Sat, 12 Sep 2026 14:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223204;
	bh=VgdA0iENcfNZD+beDNwF8eGfdX6rzbQMa1aHnGn/iW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKeLZeIikM9JMIDIW6kkHEVyax8imHVsXp3NsawnVEL19oYqzxrVdfWlgB3kNKsuE
	 6OIeVeys/3gH0Jj/Y7xNXAKPXsSrlsnvHkRu7s5el0KU7KoISMy7sLV9w3XVRE8xIK
	 6HyDI1ZGPEhSwANqUC4aEUgMEPocDWRnKX7Ibtlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0742/1424] cxl/pci: Honor -EPROBE_DEFER from component register setup
Date: Sat, 12 Sep 2026 08:52:54 +0200
Message-ID: <20260912065623.915098478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 430c502c80e542e77bcf97db13ec0e8cdf9addb0 ]

cxl_pci_setup_regs() for CXL_REGLOC_RBI_COMPONENT can return
-EPROBE_DEFER on a Restricted CXL Host (RCD) when the upstream port
has not yet been enumerated and the Component Registers must be
extracted from the RCRB. cxl_pci_probe() treats every non-zero return
from that call as the benign "component registers not found" case,
logs a warning, and continues. The rc is then immediately overwritten
by the subsequent cxl_pci_type3_init_mailbox() call, so the deferral
is silently swallowed.

Return -EPROBE_DEFER instead of continuing so the probe is retried
once the upstream port is available.

Fixes: 733b57f262b0 ("cxl/pci: Early setup RCH dport component registers from RCRB")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-cxl/ajzhsubot_PSYtHQ@MWDK4CY14F/T/#m063bbf76b1c9c293ade52ab311018ae6bba11a44
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://lore.kernel.org/linux-cxl/ajzhsubot_PSYtHQ@MWDK4CY14F/T/#m063bbf76b1c9c293ade52ab311018ae6bba11a44
Link: https://patch.msgid.link/20260706224322.714934-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/pci.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 6a6ab285034b9..3482f95e0b468 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -827,10 +827,13 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	cxlds->component_reg_phys = CXL_RESOURCE_NONE;
 	rc = cxl_pci_setup_regs(pdev, CXL_REGLOC_RBI_COMPONENT,
 				&cxlds->reg_map);
-	if (rc)
+	if (rc) {
+		if (rc == -EPROBE_DEFER)
+			return rc;
 		dev_warn(&pdev->dev, "No component registers (%d)\n", rc);
-	else if (!cxlds->reg_map.component_map.ras.valid)
+	} else if (!cxlds->reg_map.component_map.ras.valid) {
 		dev_dbg(&pdev->dev, "RAS registers not found\n");
+	}
 
 	cxlds->component_reg_phys = cxlds->reg_map.resource;
 
-- 
2.53.0



