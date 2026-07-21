Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE52430CDC;
	Tue, 21 Jul 2026 19:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663309; cv=none; b=N10A3WO0ikibZAagMk53PKh5tRNT4z1cd8jaKbpftg8ppkZl2ks7a3tF2ioJzdT+Qhjm4TGyiCRZJyyhkSh2UpW96RJHMawtNLEI65CakmflqTPSI/mRzVkvgKDOSaLnx9vnj3ERrGDooo+NV25szLCuAe6v7TPbqDbuE1tMqDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663309; c=relaxed/simple;
	bh=emFNveLKPVJZmS3PUJ5xO+Du3G6Ro2DgdtdH9x1LpMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCqaEX+qv0zklM0x2Xsk+QgXTscftmsI0hNfaLNmi2M1V1B3QaxnYTXEpCFCfl0G0vEWgMlS9sHt82HzIv7YuskxnG2vzuHFhEPR7Ft0V88MX6D/4EDUxquL8Xebp5mAonlkb+mGrJjWmA4MPnbO7Lq6O+DudM0zitsm4pLHH1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4Imtcwv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4Imtcwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF8B1F000E9;
	Tue, 21 Jul 2026 19:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663308;
	bh=JghdwbOIQRqel5acTAJ6BBZZikA+jDAZQWWltIODb5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4ImtcwvOHi7DadAPxYaZAALyHQaU8F/aUaI44q8Ob5cqAD+nsXo+lQDxrfdd7VAk
	 VBJ/DbTANerlwU+Cu6edhX4UkAc5dxtLURM8yfKiGR+K5cogWdmsT3eOtuL9ZEoQR5
	 SYyg4CFA0Qf01Q6T+IjXPawsISF3DhXYqlBzmMD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0773/1276] amt: fix size calculation in amt_get_size()
Date: Tue, 21 Jul 2026 17:20:16 +0200
Message-ID: <20260721152503.375563769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0433a0f36d1b4e..ef6848c2e60841 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -3297,9 +3297,9 @@ static size_t amt_get_size(const struct net_device *dev)
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



