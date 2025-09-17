Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6DD36D;
	Wed, 17 Sep 2025 12:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112623; cv=none; b=AIsnKTlt3OzSSL4G7W1wg677O+HKf/mXbh3l1DzcZoNeTC/xU/cNfcSbqkLH8i4K/uPMp2Uifs52F/s39EJxYpwb/YcHowW2eF4zQjhxIQLW4ljsjkfiGoi59hIjInTxYeFun06sbcaHBIV9gxBQoTRZXy9/k9E9QKMr59gUNbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112623; c=relaxed/simple;
	bh=5VJmtpqbf5Dv4/c0XDqyZ1kYoOvFd4E3rCHoWY7YfFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsqPc4k8EmejnW8d+ktH75R375Qy9lV7i/tWvDDz9sqRi0y81Nuao1zd4pocGpVmm1T9qMvHIxDwm2v+hhKjkZzuY+p0na4wcTsN6wQHf1FEVeO6Cxx9ST6QolmSaPwxJlZmTSUCeBatjlxdz7FHwEXkJ3+8Odg+JdkGeqE+/xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yRVBxI8L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRVBxI8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F708C4CEF5;
	Wed, 17 Sep 2025 12:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112622;
	bh=5VJmtpqbf5Dv4/c0XDqyZ1kYoOvFd4E3rCHoWY7YfFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yRVBxI8LZIUbeGAkEsQTPacqGDODp6t1sVAdteBviFNLRhCyrss7eCW9gJmzcPyvi
	 eEK1yjyCBYW8IoimqCyy73cdCbtO7JMmZ0slghCjxDUs1cxah5UvC+zFiDw3u59aTh
	 3Rr0f1LCCS6buO4y67pxYoiHesT1wTCWyWKsGjJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 009/189] Bluetooth: hci_conn: Fix not cleaning up Broadcaster/Broadcast Source
Date: Wed, 17 Sep 2025 14:31:59 +0200
Message-ID: <20250917123352.078727318@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 3ba486c5f3ce2c22ffd29c0103404cdbe21912b3 ]

This fixes Broadcaster/Broadcast Source not sending HCI_OP_LE_TERM_BIG
because HCI_CONN_PER_ADV where not being set.

Fixes: a7bcffc673de ("Bluetooth: Add PA_LINK to distinguish BIG sync and PA sync connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index ad5574e9a93ee..dc4f23ceff2a6 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2274,7 +2274,7 @@ struct hci_conn *hci_connect_bis(struct hci_dev *hdev, bdaddr_t *dst,
 	 * the start periodic advertising and create BIG commands have
 	 * been queued
 	 */
-	hci_conn_hash_list_state(hdev, bis_mark_per_adv, PA_LINK,
+	hci_conn_hash_list_state(hdev, bis_mark_per_adv, BIS_LINK,
 				 BT_BOUND, &data);
 
 	/* Queue start periodic advertising and create BIG */
-- 
2.51.0



