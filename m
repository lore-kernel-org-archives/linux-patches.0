Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34DF37DE97;
	Tue, 21 Jul 2026 18:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657863; cv=none; b=WRhTO8uWjP8Y7aMGcnkr18yJVRNzpgZtCkE05k0ABt5XlU073kC+oaP18Zjv8pF9tGCkOq4ZRaXeZREEOCWDKJDK4CgGUOTsTFDX17dwWELdbZnovzNWlUovcFEJtgGvSXQv0e/zPwfcrw/MhSpmqYMax3q6sb2xV2teNyYTmgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657863; c=relaxed/simple;
	bh=zF6DTxdngKXw6I5gEjz768H7jQCRvVrvppxtEgL4bpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rrmf9C2ePyazonUe8Rw/dA2qxp79H4oEpaByh/2mGi/bNeAQ63cAwsYhhuRNqfAKgr4w54jmSuC2gnPfFuwFw4Fk2N61Q37CVnUoBgNUOefgGSyq0NKkTNRPVtHmARQm/sQKvMaMkN+DI7y90xR6MMWaKvTMgvDqQGx7Wjenk84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKb7f1Em; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKb7f1Em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D781F000E9;
	Tue, 21 Jul 2026 18:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657862;
	bh=cxHXujeO1bYe69OwR/rqW0EpLJ9xqHKkf5oijUXNZBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKb7f1EmRwRL0DXE7YUUiGjoYN7Xzako6xHHrsuro3Hk+4YhIiw8DiulgPDbAWTCv
	 l2oVZgO5oyfxQZkRhqvSUluUrUho+3BX00VPbOk13Tz782O9S0YmsZgVBp18/rITfI
	 ClIrOwy7YJWo2vVoA0BZ2b967RDG/MhNToeILHPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0924/1611] eth: fbnic: fix ordering of heartbeat vs ownership
Date: Tue, 21 Jul 2026 17:17:20 +0200
Message-ID: <20260721152536.170578144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index fcd9912e7ad3bd..1204c12ea0fa24 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -484,15 +484,10 @@ int fbnic_fw_xmit_ownership_msg(struct fbnic_dev *fbd, bool take_ownership)
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
@@ -500,6 +495,10 @@ int fbnic_fw_xmit_ownership_msg(struct fbnic_dev *fbd, bool take_ownership)
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



