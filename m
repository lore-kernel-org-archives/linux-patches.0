Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83E012EBEA;
	Tue, 25 Jun 2024 09:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308359; cv=none; b=fyN1ncQKKhRcT2SfnPNEOdZw0br1KAzNHzKtGHPDtcB4IA/RfUYAP688z2+9BC8SW10BijIKlsGe1hu/G/IHB+bLR7RKG+iJ4trc1TaiDy75X5A/hOYyq8i+lL573PUN40/cwmQ3gjB4stU41evK3gmd/euiADyLb2xhOJQi85Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308359; c=relaxed/simple;
	bh=ldufC4TjlKM6wRNR6qisZe5iy/xm48Xprjk88sUlDu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ldmaMAo8FxhKc7lp5mjDf8OLT5pGY58KMa83nU4vs1D2BW+dJl5tZKDEFymB3iTyGuuKA8zdiWaU5aSbP9KfkNfNTIvsOqcYGwJCVlLkkO1rZGWliQ88Gn70og0GPF3z79TlODJhtRqpYXfMPs7YHP3Ai7QQlRYugrHQxuXvrr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vAUehlWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAUehlWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E270C32781;
	Tue, 25 Jun 2024 09:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308359;
	bh=ldufC4TjlKM6wRNR6qisZe5iy/xm48Xprjk88sUlDu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAUehlWG4qmUGmgbahiepW4mM22p/QQUGOnGWrraum/OIJkczTzxrLAAXklK/lc4d
	 4aRqf3qNG1iQQ/iW/OF4i2kJ/HKwDPQVDd9xIYAPMJYW3dEPpJINTAeuOpTJZqcW0d
	 VmOqEo1hgYFE2EnkcoK9U3QCVTWAt8t+gZwXfWB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 093/250] PCI: Do not wait for disconnected devices when resuming
Date: Tue, 25 Jun 2024 11:30:51 +0200
Message-ID: <20240625085551.640629350@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 6613443ffc49d03e27f0404978f685c4eac43fba ]

On runtime resume, pci_dev_wait() is called:

  pci_pm_runtime_resume()
    pci_pm_bridge_power_up_actions()
      pci_bridge_wait_for_secondary_bus()
        pci_dev_wait()

While a device is runtime suspended along with its PCI hierarchy, the
device could get disconnected. In such case, the link will not come up no
matter how long pci_dev_wait() waits for it.

Besides the above mentioned case, there could be other ways to get the
device disconnected while pci_dev_wait() is waiting for the link to come
up.

Make pci_dev_wait() exit if the device is already disconnected to avoid
unnecessary delay.

The use cases of pci_dev_wait() boil down to two:

  1. Waiting for the device after reset
  2. pci_bridge_wait_for_secondary_bus()

The callers in both cases seem to benefit from propagating the
disconnection as error even if device disconnection would be more
analoguous to the case where there is no device in the first place which
return 0 from pci_dev_wait(). In the case 2, it results in unnecessary
marking of the devices disconnected again but that is just harmless extra
work.

Also make sure compiler does not become too clever with dev->error_state
and use READ_ONCE() to force a fetch for the up-to-date value.

Link: https://lore.kernel.org/r/20240208132322.4811-1-ilpo.jarvinen@linux.intel.com
Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c   | 5 +++++
 include/linux/pci.h | 7 ++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e4bb5f92a5f6e..cbbf197df80f1 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1277,6 +1277,11 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 	for (;;) {
 		u32 id;
 
+		if (pci_dev_is_disconnected(dev)) {
+			pci_dbg(dev, "disconnected; not waiting\n");
+			return -ENOTTY;
+		}
+
 		pci_read_config_dword(dev, PCI_COMMAND, &id);
 		if (!PCI_POSSIBLE_ERROR(id))
 			break;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 16493426a04ff..6f9c5ed5eb3ba 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2519,7 +2519,12 @@ static inline struct pci_dev *pcie_find_root_port(struct pci_dev *dev)
 
 static inline bool pci_dev_is_disconnected(const struct pci_dev *dev)
 {
-	return dev->error_state == pci_channel_io_perm_failure;
+	/*
+	 * error_state is set in pci_dev_set_io_state() using xchg/cmpxchg()
+	 * and read w/o common lock. READ_ONCE() ensures compiler cannot cache
+	 * the value (e.g. inside the loop in pci_dev_wait()).
+	 */
+	return READ_ONCE(dev->error_state) == pci_channel_io_perm_failure;
 }
 
 void pci_request_acs(void);
-- 
2.43.0



