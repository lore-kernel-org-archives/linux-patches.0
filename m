Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0462386C1C;
	Tue, 21 Jul 2026 20:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666096; cv=none; b=XRu+uvkEcPV5AY+o2E0Ypj9TlEwIwLmS9GWCRBh25liDjVm15s2nUarJtOaCo4sNdLOsRHczdaDByuv014FGBBTPsKD/jriGnlMBq3y2mAvR3rSkjPSmRJJStqjl4uuOPd5K+s89UI/cV9m7vDtSzMymDOsXbv3zGZxtOVFJlDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666096; c=relaxed/simple;
	bh=9v9b+Ew5cf/1gUI3Ukmxov6RWbslP/7HrGNdAQP214U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGo0UyugglqGiEHiNppAlUPBlIq/yU6KRdpqKZ0H+3OgpMIRl0Cg0VrqXgmamIZI8qaDThOVwQ93L9+NVhUsWCkq+gruAaLGOTxvvmQup7VqNDHCZSLofoPTT8/vLTQ4JdLZeoJL9lLm31EAS6IDbObXc7x7u1mgYSVTanNw3ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtYezsTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtYezsTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CD11F000E9;
	Tue, 21 Jul 2026 20:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666095;
	bh=6JmDBEKmnvYpWH9AF/sXD6Xst4RZjbxhvipwLau+4s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtYezsTE8S8XWEjJv5GycArpUNzQPXhV58P3kD4D+EYstQskqiMb4ROfeyy+b4MpX
	 4l3ja16uUXZxmdZ+hNI35E5l1gAfUCW84LXxpGdh84lQZS65ualyLyGNZIw3kDZwg7
	 HtDLD0tVORuG6vSPdUkF/hfLRu5Kn8uAQssTIB6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0509/1266] ACPI: IPMI: Fix message kref handling on dead device
Date: Tue, 21 Jul 2026 17:15:46 +0200
Message-ID: <20260721152453.236485340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



