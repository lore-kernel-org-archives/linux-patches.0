Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A2D1DF25C;
	Mon, 23 Mar 2026 13:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274189; cv=none; b=rZGQVT+d7vZqwrzMHvyUhTwCLLMwyXFB5OTuOniSIzQRDKXpec/qPaCgPSl6b7yb8NrkRlOV+atQ1PLpwRwkgmtcsaR5sqMKSGb6WAfvhx3568QuXhIK/4S6/JxzMpP53IUvOm7k0HOkRXixc3UanvKpY2tJJd8OdYUt8mcqSRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274189; c=relaxed/simple;
	bh=Asz9HWthUha/qED+G9P2fFUM3YhlAX/gU0nz+R0KWuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7+ggqw+3mLDWtTsP3Z91dAq56ZjYRklc9yBlyIwQSXuwZBnJwff9cgFYbDxU2dBV+qTpMerqqLmXpP5M3OxjlppctOthP2k98DtDmAgfVTUMNusglahdbc6CduWmVh8YyAH8Bo0ZQqHv65wHxUnAUUzO/NsXg7RzM09xEih1lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zptlhKN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zptlhKN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0606C2BC9E;
	Mon, 23 Mar 2026 13:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274189;
	bh=Asz9HWthUha/qED+G9P2fFUM3YhlAX/gU0nz+R0KWuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zptlhKN9Aw2lw3Pc4iq4ckKaSDkknkdRHkmErDPiM7Q+FwAhjjoSu4wJpPV45/Wdj
	 ww4NNwKqVKRrG2gUiQdw3ky3zcMwY1+ljieSAxHXhWKFCpBjK5G5ChqTABoxenDJxa
	 aMoKl7aI7Hokp3XF1PhxArlbl0Cs5u25/8I6pbXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 121/220] Bluetooth: ISO: Fix defer tests being unstable
Date: Mon, 23 Mar 2026 14:44:58 +0100
Message-ID: <20260323134508.420003827@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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
index dc085856f5e91..0f512c2c2fd3c 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1944,6 +1944,8 @@ static bool hci_le_set_cig_params(struct hci_conn *conn, struct bt_iso_qos *qos)
 		return false;
 
 done:
+	conn->iso_qos = *qos;
+
 	if (hci_cmd_sync_queue(hdev, set_cig_params_sync,
 			       UINT_PTR(qos->ucast.cig), NULL) < 0)
 		return false;
@@ -2013,8 +2015,6 @@ struct hci_conn *hci_bind_cis(struct hci_dev *hdev, bdaddr_t *dst,
 	}
 
 	hci_conn_hold(cis);
-
-	cis->iso_qos = *qos;
 	cis->state = BT_BOUND;
 
 	return cis;
-- 
2.51.0



