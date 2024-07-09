Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BA7158201;
	Tue,  9 Jul 2024 11:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523667; cv=none; b=cV/Tg4B6WLhQF9BMSgvlntN6An39MoVuqqq33iScGBTAyySv89iTBFeZJ2jVhyzAUIBwn5DHu5GHJenV0k+WHAeqmudqus5rQPYkziFqvbVJyWx0YytYAnywqX8rzPD/aPO9ty9Ya7/JPK+HDax1ho4XOPKjzvV7aDo308Auct4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523667; c=relaxed/simple;
	bh=kDPwb+4iMME2ajqJf2/hY4I6fQrlfcArf9CQpP6BGoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHj8gV9da3zCqa6p74xMDz4H0WpuJnLBgCFdgj9MPr5CGjbi1MfOX6ICgor1gJdOsLJEjTyk8vW2f1z2oDfBYvVILAf470XDfeKXEW2aDi8v2iWhc/2xjOFi1be/Uwf9V+YXl8YTpH4ehupmhzp7OgTfxHOrlFdcaUDTpZv5/n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRy4PM8L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRy4PM8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E12BC32786;
	Tue,  9 Jul 2024 11:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523666;
	bh=kDPwb+4iMME2ajqJf2/hY4I6fQrlfcArf9CQpP6BGoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRy4PM8L935vyhcLIJWDjsJZhPDrgLTecM4hAS1+xG58k2aOBQlMZFWbj/A37eKvq
	 fQHf6fmUChsF76uyA08U1geGdzKT+YWk4pPOwj8DdHTvOEQYjz1rIUJ6Q620U1bvkN
	 B+2vqJSQPG+0PajFTTOPMeXEWiWEerqnhWPG20Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b2545b087a01a7319474@syzkaller.appspotmail.com,
	Pavel Skripkin <paskripkin@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/139] bluetooth/hci: disallow setting handle bigger than HCI_CONN_HANDLE_MAX
Date: Tue,  9 Jul 2024 13:09:29 +0200
Message-ID: <20240709110700.844796762@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 1cc18c2ab2e8c54c355ea7c0423a636e415a0c23 ]

Syzbot hit warning in hci_conn_del() caused by freeing handle that was
not allocated using ida allocator.

This is caused by handle bigger than HCI_CONN_HANDLE_MAX passed by
hci_le_big_sync_established_evt(), which makes code think it's unset
connection.

Add same check for handle upper bound as in hci_conn_set_handle() to
prevent warning.

Link: https://syzkaller.appspot.com/bug?extid=b2545b087a01a7319474
Reported-by: syzbot+b2545b087a01a7319474@syzkaller.appspotmail.com
Fixes: 181a42edddf5 ("Bluetooth: Make handle of hci_conn be unique")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 163b56a68bb04..9c670348fac42 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -935,8 +935,8 @@ static int hci_conn_hash_alloc_unset(struct hci_dev *hdev)
 			       U16_MAX, GFP_ATOMIC);
 }
 
-struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
-			      u8 role, u16 handle)
+static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
+				       u8 role, u16 handle)
 {
 	struct hci_conn *conn;
 
@@ -1077,7 +1077,16 @@ struct hci_conn *hci_conn_add_unset(struct hci_dev *hdev, int type,
 	if (unlikely(handle < 0))
 		return ERR_PTR(-ECONNREFUSED);
 
-	return hci_conn_add(hdev, type, dst, role, handle);
+	return __hci_conn_add(hdev, type, dst, role, handle);
+}
+
+struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
+			      u8 role, u16 handle)
+{
+	if (handle > HCI_CONN_HANDLE_MAX)
+		return ERR_PTR(-EINVAL);
+
+	return __hci_conn_add(hdev, type, dst, role, handle);
 }
 
 static void hci_conn_cleanup_child(struct hci_conn *conn, u8 reason)
-- 
2.43.0



