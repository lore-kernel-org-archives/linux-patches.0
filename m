Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448DC63D5;
	Thu, 15 Aug 2024 14:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732511; cv=none; b=Maxu/GC64C4qgCY5fSnnsNrx0LoCwqRphnVQeJT9/uGCzhIOzP2hyFF0djgVAdIG3iwIUwYdJQbXDiMaPzL6IUmQm05rK+UDyoADw4iGVILTrIYDiz2js6dNkcqsBFRKMfXpWfHwbQb/vcsSS7JLJ8dN0J3Np2rE0NebuJR0ZL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732511; c=relaxed/simple;
	bh=efAejBIREQyy/P54z5EliFlt82pOs0fUeE3zLidgpT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZhcU20S/qtyfqj4cyyqEHrjN3VjlmFNmEpKFjvJu0wku9VrlRbjPAX1xfx/FXamVRMczxZmU3QJ6TtdFa8JfGjLyE4r81eh+T+esxbcW91zFBHQVoCERlPr1AMNGyRy4yhH9RNAGIkg+Ahwcv8KjNDC9SdzlfT9M7sQ+4TQp/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBRmqAPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBRmqAPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3DBC32786;
	Thu, 15 Aug 2024 14:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732511;
	bh=efAejBIREQyy/P54z5EliFlt82pOs0fUeE3zLidgpT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBRmqAPVzfDLS71dWFxGHIE0r0n0Lnr3dypCTgofahaFtHoKI/YiHXxpboMT8ZOZq
	 1/42JBNPUm0r51PZRh84Pv1St2lMoIzXMgjfs1ib7Gb+y65LaxWKs/27nTGTftIKWP
	 UHnub0xAq2JuQAuwcjTn3OCu33pfqjnxRxBixa0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/352] net: nexthop: Initialize all fields in dumped nexthops
Date: Thu, 15 Aug 2024 15:24:27 +0200
Message-ID: <20240815131927.046232786@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 6d745cd0e9720282cd291d36b9db528aea18add2 ]

struct nexthop_grp contains two reserved fields that are not initialized by
nla_put_nh_group(), and carry garbage. This can be observed e.g. with
strace (edited for clarity):

    # ip nexthop add id 1 dev lo
    # ip nexthop add id 101 group 1
    # strace -e recvmsg ip nexthop get id 101
    ...
    recvmsg(... [{nla_len=12, nla_type=NHA_GROUP},
                 [{id=1, weight=0, resvd1=0x69, resvd2=0x67}]] ...) = 52

The fields are reserved and therefore not currently used. But as they are, they
leak kernel memory, and the fact they are not just zero complicates repurposing
of the fields for new ends. Initialize the full structure.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 7a0102a4b1de7..a508fd94b8be0 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -210,9 +210,10 @@ static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 
 	p = nla_data(nla);
 	for (i = 0; i < nhg->num_nh; ++i) {
-		p->id = nhg->nh_entries[i].nh->id;
-		p->weight = nhg->nh_entries[i].weight - 1;
-		p += 1;
+		*p++ = (struct nexthop_grp) {
+			.id = nhg->nh_entries[i].nh->id,
+			.weight = nhg->nh_entries[i].weight - 1,
+		};
 	}
 
 	return 0;
-- 
2.43.0



