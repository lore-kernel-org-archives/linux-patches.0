Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651E11A76A4;
	Tue, 30 Jul 2024 17:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359937; cv=none; b=NksHJ0b9tyXNdxMyNaVZJEWfgo5iUGLNkDRNRTkqDPZk0TR4pi6HwzG3XtpCocQKFMOQSztmjhjo05+7VkCQpgFWJrQ15ogq+tixpbuNSi9WYzdMi/y2KiJT1OFGTGVQOxrEy26RkaCRqUltBnbIMc3hApslB1FUK3Eqsd37AP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359937; c=relaxed/simple;
	bh=yaKc2pihzlzotMImQyVibWjAQFjGPB+fdyCFs+bvknU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8WoSbK8WVMkwZ3jXVNpmD0rGvIbL7fJm+vUzqzUin8BfPH+ADHZEs0V3zOT+x6Sicrm8bkU60DF7nqlokyYEfOCgaj0s65zOY2rlK0Am7SMT5qDyHGoOBU/wZPewM6EFd78Wj2FuiPxrIU7KUj6C54qeDyIimULQ7NSEZjm5VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4/LwBQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4/LwBQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0E9C32782;
	Tue, 30 Jul 2024 17:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359937;
	bh=yaKc2pihzlzotMImQyVibWjAQFjGPB+fdyCFs+bvknU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4/LwBQBnqRtkyVaEsxrnIwpWNhHdDOcQJV5Yt9kCQp7RogA4cso9G+W+oGHL5kPe
	 S4JsjS2PFJo+NLgDZNeOoYIUPpQaTcbwAeCvXb1BN8Ow9uDpcL7zBDOCQY24PrpSjq
	 PU3dgK4PJNm7y+Ht/kBE56i882e0dtMWTaGOuZsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 556/809] ipv6: take care of scope when choosing the src addr
Date: Tue, 30 Jul 2024 17:47:12 +0200
Message-ID: <20240730151746.718006353@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit abb9a68d2c64dd9b128ae1f2e635e4d805e7ce64 upstream.

When the source address is selected, the scope must be checked. For
example, if a loopback address is assigned to the vrf device, it must not
be chosen for packets sent outside.

CC: stable@vger.kernel.org
Fixes: afbac6010aec ("net: ipv6: Address selection needs to consider L3 domains")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240710081521.3809742-4-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1873,7 +1873,8 @@ int ipv6_dev_get_saddr(struct net *net,
 							    master, &dst,
 							    scores, hiscore_idx);
 
-			if (scores[hiscore_idx].ifa)
+			if (scores[hiscore_idx].ifa &&
+			    scores[hiscore_idx].scopedist >= 0)
 				goto out;
 		}
 


