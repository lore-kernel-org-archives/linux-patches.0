Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578553B2FFC;
	Mon, 23 Mar 2026 14:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277386; cv=none; b=aBfk1fUlTToecZNWg3vdolxxBZyUSAhylLJolhVFyOlM1gOBSxx7mIKoNyZ1EUdoYlJG/Gq+Dm1di039LnEw4KcGbNBmRYiyMIPr8waGMtLEHKgxKjtVqRSQXl6W86GAPhSiPkWG1g6JfLlQGwC6qjgh8S8nYGdDQaVJIYlIDw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277386; c=relaxed/simple;
	bh=KMz5i571M73eZmOyHJIsRPiW9pUFIJULhJRzpM5eQKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0qXwyP9tJXRdvXYA0Rf5NIOVkEMGW0zfKxnnV2SxIywia587g/euuI89RSR1KcSQN2V7X2fOUh/O+yXSygpgf6KkHp9Q62GTYZ/SOIr8Hiaon0lDM1Qv1WLY7I3p0CLIUKJtEFQCMENGedLkyTo9nFEvVe7EbKHH9XQrlxCJ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKauHyR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKauHyR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FD0C4CEF7;
	Mon, 23 Mar 2026 14:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277386;
	bh=KMz5i571M73eZmOyHJIsRPiW9pUFIJULhJRzpM5eQKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKauHyR5XqAYXHnu0nDlElO1/UpjyUhuRZF3mkiYn0zLLYBJLkChTKm/1B5m7KXO4
	 FtynWtVrTkQ6QnecB11fY/7s12nQC7lKX8ySQ6QzrnBAlJwW7Mek+tR/ngf6RETJ+P
	 gRTQD2MavYmIepNKQET1Tw744mhZ1ZD0MmLo32Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 383/460] Bluetooth: ISO: Fix defer tests being unstable
Date: Mon, 23 Mar 2026 14:46:19 +0100
Message-ID: <20260323134535.980379965@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
index fa74fac5af778..447d29c67e7c1 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1868,6 +1868,8 @@ static bool hci_le_set_cig_params(struct hci_conn *conn, struct bt_iso_qos *qos)
 		return false;
 
 done:
+	conn->iso_qos = *qos;
+
 	if (hci_cmd_sync_queue(hdev, set_cig_params_sync,
 			       UINT_PTR(qos->ucast.cig), NULL) < 0)
 		return false;
@@ -1934,8 +1936,6 @@ struct hci_conn *hci_bind_cis(struct hci_dev *hdev, bdaddr_t *dst,
 	}
 
 	hci_conn_hold(cis);
-
-	cis->iso_qos = *qos;
 	cis->state = BT_BOUND;
 
 	return cis;
-- 
2.51.0



