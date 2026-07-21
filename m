Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B020C46D098;
	Tue, 21 Jul 2026 19:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661962; cv=none; b=sSNQiA4C0Ehlu+i3wIOg8NqFV/O8axOS4oSO7Dz4BVUMRdNho9ZlBjEsvf9zbBrHAMFQph96CDrAjzcnlCG0HomHJO1rNKfyqrqaJn5exdnJOqqHd6F24axCcz1ZDuYXbz51hDNXMKkdt1p75jeagiJipdcAfzSt1DhpLn5ylm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661962; c=relaxed/simple;
	bh=GhqnJWGHcn1gDZ26BE+e1HGOWL3O5CFfEo9UgZvGJI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJD6SfBOs5DR925PWCG5TwuSUjAQo+Ggv02zLucqA9s/yfnr/1bu36NGA6n4hKUlo3kNNzSK2qmJk1p4lUvaRmkXg3POp0YDswdbRxfE3FtTsfQ4zpZ0NAFNcoIQdhgecCXAg2Mxu2iNJ9ribNrWMhOydJ8krYnyJRQjSY+qQC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zj5MVKon; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zj5MVKon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF081F000E9;
	Tue, 21 Jul 2026 19:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661961;
	bh=PoZ5DBfYIfqCTHsS+4Jl9+8SLb3EFiWoX79kamCBfCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zj5MVKonmqKYtGN/53/P1dV4uPsIbA57pVk3eZYdfyVemg7zSiTg5l8P+4RI6tpFp
	 Bhuw7fLSo9Lx7Ya4Jg8KSxf103Vk5pYNuBonHDVXiqYobSkl4N1/1t5EWvB8E3jl2u
	 LKAynd0IacfpPCqqKJEpCwDXdjVjmq1+9a5d80t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0263/1276] ACPI: IPMI: Fix message kref handling on dead device
Date: Tue, 21 Jul 2026 17:11:46 +0200
Message-ID: <20260721152451.969074005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5fba4dab5d0886..c672abc3a6dbbe 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -550,7 +550,6 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 		return AE_TYPE;
 	}
 
-	acpi_ipmi_msg_get(tx_msg);
 	mutex_lock(&driver_data.ipmi_lock);
 	/* Do not add a tx_msg that can not be flushed. */
 	if (ipmi_device->dead) {
@@ -558,6 +557,7 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 		ipmi_msg_release(tx_msg);
 		return AE_NOT_EXIST;
 	}
+	acpi_ipmi_msg_get(tx_msg);
 	spin_lock_irqsave(&ipmi_device->tx_msg_lock, flags);
 	list_add_tail(&tx_msg->head, &ipmi_device->tx_msg_list);
 	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
-- 
2.53.0



