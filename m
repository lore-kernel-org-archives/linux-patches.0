Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215043;
	b=iK00UaU5WG+tkymV0lz7kLA6x5gIOlms1hkQlJnxQ24zbhiIqNpBHcBLzwWCGCdYOwQ3
	 aAfWo1xQ3eC3zmjGKLyWVhenU2V128Q/4xe+Yv8SX8Uv6OYAAiezk1yUqy0cbasJo6ueE
	 QvfaXOaiWaydfhyt0RTN2lGb7oo0OEaL12eRQ0vapb97CW5lcA+Iap+20Mwi4T8YNpdLW
	 JHTKoFO6X14rC1m66fXCnnfLyB0ZSmAI+IrZL6sTLyntcba+OuQtlypiahfWFiJvxXSjE
	 wy5lFwDYZER7z6z4PFZchcvg5OhPuIYymVhmKkFwZ6MbuJSoan0/hdEoxpgG4K7b1LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/nqNMdN4cGJVChNQOKF8Su7qiB2+BNdBHVOOgnvxtHw=;
	b=WdS9ndjj6TNlSYSJ/OO5lfiDXWeT+Pf3QFfK6unIeDU4NiDCxv2FcQN5Ls6XiAyrJl6i
	 hzV4d/n9dcdVct83v/g2ZCvATljQG8QNvleCXb8RTPLRY9LZt2go8+ZtvNAVVyneArCdU
	 H4Xw4H2WUXh7grjWRoNh45S2ShxFd7HL4CJfFfUvtLjW96RgIphiWyrSPx0c6owoNRVtm
	 uzgDEpEQEwe03VhFWEwKiSgbLy7mT6ZgXw1UGSVYUIKJ4RsMKvJlY1141aybRq6YOyOpH
	 fVkC2TW6NFa7EWOVkv1E3PzZEaCubw/Y3AuvO3IRLY8ePWNGrNUO6tm16I8ePQQN0aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NtBsoqwy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A93606A31A;
	Wed, 28 Oct 2026 19:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NtBsoqwy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746F51F01825;
	Wed, 28 Oct 2026 19:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215043;
	bh=/nqNMdN4cGJVChNQOKF8Su7qiB2+BNdBHVOOgnvxtHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtBsoqwyp0iIfe7OFdInB2gS2XwzCfRoAybYtL8XklVaKiDVf02qTtDW6CpAUXYLf
	 kccrXgbNbYtCEUPGI3EP8zo+zNmU73ei0W0a5NZ09y8glSC+yHCMb7Ehhw3q7E6IiH
	 COp68LgkRzuubUDksxKdY5owgbTamcW4rcG3Mw4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1071/1887] tap: fix stack info leak in tap_ioctl() SIOCGIFHWADDR
Date: Wed, 28 Oct 2026 17:52:47 +0100
Message-ID: <20261028170523.782197758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit bddc09212c24934643bd44fc794748d2bbb3b6cd ]

In the SIOCGIFHWADDR path, tap_ioctl() copies 16 bytes of an
uninitialised on-stack struct sockaddr_storage to userspace via
ifr_hwaddr, but netif_get_mac_address() only writes sa_family and
dev->addr_len (6 for Ethernet) bytes, leaving sa_data[6..13] uninitialised.

Those 8 trailing bytes leak kernel stack contents; SIOCGIFHWADDR on a
macvtap chardev returns kernel .text and direct-map pointers, defeating
KASLR.

Initialise ss at declaration.

Fixes: 3b23a32a6321 ("net: fix dev_ifsioc_locked() race condition")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260520075736.3415676-3-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 15ab71f5288ac..9124601d658b4 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -995,7 +995,7 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 	unsigned int __user *up = argp;
 	unsigned short u;
 	int __user *sp = argp;
-	struct sockaddr sa;
+	struct sockaddr sa = {};
 	int s;
 	int ret;
 
-- 
2.53.0



