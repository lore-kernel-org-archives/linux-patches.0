Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8956F12AAF7;
	Tue, 14 May 2024 11:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685457; cv=none; b=lcZVUcZf4qeQ0U4uQGhVONMVeK4PkeFK6G5Gn8hbihHI/dijr/5eRBVipVvzC919xD2Y0Hap3tIoTIPjk/pHlvL2+uTE72gv3h2fzHgyGgWDaOzmy4n8LX7zSrV1CckSwnPU0/yOSGAzksxTTESu/CO4mHr6cHkAIm6VuYMCVIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685457; c=relaxed/simple;
	bh=hhR/I1LSI41mmktZ8ilIi/+suh/J1xC1b51U5gyJAuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyLJYf909TQMLWPjwGzozi0H3C1exEoRLMAXg41wBrwZedeQYsB41udPmhroT4HIR1M0jjuMeTqr8hLT7UgHzI5giw/qX2O4ChyGT+GWX+pSQE26yc/wjmnrWI2iivDVA3V+QhQqILOczkorzFwEK1vbX9KS7dDrVpAcQIm6BLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JobI99wB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JobI99wB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BB6C2BD10;
	Tue, 14 May 2024 11:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685457;
	bh=hhR/I1LSI41mmktZ8ilIi/+suh/J1xC1b51U5gyJAuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JobI99wBmXGuC+7LlMcSWFwzdNlWhoLiB5bsvuCPRyC9OWBOz9/43qm8STn64OgRw
	 kl7VCqty1ctgH3MxtWRqyUVuQJ12Z2/YWCr8+OVP179ASYnDjvd0HRFtKlj9ekW9ix
	 2ov0n3pN96+N1QhYV01pQjGpC9HLB+yhxHtV0ALc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/301] ipv6: Fix potential uninit-value access in __ip6_make_skb()
Date: Tue, 14 May 2024 12:17:42 +0200
Message-ID: <20240514101039.465185510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 53fe1375b147c..fba789cbd215c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -2003,7 +2003,7 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 		u8 icmp6_type;
 
 		if (sk->sk_socket->type == SOCK_RAW &&
-		   !inet_test_bit(HDRINCL, sk))
+		   !(fl6->flowi6_flags & FLOWI_FLAG_KNOWN_NH))
 			icmp6_type = fl6->fl6_icmp_type;
 		else
 			icmp6_type = icmp6_hdr(skb)->icmp6_type;
-- 
2.43.0



