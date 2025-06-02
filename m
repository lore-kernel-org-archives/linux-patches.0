Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC77F223DC0;
	Mon,  2 Jun 2025 15:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877067; cv=none; b=UEtoF3snfLfypcg2hkrllEuVKESv20dhvo54ko975QsKXQD5Rx1WJaB0RBueR6njh7+MQfZ+uQKIIPUpLKLZhBfaPL3nxAS0YbW5DwbYWL39GGZoUL10zyzrxb8Yzx66KN/lCptMHLyPPRW7UpGO53iQaazHoL4CGwxmY3auS/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877067; c=relaxed/simple;
	bh=42TchODPCXmY1npgxP7PdxgPqY0664nqfLpjwr1kB2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r+QHAFXgnb7/eAXov0m+BPIc6JbBEbo0/w8IdqWd52yLW8kzB6q/tqaUt0IyI9Xu1llyoaKOBr5veEF3jmexhakl+9sG98N1mFkrfxQty0OjvC2Z79qy0kEsZQDrxcjZzzsi+jobSLLD2ZVP2CeddIYrPUAkdZe/CbKXXH6EUg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUrxqyBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUrxqyBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181CCC4CEEB;
	Mon,  2 Jun 2025 15:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877067;
	bh=42TchODPCXmY1npgxP7PdxgPqY0664nqfLpjwr1kB2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUrxqyByibIfyjIu6SnkagrkwTMhBh7ARv/v0yI0DJogacdQaPpcgUi+6xpuyMu1O
	 i+gIeHZ/zyvbdqtX+s/RMidaVVxH9xOtn5dwQCSD7CTKZ8sg0tJrCl/iFs+yalyiQo
	 mdqOz5hzr7vEIdqV8rmAn9AYh8PkRPNh8R24LFP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Xiaochun Lee <lixc17@lenovo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/325] PCI: Fix old_size lower bound in calculate_iosize() too
Date: Mon,  2 Jun 2025 15:47:17 +0200
Message-ID: <20250602134326.345633845@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit ff61f380de5652e723168341480cc7adf1dd6213 ]

Commit 903534fa7d30 ("PCI: Fix resource double counting on remove &
rescan") fixed double counting of mem resources because of old_size being
applied too early.

Fix a similar counting bug on the io resource side.

Link: https://lore.kernel.org/r/20241216175632.4175-6-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Xiaochun Lee <lixc17@lenovo.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 8c1ad20a21ec5..3ce68adda9b7c 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -806,11 +806,9 @@ static resource_size_t calculate_iosize(resource_size_t size,
 	size = (size & 0xff) + ((size & ~0xffUL) << 2);
 #endif
 	size = size + size1;
-	if (size < old_size)
-		size = old_size;
 
-	size = ALIGN(max(size, add_size) + children_add_size, align);
-	return size;
+	size = max(size, add_size) + children_add_size;
+	return ALIGN(max(size, old_size), align);
 }
 
 static resource_size_t calculate_memsize(resource_size_t size,
-- 
2.39.5



