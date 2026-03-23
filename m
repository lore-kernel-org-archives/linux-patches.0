Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887943B9D9E;
	Mon, 23 Mar 2026 15:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279358; cv=none; b=f8V0aTRsXRxbflOurPJZ73bmyqVtmEm06asniZJ1sQpdXVGpFWbk5rgztFCTNpVIT5sJJXbA5UWMSXDua0pb5qZRFzBgyQaMaYt+QakhFyRvFJZ7jY5QSlO5RDTmW+Ss4XDnAiFNJv7kvfuEvb3BoKVxiy0F7c3ZBa5IgjOqtno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279358; c=relaxed/simple;
	bh=ZKvzamMD5QCpjdFVGHU1sQjlT1KNpDsWeH9Bnqo9ecs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akKWq9qzapjdAJe/RTMk9B8rWLNiibZ8ywuLeHmbkCJ+7BvVw/JH04UAZKgIckYoYQnC/iu39wXOT+PJ+fZvHwldYsmTQ5Xd3Z1an/DFGtsEQYhrfo8paPvejjkjDI3oP5JcvZATKMKauy84/7pb6HjFv+li+22rIrlXoCk/7gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rkw0bsRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rkw0bsRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10A4C4CEF7;
	Mon, 23 Mar 2026 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279358;
	bh=ZKvzamMD5QCpjdFVGHU1sQjlT1KNpDsWeH9Bnqo9ecs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rkw0bsRaC3IfbAB2cG1YTctKzgmHDv+HCw2ptEStyW+D2M+0ucUuzdxFDTJ7J2ysQ
	 epYGHg/opOJxMv75pfmtqobCyv3I8oz9aYZxfX+EA+EjVT9PaCMoMjgUv5ffsVAIHi
	 uVz2ohqBYkV8qhVm6c+ir/0/9IhUQIWBcoRbRX3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 506/567] Bluetooth: ISO: Fix defer tests being unstable
Date: Mon, 23 Mar 2026 14:47:06 +0100
Message-ID: <20260323134546.539276215@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 62bcaa6b351b6dc400f6c6b83762001fd9f5c12d ]

iso-tester defer tests seem to fail with hci_conn_hash_lookup_cig
being unable to resolve a cig in set_cig_params_sync due a race
where it is run immediatelly before hci_bind_cis is able to set
the QoS settings into the hci_conn object.

So this moves the assigning of the QoS settings to be done directly
by hci_le_set_cig_params to prevent that from happening again.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 30feeaf7e6424..97e48c1f69aff 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1837,6 +1837,8 @@ static bool hci_le_set_cig_params(struct hci_conn *conn, struct bt_iso_qos *qos)
 		return false;
 
 done:
+	conn->iso_qos = *qos;
+
 	if (hci_cmd_sync_queue(hdev, set_cig_params_sync,
 			       UINT_PTR(qos->ucast.cig), NULL) < 0)
 		return false;
@@ -1903,8 +1905,6 @@ struct hci_conn *hci_bind_cis(struct hci_dev *hdev, bdaddr_t *dst,
 	}
 
 	hci_conn_hold(cis);
-
-	cis->iso_qos = *qos;
 	cis->state = BT_BOUND;
 
 	return cis;
-- 
2.51.0



