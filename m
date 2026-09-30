Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2025A51616D;
	Wed, 30 Sep 2026 16:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787415; cv=none; b=nii9SkmTNFTQcVA+PL4vdeD/Tqvaf5T3e70E/cvaY9SCODWlNWRUOMl8EiGnXjPjfpNByBqFsYSMWys+kUACGF5DHsvZ3DCXzYUDx4G3Zhcg5yE9vpQZEQziCPjNA/rlurrPd2F0jmXl+S+eVBERL04Un0LlWqt+6ZJc2QVMu18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787415; c=relaxed/simple;
	bh=gnnJk73nDkI1GaIO7/fxtlMIl1SvclAwE2UBUv0397Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfnKh2jNf0WkiwpxC621/eAMq8NqviSj3Rd9LAZzXzv6gCyaWgSFNNuvNXIY8QJsinfKmSRxycfCKIeU/HKhRNCSvt5dh6lExf8jlhDYrVu8JNLHRisROeaVRf7pE/garT96yTl54yXy48rxgk6JOX7iganF8Vhd1YgrIPMRbWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgADiIll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgADiIll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D35E1F00898;
	Wed, 30 Sep 2026 16:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787414;
	bh=dEsA8ejoWll/anO1eoSOJoeA9ATmMIMSGKiX4kWeS6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OgADiIll43ENY4mkM93Yqj6clyqNQWerC3TzLLev7bxPMjx2Cd7tZAYY39HFJW5wO
	 ZH/WHcA1w5lUDc5DteP/e2+OJBJxjj9Z4Y91MpHYMJT00LEHjX0nkWK3ToWE5UNLso
	 wWyJ9i2paX/F3CZfBipMycB7KFv0Z3ssYgL3pwMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 222/457] llc: fix skb UAF and leaks on llc_mac_hdr_init() failure
Date: Wed, 30 Sep 2026 17:25:27 +0200
Message-ID: <20260930152350.840728681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 724ecd741d4cf..1aa7fe28acddb 100644
--- a/net/llc/llc_c_ac.c
+++ b/net/llc/llc_c_ac.c
@@ -437,7 +437,7 @@ int llc_conn_ac_resend_i_xxx_x_set_0_or_send_rr(struct sock *sk,
 		if (likely(!rc))
 			llc_conn_send_pdu(sk, nskb);
 		else
-			kfree_skb(skb);
+			kfree_skb(nskb);
 	}
 	if (rc) {
 		nr = LLC_I_GET_NR(pdu);
diff --git a/net/llc/llc_s_ac.c b/net/llc/llc_s_ac.c
index 98deee5603735..831998211b52e 100644
--- a/net/llc/llc_s_ac.c
+++ b/net/llc/llc_s_ac.c
@@ -121,6 +121,8 @@ int llc_sap_action_send_xid_r(struct llc_sap *sap, struct sk_buff *skb)
 	rc = llc_mac_hdr_init(nskb, mac_sa, mac_da);
 	if (likely(!rc))
 		rc = dev_queue_xmit(nskb);
+	else
+		kfree_skb(nskb);
 out:
 	return rc;
 }
@@ -170,6 +172,8 @@ int llc_sap_action_send_test_r(struct llc_sap *sap, struct sk_buff *skb)
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



