Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDF22AF0E;
	Thu, 12 Dec 2024 15:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016940; cv=none; b=g0SInlSLRbpwab+Q5lyn8IM0vTNbmB1TjPOeXQ/ohSbpbjkqsGrVlw+mmeGWn22iD7wNNkZb34LwP3prijwbezpYjDeyR7AzDMydTHyTkiK+ZzG1tpdBVPLcC3N/oxfSEPAJIqvBCY5cH2DNW8THSg/sGefHeOfrOvByNiJzK6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016940; c=relaxed/simple;
	bh=tW3utze1VqAT49BVtxLdQzOUKYAH8xQCBtK1rz5Grgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJQ4vRhJek/K2Phkr8xbw5YXpskAEpjOorEKiimspYveQ30jU76CJ0c4q+mKF1n+2Xa9v7GTlJ5Zi0uoiHreyygEypY2MYJ4YCf+vaelWFTURMhtITWKj40DpnNyMRUDICoGPyWH/4JnKP78B/gbZtVZBAzSW6ORP+g3I7POPDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZCfECxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZCfECxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DCDC4CED0;
	Thu, 12 Dec 2024 15:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016940;
	bh=tW3utze1VqAT49BVtxLdQzOUKYAH8xQCBtK1rz5Grgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZCfECxQJPayOem+8o0BBjc3pz2tafGAj08kF6EAgU4BrWHxLrhaJAFVbk2qJcHQX
	 3EikB2PHO97YJOQrFriiE1/JOEg/9BN3FElPuA3uU4oBuNSvOaM7bsICA6VgK4fzLB
	 hsgLKcjv+iuAJJMmTGeDZXmOpWXl6ReAAm8vi4hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 339/466] Bluetooth: hci_conn: Reduce hci_conn_drop() calls in two functions
Date: Thu, 12 Dec 2024 15:58:28 +0100
Message-ID: <20241212144320.176426418@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit d96b543c6f3b78b6440b68b5a5bbface553eff28 ]

An hci_conn_drop() call was immediately used after a null pointer check
for an hci_conn_link() call in two function implementations.
Thus call such a function only once instead directly before the checks.

This issue was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 6354cdf9c2b37..a1dfd865d61ab 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2345,13 +2345,9 @@ struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst,
 					  conn->iso_qos.bcast.big);
 	if (parent && parent != conn) {
 		link = hci_conn_link(parent, conn);
-		if (!link) {
-			hci_conn_drop(conn);
-			return ERR_PTR(-ENOLINK);
-		}
-
-		/* Link takes the refcount */
 		hci_conn_drop(conn);
+		if (!link)
+			return ERR_PTR(-ENOLINK);
 	}
 
 	return conn;
@@ -2441,15 +2437,12 @@ struct hci_conn *hci_connect_cis(struct hci_dev *hdev, bdaddr_t *dst,
 	}
 
 	link = hci_conn_link(le, cis);
+	hci_conn_drop(cis);
 	if (!link) {
 		hci_conn_drop(le);
-		hci_conn_drop(cis);
 		return ERR_PTR(-ENOLINK);
 	}
 
-	/* Link takes the refcount */
-	hci_conn_drop(cis);
-
 	cis->state = BT_CONNECT;
 
 	hci_le_create_cis_pending(hdev);
-- 
2.43.0



