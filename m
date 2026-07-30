Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E5442E8C9;
	Thu, 30 Jul 2026 14:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421443; cv=none; b=W+Pr4w8riKxSdIkZp5REqTgqYvN8vGuaEQx8MpECL31r3fBNBCPKUB3qUe5wHc6RnLraC7NgW0Do2UT3BuVrTq9EPBJ2Ra3tbhj0TKgIt2TcYWXZRJ+e9+296nYhnPpmVznaJnudoVvx5g8AjQNYpxYON1TM1g04HF9UdIis0j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421443; c=relaxed/simple;
	bh=eK13LeOARh+qCbf2Hv1vJ6OqjaGGk4WoTYKpNjCTTiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBqRewVsjdUxUMgmMp8GPiTH8viMhKWUtFPRpsWoZxIDKCyGNDy527TePRDsSL+1q7Pt9+k2dZ1ohw/QE0I2i4D2iOeQkDapHWhlCRQcxq0UU3zi8LXhUvhXy16w52KQM1xwjGM6GZiiBf+muwG3wAlNutry5USq29o6ATSNPoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsn4fkN/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsn4fkN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27EC1F000E9;
	Thu, 30 Jul 2026 14:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421442;
	bh=stEqs9xtMVjYn0+TYHuuEDhWIxsaE+ohU/6/r7riOKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jsn4fkN/ZS7suozSiGz0xUPy2XhH+zh8SAZF7NS7pJKnGK0KxXQ17ebKBhBSxeB/4
	 b+1wSbpB7ZSJmWckCeBUZ/9vmEOSNwdRL0UN8P4CuhJ11h3roT++W0kamNg/0es50I
	 2MgCo6EkL1WKaVoZri7xNHXm/joqLxWEQk9a6egY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 105/744] Bluetooth: hci_qca: Clear memdump state on invalid dump size
Date: Thu, 30 Jul 2026 16:06:18 +0200
Message-ID: <20260730141446.507878600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2444471956197b..bd29d422c2090a 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1088,6 +1088,10 @@ static void qca_controller_memdump(struct work_struct *work)
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



