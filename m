Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827A7224AEB;
	Tue,  8 Apr 2025 12:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114426; cv=none; b=QVhrIR0uXVR7rEZgkqWLVG2d2OgJOpNRMRgKciJU5zc9uSrvt1Y26NTadWFunqBrsuay5PTqxJuAOl1GR+iPcnp0YMayDigZIj4zO5/SFGjNijAtHElLtXDBNN+7O+wgxsLJKT2Qcc181KdmRjGj7sxyZI7Leimliqe4KFu291M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114426; c=relaxed/simple;
	bh=qtPC1njvO0kv530t7JW4NrJJ9/BqJgjNd2Q2DKRAdpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L576CeuECZzECQdVSVdOhRN6tJO99dDeEEpS+ogfw107Rhfwy/8YLEYH5gj0+jBoqEQRBiqidaJ9edVkMnCOwSQXES1AZj1LEazBSGcSodjNR5NaCRjgZyQEx9MILobHHlWj02m31diRDB1C6YerFmJPfGlKsUvfi9X7SBcQOjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rh0pjWwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rh0pjWwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13806C4CEE5;
	Tue,  8 Apr 2025 12:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114426;
	bh=qtPC1njvO0kv530t7JW4NrJJ9/BqJgjNd2Q2DKRAdpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rh0pjWwDyMHhM0LDtQUEnjO6ERYNWO8YclILtXQ0sLq4spCfSH/dr7amZjyZGH0rJ
	 i/Ck8a5i1DVY+j+nEgsyaKPVzhj/GchyvALS+mv3r+EGfFsgQcoB7HayZe2oqY4oT9
	 uAfvcV7qIk6x28JywcTqIJ8sb0LLpWHAOW2tqXJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 102/499] PCI: Remove stray put_device() in pci_register_host_bridge()
Date: Tue,  8 Apr 2025 12:45:14 +0200
Message-ID: <20250408104853.756707849@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 2e81ab0f5a25c..e5698bd419e44 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -952,10 +952,9 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 	/* Temporarily move resources off the list */
 	list_splice_init(&bridge->windows, &resources);
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



