Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9C26ADD;
	Wed,  5 Mar 2025 17:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197155; cv=none; b=GLB0GDGUV8HAp1eRzMeLXcQnTmqUg7paa7ILjlL1bhsHmyz5wuS7JKub2SF+lXgQBtMSvyDWwewXTMmhGBCgZ+KLiQTKs8HNbTzpqMoQUcv3kO0Ax/pa5zM/UEbtcbn63tLaMNBLgG6ePQKIpLdgt/udUGm261AQov7NWBEuE+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197155; c=relaxed/simple;
	bh=Vx7xFHL7D4OYrVA/RPXfxAcE1Pt7053TQqiDa7aZJKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8GxlcewO3NCElyHC2YkqP4GzHXbMVYfIbROVnxFsSe5HBwztds29HU5nK2RRpjZTMtVwbaY5HwCacsNJ/+CEjjtWGtsGBs6VN70JcsNZWCkX7L9598xffdRmX6TG6VZjOVWmKyroO+VH3A41ARJJNe7acrSSmuss/5MBv2qTzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHJJrHnF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHJJrHnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF5DC4CED1;
	Wed,  5 Mar 2025 17:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197154;
	bh=Vx7xFHL7D4OYrVA/RPXfxAcE1Pt7053TQqiDa7aZJKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHJJrHnFN+lnQ3x86DCrpsUy8u/h/dHMMORdfXIxu8PYvwYtoZxm4auW3owO9Rl5U
	 LARQfGbZmkK6EiAVK6uUQMQwWblUk4SCSmDMM3Nhy/lgY+dJKTAf9MhJEMDUcrxYty
	 KqLe41pnNgTwyE58qiC5/UZVFSSUGwVCWnWHNJHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/176] arp: switch to dev_getbyhwaddr() in arp_req_set_public()
Date: Wed,  5 Mar 2025 18:47:07 +0100
Message-ID: <20250305174507.787540279@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 4eae0ee0f1e6256d0b0b9dd6e72f1d9cf8f72e08 ]

The arp_req_set_public() function is called with the rtnl lock held,
which provides enough synchronization protection. This makes the RCU
variant of dev_getbyhwaddr() unnecessary. Switch to using the simpler
dev_getbyhwaddr() function since we already have the required rtnl
locking.

This change helps maintain consistency in the networking code by using
the appropriate helper function for the existing locking context.
Since we're not holding the RCU read lock in arp_req_set_public()
existing code could trigger false positive locking warnings.

Fixes: 941666c2e3e0 ("net: RCU conversion of dev_getbyhwaddr() and arp_ioctl()")
Suggested-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20250218-arm_fix_selftest-v5-2-d3d6892db9e1@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/arp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 8f9b5568f1dc1..50e2b4939d8e9 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1030,7 +1030,7 @@ static int arp_req_set_public(struct net *net, struct arpreq *r,
 	if (mask && mask != htonl(0xFFFFFFFF))
 		return -EINVAL;
 	if (!dev && (r->arp_flags & ATF_COM)) {
-		dev = dev_getbyhwaddr_rcu(net, r->arp_ha.sa_family,
+		dev = dev_getbyhwaddr(net, r->arp_ha.sa_family,
 				      r->arp_ha.sa_data);
 		if (!dev)
 			return -ENODEV;
-- 
2.39.5



