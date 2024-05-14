Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786F86D1AF;
	Tue, 14 May 2024 10:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683621; cv=none; b=fdHHs8Ahd31zvP31WBTTdL8SToq7qCv0zFI+90/p2TRfOmCx/D6TH7dgHMnQG/bEIHTg15bxG4aKLb8FfyuepUXXyTIMlur0XBgwPsLS3x/jO2CHWSLrvVrmHLDPRsI/Uvj0M/poOjzXtjPossJTn1lfHIdmhVmC1fG2xK4efeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683621; c=relaxed/simple;
	bh=3o7T35DWSFV0jtEyRE7oZvSegAlllO8014/AQAsfXuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJDdtCpfMCuA4CKxk/bmIVrVIQdwzQgHd6ymt5Qp04rzC5aYvcIFIPwIOHcryT9i4Q3q34pGZGJyXTtw0o7vdY9/7tvyRF2IgsvHFsFByTyIk4Gu+gInKGDZyVjSjwsQrLBmRHIjsv7DvCWtxOkCMjkY/+VeiaS0prQFpWmyt60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3/ckcpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3/ckcpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A650C32782;
	Tue, 14 May 2024 10:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683621;
	bh=3o7T35DWSFV0jtEyRE7oZvSegAlllO8014/AQAsfXuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3/ckcpyA3PLV1Tut4Hd6vpHVyHFslSIjR0Gv0BZwy7VEjLg1bBX2Tp2jUNprqqY8
	 Ubekysu+e+on8l6mPk1CHwp5+NcKdDvW/roK1MU5ODET/QBQliTQXq2mgsda/tK9OC
	 Sll8pndfAe/clNw8aEZWrSeIlzH6VqCCokDPfxzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 214/336] ipv6: Fix potential uninit-value access in __ip6_make_skb()
Date: Tue, 14 May 2024 12:16:58 +0200
Message-ID: <20240514101046.691534069@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 4e13d3a9c25b7080f8a619f961e943fe08c2672c ]

As it was done in commit fc1092f51567 ("ipv4: Fix uninit-value access in
__ip_make_skb()") for IPv4, check FLOWI_FLAG_KNOWN_NH on fl6->flowi6_flags
instead of testing HDRINCL on the socket to avoid a race condition which
causes uninit-value access.

Fixes: ea30388baebc ("ipv6: Fix an uninit variable access bug in __ip6_make_skb()")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 31b86fe661aa6..568065a015c41 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1933,7 +1933,7 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 		u8 icmp6_type;
 
 		if (sk->sk_socket->type == SOCK_RAW &&
-		   !inet_test_bit(HDRINCL, sk))
+		   !(fl6->flowi6_flags & FLOWI_FLAG_KNOWN_NH))
 			icmp6_type = fl6->fl6_icmp_type;
 		else
 			icmp6_type = icmp6_hdr(skb)->icmp6_type;
-- 
2.43.0



