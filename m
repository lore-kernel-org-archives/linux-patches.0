Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C54A329C7C;
	Wed, 23 Sep 2026 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174615; cv=none; b=uBPLPfFKMFMi74rrd6sDD5DlzCQWIHF0ZpMfJRz1uFGKTu0a0PmEUtTOmtXSMyLYlxIyv4dOs4YE1RXWJaL7llu1qVpwWgWGPwdu6rDEGasyU/Yhx/qcnxmuPP8nOYzdqAArH5QqTc3CwA8AbXIHtZAwqfwhNir87NUdXDzFFw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174615; c=relaxed/simple;
	bh=bJFzp0CHdA8kM10UXLxy2UL0DGeQkQooFsEW6QPjikY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAyyVzi0yIgF6SrgnS6HFB4utLbJkm/ct6S79w+XG4vR1PLlI1R8S3Ec8H5FGrN0azak38jOiNQY2lASPyB2cJVY22iempPI1cXWydBGq2o3sPkoflYXYAxWlRW7Op2Ul8DKU5Fxk9P6krRp8AO+4NMZ6u8GdoiKjfniaOcJmdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clyq4BZd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clyq4BZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5081F00893;
	Wed, 23 Sep 2026 14:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174613;
	bh=mbm56d9uDfsLh9KFZ0vNck++uSVAxLBApRRr1dUGSV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clyq4BZdAmkvbc8DusYNwERwbQXJOuTpVGCojBuRxmAJ4ekxLrSu6NxYb6fNOFret
	 /hZUu12Gv8zVUgVdddMKAIgvWDawEhO5trCfTAlbcJd8oflVc+I1AWKqlhmzIlouIW
	 gog/p2iTprrWYEAdIe1BdTtZK7i/u959oMbcgrpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 142/398] Bluetooth: btintel_pcie: validate TX skb length in send_sync
Date: Wed, 23 Sep 2026 16:03:36 +0200
Message-ID: <20260923140647.113803392@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

[ Upstream commit 4b837ebd0ea21ae5cc26f02dc042edc6fe7b46b9 ]

btintel_pcie_prepare_tx() copies skb->len bytes into a fixed
BTINTEL_PCIE_BUFFER_SIZE (4096) DMA slot via an unchecked memcpy.
Oversized packets are currently rejected only in
btintel_pcie_send_frame(); any future caller of
btintel_pcie_send_sync() would silently overflow the DMA buffer.

Add the bounds check in btintel_pcie_send_sync() itself, right
before skb_push() and the DMA copy.

Assisted-by: Copilot:claude-sonnet-5 code-review code-generation
Fixes: 6e65a09f9275 ("Bluetooth: btintel_pcie: Add *setup* function to download firmware")
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 56ba643d5ff7e..90494871e0d37 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -361,6 +361,12 @@ static int btintel_pcie_send_sync(struct btintel_pcie_data *data,
 	if (tfd_index > txq->count)
 		return -ERANGE;
 
+	if (skb->len > BTINTEL_PCIE_BUFFER_SIZE - BTINTEL_PCIE_HCI_TYPE_LEN) {
+		bt_dev_err(hdev, "TX skb too large (%u > %u)", skb->len,
+			   BTINTEL_PCIE_BUFFER_SIZE - BTINTEL_PCIE_HCI_TYPE_LEN);
+		return -EMSGSIZE;
+	}
+
 	/* Firmware raises alive interrupt on HCI_OP_RESET or
 	 * BTINTEL_HCI_OP_RESET
 	 */
-- 
2.53.0



