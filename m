Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A423F9F45;
	Mon, 31 Aug 2026 14:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184856; cv=none; b=DodiLgRYXCxa1J008qm2flnr9cZFwSTAVzNk1S0xCOoEpJbUiLS6CltTabafm8SmAh5CfXp1/BGa1iQknbzXDBmvRREZ1ksq8OnQ18BGf897dlq+iY1K+foaFH0EzrWhDF7tieYrzczSGi3OX+QdJ5UPKVvBBQvhxxvWPzXnHkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184856; c=relaxed/simple;
	bh=aKhGFyzMQPLPXI1ouXBv/4PJbNpYjXc0iOkby7/UjlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdMTndMIv4SsH/PBN/7xAur2XhEpKsSSF4/K5rTJFOyMQeCNi9MfdV2OKlzNEMfB0AmBo580wCPPAaa1vY/r8woV7V4waZJauZC5lldFeoPsj18OVwX/IMPdyR5YeUVhooft+306YzLXWeyy299AkpZq1NX+eSFYplzTpG5mc04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmxSyf+d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmxSyf+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDD81F000E9;
	Mon, 31 Aug 2026 14:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184854;
	bh=sUVu/cqM7zftvvZvDTikgtlWRxYhnfzQhiuURz/HU9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmxSyf+dK39OHvl5mzAZ68GHU/dSo9jo4YnPCf7hUba+JS92YIzFkHnBNFziqWdwI
	 56S64RKYK2BMt4izJMDTEOKzwLurJFmlXLInq4kXRPvF7tLhwKVZnFNpKZ1RmDi5wL
	 ysZqL4/oD+ZKpc77Qd9pZlhqK5mDJ5exOs6cB/H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 59/92] Bluetooth: hci_event: fix Set CIG Parameters error status handling
Date: Mon, 31 Aug 2026 15:34:57 +0200
Message-ID: <20260831133402.747092631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit db9cbcadc16e8b9f0b3ef5870f3a38ebafcbe8e0 ]

If the event has error status, return right error code and don't show
incorrect "response malformed" messages.

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0acd4eeb4b22 ("Bluetooth: hci_event: validate LE Set CIG Parameters response")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3793,7 +3793,8 @@ static u8 hci_cc_le_set_cig_params(struc
 	bt_dev_dbg(hdev, "status 0x%2.2x", rp->status);
 
 	cp = hci_sent_cmd_data(hdev, HCI_OP_LE_SET_CIG_PARAMS);
-	if (!cp || rp->num_handles != cp->num_cis || rp->cig_id != cp->cig_id) {
+	if (!rp->status && (!cp || rp->num_handles != cp->num_cis ||
+			    rp->cig_id != cp->cig_id)) {
 		bt_dev_err(hdev, "unexpected Set CIG Parameters response data");
 		status = HCI_ERROR_UNSPECIFIED;
 	}


