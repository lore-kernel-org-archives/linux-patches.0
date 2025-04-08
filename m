Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7625E26981F;
	Tue,  8 Apr 2025 12:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115624; cv=none; b=P1aG3HNcslA1eBZ3znyrHX+O6NMdJ6QfpFBPbZNXJqlDbupnkMfB4DVpQDiGTkJ/LA6n2NKM81j/TgBu65qnlpNWPBDa4B05cPArojJTP4zd0PmLG6XoIwkSDH6eI6uG7vsb1PgLxwNccaxuNk4GvBbIQ2ZrQ/sEieq40YAaPd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115624; c=relaxed/simple;
	bh=b5hebK4CsfZyjZ47rxFr6TtbHnP5ICDUrKaBTOpAV64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssOldvyZ3gGaSFQJe+e2FbmlBA/smtAONGBu6QXXQBcz/hGYM0SqnwKp0p/4hLCCOxlGuTRbisiZ2uaBhtS01HPz9okpxmFPFVisw5SGlsRapfeB6xEcyn8oYVVSDBFNnN49A2t2W5eE9ss50mm7FZaQXT99AruOnSNrhTG6oM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1YVZX61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1YVZX61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEB6C4CEE5;
	Tue,  8 Apr 2025 12:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115624;
	bh=b5hebK4CsfZyjZ47rxFr6TtbHnP5ICDUrKaBTOpAV64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1YVZX61I0GTxIWP4VZQRUQQP5dKpZvAzw6LTR522a5dZntBV0fx4GEd+ebduDqLl
	 BAQFxbihgxN3KUyU/w3vfUVj1HFCR6TIu5Mk0kZjCcztMRecuBzAethRTyTBwvvAJf
	 lKdT17aQYES+QCCm1aS/3PpH3wqzCPstiahERgqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/204] PCI: Remove stray put_device() in pci_register_host_bridge()
Date: Tue,  8 Apr 2025 12:49:34 +0200
Message-ID: <20250408104821.640293185@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5c1ab9ee65eb3..bd35327648778 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -926,10 +926,9 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
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



