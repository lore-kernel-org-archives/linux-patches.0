Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E35F5208B0;
	Wed, 30 Sep 2026 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793632; cv=none; b=pyKlza6UmhvtQwvLuFOzneQ3c1MqRW+9M9MLDRwXhow0x6XgV9L/bYpLAf8VEyqMGZiK9KAtIpKiECGUSvrACy0S1IjdAE0l6dtTFwVbNMTIK8cr0Kx8PGY+z+k/x9U+4+JnInMl7feByzo5pRxuzr6IF/ZeSy0zaGvGmGQzuiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793632; c=relaxed/simple;
	bh=gcUHrj3IYqv08Rh+bxmYtLLVUQ3hw5/X+eh7gNh7t3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQK7Ts9LmIIL/mvty8QkLcFRu53P25XiL1OCp3Aj5FQt1CYQ1Eg0QD32X5ICVNcKtIrl5hDtGSyWx8SCO8aLaG+I/4E0WfExe8bbYdnLFiGpAnmI0ayR0iCg/CgZ52wkpelo4Dcb7WUJ8CpFJZjiBWPVd0Ljf0+XhOrebKC8xdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBzpdnun; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBzpdnun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4521F000FF;
	Wed, 30 Sep 2026 18:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793631;
	bh=jYKGpweIRB+pEKe0DnQkszLk2WZlDApoU7a3lHc7LBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBzpdnunjo5dlSHzzUjXbsUFeZU+4Jvkupfno/zSI7wrX+WoDQI+rig/VVCcRD/m7
	 0GcLSXO87qRfBiQb4s7M/99Wf6nouL4yzqyXBbBV5YdqfEcM/J7cIsJYaeVc8dY9OH
	 AWkBvIXjkH/arqMpLrC/DLdHIr/RUyCBtRSSWK1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 324/395] Bluetooth: ISO: balance the parent hold in hci_bind_bis()
Date: Wed, 30 Sep 2026 17:29:46 +0200
Message-ID: <20260930152347.688292809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2273,10 +2273,13 @@ struct hci_conn *hci_bind_bis(struct hci
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


