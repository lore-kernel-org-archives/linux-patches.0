Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D982AEEB;
	Wed, 30 Sep 2026 15:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783851; cv=none; b=GVIFTT26PxtrAJqClN7b+i51Mk1QTze9hLhct+qKxPwNdJTblVkP5iDyHtTBni7f+V64N6C25JSC1DOYhaYJMHu+EXNQR+TQE0UWdsmJhLCRyvfVgmFz0tGNxnTZhMWt92bmOs9EDaB+Eo9njHrZmGPd+xAD391/MU2cjATaSfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783851; c=relaxed/simple;
	bh=4r38ndvo9nmftH4x9vPhOxVVwfmTCXzSHo7SroiZTEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPp5M6Z2PwhWF0B1KHxr3XkQl/rUPiZpQ2i1V3bBzYvdq3zO88YfZ0y/95JUDSEaOaHYKIvuVRGB8/1GyIvdF223GYr9R/PqQeos0LFkW6Z4xn9Y/UVYpwPPw0pmpg2BfjMrRA5NdYm+LEMuvU1uG5i8LkLTHM7XgrLBRrPFjNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJT0urDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJT0urDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FD01F00898;
	Wed, 30 Sep 2026 15:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783846;
	bh=zJbbHeT4X0qnsvi2LICZLziSJyW2j4/eH7Gtg3kGFik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJT0urDxWjtk0VwVMweiiIhrWxevPR8AC2kcjhC5GxTBmDcRHJjsafukDqp++aggP
	 miXFTW7MHeem2QvmfLis5qE6sdSQZHQppGHI3BmQhljfkzsWF+5XagiX6z+g3gNDDu
	 kdkkaJPlFm7cqSRdU99CaMWV0jpcXAS01v9qFXbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 541/595] llc: fix skb UAF and leaks on llc_mac_hdr_init() failure
Date: Wed, 30 Sep 2026 17:27:14 +0200
Message-ID: <20260930152359.346854516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 647c0554d04cd..8e18b264408ad 100644
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
index 942ace4af18d8..188d8f92b0243 100644
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



