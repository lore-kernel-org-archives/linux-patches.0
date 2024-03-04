Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D021846BA0;
	Mon,  4 Mar 2024 21:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588719; cv=none; b=SAQUgahCyp7STd5CbSVxqGNoJtVz0H0s2rcTqoELo70GYUE343PTpS2v0GCpaIMk2ow7biNmGFpwm62HNcc9URE3gmeYcXm5CYTceD1R2jaY3ntWZRwV5lJbWdHyjLHXyvCu3T+zRdzPNGnHGi5T2xgyzo9Pkr9wS7CbqGTldXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588719; c=relaxed/simple;
	bh=IaIm+MsarA+fgzfqDQ5ASgpwCggKMM/uG9Ij7E14MDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnTxQtQ6EMa3j589ws0iUzgs8talnNcZCLkHqoMHlXU2zCQfRhSmMpPJlRktxpx1COAwnPThKTTbFc9DMMWRhA0wz9AG1V74tv14456EaLG1m+y62rYRmDYJcVRqIpzFCjqH3rOQozWRY5YlfgQdnc9/Bth0i7PADlvdJhYza4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcx/qgIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcx/qgIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E60C433C7;
	Mon,  4 Mar 2024 21:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588719;
	bh=IaIm+MsarA+fgzfqDQ5ASgpwCggKMM/uG9Ij7E14MDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcx/qgIoajahSoad0iV/QnFiccfVfUXSD1taB0+ttaLBb+7QuVfsFh09wtp/0sszU
	 A/U/mB/EC0n3OssGEGgg4VnU6al6EEjEHidiHrW3OxLJTEf6DQ97GxYcQNNSXqKcAF
	 I9gNYDCdVNZ+W0oaVL5W17DSUsJFRfSEvY2xX4mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 046/215] Bluetooth: hci_event: Fix handling of HCI_EV_IO_CAPA_REQUEST
Date: Mon,  4 Mar 2024 21:21:49 +0000
Message-ID: <20240304211558.460617529@linuxfoundation.org>
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
index b18f5e5df8ad0..f79aaef5a276d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5282,9 +5282,12 @@ static void hci_io_capa_request_evt(struct hci_dev *hdev, void *data,
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



