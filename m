Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE9530CB29;
	Wed, 17 Sep 2025 12:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112729; cv=none; b=BjUbSW9mqNDboWywfw8k9w9mFVF3byV9wfwphm3WiQsukupvbgJ6aic1e0ZGpF0H0OhAe3clNpIUoRQmjmVX4KTmb6n2mpA67Zza1s7ZOQ79O22ndKMZWWdtClu43mFbmixDwZiq3bVc3Sl05J0Vk9x8vJZp/Dax6xoy7h1PA9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112729; c=relaxed/simple;
	bh=k3CYW3ukjjhLI2bxlRSkQmV6tEqaYocHpGI8BITV+ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Th3jmMfia94glq5KY0pMYkChWNSXY71vWVr9WUPoqXVGI9GABjA3Mi+pFMfwt59jKewhnOL6UfrKJ0H8nSIeqbz8ybHiDRU8krxNQ/GCnKdGtqCZil0GeW3Gt3ZH2Sa/Fj9QoD/Hnyu8ZGvQNRs5UQckvilEXycB+vb0xfnOfpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrNOkdaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrNOkdaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05586C4CEF0;
	Wed, 17 Sep 2025 12:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112729;
	bh=k3CYW3ukjjhLI2bxlRSkQmV6tEqaYocHpGI8BITV+ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrNOkdaJoSWyFIzpNWZrs54B1Nz1UGJeOJX22EyoWGc104XwS0jwzvUvprIDvpalu
	 mUEpTDSM00btONxN2t4NAeTuqU6+pHN6lowAZCwhSQS09jy5V1Ej1A5qskbkfuT/6l
	 ZFHXsUB3xRVLR4AHSTtV+bF9dmMYNVNiS32hRHl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 014/189] Bluetooth: hci_conn: Fix running bis_cleanup for hci_conn->type PA_LINK
Date: Wed, 17 Sep 2025 14:32:04 +0200
Message-ID: <20250917123352.197184841@linuxfoundation.org>
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

[ Upstream commit d36349ea73d805bb72cbc24ab90cb1da4ad5c379 ]

Connections with type of PA_LINK shall be considered temporary just to
track the lifetime of PA Sync setup, once the BIG Sync is established
and connection are created with BIS_LINK the existing PA_LINK
connection shall not longer use bis_cleanup otherwise it terminates the
PA Sync when that shall be left to BIS_LINK connection to do it.

Fixes: a7bcffc673de ("Bluetooth: Add PA_LINK to distinguish BIG sync and PA sync connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c  | 12 +++++++++++-
 net/bluetooth/hci_event.c |  7 ++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index dc4f23ceff2a6..ce17e489c67c3 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -829,7 +829,17 @@ static void bis_cleanup(struct hci_conn *conn)
 		/* Check if ISO connection is a BIS and terminate advertising
 		 * set and BIG if there are no other connections using it.
 		 */
-		bis = hci_conn_hash_lookup_big(hdev, conn->iso_qos.bcast.big);
+		bis = hci_conn_hash_lookup_big_state(hdev,
+						     conn->iso_qos.bcast.big,
+						     BT_CONNECTED,
+						     HCI_ROLE_MASTER);
+		if (bis)
+			return;
+
+		bis = hci_conn_hash_lookup_big_state(hdev,
+						     conn->iso_qos.bcast.big,
+						     BT_CONNECT,
+						     HCI_ROLE_MASTER);
 		if (bis)
 			return;
 
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 0ffdbe249f5d3..090c7ffa51525 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6973,9 +6973,14 @@ static void hci_le_big_sync_established_evt(struct hci_dev *hdev, void *data,
 				continue;
 		}
 
-		if (ev->status != 0x42)
+		if (ev->status != 0x42) {
 			/* Mark PA sync as established */
 			set_bit(HCI_CONN_PA_SYNC, &bis->flags);
+			/* Reset cleanup callback of PA Sync so it doesn't
+			 * terminate the sync when deleting the connection.
+			 */
+			conn->cleanup = NULL;
+		}
 
 		bis->sync_handle = conn->sync_handle;
 		bis->iso_qos.bcast.big = ev->handle;
-- 
2.51.0



