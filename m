Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187D210A35;
	Mon,  4 Mar 2024 21:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588725; cv=none; b=UjrzTkkRxLxAPf4DOmSZivqZWjaw+hkoRSlkPBtJYegvK5GgDKUM1bDuUcAeASSK9FFCdW9BOp0Ob14ceYOVYVeqQTfd5lrMsIDL1cH7q8PO8HBKqdUGjH85SXDDba4khZyZRWIHMt6/ebxv4bG2D5i23oxLVrXKTSBcYIH8w6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588725; c=relaxed/simple;
	bh=C34z/KvQp0ZI9vF0aDlVKLw4uvTPRieVUjLo63isnKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwU2TAUUd+rBy2yHVuYPSOdXIuYsBmMVw9ome4D38TCY7eCDMYD4HXBRpEtSmuSkdEd9q8QGJwxGk8BmOroOtQ7bUScXVPiv/6n8laFMrAQBJyNt0iT5pXixoP0sit2QnhSLo5SDV3AfYn+hY13Kn3+jAuzeRTXvG2GeyrXKebQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xINUrTBg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xINUrTBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D1AC433C7;
	Mon,  4 Mar 2024 21:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588725;
	bh=C34z/KvQp0ZI9vF0aDlVKLw4uvTPRieVUjLo63isnKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xINUrTBgJ3CcLZN6gn7ypIQf8xwiRv33p7OmarIWeRSWp+iLrex7l+oeaCQ55ip/g
	 WRWSmexFnkdB0wDqT3jPudy8+BenkwjJaYumxm4m+PMhNjsDN4jAlFwIOPVnLKlhoK
	 PD9zx/7Pjz3qnvhF5BjaOCqKSv1vfSYKiWE5L4so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/215] Bluetooth: qca: Fix wrong event type for patch config command
Date: Mon,  4 Mar 2024 21:21:51 +0000
Message-ID: <20240304211558.522438770@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit c0dbc56077ae759f2dd602c7561480bc2b1b712c ]

Vendor-specific command patch config has HCI_Command_Complete event as
response, but qca_send_patch_config_cmd() wrongly expects vendor-specific
event for the command, fixed by using right event type.

Btmon log for the vendor-specific command are shown below:
< HCI Command: Vendor (0x3f|0x0000) plen 5
        28 01 00 00 00
> HCI Event: Command Complete (0x0e) plen 5
      Vendor (0x3f|0x0000) ncmd 1
        Status: Success (0x00)
        28

Fixes: 4fac8a7ac80b ("Bluetooth: btqca: sequential validation")
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index c9064d34d8308..d7d0c9de3dc31 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -152,7 +152,7 @@ static int qca_send_patch_config_cmd(struct hci_dev *hdev)
 	bt_dev_dbg(hdev, "QCA Patch config");
 
 	skb = __hci_cmd_sync_ev(hdev, EDL_PATCH_CMD_OPCODE, sizeof(cmd),
-				cmd, HCI_EV_VENDOR, HCI_INIT_TIMEOUT);
+				cmd, 0, HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		err = PTR_ERR(skb);
 		bt_dev_err(hdev, "Sending QCA Patch config failed (%d)", err);
-- 
2.43.0



