Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9BA2641CA;
	Tue, 21 Jul 2026 21:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669014; cv=none; b=oRt7JgkPpbbUBWb7R1WMe5MZNRC+xkdVM4Z4gB4FeyWA6aS+iqYkIG+HJOyQDXusqSYZLFDYfPc8SRa17g4OUpJxnuAVp5pB3P11dOpAd+2ccqgbn9Oeio3Ef5rsaD6BrsqpOQ7d2QeQ2poj+qkF6/Srbge23GsiO8qIcWx1W7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669014; c=relaxed/simple;
	bh=0juzCm4LG05OrIog3HbpNA+1xYKf+1TYMdY4zqfsRvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkZyuza6CRv5g+6KSdhYH4WQxcA59N9DTULXBgUDDXXpBUWVprTFQOOOaSGhOE6Fd8RfKG1gP70Uo6l7hsG7wknRQRaNFdpZ2BRnx341SS1n4uvMXCJYF0nHdyjPH2tZevf57FBNjc7Jql1tO7pNE3fyY9oC7ZoPJL1bQekYc2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgTmvd9M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgTmvd9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32271F000E9;
	Tue, 21 Jul 2026 21:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669013;
	bh=ItMiiBIvQg5UBE2+2u9+Fo5PVHkKcnUk6IYRKd18dGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgTmvd9M2BcEXgM3lqqNc3gZD5fOG6sHpVShWIwyqfkZQrqfFKbZsFyRFEKlGZBr6
	 WgQyKj4vmfNqdWwIPLzBlXPOLEVWhemTWQHSOotxAqsUVaY6ptPd1u7chelcRBerOT
	 JcgweB5jmDi0/oPCM0r9LZ+68FWxEewtQHz6ykJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0395/1067] ACPI: IPMI: Fix message kref handling on dead device
Date: Tue, 21 Jul 2026 17:16:36 +0200
Message-ID: <20260721152433.467776481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index 0555f68c2dfd68..148d9486106cad 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -545,7 +545,6 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 		return AE_TYPE;
 	}
 
-	acpi_ipmi_msg_get(tx_msg);
 	mutex_lock(&driver_data.ipmi_lock);
 	/* Do not add a tx_msg that can not be flushed. */
 	if (ipmi_device->dead) {
@@ -553,6 +552,7 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 		ipmi_msg_release(tx_msg);
 		return AE_NOT_EXIST;
 	}
+	acpi_ipmi_msg_get(tx_msg);
 	spin_lock_irqsave(&ipmi_device->tx_msg_lock, flags);
 	list_add_tail(&tx_msg->head, &ipmi_device->tx_msg_list);
 	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
-- 
2.53.0



