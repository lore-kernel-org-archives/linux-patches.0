Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C79283FFB;
	Thu, 25 Jun 2026 13:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392897; cv=none; b=BG7aZHvByCg5+YqWaFGKmq3NIdwiEydhbflYgu64rNDDh5UlCbMl8qk7RyLpwOdXU5ML3+I5NS6RxP8Weq6jX2FKFTcn00rq3sZ/wOpSdk+QaxOTUKf6EM/xAO81GrFv71j94gIzUDAjkY02X59IjtpVOefBPQcSjRS1IdjaCCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392897; c=relaxed/simple;
	bh=Qn16bBRWsbDvv+l0e3GTVRUSSIbTJu2RL3qh2JosLOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgoerZTVUSAZEaWVbAadzqr5g1esWQCe6rx1SeHZ3gEMW9NsLub8gX9WXeah0ykU3CaSkCHbTCnRq1BN5TZm3IEQtQNM+V4VLO0Ls/RGsOaofIPT02Eypz/QyuLo+znz3YOv6fpBShyiZu6C8OcDewucbHSIMEIpWzO0YmAsvw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZhj3pov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZhj3pov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A4A1F000E9;
	Thu, 25 Jun 2026 13:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392896;
	bh=PEGZKtJTAR+fU3JInjR914b4FkUp9vcywg1DzimdY4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KZhj3povzsscxorDYbJf+/LhGNTBDxLJ6Mi6QLC8jaKOkf2OfkeRCyc+T56WbWTpE
	 GKAgoGt/3YgJnabCxlhgH1XhUinRLZUG5iH4tuGRKz98/VSbYQfAVPScm3WvgHx/tc
	 PfftgnjUocIPuVC9wy/UrnlYkAZqIDr0n0iORcu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Marciniszyn (Meta)" <mike.marciniszyn@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 42/60] net: export netif_open for self_test usage
Date: Thu, 25 Jun 2026 14:03:27 +0100
Message-ID: <20260625125651.837788276@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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
@@ -1724,6 +1724,7 @@ int netif_open(struct net_device *dev, s
 
 	return ret;
 }
+EXPORT_SYMBOL(netif_open);
 
 static void __dev_close_many(struct list_head *head)
 {


