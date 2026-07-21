Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EC746DFF5;
	Tue, 21 Jul 2026 18:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658199; cv=none; b=HH1RnF5Bcg3DRRIypFGpqfi96ioWvGM3VVEa4JlYmUIZRko4QS0YA5JBa+GQYAG7RXRIPCWXrOeQ+O4h9QTL0nvBCg2WYC7h9BtmT0ofToBjd5fU65psVe9OtVsvLbtuU+RMtR7Hyj4hc0JiYkWTrvPl0xe2kqe67NTbJ9o5jyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658199; c=relaxed/simple;
	bh=vFdJMkZ/ZzpsGHWSaG+KduF1Ns86Lcll20r2uUX88Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i44z+IYuKpL1M/ZBGkq3ELvEY2DWy6MU7zF6KHMJPuscE5WwLyvt5++g/hIVsae6Xp93ZW5gzPBjpX+8zNVESDvpgVtX17Q2Ah3Sfch9Z6e0i/bUNK4g4CNOcu9ob6ZQupcJPLW6iy4PgtK2qNV+/Evc3nJSaU9FzXxR1DQwgCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2cQzLn6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2cQzLn6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BD71F000E9;
	Tue, 21 Jul 2026 18:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658198;
	bh=ZdQJT3RoGoiXZYBr5li3pTmKNnQ2faIU+BdTdZzR2Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2cQzLn6h6ivMQp+t+rtq55EAC8NpNvfhPhyu9JAWxR8yMMxc4H8BPTrKepDSSMVQI
	 qMxAdlYiZLjRRwqIei4MCmuU6c2qdRQr+uw/MXltLezBuaIvjrXg62Ea6Yx0d11Ngq
	 RjQg+5Fk1uUttpMwvFPU7e4eX68qy+9ryP9xMuTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1052/1611] amt: fix size calculation in amt_get_size()
Date: Tue, 21 Jul 2026 17:19:28 +0200
Message-ID: <20260721152539.070511860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9e05e91a9a847ed57926414bd7c2c5e54d6c56c6 ]

amt_get_size() incorrectly used sizeof(struct iphdr) for the sizes of
IFLA_AMT_DISCOVERY_IP, IFLA_AMT_REMOTE_IP, and IFLA_AMT_LOCAL_IP.
These attributes contain IPv4 addresses (__be32), not full IP headers.

Replace sizeof(struct iphdr) with sizeof(__be32) to avoid over-allocating
netlink message space.

Fixes: b9022b53adad ("amt: add control plane of amt interface")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260701122329.3562825-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 902c817a0dea12..e4d1aa26d7bbd7 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -3301,9 +3301,9 @@ static size_t amt_get_size(const struct net_device *dev)
 	       nla_total_size(sizeof(__u16)) + /* IFLA_AMT_GATEWAY_PORT */
 	       nla_total_size(sizeof(__u32)) + /* IFLA_AMT_LINK */
 	       nla_total_size(sizeof(__u32)) + /* IFLA_MAX_TUNNELS */
-	       nla_total_size(sizeof(struct iphdr)) + /* IFLA_AMT_DISCOVERY_IP */
-	       nla_total_size(sizeof(struct iphdr)) + /* IFLA_AMT_REMOTE_IP */
-	       nla_total_size(sizeof(struct iphdr)); /* IFLA_AMT_LOCAL_IP */
+	       nla_total_size(sizeof(__be32)) + /* IFLA_AMT_DISCOVERY_IP */
+	       nla_total_size(sizeof(__be32)) + /* IFLA_AMT_REMOTE_IP */
+	       nla_total_size(sizeof(__be32)); /* IFLA_AMT_LOCAL_IP */
 }
 
 static int amt_fill_info(struct sk_buff *skb, const struct net_device *dev)
-- 
2.53.0



