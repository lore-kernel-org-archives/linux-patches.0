Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99964268FED;
	Tue,  8 Apr 2025 12:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116286; cv=none; b=W6BmMJm/qFZzVPWdx4LOCvBgOn4OZiVrNJfWq+p8sdm8FdgHCevk/pxjVptvgEIUBTfMZq9lpAmDvl8R6OskeYYu6hg0fjffN70fqG8W88sid7MebGxqNc/cDsD4BB80Ryo1A1xNW/pnqJKWaV6XeiEdBaoUmi5hG6zvHZbkYbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116286; c=relaxed/simple;
	bh=cL6ZZm2QEY7oN5d0eDT+VyaMlkuYExcAR+WYmxGSXXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pem1pOM10VoJBIm5GQG9UNRAyzbOcKzd/Im3/SROItBsC8RHuKsMWG1nwBth43BbxhaCtOuIqyNqIoqQ0+PHTpvMFv6nC3FheKyfNY/AmUzWSeJhECSFQY6Wbss5x3KlJZbl4LlAVQfzVSEFoGU42YFxQ1is0e+elbH6kUj6ZIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skOTmB99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skOTmB99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA6AC4CEE5;
	Tue,  8 Apr 2025 12:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116286;
	bh=cL6ZZm2QEY7oN5d0eDT+VyaMlkuYExcAR+WYmxGSXXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skOTmB99O3UcoczpwzvVyEeA+3YN6wr9r/bJU5OAWY5PdKtRbuTneWp2JB4aW2B5t
	 jr3MHU6zby87s1VWwyHuJzZlQUS2eVlIGaRJ4f4BNoUvEHnf5ullxSFArjpMBdDoyc
	 JufoVW2I7Ma0K2YiL/e04xFOVAfcswGLhVK5Njis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/423] PCI: Remove stray put_device() in pci_register_host_bridge()
Date: Tue,  8 Apr 2025 12:46:49 +0200
Message-ID: <20250408104847.676817791@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ebb0c1d5cae25..0e757b23a09f0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -950,10 +950,9 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
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



