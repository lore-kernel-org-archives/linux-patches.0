Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38B81C687;
	Mon,  4 Mar 2024 21:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588044; cv=none; b=AXyHb6LX+I2JlXJoQs+a4k5M6JENGaA5boFh5b2NaPaGxuPvVl6+NWUDGje/3Dy2km8vmDikznN0I1oiqlrT2rqzj82QlJWES36YAGGirEbN6C4/C69hw2EQpTRUCJltaRQFMIq9bUOWWs0mA05/meJXTrOVOqHtRofcX2AIrkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588044; c=relaxed/simple;
	bh=AmnEXfjY2hLrm/npFDMPGzfcQF17ni69WO6KiXnovi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzP2IjGBtnvoRh0Wi+PGpgVL3hhuzBdYwctWdw5OA5VPXuoKBVCix9ao93e4kY2ctkMXUwgJsI9dezeRPk2Lj8PBpZYeQJawPj3x4UR0cmA9dmGsdgefmycYTrGCZd+dlLlikVbck8pN2J52kmx741gh+cwTW6D1+1GNb29P0OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzLcNrmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzLcNrmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DC9C433F1;
	Mon,  4 Mar 2024 21:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588044;
	bh=AmnEXfjY2hLrm/npFDMPGzfcQF17ni69WO6KiXnovi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rzLcNrmrJNvwk4MHJnBdxb61JqLWEH9D51RdgtnVb0IkJsh2oy8eaBU725pqQfi1b
	 JfREodCLgmvAgVFNeP2CqRWUrp+k3VLeKYTa4iWv9M6PKDRDF56J1uPVOcXr1hGzcm
	 fQRYJl+IXJ4F8IbtiUEEo9VZAZ6JWYcQ4XP4iZpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/25] ipv6: fix potential "struct net" leak in inet6_rtm_getaddr()
Date: Mon,  4 Mar 2024 21:23:40 +0000
Message-ID: <20240304211535.893182620@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211535.741936181@linuxfoundation.org>
References: <20240304211535.741936181@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 10bfd453da64a057bcfd1a49fb6b271c48653cdb ]

It seems that if userspace provides a correct IFA_TARGET_NETNSID value
but no IFA_ADDRESS and IFA_LOCAL attributes, inet6_rtm_getaddr()
returns -EINVAL with an elevated "struct net" refcount.

Fixes: 6ecf4c37eb3e ("ipv6: enable IFA_TARGET_NETNSID for RTM_GETADDR")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Ahern <dsahern@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6fcbe8912b431..974e650e749e6 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5380,9 +5380,10 @@ static int inet6_rtm_getaddr(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 	}
 
 	addr = extract_addr(tb[IFA_ADDRESS], tb[IFA_LOCAL], &peer);
-	if (!addr)
-		return -EINVAL;
-
+	if (!addr) {
+		err = -EINVAL;
+		goto errout;
+	}
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifa_index)
 		dev = dev_get_by_index(tgt_net, ifm->ifa_index);
-- 
2.43.0



