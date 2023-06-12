Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184CAD518
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93836C433D2;
	Mon, 12 Jun 2023 10:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566837;
	bh=t6oZawh5BrloM/nJ95odXw9T/mS493zvK3EbgkxQUmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4dS2UnNNy6bVc5BjQFYQ5SsM/M3+9cC3LPMQ12RvEApCCprcWw4L+ps7kI/qkC/v
	 cqq5Y7RwYzKczKzhvGDfY9kmw/wFLz+SEFAfrtGKA75LF87jk7g+xOg/9rNY6SwGw9
	 1AdfT3YLS+Mfit1e86YVCmlDBJVpK0CKP06nFWVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 021/160] Bluetooth: ISO: consider right CIS when removing CIG at cleanup
Date: Mon, 12 Jun 2023 12:25:53 +0200
Message-ID: <20230612101716.040555329@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 31c5f9164949347c9cb34f041a7e04fdc08b1b85 ]

When looking for CIS blocking CIG removal, consider only the CIS with
the right CIG ID. Don't try to remove CIG with unset CIG ID.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 5672b49245721..3820d5d873e12 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -943,8 +943,8 @@ static void find_cis(struct hci_conn *conn, void *data)
 {
 	struct iso_list_data *d = data;
 
-	/* Ignore broadcast */
-	if (!bacmp(&conn->dst, BDADDR_ANY))
+	/* Ignore broadcast or if CIG don't match */
+	if (!bacmp(&conn->dst, BDADDR_ANY) || d->cig != conn->iso_qos.ucast.cig)
 		return;
 
 	d->count++;
@@ -959,6 +959,9 @@ static void cis_cleanup(struct hci_conn *conn)
 	struct hci_dev *hdev = conn->hdev;
 	struct iso_list_data d;
 
+	if (conn->iso_qos.ucast.cig == BT_ISO_QOS_CIG_UNSET)
+		return;
+
 	memset(&d, 0, sizeof(d));
 	d.cig = conn->iso_qos.ucast.cig;
 
-- 
2.39.2



