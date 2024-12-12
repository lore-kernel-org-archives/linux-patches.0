Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE531487CD;
	Thu, 12 Dec 2024 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016961; cv=none; b=tFOvy/xDm5aD/zdNMKVphmOVDz0Gz2QIDBZdCWDIteZP2zzG6YGZenDhLFUhQv50icaLBuEPBU9PWuWebaW9zKhXUZkIjzqlVsRF8CDH/b2H3YOk9ErRZvshdXY0hz5uNhVzwsYAu8FSjXiNNIjt9I9j37hLCq4shrYNSfc+5iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016961; c=relaxed/simple;
	bh=X0/xNt82Mr76Yex8sflXBJqQfO9dzOOaO0elMSUcodc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0/S/IywPNJlKGqW5V+tnKdik3ZCtyiMCOZiBy/cG1hpipLulm6l5lcXhwFLSxJVUGvklZa2vlNHBHRr3xQgnYCw2O2g5pC8nEZbdh6vr1XVgy3nKCuhY/ZRbPLWcoeUz44CHg+FxUDu7HWfGLr+o1SjJwQWHTEC8a3II19AzKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxS9oQQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxS9oQQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F83C4CECE;
	Thu, 12 Dec 2024 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016961;
	bh=X0/xNt82Mr76Yex8sflXBJqQfO9dzOOaO0elMSUcodc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IxS9oQQ2OC1yofUawj6MAsjjDAq6IIL0uKoBIpg1D/l1S3HRkba6WM3j5BeXTIH1h
	 wGoQ+P5mmZ8vP0JMCHxY47TyH4jMqQsXXOVo3aFcGvav/N8eTlodJCpI6EkvpuC34o
	 46cGUQr1N9QnK7NTmkGLnCRCzNuIAFlINfihdehY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6ea290ba76d8c1eb1ac2@syzkaller.appspotmail.com,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 343/466] Bluetooth: hci_core: Fix not checking skb length on hci_acldata_packet
Date: Thu, 12 Dec 2024 15:58:32 +0100
Message-ID: <20241212144320.343629937@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 3fe288a8214e7dd784d1f9b7c9e448244d316b47 ]

This fixes not checking if skb really contains an ACL header otherwise
the code may attempt to access some uninitilized/invalid memory past the
valid skb->data.

Reported-by: syzbot+6ea290ba76d8c1eb1ac2@syzkaller.appspotmail.com
Tested-by: syzbot+6ea290ba76d8c1eb1ac2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6ea290ba76d8c1eb1ac2
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 0ac354db81779..72439764186ed 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3771,18 +3771,22 @@ static void hci_tx_work(struct work_struct *work)
 /* ACL data packet */
 static void hci_acldata_packet(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct hci_acl_hdr *hdr = (void *) skb->data;
+	struct hci_acl_hdr *hdr;
 	struct hci_conn *conn;
 	__u16 handle, flags;
 
-	skb_pull(skb, HCI_ACL_HDR_SIZE);
+	hdr = skb_pull_data(skb, sizeof(*hdr));
+	if (!hdr) {
+		bt_dev_err(hdev, "ACL packet too small");
+		goto drop;
+	}
 
 	handle = __le16_to_cpu(hdr->handle);
 	flags  = hci_flags(handle);
 	handle = hci_handle(handle);
 
-	BT_DBG("%s len %d handle 0x%4.4x flags 0x%4.4x", hdev->name, skb->len,
-	       handle, flags);
+	bt_dev_dbg(hdev, "len %d handle 0x%4.4x flags 0x%4.4x", skb->len,
+		   handle, flags);
 
 	hdev->stat.acl_rx++;
 
@@ -3801,6 +3805,7 @@ static void hci_acldata_packet(struct hci_dev *hdev, struct sk_buff *skb)
 			   handle);
 	}
 
+drop:
 	kfree_skb(skb);
 }
 
-- 
2.43.0



