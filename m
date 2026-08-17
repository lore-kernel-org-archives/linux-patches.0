Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B731C242925;
	Mon, 17 Aug 2026 15:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978904; cv=none; b=UIQFgu1TEb7JrjDYWsrK/T8bysj5A36csvbS/DdZTHj7eADrERtlcn1VykVCduKo81+ocsj4Swc0OIAt8XwAiuYhTPrkePkhixv+Zfk4iQn5hTptkPUWpOk22kL53RX8qw1fGi+UgeKfcQT6Saz7JCTi+pdmeKZT27h67K5mT9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978904; c=relaxed/simple;
	bh=VlXvUvAPbPTXjHkhRTQf9ZGVk1psmHJw8+H3meK+XEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWYgTQE/3rqDVz5USCL+XmId3jcAQF65I4YTaOoD9APxhut1peyCLv7V+lW/inmXIL/PlN74lMg0WMdpWO4kAqC6NB5OW1d6yksdug8/c2ZsBe87Ltx0mA+0x/73d4zb565qPiPBugfX5wk9SMolHBZyyiCj1hKg/IEJGL7PCCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0X3LO3EU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0X3LO3EU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6871F000E9;
	Mon, 17 Aug 2026 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978903;
	bh=IMfvSDJ3H6DoBqLDArbWs5pBFoRMuBbapqTKs9lYwvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0X3LO3EUQuVRjciCOe+hNUjBBd2vqTaZOUvOH4WkyHBX4Lt5V1B4kWho9NCrcbYb5
	 U7BmP9L+I0EZF/s5JKGuPKHbaUUmy9DrYkpmKOhUUuFHeklZ8K8tdtBS2F2ELIElPL
	 I7Nlcpt07xJWqgF8AJkU0VjkTazdh/B0jPJiXaUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/609] wifi: ipw2100: fix potential memory leak in ipw2100_pci_init_one()
Date: Mon, 17 Aug 2026 15:25:37 +0200
Message-ID: <20260817132544.682263712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 0d388f62031dbabcba0f44bb91b59f10e88cac17 ]

The memory allocated in the ipw2100_alloc_device() function is not freed
in some of the error paths in ipw2100_pci_init_one(). Fix that by
converting the direct return into a goto to the error path return.

The error path when pci_enable_device() fails cannot jump to fail, since
at this point priv is not set, so perform error handling inline.

Fixes: 2c86c275015c ("Add ipw2100 wireless driver.")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260620065242.93798-1-nihaal@cse.iitm.ac.in
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index b0f23cf1a621b6..a76e94fcb29558 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -6183,6 +6183,8 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_enable_device.\n");
+		free_libipw(dev, 0);
+		pci_iounmap(pci_dev, ioaddr);
 		return err;
 	}
 
@@ -6195,16 +6197,14 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_set_dma_mask.\n");
-		pci_disable_device(pci_dev);
-		return err;
+		goto fail;
 	}
 
 	err = pci_request_regions(pci_dev, DRV_NAME);
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_request_regions.\n");
-		pci_disable_device(pci_dev);
-		return err;
+		goto fail;
 	}
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
-- 
2.53.0



