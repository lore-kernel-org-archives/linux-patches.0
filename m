Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7572C3DEFE7;
	Tue, 21 Jul 2026 22:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673636; cv=none; b=V50pLlIkLH51NJe6a/t0ECmtf2EYVE6otMSg4799CC2mICT78SVRtfWdYg7vVebUOOuFWMgrqSmAFAjq1YImZdxZyQHXo/IyaSNRbb9QeymgZAAmasb/45V3jBe7z/QogMOU+2AvzdKkVYYaPgjuBwYxpMzTGE50tVz9qUo22Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673636; c=relaxed/simple;
	bh=Jqz5MPZxzBAvT2pVgZq2W4hO516pwjOP8GvALiFw/d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhtvoCp/QGxXPAf68RwKW1oGUeNj0itKVZDEv+gqDFYibSXoIx3MtMZoF0OG9BiV8qQ550YtHA7GBTq2u/Fr8roOkb+pjRe3kE/QSkChrJPF3YWFfIrYoN8Tv6IjuDbcE1U6UQ27HAPv+O59EM9y2zw/oDLH75lw5EkdRFVnjoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlDNt0AR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlDNt0AR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEAF1F000E9;
	Tue, 21 Jul 2026 22:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673635;
	bh=9bJmDfL0g/q7RrjIy33R7dsQTXgPaG1XH/6sISuE3bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zlDNt0ARZ4fE2llzGTEcRyVYfGEGtzKxgavVmJ564u/slDNNLOzWCRbZDo4hOOhyU
	 NfAnklimkXhvfzS8y7X93RF9ccVKmde6yIyuNKGSlvWxt5aTIN96ZNMpnpAvIsL0IV
	 /c9/5fP8vwGQjc7duYUR0Q9vtXfGnOtPDqXxhd0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/699] ACPI: IPMI: Fix message kref handling on dead device
Date: Tue, 21 Jul 2026 17:19:57 +0200
Message-ID: <20260721152401.067107675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 63320db6a5d84ec3fed8b3d36ba5244d07ddd108 ]

acpi_ipmi_space_handler() takes an extra reference on tx_msg before
checking whether the selected IPMI device is dead. The reference
belongs to the tx_msg_list entry and is normally dropped by
ipmi_cancel_tx_msg() or ipmi_flush_tx_msg() after the message is removed
from the list.

On the dead-device path, the message has not been queued yet, but the
error path still calls ipmi_msg_release() directly. That bypasses
kref_put() and frees tx_msg while the queued-message reference is still
recorded in the kref count.

Take the queued-message reference only after the dead-device check
succeeds, immediately before adding tx_msg to the list.

Fixes: 7b9844772237 ("ACPI / IPMI: Add reference counting for ACPI IPMI transfers")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260603163108.2149359-1-dbgh9129@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_ipmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index 9d6c0fc120d77d..d8fd2f9294047d 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -549,7 +549,6 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 		return AE_TYPE;
 	}
 
-	acpi_ipmi_msg_get(tx_msg);
 	mutex_lock(&driver_data.ipmi_lock);
 	/* Do not add a tx_msg that can not be flushed. */
 	if (ipmi_device->dead) {
@@ -557,6 +556,7 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 		ipmi_msg_release(tx_msg);
 		return AE_NOT_EXIST;
 	}
+	acpi_ipmi_msg_get(tx_msg);
 	spin_lock_irqsave(&ipmi_device->tx_msg_lock, flags);
 	list_add_tail(&tx_msg->head, &ipmi_device->tx_msg_list);
 	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
-- 
2.53.0



