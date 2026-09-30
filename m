Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F8A3C0A01;
	Wed, 30 Sep 2026 19:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797231; cv=none; b=eATF3sjVpOOGXkDND1fDBUfyZsSpuHRRY6n5+06FXLsH/OFrv8DWRptYzZxMh6nqKhnBalPQIaIh55maMabgiDBf3iXD8WxaqEm1I2+mKuCEGDcek0CoQQFZM4udIeNIbZtEsNiWxqRg8bUzsmxcVMkpskrM2K061SFSXFRu0AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797231; c=relaxed/simple;
	bh=fvc2Hr8oEezJmcifJds3yRI7E111BYnhgkBxWbeCJ/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kp6wIRFfE72dFw0Bo2V0lVRbEEb0McT3O4WPVMxhDPMLs/9W/YIsJ28ytGkJ79hLG6MxszjKl/nQvPUca40Msxw4SRSvjhjDEOxoUsbc3fT/thfLoDzs84OFPLtPmTCj+2ZEC3eU37p0ZXIoa3uptZftVxT6rrMbr7A2Kj7Fsm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUsiXdli; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUsiXdli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC88A1F000FF;
	Wed, 30 Sep 2026 19:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797230;
	bh=AxoYLqQvW7VfVE/Aga1DLdvw8M4W8S/WNZ89j6OW/OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gUsiXdlimAAjuU5MXwbKNbnb4hxx+6JoB0TkpVKG6sPVzxqT6CtPlprRaBAUzWE+M
	 V8P15/M7uOeznYiDaXezr0oPUQzPV8Mlos5E7RQUs0oxrG4gBoSztdrimeg7fFUZOw
	 ZYZHDq/jjrhxg+1go/SDQ3q8bG9p9ni44fzgt2JE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 1148/1193] Bluetooth: ISO: balance the parent hold in hci_bind_bis()
Date: Wed, 30 Sep 2026 17:30:32 +0200
Message-ID: <20260930152459.743799548@linuxfoundation.org>
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

commit 4c94557dd02569efa6c1072a0439addaef9a5224 upstream.

hci_conn_link() takes a lifetime reference to its parent with
hci_conn_get(), but only takes an operational hold on the child.
hci_conn_unlink() later balances both a hold and a reference on the
parent.

The SCO and CIS paths pass a parent acquired from a connect helper, so
it already has a hold. For an additional BIS, hci_bind_bis() obtains the
parent from hci_conn_hash_lookup_big(), which returns a bare pointer.
Unlinking the child then drops the parent's existing hold and can
schedule it for disconnection while its socket is still using it.

Take a hold on the parent before linking it and drop that hold if linking
fails. A successful link transfers the hold to hci_conn_unlink().

Fixes: fa224d0c094a ("Bluetooth: ISO: Reassociate a socket with an active BIS")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_conn.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -2220,10 +2220,13 @@ struct hci_conn *hci_bind_bis(struct hci
 	parent = hci_conn_hash_lookup_big(hdev,
 					  conn->iso_qos.bcast.big);
 	if (parent && parent != conn) {
+		hci_conn_hold(parent);
 		link = hci_conn_link(parent, conn);
 		hci_conn_drop(conn);
-		if (!link)
+		if (!link) {
+			hci_conn_drop(parent);
 			return ERR_PTR(-ENOLINK);
+		}
 	}
 
 	return conn;


