Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B4A3F5BFC;
	Wed, 30 Sep 2026 18:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793261; cv=none; b=fILhxyNPqRX6PkvEfwsrHw9yvs/scV0bBjbqfx1leP930PR+Y8diFhsy0vAU+OAX2T55PCRYmHE66IRpO4j5rhfBJYIDfZjQ/fjM6ts35GWNR/6jOR3DNZlYaodmU8BHg6wGoJifk4X64cSxAek/8J2hXBqvM1xXVBGgzB84jCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793261; c=relaxed/simple;
	bh=GibVQ5SuohxSdkK9U8JEjyBYklHVR4HtV+saPU6Le04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5YzzH/gZNDfuXW6cxDPeL309V7zIXHaG/jN7BbLfhJ+mNSWNO+e1bV/P0Bss1sT5OEo8RKlbEiHGjUZWF2aHx5k1JnFWdyYw7ACBypobdFzV/KN53wNVBwYKIcsBvrxvTLmSn7/YTM3U4nSn0AHcWex5Kh/eNdXQfnwAgmXEGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxUnu1q8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxUnu1q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9DE1F000FF;
	Wed, 30 Sep 2026 18:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793260;
	bh=Ta126LyjZMVA416wl0gSSca6/7sUUMxHZFsOCoKyRdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxUnu1q80F1hvpPNmlhEeNul5cqWyUDnGY47CbK5yWnMapLVZezsDGEtjXK16Pa31
	 +aA3//u3fDFvhiAVdQbrIQ5/Nuw6baxVlrJ17KLhyt+yPj9qcYAhOP1mq/kYcPCYws
	 iIwe8Y48pRRZ0rU0fEEkg1375tZ2wWJe8tkjserI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 192/395] llc: fix skb UAF and leaks on llc_mac_hdr_init() failure
Date: Wed, 30 Sep 2026 17:27:34 +0200
Message-ID: <20260930152344.814692473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

[ Upstream commit 72f9dd522f8d6c5a00be9695c7bb74631eb5069e ]

In llc_conn_ac_resend_i_xxx_x_set_0_or_send_rr(), if llc_mac_hdr_init()
fails, kfree_skb(skb) is called instead of kfree_skb(nskb). This leaks
the newly allocated nskb, reads from the freed skb via LLC_I_GET_NR(pdu),
and double-frees skb when llc_conn_state_process() drops its reference.

In llc_sap_action_send_xid_r() and llc_sap_action_send_test_r(), nskb is
leaked if llc_mac_hdr_init() returns an error.

Free nskb in all three error paths.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Closes: https://lore.kernel.org/netdev/179022851638.2160803.1808206741379444999@kernel.org/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260924082951.1599377-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/llc/llc_c_ac.c | 2 +-
 net/llc/llc_s_ac.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/llc/llc_c_ac.c b/net/llc/llc_c_ac.c
index 0779daa8aa8f3..a9e0341f4d210 100644
--- a/net/llc/llc_c_ac.c
+++ b/net/llc/llc_c_ac.c
@@ -443,7 +443,7 @@ int llc_conn_ac_resend_i_xxx_x_set_0_or_send_rr(struct sock *sk,
 		if (likely(!rc))
 			llc_conn_send_pdu(sk, nskb);
 		else
-			kfree_skb(skb);
+			kfree_skb(nskb);
 	}
 	if (rc) {
 		nr = LLC_I_GET_NR(pdu);
diff --git a/net/llc/llc_s_ac.c b/net/llc/llc_s_ac.c
index 7a0cae9a81114..cc6fb29a9510a 100644
--- a/net/llc/llc_s_ac.c
+++ b/net/llc/llc_s_ac.c
@@ -127,6 +127,8 @@ int llc_sap_action_send_xid_r(struct llc_sap *sap, struct sk_buff *skb)
 	rc = llc_mac_hdr_init(nskb, mac_sa, mac_da);
 	if (likely(!rc))
 		rc = dev_queue_xmit(nskb);
+	else
+		kfree_skb(nskb);
 out:
 	return rc;
 }
@@ -176,6 +178,8 @@ int llc_sap_action_send_test_r(struct llc_sap *sap, struct sk_buff *skb)
 	rc = llc_mac_hdr_init(nskb, mac_sa, mac_da);
 	if (likely(!rc))
 		rc = dev_queue_xmit(nskb);
+	else
+		kfree_skb(nskb);
 out:
 	return rc;
 }
-- 
2.53.0



