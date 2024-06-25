Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA66149E0A;
	Tue, 25 Jun 2024 09:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309001; cv=none; b=j8UlTppOrciNESI5zJWJ0vATz73hsxKAysnBYPH55bV7qXrgP5pgFYbh+w3UFUBZsDgiZaXy0Mw8ACXCX0773CdkAodX4eDBdL/lXhIJ0fhZQzbaSQA0WlEndNSFvLUv7xnKhRTfPoIFf0CjjtUcOeXl8mt9OggO4/eS6CS5KaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309001; c=relaxed/simple;
	bh=aKYkJGh2jYxFEXYoxQQMZJBWIH9RfF4Hh4O82+9YKPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=omcghWlyFlEpim3WSSW2ZGttR7iwzqyfLszTwOgL6fWSAYZSHyf82YheJ1ngQeDrcL7U1b+GV2wssuo48QvydJ00RYpWVZ6Xi5R30fH+uaZPcB7Mf5HfqshpsJN0jIOkgAjklcw/ACbdjD9Tq5QVJ8Vsy50ZMgMTzSMeFfNjbuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bnxi3Qpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bnxi3Qpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8819C32781;
	Tue, 25 Jun 2024 09:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309001;
	bh=aKYkJGh2jYxFEXYoxQQMZJBWIH9RfF4Hh4O82+9YKPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bnxi3QpfVkhxMG1hDi5CL1OkR28nLvUeOU2NaS0mlvFXAO/oxjZ8MxZmJdVFNShvH
	 lUUFUdGV5DU+w+KRYs3cE4CfhAJFmsKk8Knf/E5NbdZl5LVh0K2OIBkBjoqANbqJZ7
	 KqdMeIzM4ziEGzjjRnnlWNvMkfqhAOUQrQa+nKVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/192] PCI: Do not wait for disconnected devices when resuming
Date: Tue, 25 Jun 2024 11:32:14 +0200
Message-ID: <20240625085539.553680815@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a41a1a6155411..cd759e19cc18e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1190,6 +1190,11 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
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
index ee89a69817aaf..512cb40150dfe 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2484,7 +2484,12 @@ static inline struct pci_dev *pcie_find_root_port(struct pci_dev *dev)
 
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



