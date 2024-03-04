Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7E043AAE;
	Mon,  4 Mar 2024 21:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587636; cv=none; b=IuLn07dcoyCZI7f7Xcu/xmfVTmvC2JUEzSVGS2ZVLLcI+PQDHQjI83sCgRClea8614M+TLmYnpiak9u5hVKZlptRQd13I91v6sKHzo8JB8zWdDIeL9oHNcwoGAlFxDllAG9lD9MbIDoD1/j/MPzPRntzjUJjYz2w/pko2vE1U3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587636; c=relaxed/simple;
	bh=Ssm+Y6N3dM/nvSmJgynn8TFNQi++b2oeeqTZw3EJ53c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkvCgpVwu+hLNdam50lPgZDZ5bKZitA6v1nujykekCeoRSwxEBHwOQTJV1xYslUdtfip27z9OHdWvqHNJm5s8K3L0LGM+ptef4XezcV8NB6tTtX/gAJHsjPf/pEfz0SxYOvjxpIl0mNJ/V+Ch3wNtjEeKMH2pp4fBHRDf+Ga7bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRxuhOE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRxuhOE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CCBC433F1;
	Mon,  4 Mar 2024 21:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587636;
	bh=Ssm+Y6N3dM/nvSmJgynn8TFNQi++b2oeeqTZw3EJ53c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRxuhOE3Iu85iwH0o2isMvIabg1T2OWWUSmpy8f8Sr+rKbhelLMfFTDH4BIrtjWER
	 iNzLx4Vv451RilqMlogF6usjF4KdAz+s4VdcKdU5M/U64A9fg2/DtznSCKly/PIpuA
	 tq93l6qmYZbR+u+jRaV7nk5dLKnSjBWYRUW1mQkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 031/162] Bluetooth: qca: Fix wrong event type for patch config command
Date: Mon,  4 Mar 2024 21:21:36 +0000
Message-ID: <20240304211552.825688145@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index fdb0fae88d1c5..b40b32fa7f1c3 100644
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



