Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A2E495503;
	Mon, 31 Aug 2026 14:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185234; cv=none; b=l4HcQv5+sJ79QD+niqHRhww32xWa13Uz+3Q41vb0VqxszbN/5GH6vpiuwUSls3/ORfuY3zhM5+CiAtoh6ZmAgn8oDJzgJIdhIVekfcM2LlqRbvjWbSseVcFcv1/4E/Phz9pOUp4FXpqHDI1iEwyQ6B1dmpOs5Z1wSVOFJeNL7iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185234; c=relaxed/simple;
	bh=2l9qyGJCr925iZTb/rKmkCy/JtGVmtmZdQoxDK1759E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJ9OdmAlukY0QCXSYUIzA1XqxGyz94dsBXyANujfe7nUExR+GMf8oiUMu8x6kv1OccFssOrx6GcDe9IOiRnLYm3CqKcS3enEBkRKfq874Qr5+rvAik0DQb6Lj7cruRFIAIePECrEXv4A0SrjDhpiEgHY+hzpVujWoJyTB2+u0Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myMJboYs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myMJboYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CC31F000E9;
	Mon, 31 Aug 2026 14:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185231;
	bh=XZXV+owdvNLeFB8V+0WWkhqU4q3NVJkcMQqSkhHHqmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=myMJboYscQkBGKGnQ9ZnkrlAkdXvLiRuPLgNhBdl/zhVmm7HhJyqtS3zJ19ygZjFP
	 /2iFIuMCzZnP3939qufLzE7nwLI6AMPMBXmO8o/cvmiSRX3bi4ObA/LFPWmUxhrI/G
	 cTZ8kU0uHCUSPLFJT3lPzPLBnBJI3+/95UvSkDOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.10 29/43] xfrm: drop ESP-in-TCP packets with no ingress device
Date: Mon, 31 Aug 2026 15:35:37 +0200
Message-ID: <20260831133359.934810272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

From: Zhiling Zou <roxy520tt@gmail.com>

commit e1d7c5ac1c246ce5775f604515de0a59fbf2116e upstream.

ESP-in-TCP receives records through the TCP strparser. handle_esp()
restores skb->dev from the saved skb_iif before passing the packet into
the XFRM input path.

Queued TCP data can be processed after the original ingress device has
been removed, for example during veth or net namespace teardown. In that
case dev_get_by_index_rcu() returns NULL. The XFRM IPv4 and IPv6 input
paths both expect skb->dev to be valid while building the route lookup,
so queued ESP-in-TCP data can dereference a NULL device.

Drop the packet if the saved ingress device can no longer be resolved.
Such a packet can no longer be routed through the normal XFRM receive
path, and this preserves the existing behaviour for packets whose ingress
device still exists.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Assisted-by: Codex:gpt-5.4
Reviewed-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/espintcp.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -38,6 +38,11 @@ static void handle_esp(struct sk_buff *s
 
 	rcu_read_lock();
 	skb->dev = dev_get_by_index_rcu(sock_net(sk), skb->skb_iif);
+	if (!skb->dev) {
+		XFRM_INC_STATS(sock_net(sk), LINUX_MIB_XFRMINERROR);
+		kfree_skb(skb);
+		goto out;
+	}
 	local_bh_disable();
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == AF_INET6)
@@ -46,6 +51,7 @@ static void handle_esp(struct sk_buff *s
 #endif
 		xfrm4_rcv_encap(skb, IPPROTO_ESP, 0, TCP_ENCAP_ESPINTCP);
 	local_bh_enable();
+out:
 	rcu_read_unlock();
 }
 


