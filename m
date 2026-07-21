Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC86939B4A2;
	Tue, 21 Jul 2026 17:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655151; cv=none; b=XVveg7pmvpMCEfND8aTRFhuCSanFVFK9fvf0O7NJ/P8bT8netMwpt2oDIcIt+AzeZWbTQQHf20YsW9mv3J9aedjrsHCm6Z0ckjD4myD/EsU7w3EHPr0g9zybwLrIcUq0S1ZqQ+ULWYtYrz0nvkxhXiH4s+28sXkL9Vp6Bo8/2w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655151; c=relaxed/simple;
	bh=Yo+qLf7g26zqztvJe3/Wv480ZoxhoOO4r2j6Qh2OFOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crM37gySb4Mojx7x0zfAu/AgD6s+1dpZYULtxTZXd9ks6UJX2jafxO3PBl63UWVT3m6dhgR4xVFXi4h3YrVM9+2PtD9OsrGVoRoJrhEamQByy7TqWER2o/hU64gamJTEPp8Ew8Vz4uMr0hX72AkFMGcqv9HJ7KCZdLFiKXzYk4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ieTWOJgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ieTWOJgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E55E1F00A3D;
	Tue, 21 Jul 2026 17:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655150;
	bh=A23vG9KGKszJD020dla4+3SQhjd+GCZMaGPn0kGE5TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieTWOJgO2/mlsNfSvw78aBurbrhhaletosDOw7jVSQsfj0khN5bsx++BILMvQH0+E
	 pAVN3gLM+V+myxrbwh7RduBL0m2Ac2lpd2mk1ZAqy5PBNCr3w/w3zjiCds9/rlSx8o
	 BTJL2QsPNQNrdPD5r/QZIRg1fBiadHobZXTTIiko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 1974/2077] llc: fix SAP refcount leak in llc_ui_autobind()
Date: Tue, 21 Jul 2026 17:27:27 +0200
Message-ID: <20260721152639.265423652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 660667cd406648bbaffbd5c0d897c2263a852f11 upstream.

llc_ui_autobind() opens a SAP after choosing a dynamic LSAP.
llc_sap_open() returns a reference owned by the caller, and
llc_sap_add_socket() takes a second reference for the socket's
membership in the SAP hash tables.

llc_ui_bind() drops the caller's reference after adding the socket,
but llc_ui_autobind() keeps it. When the socket is closed,
llc_sap_remove_socket() releases only the socket reference, leaving
the SAP on llc_sap_list with sk_count == 0.

This is user-visible because repeated autobind and close cycles can consume
all dynamic SAP values and make later autobinds fail with -EUSERS.

Drop the caller's reference after a successful autobind, matching
llc_ui_bind()'s ownership model.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://patch.msgid.link/20260630194856.1036497-1-shuangpeng.kernel@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/af_llc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -317,6 +317,7 @@ static int llc_ui_autobind(struct socket
 	/* assign new connection to its SAP */
 	llc_sap_add_socket(sap, sk);
 	sock_reset_flag(sk, SOCK_ZAPPED);
+	llc_sap_put(sap);
 	rc = 0;
 out:
 	dev_put(dev);


