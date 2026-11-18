Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050306;
	b=rViMcORO+pYE6RcuACFhnO5lIof7NugrHda+IlCencKAvzd0RCUxhDaE5w7l4P936rR9
	 y5HmDm8gPBNtFEREpEdMEhJWw7iMJWaiLZyot023kZm+cYrZvtsUa0Rn9UYIQzuNtnted
	 ypjh1U1MVRVLN0KnQOMS66il5ZlTH4p/aIWOb+jTncQ0OgbY0+nvRaDgsV8bBeGvXC1+s
	 V6jpSpwN3ufy7ghYQwtdmwpZGcstyqQllv/y5CYPWmuCeNJ9zBMIvMHTuXfaKg4Qrhsvn
	 Kg74ghVBi8g8QpJ5FNUjipA116Ly+H3YKFAStMx/zII4LXgXboDxYG6r3ZYohjkEZlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LuRDfCHFzhrF/ozoyhvOOhMs4VMZKVt+yMuQV51mkQY=;
	b=EQj73KF40sBpK+yZpnFIRRQXBT2XkjS1iMUcO7UECgu4IqVtygg4zueuI4Ju/qameWiS
	 kjyog1iI1StMYnWPGqhAGNtBA5Ny2C3AYXRRE1uVCWkC1Q+tE1EY2ErH8U5bRlvKybiuP
	 wuJrCUKsAsrhmAdGm7pm5X+A4uzkuTPaJlxd4udI59ZyZlLn+NLOlAmr9k6wJsc7l4EAz
	 9rXfoBajOStKsp8e3S8lJ49XzGf+CPC7DPwO1aa1q4Yc6d5FOeyEY1X6vtuBG/H0E6dFF
	 p8dqpiiSyxkdCaf+qm3sYrQbrwm7oGvpiB+e2YwaaYxZoD+DCOuyfjDebJb9VwNwrKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDSv85lm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EC160A2607;
	Thu, 19 Nov 2026 01:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDSv85lm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFDF1F000C4;
	Thu, 19 Nov 2026 01:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050305;
	bh=LuRDfCHFzhrF/ozoyhvOOhMs4VMZKVt+yMuQV51mkQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDSv85lmRonVfJV7NdUToQfz1pmisPH+jR+O+666kXYA6AFUpH5rF4FVKNWpl/wLV
	 AqqDI008/lrg1KkPezIaC0oAL+RUP2x0NA/8zDfYYiK0m6swB8mTgSuTOR/Jvyf4Ae
	 w1AVeoITU+zA0mUh/plbtQphEqjp4riP1G5aCLVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2660/2857] ksmbd: fix unlocked IPv6 addr_list walk in fsctl_query_iface_info_ioctl()
Date: Wed, 18 Nov 2026 16:01:34 +0100
Message-ID: <20261118150337.355242038@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index f55672f08a20b..53c2cda2581e6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7808,13 +7808,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
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



