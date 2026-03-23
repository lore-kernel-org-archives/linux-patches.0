Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A28C3AEF51;
	Mon, 23 Mar 2026 14:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274856; cv=none; b=Jg/yXwO4UhdWxzfLLIkhOnOtRwv5H7tvYpsU/aCscq2SFeXvhjMtNYyMCsKB0E9C0avv69kTaEQw8X6VBgxkbJjriJcYppllX78HX4fqMwvN6WFWOQPq3Zf3FjCkMt93ZIEo8AjcAbzviaAx5qQnC9NKAtmhwGqh26iZRFg7on4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274856; c=relaxed/simple;
	bh=3/MJwTqKaclFx9DobQ5BjuO9GBqhoztWhQE11QYnnsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jx7ymacBWUnQQoEbynVaK+cRS4J1oX4jysqQRaRZkUvHEcx7VouhKog4VauxbfwTfj+oVtjKIUj5m+8uca3yE4k13SFg5boSbVxr3jpbyMe6nh46Af0GmTkw8Uv26Ez+eRpHHDy2gJi4yidQfhKufhh33bSPNpJ6+K1088Ci1kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CI6QUt33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CI6QUt33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E6FC4CEF7;
	Mon, 23 Mar 2026 14:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274855;
	bh=3/MJwTqKaclFx9DobQ5BjuO9GBqhoztWhQE11QYnnsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CI6QUt33bR77B1PXBz1HNjUm+yg8aqkzb6euFGyUd65xV91FQtBG5XxL02/08Erf+
	 +A9uGxKGslW/EZI2xuxkn0dGqaZIr9t308v7xex7vBRZPDPbdO7Dn4Hl2FRT5OXA+H
	 soURh+C4zrAblbLmjVTOgji8Ox289eIbm2sGERno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/212] Bluetooth: ISO: Fix defer tests being unstable
Date: Mon, 23 Mar 2026 14:45:46 +0100
Message-ID: <20260323134507.719260646@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6a27ac5a751ca..8906526ff32c5 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1927,6 +1927,8 @@ static bool hci_le_set_cig_params(struct hci_conn *conn, struct bt_iso_qos *qos)
 		return false;
 
 done:
+	conn->iso_qos = *qos;
+
 	if (hci_cmd_sync_queue(hdev, set_cig_params_sync,
 			       UINT_PTR(qos->ucast.cig), NULL) < 0)
 		return false;
@@ -1996,8 +1998,6 @@ struct hci_conn *hci_bind_cis(struct hci_dev *hdev, bdaddr_t *dst,
 	}
 
 	hci_conn_hold(cis);
-
-	cis->iso_qos = *qos;
 	cis->state = BT_BOUND;
 
 	return cis;
-- 
2.51.0



