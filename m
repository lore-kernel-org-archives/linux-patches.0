Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686735158BD;
	Wed, 30 Sep 2026 19:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797200; cv=none; b=Kh6rJVq5zNAN1pAoO0kdNRNmEF2JwM3mazGDbTjLnCxxy17gq2jFMHu+TyNFeQfSvcIphTNKu7DqqfiT3sPtH4B90b3FwBIoTyojD0H5ZkpCjyly3sCvpkXEibDxU5N179cudXc+Kjs34n7f9TeB+pNY+rkdHzXkmZCuGde84mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797200; c=relaxed/simple;
	bh=/Lc5v7zIDIcTlczxobjfdLKsW6Wjz5T2SRxQGtlFq1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fG7m1f+Bkagk9hLUdmJocvEgVvbmnA20cT7yIbNcN34WxQWdVIrnq4Yk75j/vfO5l2ym6wwJk13Zl+F/zV5FBrtBfXS41XjHUPMKcvlkvlwsXvZalv5CE+3p3Sg/ht9aeo9Pt0ghaKLU86qyJ6T49kX+3tjKVrLiiyTpNn+dW+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cvr4obOG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cvr4obOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA59F1F00898;
	Wed, 30 Sep 2026 19:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797199;
	bh=XjFUZSkRQm2nWOGZaTLKLN8sFnkfb6OkHoJfQ39sn24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cvr4obOGRFhzKpEcJ+FrlpsZR9OO6Of4lEIsCcSmQzERDQQGtuE/faXh+Bg1m40mg
	 InP5yjVsM3y1ct3tc7iWoJZc6PAMuuaHjLRcET+Is7kKEQJEoMMWEn7H76kmyU3J3H
	 ed1/IwWgDAo2pIcU2amM9M0Zk9i6s80RfV19Dmno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 1145/1193] Bluetooth: hci_conn: fix CIS hold ownership on reuse
Date: Wed, 30 Sep 2026 17:30:29 +0200
Message-ID: <20260930152459.675020932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1887,6 +1887,8 @@ struct hci_conn *hci_bind_cis(struct hci
 		cis->iso_qos.ucast.cis = BT_ISO_QOS_CIS_UNSET;
 	}
 
+	hci_conn_hold(cis);
+
 	if (cis->state == BT_CONNECTED)
 		return cis;
 
@@ -1928,7 +1930,6 @@ struct hci_conn *hci_bind_cis(struct hci
 		return ERR_PTR(-EINVAL);
 	}
 
-	hci_conn_hold(cis);
 	cis->state = BT_BOUND;
 
 	return cis;
@@ -2311,6 +2312,12 @@ struct hci_conn *hci_connect_cis(struct
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


