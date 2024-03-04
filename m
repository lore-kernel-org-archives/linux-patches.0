Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7421F60A;
	Mon,  4 Mar 2024 21:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588078; cv=none; b=BeIYB178IBP4A7Hc380VVAzCwC+gDjR+Qjna49jz/co5S1yln7HFkPOy7GQnY471UY894c7IGiccTaWNJxX6GS1lCHd72bFDU8y3dS5beWTOzEPyO7sPnhBBNeovPVpg+wY0FwoZqJZkS9Ax/+LqmTEsUNrN37hc4Mca2ZNT230=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588078; c=relaxed/simple;
	bh=Lo9ypt0c+doW6kvTx96Fh6Q0HwlRIONk4x2O4Y0ncmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3vgCZz+kmP46/dBjYWCPiRltCN0UrAx/kEhauLPmQ/WOSLvivbub7miAHljAkSaG0RHd12tv34MV/wyO1RM25xWWUiD9CaghdKYNuWKSaEiPzgb7mH1vRfyAW88Z7AbnZzX0SAK1o6SfwGKc+vqBtVVHp9bjvO1bNwPJ67TSgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnHiJZ5Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnHiJZ5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E704DC433F1;
	Mon,  4 Mar 2024 21:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588078;
	bh=Lo9ypt0c+doW6kvTx96Fh6Q0HwlRIONk4x2O4Y0ncmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnHiJZ5ZzP78sA4Vn2qxlnSgDtP/DjOY4h3gBQMoInnDwv6YJknRcVqgCr/rN2Hki
	 KyCvXAfmHG+fUSXXr4NhSH27LtseyG/yw6qiaCIe0oeXQCYxPIGl8nPrXG5g4I1zRM
	 UkgS2JPg9DctlMdSJU4FDehQc1orbUJv2gWFebwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/42] Bluetooth: hci_event: Fix handling of HCI_EV_IO_CAPA_REQUEST
Date: Mon,  4 Mar 2024 21:23:40 +0000
Message-ID: <20240304211538.088447149@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 40e9f1babe9e9..ea25bb31b336a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4612,9 +4612,12 @@ static void hci_io_capa_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
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



