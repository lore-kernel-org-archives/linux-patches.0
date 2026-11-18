Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028754;
	b=urmnmVC0Bk4DRJav7RmxKddMG7QeouBNs/bgaJRsUHofmw7KaotS/0QDkAPiZeIohIXR
	 pafFy/2/FSarFbeAAmXJJsFqIMnHgcECbGE3/im6eNh8M98+CcQr2PBiFEKxtL+LQTER/
	 fT4cIOchOqy2Y1nmc7zZ0Etq9A++SFhPiOHjQYcDWtvth1K9PRhA3PcJQqjh147G+XWcl
	 EGMvX5XsyaWIV36IqC8zVaFQMNByrQT2bs92dzWahvO+CJ6ph6TqPO3d8xlkrvoJXHZmJ
	 Awq5zPeCJec6RrWjAoLfbX0zpRFu1y+537e9YlpZTJPIDQ9v0ZXP8x8nE4vu02XcqHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GEcuCCmZkRJXYnjeYtpDaQcmvi6MG6+vpiXgwZWKVEU=;
	b=O7lgTMVrb1THbSQwa3uyhw4bfJ9mWso/+72jVvqaOJEacce930XroZppMFmuJQm0umsB
	 YdVOf5MaVJ8a9kp2n+sP6jPn7oGpHKRrGWqFIdzQB0DW4tloBTbpbCg8DJ2Jj6tt7ALtZ
	 ZJSmDNVzbq84LS4r7q2EYHdUBPRdymhTgabmV53ZlB7TwP99pre3hEdgGaGjebJFplA81
	 i2Sf3tGVAmX3MH0uS/vCYcwwZjpSxutsdFKtq4xhW2emiSE3Nh5kUnFzU+AJCLnVSkGel
	 iUZCdqdeqPm2Hn8F7YP5/OLu8cBi5OGTzW9SZbk+KMl+mqlI00wX+Eh6ujOb0BGFogA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+Eh1cVi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0A9606A330;
	Wed, 18 Nov 2026 19:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+Eh1cVi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8021F000C4;
	Wed, 18 Nov 2026 19:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028754;
	bh=GEcuCCmZkRJXYnjeYtpDaQcmvi6MG6+vpiXgwZWKVEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+Eh1cViaE3X5LNKPILWuLhz2mZ56Qsouwd/c+H9IEZtwYofPq8CBGoBzn7KbJ43D
	 nFprN9a00l3sITPJVKZYJ38ZQKQ6OVtslrv2eNen2Q58nYxN/d4LjrcqSG7xDItktU
	 9iwthGjtxSLxUo2C1DiWSAdpW2Tij1qC6EKMAG7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0106/1756] rose: walk the neighbour list under its lock when a device goes down
Date: Wed, 18 Nov 2026 15:37:13 +0100
Message-ID: <20261118150012.435855396@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

rose_link_device_down() walks rose_neigh_list without
rose_neigh_list_lock. The list can change under it: rose_add_node() and
rose_del_node() from the SIOCADDRT/SIOCDELRT ioctls, and
rose_rt_device_down(), which the same NETDEV_DOWN event calls right
after, all add or free neighbours under that lock. The walk can then
follow a neighbour that has just been freed.

Take the lock around the walk, as rose_link_failed() does around the
very same calls to rose_del_route_by_neigh() and rose_kill_by_neigh().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit bf7007048732cd8eac6e3c7c68d131692b480f75)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_route.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 00fbe47fffe04..70ed72f4a11cb 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -958,12 +958,14 @@ void rose_link_device_down(struct net_device *dev)
 {
 	struct rose_neigh *rose_neigh;
 
+	spin_lock_bh(&rose_neigh_list_lock);
 	for (rose_neigh = rose_neigh_list; rose_neigh != NULL; rose_neigh = rose_neigh->next) {
 		if (rose_neigh->dev == dev) {
 			rose_del_route_by_neigh(rose_neigh);
 			rose_kill_by_neigh(rose_neigh);
 		}
 	}
+	spin_unlock_bh(&rose_neigh_list_lock);
 }
 
 /*
-- 
2.53.0



