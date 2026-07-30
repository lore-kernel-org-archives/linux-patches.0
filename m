Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209BC29DB6C;
	Thu, 30 Jul 2026 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423636; cv=none; b=oEXpLZmPwsibLncl3ybup7Mqx9iDspvoUfWSM07NhfNT0LRZb/Yfgt0nuUzv05tSZZLIBv9Bdpb0jtPRUJK+MA/N+zpqsDZoWbBRGg0KuESa1VCRkJruyi/0h7XZMh9jXTgcg/WFptNKTgKI10mQVPdU9mmtvrI8Y5mR8KkJiS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423636; c=relaxed/simple;
	bh=yKX7HcAazyEIxbz4NSRqBiqm7RbsOpyf+Z9bv0UOZfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OX1Rz+y2scJ6J7f8Na8pxZ/SqzTVqBViDhoClh8OK1JqlVCvmn2y4Ys/2e8u3EDhUoVZXwHqI9jB+SlpkDD7PPpbTHxifwF+TNXJP6xw+zRoHyeERpQiS+6uGFBu8xJ8v+AMnxNq/Eg/PIhrClDrguGR7g7OSrBwYRktFDew3oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gESBitfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gESBitfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729F21F000E9;
	Thu, 30 Jul 2026 15:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423635;
	bh=WsMbkDQQ7veMhyjmu1uQJrDYlsf4KC6Bo7OxQn/MTQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gESBitfFDQbelwzl8E1dhCmKX8Qsfye6U3saEB4ViLHdQ/O2dLgNivHA/pens6y3J
	 VUXdHJlXnMoEGuIHziqKMEr+mIuteXuE5OqXxtmWlah8PxlaQPN5Zpg/OjC2e14Lff
	 6d9GZni/hp+YselVv6e6jVmy8Jaht8CoVoYLliTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/675] Bluetooth: hci_qca: Clear memdump state on invalid dump size
Date: Thu, 30 Jul 2026 16:07:22 +0200
Message-ID: <20260730141447.523045083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit bf587a10c33e5571a299742e45bc18960b9912e7 ]

qca_controller_memdump() allocates qca->qca_memdump before processing
the first dump packet. For a sequence-zero packet it then disables IBS,
marks memdump collection active, and reads the advertised dump size.

If the controller reports a zero dump size, the error path frees the
local qca_memdump object and returns without clearing qca->qca_memdump
or undoing the collection state. A later memdump work item initializes
its local pointer from qca->qca_memdump and skips allocation when that
pointer is non-NULL, so it can operate on freed memory. The stale
collection and IBS-disabled flags can also leave waiters or later
transmit handling blocked behind an aborted dump.

Clear the saved pointer and memdump state before returning from the
invalid-size path, matching the cleanup used when hci_devcd_init() fails.

A static analysis checker reported the stale memdump state, and manual
source review confirmed the invalid-size failure path.

Fixes: 06d3fdfcdf5c ("Bluetooth: hci_qca: Add qcom devcoredump support")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index c649a3f702c042..b510b03dae870f 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1083,6 +1083,10 @@ static void qca_controller_memdump(struct work_struct *work)
 			if (!(qca_memdump->ram_dump_size)) {
 				bt_dev_err(hu->hdev, "Rx invalid memdump size");
 				kfree(qca_memdump);
+				qca->qca_memdump = NULL;
+				qca->memdump_state = QCA_MEMDUMP_COLLECTED;
+				clear_and_wake_up_bit(QCA_MEMDUMP_COLLECTION, &qca->flags);
+				clear_bit(QCA_IBS_DISABLED, &qca->flags);
 				kfree_skb(skb);
 				mutex_unlock(&qca->hci_memdump_lock);
 				return;
-- 
2.53.0



