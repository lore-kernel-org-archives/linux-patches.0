Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D0E472F6E;
	Tue, 21 Jul 2026 20:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664153; cv=none; b=JpDcqZvb7I02Kq+ihMWC7gz+0C8VBlRRuVqpYtYqEhaVCo4tfU6ovt/ASwgPDxer+XL1pheZCT/XGnfjsSUlF+pn/dudPtVfFyzjBSRqHRxwKS0DZW+rePIFA2W95nSYRkok+KxeC0Z6HXPELv+9zDkk8KA3NRbF/ShFScaksZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664153; c=relaxed/simple;
	bh=u9fAFeT5XtvsdlSF9SZZ+tykGlixd19MkJFzvxCoTIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q123gAHniE6sqTf4Nt1Kpxw0jxAvtPGU0GC6zUHifaUdD5bUMTr4rI4ccsu3fxwHsI/uN0UX7frjP72OIdZvN3EZ4WosPIdqU3cd3owrrkJG1LReoEAj/2fwRTZmKpODKyevpKEvrDS4c+3/836JVMbIxlUHi6E/PkVs64+3x8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMMeRHsS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMMeRHsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0811F00A3A;
	Tue, 21 Jul 2026 20:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664152;
	bh=LY2Cr+5J6AcRFCUnJDrnNMMzTocWbHYgh6CIbTTjfOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMMeRHsSoUJPufHNemZ39jZImvZe0+2AZ2wV/eu1llQoXD54vJo1PqUrZsQzeVg4L
	 o033rjziKNPemL6VMBYEvrKXFIJZmqLmPcii0iDEn/LFKp4BDPkscjZgawPR/Ww69t
	 Zc12j3HhZuGBfB+9tvUkoo7D11w2eBSeZVtalOAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 1091/1276] llc: fix SAP refcount leak in llc_ui_autobind()
Date: Tue, 21 Jul 2026 17:25:34 +0200
Message-ID: <20260721152510.400101436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


