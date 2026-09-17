Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1ACD389E1A;
	Thu, 17 Sep 2026 18:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670766; cv=none; b=MqhYEK0h3fooqPQ6vxqYiefMbh6kSMW0OxB81DhKeYrLYCEfnaUN50IH1Z/5EjrrggOtXuXkxJojrUH3DU/YHyN90fh/V61MUr1I/sw/fSWRTzhIxiX3suCuiRG1z0g9vceiCrWFXWrZbXNZ1NIn9kDrqX+BwWlS1IcTSYzAkGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670766; c=relaxed/simple;
	bh=NsqxIp7uC4YoG2GqX/rLPPXKoNGEKIITPzXy/xN1ig8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzfTH/KPXFtjHsDk91ZDdrBz0SfCsf7MDrnZ/PULDkxCN8RSArVpjUAbt8ityikvFquXdBcuOmd4U8vnfKBrtz8bkeSjp+BEpZS3Ia8sslHjqu1pbDa6fBg8OHAgIZXqCP/568u72kd6A/zWBTztj8yqqXNXGJzrBSrTv5uG+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VnCeRR6w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnCeRR6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B251F000FF;
	Thu, 17 Sep 2026 18:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670765;
	bh=WdghF2jvetvFImcRQyolFMF+W5hUzCVSkMsvHa8/r0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnCeRR6wtFsbDXQFUkQQaRSq+7+fut+fs8H1CRO5TX3yXLBt0jtPdENsqloZVeSMZ
	 OTIBvhekWaF5Vi9SKvFwInzLSDfjbnRRVPxlYp8CxKKYxvfE8vwODINuH6mEa+6Kuf
	 4NUupDdvAztYJmUYIXyw5vioyS5O8rVn+W5vKrqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0724/1102] net: ipv6: Clamp to IP6_MAX_MTU in ip6_dst_mtu_maybe_forward
Date: Thu, 17 Sep 2026 16:11:07 +0100
Message-ID: <20260917151558.535125188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Alice Mikityanska <alice@isovalent.com>

[ Upstream commit 199271ebc71c1e0913b2fad988a7bff330a8828a ]

Commit 427faee167bc ("net: ipv6: introduce ip6_dst_mtu_maybe_forward")
dropped the IP6_MAX_MTU clamp that used to be present in ip6_mtu(). A
similar IPv4 commit ac6627a28dbf ("net: ipv4: Consolidate ipv4_mtu and
ip_dst_mtu_maybe_forward") preserves the IP_MAX_MTU clamp.

Restore the upper bound in the IPv6 flow to avoid potential 16-bit
overflows in forwarding paths.

Fixes: 427faee167bc ("net: ipv6: introduce ip6_dst_mtu_maybe_forward")
Signed-off-by: Alice Mikityanska <alice@isovalent.com>
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260901195714.673548-5-alice.kernel@fastmail.im
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip6_route.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 59f48ca3abdf5..80f61c76ebc04 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -343,6 +343,8 @@ static inline unsigned int ip6_dst_mtu_maybe_forward(const struct dst_entry *dst
 	rcu_read_unlock();
 
 out:
+	mtu = min_t(unsigned int, mtu, IP6_MAX_MTU);
+
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
-- 
2.53.0



