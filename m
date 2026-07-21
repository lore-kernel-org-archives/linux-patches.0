Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11905441035;
	Tue, 21 Jul 2026 21:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669813; cv=none; b=pOI66VNGunvYcKB6N2Jek03cijXKXVfLsTLsyNeiqbBTqzeYBK0/fNQlNy5+I1bRt9rWZTUbU0A4pgr7uKUh/I1jP3bW+6se43nrfOV0euBJzzKvdCtIrhe0oo5fkQRp6RmT1jG1xQPQZ7XoQs9OUppGW53G4eoep2ike1QuZOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669813; c=relaxed/simple;
	bh=tBcuRcYBCGauuyn73tvgidFWr5iTtCr6QMUN4PtRv7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ox2/PITeq4Byka332PHWRm6ZjEvBTyCMx26RG4kUpBkH7nwYYYqx5A0sWYIHil+OlFDmQba17LO4THoExY7YuslWT8REWa4CTtRQkcRYxsvwXFAOiXY6bd5AwzEsYq3azkvDqcy/3BVgq+RymMJzQif205zJ6Q5RulgQIwPQU9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0avCeeWe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0avCeeWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F5B1F000E9;
	Tue, 21 Jul 2026 21:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669809;
	bh=hUBh79rurwwPudFhShpOX4ckGv3g21g92tDuYEHb+uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0avCeeWexHYtVZK5QyK+j/Xma0bpozdiM84QT44b7s4Ff2w/L0lZrwDxyozpDrkFP
	 0WNQuHQXElxNoSVDqm0wnZSZuAvWAVCAGJ2C9S1XO+eW1GMc0uztlEqIr3JaWBugyd
	 7XJFa4JHIHAkwlDC4mDiTDrGpMZXOD77321qP1hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0693/1067] amt: fix size calculation in amt_get_size()
Date: Tue, 21 Jul 2026 17:21:34 +0200
Message-ID: <20260721152440.097906738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ddd087c2c3ed45..f2da0c49171f5d 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -3303,9 +3303,9 @@ static size_t amt_get_size(const struct net_device *dev)
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



