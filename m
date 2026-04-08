Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753883D9DA5;
	Wed,  8 Apr 2026 18:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674497; cv=none; b=FPOcFg4azB8v1KlbjdcpcwJ0hZldD/NHUo5Db02xhQX6ZH8jpjlieeuwCZ1fy2G6nT7Kc+lG0/dXXQ01NLyTo1QPPFeWwogWEnFwpKB9BsgVxqSgl9rz6AzVN+SQGR3AbISmLLAEiCbnqlgGjhrLdzoPDfg+aanSBYtIl7bWnWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674497; c=relaxed/simple;
	bh=FfwSmCIbN6y2+5vT/wrjsaIQH3x6K17+BOGuE/g3N1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cc34qKUJFkyQQzc8TRGyQvKylGP32TiA0gmdt+O70h+oNhefoHjaLtw5NEzECUybFGHsnh2RSlkZ3/jR08Om5uFztJRbSyosG34I+y349lAuPnCx737NjpL5rB4QlioZdj8IZBOdC4FXblQk7oPTxJ0pzaZJuSVSqh8qXonEdyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCB/jVnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCB/jVnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC52C2BC87;
	Wed,  8 Apr 2026 18:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674497;
	bh=FfwSmCIbN6y2+5vT/wrjsaIQH3x6K17+BOGuE/g3N1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCB/jVnl2IdGOL0qegwXE3aHreJ9ZXwwnaOh7YVHfGDojrlRzmwBId2yjpOTFpaNj
	 VhM2vpJE+418y4oXpc7M84kIUAnTn1Siu/O/uR0mscDR4FW544F1H2eHJW15F2q4in
	 rYVLnwm2WsEH8wkmOCcvYLua6vcv1jSDBJob8Fi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 103/311] Bluetooth: hci_conn: fix potential UAF in set_cig_params_sync
Date: Wed,  8 Apr 2026 20:01:43 +0200
Message-ID: <20260408175943.260350722@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 48aaccd35954a..a966d36d0e798 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1843,9 +1843,13 @@ static int set_cig_params_sync(struct hci_dev *hdev, void *data)
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
@@ -1884,6 +1888,8 @@ static int set_cig_params_sync(struct hci_dev *hdev, void *data)
 	}
 	pdu->num_cis = aux_num_cis;
 
+	hci_dev_unlock(hdev);
+
 	if (!pdu->num_cis)
 		return 0;
 
-- 
2.53.0



