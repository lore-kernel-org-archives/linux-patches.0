Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B76264FB6;
	Tue,  8 Apr 2025 12:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113991; cv=none; b=hKEGF0L4v3CCOHxH3/cZ+0hhTvE0Og6+F3vvT+euV3GtI7JW7s5lPhhlNX2RELX0E87ka6zjs9zLlUpmvhepz1LPy26r3KGGdjtU5fSSWb7U/V9JfreukfSGGz/cOVB5O8a8BaFWZK4SsgEPfc+AO5r4ZIbnG1aZ9JD62YdgWl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113991; c=relaxed/simple;
	bh=O6XgTUUQWyR15bIRogvU6f468hv7C0eNu0l1bR+tp4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFkoCqaCSGM0nBqKF7Ho4FTR9eDcuvITJhnEeQ+QJ9a2b0/mbwVELRLKBiNzH/61UdkwVEbQHOWlzvsoDhaUg+00//riPgMCjNQFtg9w9w+ykRSmjzwPHEXLVW//8G8XnK2VOTE92X6JIVNCU+1d4ZgWyz355v71H1x8MqGelYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fb2xJmVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fb2xJmVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75D8C4CEE5;
	Tue,  8 Apr 2025 12:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113991;
	bh=O6XgTUUQWyR15bIRogvU6f468hv7C0eNu0l1bR+tp4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fb2xJmVJhVLPeLorQSS6M6QHfN5pWOpQ52I2OFD4HHhlYuKtY2aOrxPheBvstSj42
	 IvgkSX39yxiQgROz9ZhpfUyfmczAah0tN47T6S2EACkuZhqNloJlO1o8GKEEYu77aM
	 5QKdn8S9jiiMA3Ju56uEl4NU6GeG1z/7ll5AT0ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/154] PCI: Remove stray put_device() in pci_register_host_bridge()
Date: Tue,  8 Apr 2025 12:50:37 +0200
Message-ID: <20250408104818.402029223@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a41d04c57642d..701489c1c5d32 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -869,10 +869,9 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
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



