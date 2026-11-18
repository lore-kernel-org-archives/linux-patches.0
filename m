Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022699;
	b=X7ok1flbK+5J/GPlQ4PVYHN5Hd4DxWBxhBYMNNHskNrSYvIDDK50E1D5KkNaVNzMnq3W
	 5OmBv7JU79rzcJad66dPW7ctYoq1Cp02pTm2R1NWLGpvIMRGLZ42KKt3WlSRlLsEHbJdL
	 IkU8E3Zx9BtA3C4DHbQz9C5KxAfpN2n4Km7FGjhJ/ITCKXEy1wzmsseSBS6NEUO7l6Sz/
	 HJMl6kWrXIzkb0T+5SDpSAe0Svn96buvinfA81YQ7/VbQ4zqTPOP/MuD/pg4F7ww7+k6Z
	 npn6v93qxK19u4UMUL2P193scoogohOPmThMJ8KyjXSRAq+UoXfRMcLTa25mYwGE23w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Y+D3TZPRPX48wLLAN2gzi91bDckCz7L+OwHkjvqjac=;
	b=ca/UF59FLqH6sgvGq8kWciEopo3fmMRczEtZv26mC3Md4pLy3KiyXdcSbvL+3EIzywRR
	 79OoEBkDJy03MnyAMuwUO5Lua6B8tIvz8J+O1DtGroD8lL6/8NE97TDi8Yazy40M79K2Q
	 7RISyVKMozvlloi4ZSXmhG/U+K76gnwoPpVVz1bPvQEyGVtmDN/A22gJVKhX2Gw43uYdy
	 EsKHQX9XJwh/WUoBExsIDenihYAyd3QZEmJ7hXTS5GlRYggGk/7Zi82hqEuRsbNRBgsYG
	 564GClVllCYmUo8SRqnU+6+C4jY4KsuO2CxhxLcK7oia9fwBfO+DJiA2ayYMbE3hfmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3HgUVjn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF54606A32A;
	Wed, 18 Nov 2026 17:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m3HgUVjn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E541F000CB;
	Wed, 18 Nov 2026 17:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022699;
	bh=/Y+D3TZPRPX48wLLAN2gzi91bDckCz7L+OwHkjvqjac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3HgUVjn0idr1yNsRxKMnRXghmJU83d2SsuAkiKhgkTPADx7TmV8Ps5VUAOLdRF+I
	 sLjBZZNy2sse5JunENJCobiosTfh5VdSpqC1Lkx4eY3lNFa4WwI1elafC9r/BhcSSO
	 mvXZpoBZuKj5Tmf//b47u5VADDAVr+sZfjA4KYVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0107/2151] rose: walk the neighbour list under its lock when a device goes down
Date: Wed, 18 Nov 2026 15:30:42 +0100
Message-ID: <20261118150125.698379276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



