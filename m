Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032607;
	b=V5ecOY7JQPqKQo/A6bbRPbQ7c/7ocu0TFtg8cJHHEEUHj22+ANd8PQYt91VZrgqniIXr
	 q/+h8ezyUkMm4JzRER5XJ1ONU/Xw+vcZ9RtxGVEgDhIsIB8bnFrXEvpXl2CheM5UxtB6z
	 jGnFisGj9X4HsNfIY6G0zgNmEmrKXLpNJnPvHkDf+pgA8m107Zduzee13rUDEVx3y8pv9
	 fZhZlv8RR0a1g7NWWLaneeQA3PUSAeaeX7hmzl8JoXU0a7aRj8+F7h07/H9wpLaK8Nzcw
	 KuY/gVvaP0+9eOlRiB1ie6RA/V1KSkz7NV809skiHhf3JvEnNwxsIuf41p08HoA7sCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RailAe45xpl6A14n+J9aDz9ZRCTB2RwJKYqo54IDGrg=;
	b=3j0maIvYsJQ+kipH3b2f9lGeeqmhtgV3KwdZciumxKymm0Y+WbZRPyRoXDwAPvuyF9ie
	 VG6s/QwyN9/U5ySXoFErrokEG19OGsQIsMp8Zxo4B5j9upKOLwKzb6EZP3EFnkN3qjvWY
	 1XR61qIBpmOAJspROV75N1+nHrTin2x6mRo7GnV0oBuScW4dTSL5fvaqaW57tOfs/o8gZ
	 LaMEnaXv4BaqexazoNSy0RWHVBIIPs45/CnnnoCa+khTBVcJteAkknpdUxlAkNbIJsvI5
	 gmblv+vzguzZ5hbp7JokO3tkDpGKuTDsxNtsddikmqFw6zeG0VGGN22K7vX48NsH4ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trRgFTSo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D945606A32F;
	Wed, 18 Nov 2026 20:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trRgFTSo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8297A1F000C5;
	Wed, 18 Nov 2026 20:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032607;
	bh=RailAe45xpl6A14n+J9aDz9ZRCTB2RwJKYqo54IDGrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trRgFTSoKJGQIIdcraEx4nZHwAmuIu59HtBt2FUFH52r+wRUu8gG5uT/74zi/+sZQ
	 cTwBffzNlApl94+R1cO0W66rbcdI6i64PeLw7TkhwlSbS7WNYXNMVpzouqOtaskB3n
	 KmZNc5VLJobt5e28JpiTAROeGa66ZD8CJjdUCKjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1472/1756] ksmbd: fix unlocked IPv6 addr_list walk in fsctl_query_iface_info_ioctl()
Date: Wed, 18 Nov 2026 15:59:59 +0100
Message-ID: <20261118150107.610605259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7c7eb542caf10..e03a9401e276d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8283,13 +8283,15 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
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



