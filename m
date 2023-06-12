Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CA411C88
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9643C433EF;
	Mon, 12 Jun 2023 10:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566419;
	bh=KMI9ei2Dfb6cE4OolLTe5QXrIfxcguDlWCN7q/2DRvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRGBWf/dBPOh9obIwtXnjN1bjMnjjaidBXTuVIyVwJqje5OLVKCrXgVmyTM2RQn93
	 D7NDwRUgHokxu6I8zB6KJVASiUT/h4ZcY7o8ut6pwFAptceQKk1XnYTtOxfAN+zOyj
	 rzvY7WbVpxDUWOV0X6tNoyZqQorbzW5/x60Ev3es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/132] Bluetooth: ISO: dont try to remove CIG if there are bound CIS left
Date: Mon, 12 Jun 2023 12:25:58 +0200
Message-ID: <20230612101711.329168669@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
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

[ Upstream commit 6c242c64a09e78349fb0a5f0a6f8076a3d7c0bb4 ]

Consider existing BOUND & CONNECT state CIS to block CIG removal.
Otherwise, under suitable timing conditions we may attempt to remove CIG
while Create CIS is pending, which fails.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index c2c6dea01cc91..ab9f00252dc2a 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -966,6 +966,8 @@ static void cis_cleanup(struct hci_conn *conn)
 	/* Check if ISO connection is a CIS and remove CIG if there are
 	 * no other connections using it.
 	 */
+	hci_conn_hash_list_state(hdev, find_cis, ISO_LINK, BT_BOUND, &d);
+	hci_conn_hash_list_state(hdev, find_cis, ISO_LINK, BT_CONNECT, &d);
 	hci_conn_hash_list_state(hdev, find_cis, ISO_LINK, BT_CONNECTED, &d);
 	if (d.count)
 		return;
-- 
2.39.2



