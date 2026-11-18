Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042210;
	b=GCtI9aME7R3ciabWGenELmv9zFz8hjOy+Fjgvbp6ksWzXOPVSb+1rtI+DO9tfjwzLRFA
	 xTi0yUT+1xQVugSNtyI/uk+iB435xVEoyZ9Sd/aWhVHGgTZ7xty0eocpE3FpCUtKW9ufc
	 H4ISOwPkhAVT3eQunuyvY1M3sHD7Zk8Tn08Xb3tiAZ75rtwVWr/kcRK6h1BnTGgUsV8x4
	 A88aP6+wHw4ssI5FTJ4fanCm2oW2LwOVSW3vh53cQItpt1UO+hcAsh3E9YwUHMWljtD6I
	 Fo95y2QhVGCbmXZ/iU91vWTomu53/rb019RBrujn/RFgZa5xILX9m/RH04YvaO/fGsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jsbb6aAKxPuREm3ZaPrdM5OpcgF3jFYHKhnV/k/3J8Q=;
	b=bL9XT5GytIORxzrueLcemgHgwCxF6fN+QzdAft3PQDTCoC0mJskqOiKmBDC5McjinGsT
	 MJd4N813Jp5PgMFlqdyLjiGUCEboPYAg7kghp2Iesa2zs4BVgekaK6n5NgY4tohKwsgt4
	 fDcDzys8lcgmY7GAACCTGOwBlpqFYC1UMycxh3B6D32TW7vIcBKDZjf7oRwofjMsd5jTn
	 nDivNA9sngtRYzVyvrHMhGyQ8B3DOmzwV+S0gDIhsqnctSi/CbWvHoEWL1e2n9cKigE9J
	 4em3SiaIwgXVPbSI9+5MyO/Gv3GdzcCvDePOxyPdA71VEgPF+2X74PphooQA+x5QUeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jyKhDq0o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873C2606A31C;
	Wed, 18 Nov 2026 22:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jyKhDq0o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95391F000C4;
	Wed, 18 Nov 2026 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042210;
	bh=jsbb6aAKxPuREm3ZaPrdM5OpcgF3jFYHKhnV/k/3J8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyKhDq0oH4NTJsrqG7G+EgnBMuemlpmbHhXRzLF3g5TK58jPhvgH2ldTIyv5dISO1
	 ylVgk4dRNge/0Hil+dHsbeG/qc+oC/wKFOhEOXOXddQPDcu6c0XGfF5W+/IpDIUrsH
	 8iMPL7djyHDnj7ahQP8goJsQg9k5dJhYR5TLXFgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3089/3318] ksmbd: fix unlocked IPv6 addr_list walk in fsctl_query_iface_info_ioctl()
Date: Wed, 18 Nov 2026 16:01:51 +0100
Message-ID: <20261118150452.710482384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Hu <huhai@kylinos.cn>

[ Upstream commit a63bb4d91c784f63ad7c063717dff7920d8445be ]

fsctl_query_iface_info_ioctl() walks idev6->addr_list with a plain
list_for_each_entry() while holding only rtnl_lock(). rtnl does not
serialize all writers of this list: the DAD-failure path
(addrconf_dad_failure -> ipv6_add_addr) can insert addresses without
holding RTNL. It updates idev->addr_list with list_add_tail_rcu() under
write_lock_bh(&idev->lock), so it can race with the unlocked walk.

addr_list is RCU managed, so walk it with list_for_each_entry_rcu()
under rcu_read_lock(), matching the other lockless readers of the list.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260910090818.24479-1-15815827059%40163.com
Co-developed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Signed-off-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b30370ec981d3..6702e317f68b5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8263,13 +8263,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 			if (!idev6)
 				continue;
 
-			list_for_each_entry(ifa, &idev6->addr_list, if_list) {
+			rcu_read_lock();
+			list_for_each_entry_rcu(ifa, &idev6->addr_list, if_list) {
 				if (ifa->flags & (IFA_F_TENTATIVE |
 							IFA_F_DEPRECATED))
 					continue;
 				memcpy(ipv6_addr, ifa->addr.s6_addr, 16);
 				break;
 			}
+			rcu_read_unlock();
 			sockaddr_storage->addr6.ScopeId = 0;
 			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 		}
-- 
2.53.0



