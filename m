Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5365C44AB62;
	Tue, 21 Jul 2026 21:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670787; cv=none; b=r+Ri5Gi8PIpMcN3AVA/AjTpoS2Kk5C9YJomNRaNooxRu+fJcN0V0kZAwY4LyLaxArFEBjalMUSQ15EUBQjB7i0Xd1f8DNCobn3onnWmzE7JCyNy89AchhSj7bYQ79gb4VRhvqIpFuQaGhqoEg9B0NwDEOcJjkEzMTH5DT8ofgoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670787; c=relaxed/simple;
	bh=arIWglZ3JjsPbBHog6mKUUYwebxnB2Wnk7V/omB4lNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqAS5O6BZDdn/QNXyp6tR/wx2cxWUmfXnU999GKBLq1ykRSHIHzoQ31/z3BTVyVAyB9b2HBd7niqzNqcuYalFG0IquZnffj6U51uqosdOKWXq/TErqYtDVS4d++d5/DoEllDtscYKlgn5Kaq/uA9nVVofWLZj0aG2FOzg6BA230=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idUo771r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idUo771r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31851F000E9;
	Tue, 21 Jul 2026 21:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670786;
	bh=7rzTed3h02+XxQEWQ6+NpJrRW8pbsnX7+SSSEiCdUNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idUo771rJYAzUZque8j35om0C8R4kcZwQorfqyIzB9u8E+0CQBQ1HLusP+JTVUcQJ
	 NLv2smgXKDTpNu2xAsLU8wJ0z5PCRKhYWz2eDm2kcwguIyEyi/p8+uVitgsxeYJRaS
	 sztNTt9ChnND+b90qM9hsyTEaz+7lNdD/ChycAjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b2545b087a01a7319474@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 1062/1067] Bluetooth: Ignore too large handle values in BIG
Date: Tue, 21 Jul 2026 17:27:43 +0200
Message-ID: <20260721152448.343210473@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

commit 015d79c96d62cd8a4a359fcf5be40d58088c936b upstream.

hci_le_big_sync_established_evt is necessary to filter out cases where the
handle value is belonging to ida id range, otherwise ida will be erroneously
released in hci_conn_cleanup.

Fixes: 181a42edddf5 ("Bluetooth: Make handle of hci_conn be unique")
Reported-by: syzbot+b2545b087a01a7319474@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b2545b087a01a7319474
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6951,6 +6951,10 @@ static void hci_le_big_sync_established_
 
 		bis = hci_conn_hash_lookup_handle(hdev, handle);
 		if (!bis) {
+			if (handle > HCI_CONN_HANDLE_MAX) {
+				bt_dev_dbg(hdev, "ignore too large handle %u", handle);
+				continue;
+			}
 			bis = hci_conn_add(hdev, ISO_LINK, BDADDR_ANY,
 					   HCI_ROLE_SLAVE, handle);
 			if (!bis)


