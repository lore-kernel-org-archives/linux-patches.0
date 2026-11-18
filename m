Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056741;
	b=U/yaC8wgaf4i4pSa9Cx1VssbrdsoiMTlUGAQeKNcVuJdKE2+vduN5kWAFHIpyXKZIccu
	 SlnV+HQLzLNn7m+vEgvXe4WMFoafo94HMM+cfgyzJQWqyxTWgAkS351r5HR4dWh9bt8mE
	 NfKfnza34uClhA7R26VeFSd7Fv7Oi/A1lkf3MOnyJX2Q6UyV2U4RTz1eCUEPD0JWuBNWV
	 m4VGS+lfbXRGGKvOROW4wOQusjk5brktm3VbpFlgOEtcf6r1vZqOXyO6Y6KiWungW+KGg
	 reh2Gr4DWh5r+iWfl2173HpvrbjsxjvWckRnSSwwS2guFgIBVemoUHqWkTOQ4HEBKzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YUdpjsdqNriqG7iMBWmX1SiQis/stxQuns6/XcBZ/R0=;
	b=SjY+Di0vRUGBvdqTxUf97OYZJtP5bLQ/q7lQp1C2QVdqJEi4DNJ7pMevI2GYntODVfBC
	 U8LRovLJ/9645nLtZdE27MtZjWo31S7eOAun1bCpULe3uwCe5GufzCgo5cTzctaKE9c3Z
	 7qDEvEP0G4W1jfd8kYyoRuV67eBCLKeK+IZjuWyaja42La74WItX4aLgF4serldhjPlUG
	 xIA3qe6mI4h0JOiHI7yydGsbkVFuuXB9HVJXYTTFabLoAny+SYoOkTA9mgwPEDJu3041+
	 FuVsVhIC+jFPv61EJXBRjKNMpGH7DOOAyGzCcW5aWHXuFdpoFsEYXT7jYFlTGlGEx6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KmBT/Suo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA97606A31C;
	Thu, 19 Nov 2026 02:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KmBT/Suo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CCD1F000C4;
	Thu, 19 Nov 2026 02:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056741;
	bh=YUdpjsdqNriqG7iMBWmX1SiQis/stxQuns6/XcBZ/R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KmBT/Suoa8m1TDBs7MvgyTYCG6dHb9pJC/v97IXUiyGKaJLKzzddQGDlUJhiV8khz
	 4ubM7awaDRJbQdHcbjgbyUXIanPoOkIzPpx8cUSumihpdh1AxyVdLgMtdR4l4n00Sd
	 d41vyQCL4JajdCZpzxXKlQaMNBIiPoot+cIcACAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2079/2214] ksmbd: fix unlocked IPv6 addr_list walk in fsctl_query_iface_info_ioctl()
Date: Wed, 18 Nov 2026 16:02:35 +0100
Message-ID: <20261118150133.781529544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 367fe6d53aa62..7e08e71af80e4 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7632,13 +7632,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
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



