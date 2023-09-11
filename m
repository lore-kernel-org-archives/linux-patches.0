Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98D71170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65116C433C8;
	Mon, 11 Sep 2023 14:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442936;
	bh=ndNycKOeTa45sY+QTdwiUct0jTCZAjE2D1gv40takS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8mB0um/CecinawRgDb+1XvkRS6rniQPGmBXCHtYsLDFew43cWxvJQjug/VcgBaid
	 pZuciYKU9u/6uEPqCnECYvKdx9gZrXrul41v6iGS/2uOTUN2JYHshUa6tq7U18jrWE
	 Vc/d5Ka+4DGbm3wMr5ImZLWQcLFyktGHx/huhmTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 200/737] Bluetooth: hci_conn: Use kmemdup() to replace kzalloc + memcpy
Date: Mon, 11 Sep 2023 15:40:59 +0200
Message-ID: <20230911134656.186154709@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 5b6d345d1b65d67624349e5de22227492c637576 ]

Use kmemdup rather than duplicating its implementation.

./net/bluetooth/hci_conn.c:1880:7-14: WARNING opportunity for kmemdup.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5597
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a09128921820 ("Bluetooth: hci_conn: Fix hci_le_set_cig_params")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index ee9d6ff75246f..7516166652a08 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1886,12 +1886,10 @@ static bool hci_le_set_cig_params(struct hci_conn *conn, struct bt_iso_qos *qos)
 	if (qos->ucast.cis == BT_ISO_QOS_CIS_UNSET || !data.pdu.cp.num_cis)
 		return false;
 
-	pdu = kzalloc(sizeof(*pdu), GFP_KERNEL);
+	pdu = kmemdup(&data.pdu, sizeof(*pdu), GFP_KERNEL);
 	if (!pdu)
 		return false;
 
-	memcpy(pdu, &data.pdu, sizeof(*pdu));
-
 	if (hci_cmd_sync_queue(hdev, set_cig_params_sync, pdu,
 			       set_cig_params_complete) < 0) {
 		kfree(pdu);
-- 
2.40.1



