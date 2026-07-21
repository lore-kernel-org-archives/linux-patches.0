Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661223B9930;
	Tue, 21 Jul 2026 21:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670379; cv=none; b=PGWOWSwfD+sxlaabWcP/fmeTwNn14BWC/dKjoVGaALzRO9UOHRJJD2Ft+KHDkYr0ov4ftBstcnDogObRwv/VtLNb7YZ0VxfKgh7ctIBK6GUPKRdy2O+xPLEOGKiMgjhLWDKZjWlAt+tuNLYaF0B/wrrtfihRrPuXlBmEEbLsfyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670379; c=relaxed/simple;
	bh=9ZliMJWl4S4KONawnwww4aNGZ5Gj/r1qC63V/iwcVKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ee7LJVbgZUViEGCjSvDl/AyZSwx7cR3nW1JlprlHf8l2kcSOxiFyBWo2cP1PTHvOmc6tMtEoQGolNRUUdJ2sM0UNQGVco2evTyEk3BLUxFwdxfOG1s5MpW+8muYQxw6EsqMEmiRzhdpm6rlTQEEg1NqjJJrwjXH+zwrhc5xwdL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PoMoucEP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PoMoucEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA38F1F000E9;
	Tue, 21 Jul 2026 21:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670378;
	bh=sgpVMiA9GXufZsYg6y2j0XDlCfTfWXwY342BptGd8NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PoMoucEP9KtQDL9uBxGcY0faqZHnUBBQMCCzu5SpyK4hffR8oUpl3tRIRhq4rciKI
	 ZxaN3o6U8sxfSdmf+VM60zVA1HB33vUPPT8APsHBJRTPp94tqhHsJux/UAtCKTEx65
	 drDUBRb3VBT+EKiwc4ElFEfPSDBn7W7vh/wjPYlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 0910/1067] llc: fix SAP refcount leak in llc_ui_autobind()
Date: Tue, 21 Jul 2026 17:25:11 +0200
Message-ID: <20260721152444.892695428@linuxfoundation.org>
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


