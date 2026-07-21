Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6152A376A06;
	Tue, 21 Jul 2026 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653765; cv=none; b=ttoHjmRKIyYzF6xnRPfIuy0yLxMcX/8GuQN8D+Nb7rOlku3/fHNMF1DznAVymrauI2T9XbYv+j35zZB2kkMMM8M4STcINBzKe4EafOTelK15dSyVdUAiI7n6wfMA74MExES/m/scnjOsBBbLndEEpeFrvxl5SbCLG8B+LFHkrL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653765; c=relaxed/simple;
	bh=A2tfhgTiHNmQzcDwTpkHSoKDpe+xS9Miv4D7jq1Tuyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnfuZFQ6435vh597ArsTw5mcb0W9VV+fAuKuV1pHu/7iNZn7DxMLHZ6t+HuppcKFwVYPUb60pheKMv+34ua9OlaAEaTUj4qPTRX/kSKHvwolWo9MMRJz12UbAod6bJJi+jpYwJiJGabG8+C0BJdlqdocaeeCxIDGGLAaKtipPB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRvw8Eso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRvw8Eso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC031F000E9;
	Tue, 21 Jul 2026 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653763;
	bh=SnCutSRIeAsyioRO9WAD4NTs0h5UZWJ31MIHkmh+BtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zRvw8EsowF8u6M4sGVHwOB/vJsFatsf3A0tknGURdrip+0lyjkBsi5bzc+ie2ds3D
	 wXkpkZB/d95aw4bygerWgP49yPqb7XMUAn6wyU77/9lZBIC6csXJ8emA/d9EweI8lv
	 41L6i05iPv/GxniMNdvMoJhLRgn9UhD/tjjhF49k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1450/2077] amt: fix size calculation in amt_get_size()
Date: Tue, 21 Jul 2026 17:18:43 +0200
Message-ID: <20260721152627.001724967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c03aa7c207e648..0f4ff41d053528 100644
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



