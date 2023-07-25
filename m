Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB6F14A82
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7232BC433C9;
	Tue, 25 Jul 2023 10:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282644;
	bh=SxqVO9DJmTTxCMtdDTNUQFJpsJ4w+FUa0dIh+m3hjSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yozpELvhO1ROK1Q6q3Z4QV1bNmkNWj4zpJ8vLYFZUTZTT3wc4hoWNSXeyRpsphwJU
	 wzAHNmf1we/kNUoNqCgGeKziJzjy40xQBGPYj24aWvrqjHGr5KiRvDxvMHBOwIx0qH
	 0oOLfw/EdXV6kDiSB0sGwzaprOKYfGNuxqyZ2eBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddh Raman Pant <code@siddh.me>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+37acd5d80d00d609d233@syzkaller.appspotmail.com
Subject: [PATCH 6.4 204/227] Bluetooth: hci_conn: return ERR_PTR instead of NULL when there is no link
Date: Tue, 25 Jul 2023 12:46:11 +0200
Message-ID: <20230725104523.218986215@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Siddh Raman Pant <code@siddh.me>

[ Upstream commit b4066eb04bb67e7ff66e5aaab0db4a753f37eaad ]

hci_connect_sco currently returns NULL when there is no link (i.e. when
hci_conn_link() returns NULL).

sco_connect() expects an ERR_PTR in case of any error (see line 266 in
sco.c). Thus, hcon set as NULL passes through to sco_conn_add(), which
tries to get hcon->hdev, resulting in dereferencing a NULL pointer as
reported by syzkaller.

The same issue exists for iso_connect_cis() calling hci_connect_cis().

Thus, make hci_connect_sco() and hci_connect_cis() return ERR_PTR
instead of NULL.

Reported-and-tested-by: syzbot+37acd5d80d00d609d233@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=37acd5d80d00d609d233
Fixes: 06149746e720 ("Bluetooth: hci_conn: Add support for linking multiple hcon")
Signed-off-by: Siddh Raman Pant <code@siddh.me>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 7b0c74ef93296..31c115b225e7e 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1684,7 +1684,7 @@ struct hci_conn *hci_connect_sco(struct hci_dev *hdev, int type, bdaddr_t *dst,
 	if (!link) {
 		hci_conn_drop(acl);
 		hci_conn_drop(sco);
-		return NULL;
+		return ERR_PTR(-ENOLINK);
 	}
 
 	sco->setting = setting;
@@ -2256,7 +2256,7 @@ struct hci_conn *hci_connect_cis(struct hci_dev *hdev, bdaddr_t *dst,
 	if (!link) {
 		hci_conn_drop(le);
 		hci_conn_drop(cis);
-		return NULL;
+		return ERR_PTR(-ENOLINK);
 	}
 
 	/* If LE is already connected and CIS handle is already set proceed to
-- 
2.39.2



