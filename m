Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E127932A3FD;
	Wed,  8 Apr 2026 18:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673171; cv=none; b=W99zbFfqyaVk4gMR8gaseOt7E3ysZ8OfQGDEoYZjyKb6WLjnjzz4C4jXLgIif6K21HXNMsflqA5MIBn39biL7DdlxUhJB925Zgnjn9mxHQbjzrVmkFYmFZ1J5RAjzVLjfhrz789kBea0feVknTDqSNuwKqMGyihlbWpU0Rc6HvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673171; c=relaxed/simple;
	bh=V/OXbf89/Q8FMXM0AK1eiDqS0ndRLl7Ihgbu1VGqpGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kayMZjF99TUpVcfhrIJu0pGnqZ/n3amRo0rQVQ3LI7T93c1RSNsinzrrYL6G5CPEMsnqA/Q5Vi9PT4jJevUZjXYaY8BPKuTmRxwT84InuXhy1N/0JASR+ssmu1a+rMmifOyMrd5ItD+I6u2qGgmp5DX6AWfo/dWqBc8GtPwPnbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJgcyER3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJgcyER3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F06CC19421;
	Wed,  8 Apr 2026 18:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673170;
	bh=V/OXbf89/Q8FMXM0AK1eiDqS0ndRLl7Ihgbu1VGqpGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJgcyER3aJ4rrE4FIIpMvWWR4SUmLUyMFlmvz9hW8OEDstOlLE36XPgjwCKgsCeOE
	 k2/YmpTkIfgUbDjJJXXfM5wXDuVhKuEJIht1jEEmuUV1dOmt7tvvDzDWcOMQKypyt0
	 rJVMd8wtmzhiZ/Rx/9r8A39U+H6eWQmhjv9XICis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil V L <sunilvl@oss.qualcomm.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 128/277] ACPI: RIMT: Add dependency between iommu and devices
Date: Wed,  8 Apr 2026 20:01:53 +0200
Message-ID: <20260408175938.654992212@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil V L <sunilvl@oss.qualcomm.com>

[ Upstream commit 9156585280f161fc1c3552cf1860559edb2bb7e3 ]

EPROBE_DEFER ensures IOMMU devices are probed before the devices that
depend on them. During shutdown, however, the IOMMU may be removed
first, leading to issues. To avoid this, a device link is added
which enforces the correct removal order.

Fixes: 8f7729552582 ("ACPI: RISC-V: Add support for RIMT")
Signed-off-by: Sunil V L <sunilvl@oss.qualcomm.com>
Link: https://patch.msgid.link/20260303061605.722949-1-sunilvl@oss.qualcomm.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/riscv/rimt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/riscv/rimt.c b/drivers/acpi/riscv/rimt.c
index 7f423405e5ef0..8eaa8731bddd6 100644
--- a/drivers/acpi/riscv/rimt.c
+++ b/drivers/acpi/riscv/rimt.c
@@ -263,6 +263,13 @@ static int rimt_iommu_xlate(struct device *dev, struct acpi_rimt_node *node, u32
 	if (!rimt_fwnode)
 		return -EPROBE_DEFER;
 
+	/*
+	 * EPROBE_DEFER ensures IOMMU is probed before the devices that
+	 * depend on them. During shutdown, however, the IOMMU may be removed
+	 * first, leading to issues. To avoid this, a device link is added
+	 * which enforces the correct removal order.
+	 */
+	device_link_add(dev, rimt_fwnode->dev, DL_FLAG_AUTOREMOVE_CONSUMER);
 	return acpi_iommu_fwspec_init(dev, deviceid, rimt_fwnode);
 }
 
-- 
2.53.0



