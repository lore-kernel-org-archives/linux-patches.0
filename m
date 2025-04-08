Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC6E265633;
	Tue,  8 Apr 2025 11:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113154; cv=none; b=En25VRFcxfcX1do5nZRJ4Y6VTVzLXojqrrTr4yZcHS41P79CzO82gCd4MV+Rh+z8V4FhqPfSf9qvUbyC3kdUAN8lwG+Irm5HmL/OrZvn+fVMsQJQc2hGIJ0HQtevyBxNToAwx1ZGgP5QBJNxl4zNHJBBBvFy4NXso63LzhbicCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113154; c=relaxed/simple;
	bh=VAzBCsTMXFS4wo/LTCMelvtJ3NQdQ20aJK8dkDLqNTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1ikFku3AvyMuZKSqiod1xS6rbqkDtnoJKvAfKtRGZLxejyehqRQy6AWft6DkKwbq6i2YAzZLfAqGF0+btx7qPL7pKeMupZkF9/e7DUvazeDOEPmDAPcnggBdXnF8xR+pD4oofEXTYvvuyeYLOw0qgSCnHe0in3XqGOUwnT8zS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPL1Me0F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPL1Me0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BAEC4CEE5;
	Tue,  8 Apr 2025 11:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113153;
	bh=VAzBCsTMXFS4wo/LTCMelvtJ3NQdQ20aJK8dkDLqNTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPL1Me0FpmKKvw2a96dkWn6L/RpFNtQObfBLgARsjgeSVm5ZemTvosesD/W8U9jsC
	 hndlTqbieIdBaZLh+2mwMa5twmZBR1/sJJlvSBlC6fLIj2Oh5bVa01/K+vvrmNJNka
	 cEW2sxd0GtzhT7BM6AKFGsdwfecSDFu6pLVARm0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/268] PCI: Remove stray put_device() in pci_register_host_bridge()
Date: Tue,  8 Apr 2025 12:47:43 +0200
Message-ID: <20250408104829.903185167@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 03b519a228403..bcd1ba829e1fc 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -927,10 +927,9 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
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



