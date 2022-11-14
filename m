Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B1A4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FADC433C1;
	Mon, 14 Nov 2022 13:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431055;
	bh=DRa+1hU7wHWfG3nJe38+nQQBgxNxWW2Hr44YAj4zNU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmlqK3KqIDbIWg6T4rumHrltsdeFIQk/4oYyaf5MrXF8dVZ0fzyiOHi0qUr31FkT+
	 VxFptUU6LBO3Ujy3UWi9OU+/f4Yw3HQfEEwb9l02l44xMlQ+I+6fs9boP5O1qt2XGf
	 dZWAtFw1ixWOteFhyo9ldCgw7ac1bI/fcFXjZIVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 084/190] net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg
Date: Mon, 14 Nov 2022 13:45:08 +0100
Message-Id: <20221114124502.346380733@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

[ Upstream commit d38a648d2d6cc7bee11c6f533ff9426a00c2a74c ]

ipc_pcie_read_bios_cfg() is using the acpi_evaluate_dsm() to
obtain the wwan power state configuration from BIOS but is
not freeing the acpi_object. The acpi_evaluate_dsm() returned
acpi_object to be freed.

Free the acpi_object after use.

Fixes: 7e98d785ae61 ("net: iosm: entry point")
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_pcie.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 31f57b986df2..97cb6846c6ae 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -232,6 +232,7 @@ static void ipc_pcie_config_init(struct iosm_pcie *ipc_pcie)
  */
 static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 {
+	enum ipc_pcie_sleep_state sleep_state = IPC_PCIE_D0L12;
 	union acpi_object *object;
 	acpi_handle handle_acpi;
 
@@ -242,12 +243,16 @@ static enum ipc_pcie_sleep_state ipc_pcie_read_bios_cfg(struct device *dev)
 	}
 
 	object = acpi_evaluate_dsm(handle_acpi, &wwan_acpi_guid, 0, 3, NULL);
+	if (!object)
+		goto default_ret;
+
+	if (object->integer.value == 3)
+		sleep_state = IPC_PCIE_D3L2;
 
-	if (object && object->integer.value == 3)
-		return IPC_PCIE_D3L2;
+	kfree(object);
 
 default_ret:
-	return IPC_PCIE_D0L12;
+	return sleep_state;
 }
 
 static int ipc_pcie_probe(struct pci_dev *pci,
-- 
2.35.1



