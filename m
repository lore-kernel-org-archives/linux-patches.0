Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209614;
	b=t2Fkjy/Gi0nA6nXVRH3kZxJmqHf2VD5OztJG+Tgx/5o0n/SU+iIvSfHNdvYFxQhFja5l
	 PRAOC+lD3rRmJCWFBz8Orv+aJGi736HmbJmDPNc5OtF9M3j7IrHMiGnZRl2pKd2DC5aq1
	 q9ivKUNicLoRTvd//ckfaFVHrlLi5U/MK7746W7jjlnfEkqoeXFAL3IkL0hownxaw4uXY
	 eVGwinPXapL9QCBIJ6WzyC9zEyiqO8gv+GjouqzogDn4US4jt4btuffliW3pBE0m1vzlV
	 7Bp9DoCx+4daq6t8n7NTyLpEwOy4pNyOwYynnR05kRNkJFPWKZlrWqPYEU2GOcHtSmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mjlM6E3V/uSO+9xSt3L96216Rh6azzZ5Qw+qs6nUwuA=;
	b=45eyzZEC0iePUJDPbU9fkDg5KtmkUXa0Rs5DP9Z95+L3pLyLyoDr7HX5GGmWYdvu1WT6
	 MNRQW6LBhDbQFi6d0Rka2QV42Px1HWjDWB8qJt5vc2lp3uGn3K7N8hTclHeVtuvFA6kuY
	 O0mAg8x/65pUmuDZs+5QTdLE9sEOpMUwlolCIdAmf1RmI4CfmZASmBpuA9Wjtm7FmwzaV
	 lg1Ys5Qxy/lzbmtMiRGQ6Jq+gcAX3PDpNSisgHPzjsK2ydS5ppOYlo320iP9ylrR6Q2kI
	 1QC3NuE7gjl2Aulh/zC/soPC0tDXajxtTKMW6zMbkftvYYktPUWuiqR3qZ/SEyZfq/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="S5D8/6Jl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAF8606A31C;
	Wed, 28 Oct 2026 17:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5D8/6Jl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4BE1F01825;
	Wed, 28 Oct 2026 17:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209614;
	bh=mjlM6E3V/uSO+9xSt3L96216Rh6azzZ5Qw+qs6nUwuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5D8/6JlkuthHZB5sUUXKO580s5kCVCJd+d9wHL8yg+ETb4HKymQLgBigWpHVfuxO
	 IWrV5PWwF44cAYsmcOkD31kD8kiFX4fh963sgdNWpFVdY6njUalm+pLt2byK4JWIKj
	 bEfJuNkBXu2NNPQF5as4Ic1CUOTpj8KV5g8m2M/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/109] netrom: fix nr_node leak when nr_del_node() removes the last route
Date: Wed, 28 Oct 2026 18:00:01 +0100
Message-ID: <20261028165942.771224877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

nr_del_node() takes a reference on the node with its lookup. When the
route it deletes is not the last one, it drops that reference before
returning. When it is the last one, it only unlinks the node with
nr_remove_node_locked(), which drops the list's reference, and returns
still holding its own: the unlinked node is never freed.

Seen with kmemleak on a live node after adding and then deleting a
route to a dummy node with nrparms (SIOCADDRT then SIOCDELRT): the
96-byte nr_node allocated by nr_add_node(), callsign and mnemonic of
the dummy node in its hex dump, is reported as unreferenced.

Drop the lookup reference in both cases.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit a4b96115783fdefae9599f9a84a39e24fb288d6b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_route.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 98ba317ada637..288c4a91ea9b7 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -388,8 +388,9 @@ static int nr_del_node(ax25_address *callsign, ax25_address *neighbour, struct n
 				case 2:
 					break;
 				}
-				nr_node_put(nr_node);
 			}
+			/* Drop the reference taken by __nr_node_get() */
+			nr_node_put(nr_node);
 			ret = 0;
 			goto out;
 		}
-- 
2.53.0



