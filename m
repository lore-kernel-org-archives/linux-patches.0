Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3C028751B;
	Thu, 25 Jun 2026 13:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393016; cv=none; b=hW7N+d2MvTMbmqHYk2XV2FXDiWYxCvWLbx+uYWPaKSGLcLaZS/WKkWk3enIQQ03aXA+0q8JGdREpv74MskdkN+CM0+dL4cFMyLGhFNgxSxzK/NpKCB++TB09ZgEB/6BEHuuDab0DwcUlvdV06EbifzUoTx6a9LRJPtmW+Yf4wP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393016; c=relaxed/simple;
	bh=uF9rPhV0LrTClBVtGb0BaWAbEBQeWVRr26fQbUrGv9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njIcBagJLiN+KDNlcAifqKVVlb+CukZAOwdbfRkRQpP9lMStuj57gS/912XrdxRJ/gXwTKmRYUAS8Qca/3bEUG+Swh/+7tNWXcs5sDq+j6vGu7qn0rGqCCR2qmIwJd28GymszUh0oCy/zw221sR74pqcQR9X2KJTfe2h3ST/YTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/3sQVVc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/3sQVVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292AC1F000E9;
	Thu, 25 Jun 2026 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393014;
	bh=We2hNdC8Mw0Fpw9qD/wAHPCQzfeABGyjFD/TXLvv0k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/3sQVVcUN+yzz7VX3C/doT/Chxo+oKBA70mttzdH8gORrA5oorJPO+7gWwMmazrJ
	 u3Gi3ns7s2i6hpVlks9eAHfkeLXJfMq8Fy668EC0jFaBKIExw+ZdPX1X6xJU0+ZY9I
	 vV9JoBdY5KavIyOKVPTLcXWmEbeJuGzaRT7kk/S8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Marciniszyn (Meta)" <mike.marciniszyn@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.0 31/49] net: export netif_open for self_test usage
Date: Thu, 25 Jun 2026 14:03:43 +0100
Message-ID: <20260625125641.907171607@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn (Meta) <mike.marciniszyn@gmail.com>

commit 3fdd33697c2be9184668c89ba4f24a5ecbc8ec51 upstream.

dev_open() already is exported, but drivers which use the netdev
instance lock need to use netif_open() instead. netif_close() is
also already exported [1] so this completes the pairing.

This export is required for the following fbnic self tests to
avoid calling ndo_stop() and ndo_open() in favor of the
more appropriate netif_open() and netif_close() that notifies
any listeners that the interface went down to test and is now
coming back up.

Link: https://patch.msgid.link/20250309215851.2003708-1-sdf@fomichev.me [1]
Signed-off-by: Mike Marciniszyn (Meta) <mike.marciniszyn@gmail.com>
Link: https://patch.msgid.link/20260307105847.1438-2-mike.marciniszyn@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1731,6 +1731,7 @@ int netif_open(struct net_device *dev, s
 
 	return ret;
 }
+EXPORT_SYMBOL(netif_open);
 
 static void __dev_close_many(struct list_head *head)
 {


