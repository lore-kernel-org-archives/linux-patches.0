Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719193D522C;
	Wed,  8 Apr 2026 18:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673769; cv=none; b=PRgJJmd4S4vvurJdgdOx78s8MLfkTVTCeX3Ef4Ntkg1FJi9hbNxnA36q6cPxg2zhjm+/BZgT2G28dYIDNIg+nx8/ZOkD7+1CnwmzCbi6d0FMKKJal1Fee474vz8VXPYsl001nZ1R8LLp+Oq2joqT1cBpj9mosSoJPrhv9EhuEvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673769; c=relaxed/simple;
	bh=N84Fbfag15lHq+i7gvU1St6sf9fWsvU5bunUeEuW1CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEuD3AzeJ6Z54ehvr1fBTiudN0sqgyCVui4bkULABLCzKwtsoDUqLkYsV1ofRY33AE9VS8Q2LCWwAvLwkzvxSeEf2WPdqCyhS/mDEN3MvNKXviCkHYdSgJS1toFIr06PUY5E3wMBCHdvkKROj6o6NztElwB3h0/JYobl7h62cfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDeeaaDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDeeaaDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FBDC19421;
	Wed,  8 Apr 2026 18:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673769;
	bh=N84Fbfag15lHq+i7gvU1St6sf9fWsvU5bunUeEuW1CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDeeaaDoCkVSPA3QhZjfYaS59+5YbdIC4OtYJUTNMhyPJAaMv2ignKXWhtRohY+5Y
	 3IXm2v8bPt7pAxjCfAYTVSYSKYpDd8SREFDWVHAD+u9WtPdaCxsAcjFMZZTyV3jz88
	 1MOrhBrOuDyXtqStZ2V30m5t/JKQ+mTpUCLOzakk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/242] Bluetooth: hci_conn: fix potential UAF in set_cig_params_sync
Date: Wed,  8 Apr 2026 20:02:03 +0200
Message-ID: <20260408175930.189040913@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit a2639a7f0f5bf7d73f337f8f077c19415c62ed2c ]

hci_conn lookup and field access must be covered by hdev lock in
set_cig_params_sync, otherwise it's possible it is freed concurrently.

Take hdev lock to prevent hci_conn from being deleted or modified
concurrently.  Just RCU lock is not suitable here, as we also want to
avoid "tearing" in the configuration.

Fixes: a091289218202 ("Bluetooth: hci_conn: Fix hci_le_set_cig_params")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 447d29c67e7c1..b36fa056e8796 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1767,9 +1767,13 @@ static int set_cig_params_sync(struct hci_dev *hdev, void *data)
 	u8 aux_num_cis = 0;
 	u8 cis_id;
 
+	hci_dev_lock(hdev);
+
 	conn = hci_conn_hash_lookup_cig(hdev, cig_id);
-	if (!conn)
+	if (!conn) {
+		hci_dev_unlock(hdev);
 		return 0;
+	}
 
 	qos = &conn->iso_qos;
 	pdu->cig_id = cig_id;
@@ -1808,6 +1812,8 @@ static int set_cig_params_sync(struct hci_dev *hdev, void *data)
 	}
 	pdu->num_cis = aux_num_cis;
 
+	hci_dev_unlock(hdev);
+
 	if (!pdu->num_cis)
 		return 0;
 
-- 
2.53.0



