Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7453344607D;
	Tue, 21 Jul 2026 19:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661191; cv=none; b=rITBSxN5GeQzak9PGmoc39Quc2v/Ehu5PDb26zOBb9sTNUNIAVczVtcTA19AFmHcaazqUp/fSe8Ic5FDQPgZET4Yq1fNs7C8AesogMzNSiGCOGt2AMu8x3G/SqOjdqjoOCOIvAldj7gzQUVjPLDCoU5MGCMQqd43eBSJ+Bj1/8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661191; c=relaxed/simple;
	bh=tL9OAwJfQrq4Q1sac+04WpAn5lLxzhMMwYbjo/nD6os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyUreNR90DryGHWff0o0inBdGMkPPaEFhngaharo19NvJl751cR85WYRDlfNGVoy9leOX1D07c0u7SEvFkX2NB6WD4VJ4XKyJdCM960IZEGqd2jZquC/JXqNgvZht0nvl1F6FsJeQ6wBcnNfZJ5d/M3PMZAgDh0Iq4D01WlBEkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtRRfNPW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtRRfNPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2D51F000E9;
	Tue, 21 Jul 2026 19:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661190;
	bh=n3qUre83o/Vvwo3wCT077VfFap6MJNY2qt1k0E8jFCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtRRfNPWoKLoQ+i9PGdLvqNP0ehbxUA/UknVvJrz0sO93l9JI+HwaReup9ZDJzEjZ
	 KVFT4AvsY9MAb/ya0S4YPxWIhcD4Zj9UWriH2Rbvebb0iUry74aBpmRxkyEDnesns9
	 VoV7JKmJXfljXgOVypR98RVkYV9CeLiUOZxBWlnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1265/2077] eth: fbnic: fix ordering of heartbeat vs ownership
Date: Tue, 21 Jul 2026 17:15:38 +0200
Message-ID: <20260721152622.653431558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit d87363b0edfc7504ff2b144fe4cdd8154f90f42e ]

When requesting ownership of the NIC (MAC/PHY control), we set up
the heartbeat to look stale:

  /* Initialize heartbeat, set last response to 1 second in the past
   * so that we will trigger a timeout if the firmware doesn't respond
   */
  fbd->last_heartbeat_response = req_time - HZ;
  fbd->last_heartbeat_request = req_time;

The response handler then sets:

  fbd->last_heartbeat_response = jiffies;

for which we wait via:

  fbnic_fw_init_heartbeat() -> fbnic_fw_heartbeat_current()

The scheme is a bit odd, but it should work in principle.

Fix the ordering of operations. We have to set up the stale heartbeat
before we send the message. Otherwise if the response is very fast
we will override it. This triggers on QEMU if we run on the core
that handles the IRQ, and results in ndo_open failing with ETIMEDOUT.

The change in ordering doesn't impact releasing the ownership.
Both ndo_stop and heartbeat check are under rtnl_lock.

Fixes: 20d2e88cc746 ("eth: fbnic: Add initial messaging to notify FW of our presence")
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260622154753.827506-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 0c6812fcf18515..283d25fae79e78 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -526,15 +526,10 @@ int fbnic_fw_xmit_ownership_msg(struct fbnic_dev *fbd, bool take_ownership)
 			goto free_message;
 	}
 
-	err = fbnic_mbx_map_tlv_msg(fbd, msg);
-	if (err)
-		goto free_message;
-
 	/* Initialize heartbeat, set last response to 1 second in the past
 	 * so that we will trigger a timeout if the firmware doesn't respond
 	 */
 	fbd->last_heartbeat_response = req_time - HZ;
-
 	fbd->last_heartbeat_request = req_time;
 
 	/* Set prev_firmware_time to 0 to avoid triggering firmware crash
@@ -542,6 +537,10 @@ int fbnic_fw_xmit_ownership_msg(struct fbnic_dev *fbd, bool take_ownership)
 	 */
 	fbd->prev_firmware_time = 0;
 
+	err = fbnic_mbx_map_tlv_msg(fbd, msg);
+	if (err)
+		goto free_message;
+
 	/* Set heartbeat detection based on if we are taking ownership */
 	fbd->fw_heartbeat_enabled = take_ownership;
 
-- 
2.53.0



