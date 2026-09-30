Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F0850279A;
	Wed, 30 Sep 2026 17:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789614; cv=none; b=tyanI3Q6Zf08y3C1UhqNy0vZps4ZNdX+/Iik4eItOWtQbQle33SYGi5NFWDiP5b0U3uvlQ05+0BH0bxHnfnEKESmPFkU1Mv+8+Jiq7NSDY97R89/9qN0shho2kfPbkYWYKCWj+0A1B2Rsq9Yj5e+lslFw72DoNMKxLtmhd7U7Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789614; c=relaxed/simple;
	bh=TeCRFkziApvvW7ZMixIsmrS+Vfn3x8qEB0K8oNvCHnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYyKCvIM+D++B9MK44tQ4fEq+LoeC17LnQi+18UxFwSEtkCu/VZXk7lLGlAVxQMWQfzrNqgLqI6JJMa7c/qqif46Ct8KZae04PKDb51V0DBmNERgeiIA1ZMb35f6hndM/8uO4IXvpqcL0aQ/nhC/9evyuV9xcEPbX0Gp6B1kNTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHcdioi+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHcdioi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755371F000FF;
	Wed, 30 Sep 2026 17:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789613;
	bh=cslTOZlYvo7AiPuEDOMV9Gfgpv++/XB13EOgvRKn2tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHcdioi+QFrhedSE1dMt8UTBRFRCytFmpejZ8RzR9Uv93ouE7B25btBQ4gunW+oTr
	 V2in4WoYAH0kPXW0UPRaEEwZxRQMjX3RlWEIYrSAIyVDTw5ToFb4vF06M75utStU9G
	 4+vkkRvPl4OyeTNFIZUExWqm9tBQC3yz7iOSTb0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 537/877] Bluetooth: hci_conn: fix CIS hold ownership on reuse
Date: Wed, 30 Sep 2026 17:24:08 +0200
Message-ID: <20260930152426.232508308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit e06d549fcd4a0ba381ed67ddf1ab3c7a6ca4314c upstream.

Commit 69997d50ec57 ("Bluetooth: ISO: handle bound CIS cleanup via
hci_conn") made hci_bind_cis() and hci_connect_cis() return a
connection with one hold for the ISO layer.  hci_bind_cis() currently
takes that hold only after configuring a CIS, so its BT_CONNECTED and
matching BT_BOUND paths return a bare lookup result.  Its configuration
failure path can likewise call hci_conn_drop() before taking a hold.

Take the hold before any state-dependent return or configuration error
so every successful return follows the documented ownership contract
and every error drop is balanced.

hci_connect_cis() also assumes hci_conn_link() always takes a new CIS
hold before dropping the one returned by hci_bind_cis().  However, the
helper returns an existing link without taking another hold.  In that
case, preserve the CIS hold for the caller and drop the redundant LE
hold because the existing link already owns its parent hold.  Returning
early also avoids changing an existing CIS back to BT_CONNECT.

Fixes: 69997d50ec57 ("Bluetooth: ISO: handle bound CIS cleanup via hci_conn")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1937,6 +1937,8 @@ struct hci_conn *hci_bind_cis(struct hci
 		cis->iso_qos.ucast.cis = BT_ISO_QOS_CIS_UNSET;
 	}
 
+	hci_conn_hold(cis);
+
 	if (cis->state == BT_CONNECTED)
 		return cis;
 
@@ -1978,7 +1980,6 @@ struct hci_conn *hci_bind_cis(struct hci
 		return ERR_PTR(-EINVAL);
 	}
 
-	hci_conn_hold(cis);
 	cis->state = BT_BOUND;
 
 	return cis;
@@ -2340,6 +2341,12 @@ struct hci_conn *hci_connect_cis(struct
 		hci_conn_drop(le);
 		return cis;
 	}
+
+	/* The existing link already owns the hold on its parent. */
+	if (cis->link) {
+		hci_conn_drop(le);
+		return cis;
+	}
 
 	link = hci_conn_link(le, cis);
 	hci_conn_drop(cis);


