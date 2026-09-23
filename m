Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99703ADBB4;
	Wed, 23 Sep 2026 14:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173205; cv=none; b=DxcbtnQxhSuxzvq7L4xRz0I+enuS0hRk+Zd67Tzse3ZK3tIdZfgeesR8WC4E996TxzbGw6UsGCCzTg0OAfKCPKC0Djdm0WQxyfu+KzAJchJaU98SdEpgRG1anXWX4gkWZ1Maw+dgLcjaPZMkviVjJH74aiJRe2z0jO/GySWHtws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173205; c=relaxed/simple;
	bh=pJypUXVum89WdlGAjVQx2uwnyE2TGuN6L09OhwaorFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAg9td71otjVYha7TPSCB4dpK5DfHIsl5YlferROj/9YwScwGpnhYVxhqxR8kI/Fz55NR8p1pSPKj3iMRPReFxOuG5OatzS32tEPA+HNEdZQmf0cRf3+5zMqyFSbWI0REyHMIyaW1a41MFfmUzt7fBcytNxF0oWLcSlYj6Ho+EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yegi5G5c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yegi5G5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399E81F000FF;
	Wed, 23 Sep 2026 14:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173204;
	bh=JUWhrS77Rhm8oVYr7PyKFLjlEA040HYGp71rHmYKBOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yegi5G5cjHgDK++inaYIyN1UU7Y1ZAdcCQ44j2BpH8KxnzNDOjaoMHcBeVcNpfj3x
	 TZlJPCWxGOardfAQE4AucQGwr2nt0Zg2UyLrooQVZs0GBCF8iIy6J4r5WbhV0fmGHv
	 MeJW8jdp6RSeQElUlSX/M+fxbFuRTxHeEsj13/Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 173/438] Bluetooth: ISO: Fix parent socket leak in iso_conn_ready()
Date: Wed, 23 Sep 2026 16:03:14 +0200
Message-ID: <20260923140649.252947185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit ca18ee413a7cb6f09885778039225e58bae0d607 ]

iso_get_sock() returns the parent socket with a reference held, which is
dropped by sock_put() once the child socket has been set up. The error
path taken when iso_sock_alloc() fails only calls release_sock() and
returns, leaking the reference and thus the parent socket itself.

Drop the reference on that path as well.

Fixes: fa224d0c094a ("Bluetooth: ISO: Reassociate a socket with an active BIS")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 75bfd5938b2ea..4de332b8901f2 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2289,6 +2289,7 @@ static void iso_conn_ready(struct iso_conn *conn)
 				    BTPROTO_ISO, GFP_ATOMIC, 0);
 		if (!sk) {
 			release_sock(parent);
+			sock_put(parent);
 			return;
 		}
 
-- 
2.53.0



