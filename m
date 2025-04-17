Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030978462;
	Thu, 17 Apr 2025 18:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913791; cv=none; b=tCUfpSrUVM0Uy7wNVZFYUp4cMrgaGwSd3PCGieqOfmNryxnN284J0h1UsXHMTm9fs/Hq4vORIVX4AsEXbMsr0upgIlQWRdheeoJYA5PWbxR/RLcqnLpAndTS0sxtPfaShcvEDuHJ1YyYqGXwe5WEd86rU9Y3nChD8MJLKN6GR4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913791; c=relaxed/simple;
	bh=oe5VXWt3RmQ6jg5ahHLe/hvJaaLIHMKRmYk/42HXeJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmNP9WDybkXgVbmwANGMCv4uvMFleoHM8BajTBFlqp9jW6gS223z/tM2jwG5EI3vvKfg6s8uIv2/GZBUKHTMI1LrYN41Q3xkj+p278zJvgJIKmv7f1UYT5gHlpeEIVhyH3vEnhMxbjyIBjn3HO2tJ0vi0nI5GNvc2NL5SVUdSG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/V6tcZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/V6tcZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E18BC4CEE4;
	Thu, 17 Apr 2025 18:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913790;
	bh=oe5VXWt3RmQ6jg5ahHLe/hvJaaLIHMKRmYk/42HXeJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/V6tcZmpj+jfQO8GYgNuGDzB5C8bMq1vtNYo00s/4ncSAX8xePTuin70g1aZXAX0
	 6b+c4jJcQHmjy7uKG3PUuxugmdC6gI93wAdVdGWtMMOvFY5JcD4b2Kxhq2DCkzqO8Q
	 zmz9f4Ol4OeGS2JZ2JOxsEQr9BusGK8xF2VdPF5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.14 428/449] PCI: Fix reference leak in pci_register_host_bridge()
Date: Thu, 17 Apr 2025 19:51:56 +0200
Message-ID: <20250417175135.522122609@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 804443c1f27883926de94c849d91f5b7d7d696e9 upstream.

If device_register() fails, call put_device() to give up the reference to
avoid a memory leak, per the comment at device_register().

Found by code review.

Link: https://lore.kernel.org/r/20250225021440.3130264-1-make24@iscas.ac.cn
Fixes: 37d6a0a6f470 ("PCI: Add pci_register_host_bridge() interface")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
[bhelgaas: squash Dan Carpenter's double free fix from
https://lore.kernel.org/r/db806a6c-a91b-4e5a-a84b-6b7e01bdac85@stanley.mountain]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/probe.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -954,6 +954,7 @@ static int pci_register_host_bridge(stru
 	resource_size_t offset, next_offset;
 	LIST_HEAD(resources);
 	struct resource *res, *next_res;
+	bool bus_registered = false;
 	char addr[64], *fmt;
 	const char *name;
 	int err;
@@ -1017,6 +1018,7 @@ static int pci_register_host_bridge(stru
 	name = dev_name(&bus->dev);
 
 	err = device_register(&bus->dev);
+	bus_registered = true;
 	if (err)
 		goto unregister;
 
@@ -1103,12 +1105,15 @@ static int pci_register_host_bridge(stru
 unregister:
 	put_device(&bridge->dev);
 	device_del(&bridge->dev);
-
 free:
 #ifdef CONFIG_PCI_DOMAINS_GENERIC
 	pci_bus_release_domain_nr(parent, bus->domain_nr);
 #endif
-	kfree(bus);
+	if (bus_registered)
+		put_device(&bus->dev);
+	else
+		kfree(bus);
+
 	return err;
 }
 


