Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D31B47FB0F;
	Mon, 31 Aug 2026 14:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184859; cv=none; b=ZrqKUl9dHFAAjwoXyh+gVUCPmxE4yrgkEtnB7lY3YDiFQlEGxlecNRDLSFtqnyjGHREYyqTp6J/uisczZZbP0AR+/NMKze+g/nWT+SPk9p415tL828qPQ64fhssnjJPdFyiFnlnOrrCqRt6cEcnjF2RXGte2dM/vdSsO/pxGvig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184859; c=relaxed/simple;
	bh=zqxHo12corpSBpjKTVPlxiQ7b3dHabaWlAQB3lUQY94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXIj9JZHNXQ5u+3rpupgPRh2oCEGUpTtmAxEJP86GMyR0F8AfszA9HrAKftsoKfm9ySOipS/5x8X6qix8Ho3bcmY+TZyzZUw5mrMuGDpM02hPH0u8/YIr6MUfBOnEkylStrGiRgcaKAqjM+TwKVijwb/XDe24xb8U4Vy+4xd5jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rv1dZ7V7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rv1dZ7V7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283CC1F00A3D;
	Mon, 31 Aug 2026 14:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184857;
	bh=PwuWtTNSGNb8WjgjNRgVhK3UVCAZj9RhNW7WGoF0qos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rv1dZ7V7ukMF5VkC1ePSEh9cK/dMiZnGL6SzmNzxcC4rN/RFmLCQrXzGQiSD1OJ6o
	 krY5oit68exDRcq/qtVO7dYIWBSZ+HpcUW+dQDPeJ4QZHL5Z6AbuGol9Y0ZFmrW223
	 mgYZ0LmzB6z3+phbgiPnllRySdgvMlEMGs0MVUS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/92] smc: Use __sk_dst_get() and dst_dev_rcu() in smc_clc_prfx_match().
Date: Mon, 31 Aug 2026 15:34:22 +0200
Message-ID: <20260831133400.877961311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 235f81045c008169cc4e1955b4a64e118eebe61b ]

smc_clc_prfx_match() is called from smc_listen_work() and
not under RCU nor RTNL.

Using sk_dst_get(sk)->dev could trigger UAF.

Let's use __sk_dst_get() and dst_dev_rcu().

Note that the returned value of smc_clc_prfx_match() is not
used in the caller.

Fixes: a046d57da19f ("smc: CLC handshake (incl. preparation steps)")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250916214758.650211-4-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_clc.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index d6fe5dede1f79..ad1120a43dbd9 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -636,26 +636,26 @@ static int smc_clc_prfx_match6_rcu(struct net_device *dev,
 int smc_clc_prfx_match(struct socket *clcsock,
 		       struct smc_clc_msg_proposal_prefix *prop)
 {
-	struct dst_entry *dst = sk_dst_get(clcsock->sk);
+	struct net_device *dev;
+	struct dst_entry *dst;
 	int rc;
 
-	if (!dst) {
-		rc = -ENOTCONN;
-		goto out;
-	}
-	if (!dst->dev) {
+	rcu_read_lock();
+
+	dst = __sk_dst_get(clcsock->sk);
+	dev = dst ? dst_dev_rcu(dst) : NULL;
+	if (!dev) {
 		rc = -ENODEV;
-		goto out_rel;
+		goto out;
 	}
-	rcu_read_lock();
+
 	if (!prop->ipv6_prefixes_cnt)
-		rc = smc_clc_prfx_match4_rcu(dst->dev, prop);
+		rc = smc_clc_prfx_match4_rcu(dev, prop);
 	else
-		rc = smc_clc_prfx_match6_rcu(dst->dev, prop);
-	rcu_read_unlock();
-out_rel:
-	dst_release(dst);
+		rc = smc_clc_prfx_match6_rcu(dev, prop);
 out:
+	rcu_read_unlock();
+
 	return rc;
 }
 
-- 
2.53.0



