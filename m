Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A2626773A;
	Tue,  8 Apr 2025 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112686; cv=none; b=Txm1JLVs0LTVdiey5OYgXA+Vuk6rspU/sPw4pn39EfbrDLl2yBXeLJoP4F/YLl1nLZbDcQrGidi+pbmGMX7nla7f10Fvxye13CBqQhzZd+F+olxPp0XkEB9lBxvGETC8O9TtK+eS/A1XW4+SBDsSQurGX4FJo/5+vblsf7H+iYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112686; c=relaxed/simple;
	bh=mVo6PEmIgSZ1pZo1hDXS5senkLFLCWPGL8Wa9uExo8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUJ44uwUg31sRgmgTMPqFYqi/x6Ma4s4sxfKneYtsUZvAeNzeGad2+4g1HRcN+rC/4RmwGlm+KY3myp8U49/Gmur+PEhXF7o2nPcrqeW14al80lFTiCMuKcV83FW0qekPa373LlGYYWSNQh/Jek5Ew84QjbKbPNBaHurvesDT6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoF1TsFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoF1TsFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EA5C4CEE5;
	Tue,  8 Apr 2025 11:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112686;
	bh=mVo6PEmIgSZ1pZo1hDXS5senkLFLCWPGL8Wa9uExo8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yoF1TsFLUCvXHVlfVHTv0rgVI2qpSz2415hCp8H/naRpNdBJdUn3FroI6yJGCk7pV
	 wZGAei9ava7rift25APS5zX4X+nYbdwYeuRctwp3mX2St76GGbSe7blfu+w96GpZ5p
	 TdSQcrJShSk6R+pA0UBlhoicD3L/3UZOx/lBfTPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/279] PCI: Remove stray put_device() in pci_register_host_bridge()
Date: Tue,  8 Apr 2025 12:49:02 +0200
Message-ID: <20250408104830.627697251@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6e8d06e5096c80cbf41313b4a204f43071ca42be ]

This put_device() was accidentally left over from when we changed the code
from using device_register() to calling device_add().  Delete it.

Link: https://lore.kernel.org/r/55b24870-89fb-4c91-b85d-744e35db53c2@stanley.mountain
Fixes: 9885440b16b8 ("PCI: Fix pci_host_bridge struct device release/free handling")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index dd2134c7c4192..51615e4d28f41 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -926,10 +926,9 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 		goto free;
 
 	err = device_add(&bridge->dev);
-	if (err) {
-		put_device(&bridge->dev);
+	if (err)
 		goto free;
-	}
+
 	bus->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(bus->bridge);
 	pci_set_bus_of_node(bus);
-- 
2.39.5



