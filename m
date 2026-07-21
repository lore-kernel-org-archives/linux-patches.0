Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAEC44AB6E;
	Tue, 21 Jul 2026 21:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670790; cv=none; b=YpDNBU87yAyp5Vz8DtEDBUcDFejhANmv/VwXSYt0Elmn03+bYGgA4yERzxMsKJEzGazwdFNq88yqBKtdj0dYrqo01T+VMBVDdas3WIrMKFp3UAHej7TlQLZBv4x/snM4TO84mF0nDhI0SpJF0YRM5km94cXbdaIHwGb5zS37iWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670790; c=relaxed/simple;
	bh=/6YXqW6z8zeg5SURhMxWMEsDsnCaTz+x2DFxwdSe+LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lje06UatIWrKKkRpCKeozFZ4X2qQ2Vyy2nOCvIrYRy+OjopgOyH53jFbCYSo71zaGGxvDGiunbXZ8qUp+0+sI2SRHwJsSHLjNNkMmK90njhlSl03t2un8Ak4RTYnshaOuqSQMXmd98eOUZx+bqj1wwwqUamC6jA0a2v8//7U9sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+vshCxJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+vshCxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6271F000E9;
	Tue, 21 Jul 2026 21:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670788;
	bh=CeXVIsFrTBDqJQrtefZxwCrz4hicYmPBiJ/v67XtvWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+vshCxJgIXTMkIc4a01rXExojGk1EOkjYnQ739bRkDSmJiYDrqFpw5yrRu0E4p9m
	 Wm0tBca0kBSHUgBAbSlw6Oc+6BxQotD/KuMM2DHCC3TRbw+1PRtUTvDa/vK3D6+cMF
	 ek+fiW6ACaJpn9tc0ruujIXF3aZyNfpZ5vMxrRxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b2545b087a01a7319474@syzkaller.appspotmail.com,
	Pavel Skripkin <paskripkin@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 1063/1067] bluetooth/hci: disallow setting handle bigger than HCI_CONN_HANDLE_MAX
Date: Tue, 21 Jul 2026 17:27:44 +0200
Message-ID: <20260721152448.364712505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Skripkin <paskripkin@gmail.com>

commit 1cc18c2ab2e8c54c355ea7c0423a636e415a0c23 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -988,8 +988,8 @@ static int hci_conn_hash_alloc_unset(str
 			       U16_MAX, GFP_ATOMIC);
 }
 
-struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
-			      u8 role, u16 handle)
+static struct hci_conn *__hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
+				       u8 role, u16 handle)
 {
 	struct hci_conn *conn;
 
@@ -1096,7 +1096,16 @@ struct hci_conn *hci_conn_add_unset(stru
 	if (unlikely(handle < 0))
 		return NULL;
 
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
 
 static bool hci_conn_unlink(struct hci_conn *conn)


