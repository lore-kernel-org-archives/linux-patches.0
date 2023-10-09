Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3810419464
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxQJ6NWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB33C433CB;
	Mon,  9 Oct 2023 13:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857214;
	bh=igpQa8sHKg7GRYCseLQBcVoEHz2h9T/iTre1qUm+Cmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GxQJ6NWBhwBgxF76zl27rk+H6CVlVWtNks1ZXB/afXsvuqMZWUMXqHik6WwSxj0f4
	 jMCeub+9etXWY/WMq2K2cAuL1JpQ4Ettc2w3jFHXZA5zW8XheNHtFFaR/NxNbXn/iT
	 /vgBhgwNh/My4j0JywljBctxmq/JOuA52WUr1vuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 135/163] HID: intel-ish-hid: ipc: Disable and reenable ACPI GPE bit
Date: Mon,  9 Oct 2023 15:01:39 +0200
Message-ID: <20231009130127.773943459@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 8f02139ad9a7e6e5c05712f8c1501eebed8eacfd ]

The EHL (Elkhart Lake) based platforms provide a OOB (Out of band)
service, which allows to wakup device when the system is in S5 (Soft-Off
state). This OOB service can be enabled/disabled from BIOS settings. When
enabled, the ISH device gets PME wake capability. To enable PME wakeup,
driver also needs to enable ACPI GPE bit.

On resume, BIOS will clear the wakeup bit. So driver need to re-enable it
in resume function to keep the next wakeup capability. But this BIOS
clearing of wakeup bit doesn't decrement internal OS GPE reference count,
so this reenabling on every resume will cause reference count to overflow.

So first disable and reenable ACPI GPE bit using acpi_disable_gpe().

Fixes: 2e23a70edabe ("HID: intel-ish-hid: ipc: finish power flow for EHL OOB")
Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Closes: https://lore.kernel.org/lkml/CAAd53p4=oLYiH2YbVSmrPNj1zpMcfp=Wxbasb5vhMXOWCArLCg@mail.gmail.com/T/
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/pci-ish.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/intel-ish-hid/ipc/pci-ish.c b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
index 55cb25038e632..710fda5f19e1c 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -133,6 +133,14 @@ static int enable_gpe(struct device *dev)
 	}
 	wakeup = &adev->wakeup;
 
+	/*
+	 * Call acpi_disable_gpe(), so that reference count
+	 * gpe_event_info->runtime_count doesn't overflow.
+	 * When gpe_event_info->runtime_count = 0, the call
+	 * to acpi_disable_gpe() simply return.
+	 */
+	acpi_disable_gpe(wakeup->gpe_device, wakeup->gpe_number);
+
 	acpi_sts = acpi_enable_gpe(wakeup->gpe_device, wakeup->gpe_number);
 	if (ACPI_FAILURE(acpi_sts)) {
 		dev_err(dev, "enable ose_gpe failed\n");
-- 
2.40.1



