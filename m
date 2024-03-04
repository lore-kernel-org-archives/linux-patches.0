Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DFA1EA99;
	Mon,  4 Mar 2024 21:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587563; cv=none; b=BfchVzn9yMTtbvZXvYcokR8AmjrP/PPMO17PC2GuXnCIS/wm0XqSeaTBWVPIbanyBALtgs51UohcB/0eBR4ihFBCHCB9EwlJ0OeB4oAoAg4ZxW69V8zL6dlYVomW9kFtgqtsOn/suEgYI0hwo3o9ivpX5s7PSRn8kQEmMJITgMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587563; c=relaxed/simple;
	bh=xDv1Ftq9css1sgs89AiL3FHZcZ+/IJp1Oe2EdVJPfvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bT0LblBkHFRW+OMlvAgMMrHqK4Hg6+G8Re9mJHqQexq3fmmQFKrTOI9LIcsUBTqif9Vy+mhAW5qgtTZKPndj/nRrdNom8mGu9T5amOPGRgy0L9b8MtcrUU0ylPPrf+G8C9H14qXGxjT35PjitPvtWQvfP6uDx4+bSSIx3Kns/Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQ3mtNgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQ3mtNgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36823C433F1;
	Mon,  4 Mar 2024 21:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587562;
	bh=xDv1Ftq9css1sgs89AiL3FHZcZ+/IJp1Oe2EdVJPfvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQ3mtNgmXSqaD2DKVQEArlS5l4vSE2pI6u00NYGZs/B93toyxiiuWTr662Pmy03T/
	 iX7D+fxUoMELpFkuYF8sTnyywU5vtCw25WY3f2LdeTzCP6CwtX8I3PeLC0UfSVWiQs
	 q3ejfojDc5MLSOKF0VABdoumEnHSRh5+OETg++h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/16] Bluetooth: hci_event: Fix handling of HCI_EV_IO_CAPA_REQUEST
Date: Mon,  4 Mar 2024 21:23:27 +0000
Message-ID: <20240304211534.568693898@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211534.328737119@linuxfoundation.org>
References: <20240304211534.328737119@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 7e74aa53a68bf60f6019bd5d9a9a1406ec4d4865 ]

If we received HCI_EV_IO_CAPA_REQUEST while
HCI_OP_READ_REMOTE_EXT_FEATURES is yet to be responded assume the remote
does support SSP since otherwise this event shouldn't be generated.

Link: https://lore.kernel.org/linux-bluetooth/CABBYNZ+9UdG1cMZVmdtN3U2aS16AKMCyTARZZyFX7xTEDWcMOw@mail.gmail.com/T/#t
Fixes: c7f59461f5a7 ("Bluetooth: Fix a refcnt underflow problem for hci_conn")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 9d01874e6b936..e4fea656941ee 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4337,9 +4337,12 @@ static void hci_io_capa_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &ev->bdaddr);
-	if (!conn || !hci_conn_ssp_enabled(conn))
+	if (!conn || !hci_dev_test_flag(hdev, HCI_SSP_ENABLED))
 		goto unlock;
 
+	/* Assume remote supports SSP since it has triggered this event */
+	set_bit(HCI_CONN_SSP_ENABLED, &conn->flags);
+
 	hci_conn_hold(conn);
 
 	if (!hci_dev_test_flag(hdev, HCI_MGMT))
-- 
2.43.0



