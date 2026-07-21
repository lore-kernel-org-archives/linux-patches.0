Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E42A443A94;
	Tue, 21 Jul 2026 20:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667584; cv=none; b=DxZWQVXZ7xy2HDfwsMt656lQrXmn5+AxJv6l7RGA+qWYwK72mZxdGwlFSHaegRmnIDVxR6vdkPoIuv6gOlWyjlxWnt4zmL4aj2WOFi0hFD5GD9fs7Hc0arP+0TWW2pwKdL+Uu2bqmsEaUG01qK7TmCTgX0ZHygyEDTQZpFbKazs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667584; c=relaxed/simple;
	bh=wC9njskMzRvzZ0wcXQfAA0CfwPYsqBaC5GzGWrsII3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDO5NGuwBMeSqk7o5RvIZg5kY5dkSMsammvPoIE0FK6HsTcS+vC7UNieuBStlIIZlDNIwVyF+dPCiIdFX6SXaIgM9pTHL8mYts5zEO1QB/eCb9fYfFVURoAh3p1SVe+0RGHXDUjOte1anCfldV+FotbJouWAmk3uDDjQ6rpwrO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TYbldjal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TYbldjal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6111F000E9;
	Tue, 21 Jul 2026 20:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667583;
	bh=vH3jKDB8BPIE6SHcLn1PVwErcHIxf4eXlVaoAc7qCCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYbldjalycb1HJyHIITpnAhwlhhfWquqWkd5m+C/pxKFU5f/hvy2ERv7K4FTtMrwR
	 wArEXUPoHwKeXyQbJaAYcwElRPhupNF43/ntShjI9Kx9T8X2FPSLLN/DVfujwVDvS9
	 divxE0EGcBTEML8QA06Vcho95KgqGRjLpo0sE7aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 1117/1266] llc: fix SAP refcount leak in llc_ui_autobind()
Date: Tue, 21 Jul 2026 17:25:54 +0200
Message-ID: <20260721152506.796605625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


