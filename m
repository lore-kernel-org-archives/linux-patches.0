Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9CC3128D7;
	Tue,  2 Sep 2025 13:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819490; cv=none; b=h7z6IRWdOod/OvSyzkkiXky9Xc22bOC5gvmaDJUONoiBnBxPHPG45H07RNt2XUVj3fd8Yv32GfC1ns1fAMCxTvyWJONQ3Y4N9vdijyxdEg4XimN8/Xbg9cjgd2B5pZp3dCXbujGZjabQ/P1KCnM5jJdJBneFpiM+3dkkjCmpAoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819490; c=relaxed/simple;
	bh=AnYaPLjMaebsKhtAgYW/qarfQPnNfcKhSA9vnuQhROE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjInWWTdGK3KNXuf2M85C8PCoOlOdjVSJPOFUltgLkGvQ/iEdWxN0gVzlgB3kCTPeL7x17CrIbCLzZCznPmsgoC2clWrmqomboQ2cL3CjmIZnVbkNCbisjmVF1t3OePGjnHp0w4zviUEA18aBCcX3HKX5j5+fB4r1MPcEodCxzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQ/nxR1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQ/nxR1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F4AC4CEED;
	Tue,  2 Sep 2025 13:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819489;
	bh=AnYaPLjMaebsKhtAgYW/qarfQPnNfcKhSA9vnuQhROE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQ/nxR1Dzfzzmkb3E9z3g1dY5i/7b9NGYx9iWJGPE7MRhaMPKTlTAU0XWugHoeUBk
	 HmNJoYrWaKb5WBEIeTdT8zgvV2766RQXHpd8MFqVlAbB3uc1Urnb6QdMMgxrv4koVQ
	 w16WQkQ/esuFZ12RyoaJoBdvjzHAxsKUrhZuZDm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 049/142] Bluetooth: hci_event: Detect if HCI_EV_NUM_COMP_PKTS is unbalanced
Date: Tue,  2 Sep 2025 15:19:11 +0200
Message-ID: <20250902131950.133556528@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

[ Upstream commit 15bf2c6391bafb14a3020d06ec0761bce0803463 ]

This attempts to detect if HCI_EV_NUM_COMP_PKTS contain an unbalanced
(more than currently considered outstanding) number of packets otherwise
it could cause the hcon->sent to underflow and loop around breaking the
tracking of the outstanding packets pending acknowledgment.

Fixes: f42809185896 ("Bluetooth: Simplify num_comp_pkts_evt function")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index cadb53e21c0ef..02b2ef9a75746 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4404,7 +4404,17 @@ static void hci_num_comp_pkts_evt(struct hci_dev *hdev, void *data,
 		if (!conn)
 			continue;
 
-		conn->sent -= count;
+		/* Check if there is really enough packets outstanding before
+		 * attempting to decrease the sent counter otherwise it could
+		 * underflow..
+		 */
+		if (conn->sent >= count) {
+			conn->sent -= count;
+		} else {
+			bt_dev_warn(hdev, "hcon %p sent %u < count %u",
+				    conn, conn->sent, count);
+			conn->sent = 0;
+		}
 
 		for (i = 0; i < count; ++i)
 			hci_conn_tx_dequeue(conn);
-- 
2.50.1



