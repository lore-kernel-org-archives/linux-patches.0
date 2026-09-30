Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5804DE728;
	Wed, 30 Sep 2026 17:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789350; cv=none; b=NrzZqCg75wzVOWx0pQ8HIht2LiH5ebuC4INAC1WVcysn6VSlM5wklOTYz8uPwANdf9fOvZMDT1LWIW7xkFgrr68DOTkg91JH86NpWTcIiwvjHJMsprhL62sDWJ6TpgyA2Yj/RkMalAod3R4pGfSDIBBLSgaaQIyJ5GGRw0SNpAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789350; c=relaxed/simple;
	bh=fcvnV7py/ZTHtFVb72oaj54nZBuRThlcMrbKBDc/Sv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqV24XCl9ZOTlkoB1uRA0Zxa5x98NevqJvuJHvdPtFkoEmvMabzWD1v8Nq/5n2HxJzj/B+/6HO88nyvYGW4flgS3DABLQizmnkTEXmQ0l7coUFbSRmqXbtK21T0eZB435tjbbQJMlAQOGDtB12DA58pSxMIDW3S2yx/I7K40cj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKJevrID; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKJevrID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC141F000FF;
	Wed, 30 Sep 2026 17:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789348;
	bh=CW+C1xno8u0Pg6zIRWKaIij650Ks9IYTxziBvdAQK3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKJevrIDQh6cdq6i2E43wy2QsMAmdD/k++APetbZpibExfKlAOkQGFafMFnuJqrRd
	 dfkHZBIVwIZuwiZMErZFZFrRVd9SrdDRLv0SdB6ZEWSOuZQ/TgupaS9m61bQL/SE2g
	 aV388f7BVhx6IWpTtzhX60zEyyV9U0toXppaINjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 444/877] llc: fix skb UAF and leaks on llc_mac_hdr_init() failure
Date: Wed, 30 Sep 2026 17:22:35 +0200
Message-ID: <20260930152424.263614354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 40ca3c1e42a2e..5c8483f63ebbc 100644
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



