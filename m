Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B0713A25F;
	Tue,  9 Jul 2024 11:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524231; cv=none; b=Rd+DZb80uk1fnlwvdEtmm7VrGdSP06RIUSDKrQpJuGEnixFStC9RIBPa2LbaMNAJRLoDG7ZMJcAdeGf+ef+0TBdBMBh2VAHe5VP4DDD5ZvF6HhXyRK8DgmNj4SQsRxQUpHZpBdaCTlrNK+7gc1KhPUDa0FIomYT9VvNKl0FkkKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524231; c=relaxed/simple;
	bh=WTbKCmPs+cAJTNF7xCH/8NTt5a5nxa/vTJpbKk4Hl6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClG0IPwCSV3/kXYUErRtFjKKnCXfd6jXvwoH9NmE2OeE+/4Pt9FaWb0sNncnb6u/ECTmPzqEDWtOmMdNYJ9XcBkDSSnZtCdoxouexhHb4KVUzlrFFChbyROfTShF9R5QfKnFkhHWvtYenVg6xwmEumKyC8jjVbQsml3yAv2wXQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrZWVhpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrZWVhpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31DDC3277B;
	Tue,  9 Jul 2024 11:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524231;
	bh=WTbKCmPs+cAJTNF7xCH/8NTt5a5nxa/vTJpbKk4Hl6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrZWVhpYOmFbAtMJxBCgENxdr5ltI2jbb4rKXK1ZQd23XPTQMbQL3SDIp5iTia7XV
	 G8iLXpDlwdDHXrpiYM8Wb3AFdMJyHvGTtVmuXQAN139NOmPqqnzxdmfVDZsWR5gcpf
	 eVjnqsDzzjdyd211g/pW4+eEtCy8LaP92tsM9l8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b2545b087a01a7319474@syzkaller.appspotmail.com,
	Pavel Skripkin <paskripkin@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 097/197] bluetooth/hci: disallow setting handle bigger than HCI_CONN_HANDLE_MAX
Date: Tue,  9 Jul 2024 13:09:11 +0200
Message-ID: <20240709110712.715650862@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 08ae30fd31551..baca48ce8d0c6 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -904,8 +904,8 @@ static int hci_conn_hash_alloc_unset(struct hci_dev *hdev)
 			       U16_MAX, GFP_ATOMIC);
 }
 
-struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
-			      u8 role, u16 handle)
+static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
+				       u8 role, u16 handle)
 {
 	struct hci_conn *conn;
 
@@ -1046,7 +1046,16 @@ struct hci_conn *hci_conn_add_unset(struct hci_dev *hdev, int type,
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



