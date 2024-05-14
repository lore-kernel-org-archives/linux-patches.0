Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FB213665B;
	Tue, 14 May 2024 11:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686981; cv=none; b=giMkgjg3wl8Cr3C5ucDZCl92mjkCQjiglbwXQ6ekdK9z41N5zo6vMGL2OIi+rQcnEvji9w5Mtx9iS4Gys4gSSG5JLLYvXiQZ/8NAVh4BcSenWAL9k9OuhLXd5xzEZynvT93SyGWu434c/2Bat5LHwhrjBgjYgf3nCZOK/00P610=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686981; c=relaxed/simple;
	bh=rFYjyFhmS8CvPDaiu6+cn0WKEO4hnItjSBzaMLb86xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsM9/fFm6mKd0RDliFkJFDQ8cSNnqL1NlIPwg6GjmbwpUft9CBFkwgR86SU7dT47Yl7fR4whtlc3rdXwfcMsTynU2yCFUVcL8nHDxbpP/HUXTcIf0lRSw3MU5dpGkul6+XrVQumKUIY7tPa1TYRCMTWp4gjFOhku7xL6Zlj0YsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axiYHqwc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axiYHqwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C4BC2BD10;
	Tue, 14 May 2024 11:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686981;
	bh=rFYjyFhmS8CvPDaiu6+cn0WKEO4hnItjSBzaMLb86xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axiYHqwcjwqCFAHw8MuEVVvYU9r04RIeNSYw241OcpiP3QlGvswa+h195JCFn2ZLk
	 7Qy8NqfTFSApwS2SOGZIZRoVg+zIRGYPWLxoGW2skrYeN1PmEl9+jv/XupehfYAJsm
	 oXnqRr5R3V+FsJHyzNKKammJeXIMBzS7KtpIzSVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Chapman <jchapman@katalix.com>,
	David Bauer <mail@david-bauer.net>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 24/84] net l2tp: drop flow hash on forward
Date: Tue, 14 May 2024 12:19:35 +0200
Message-ID: <20240514100952.604946344@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Bauer <mail@david-bauer.net>

[ Upstream commit 42f853b42899d9b445763b55c3c8adc72be0f0e1 ]

Drop the flow-hash of the skb when forwarding to the L2TP netdev.

This avoids the L2TP qdisc from using the flow-hash from the outer
packet, which is identical for every flow within the tunnel.

This does not affect every platform but is specific for the ethernet
driver. It depends on the platform including L4 information in the
flow-hash.

One such example is the Mediatek Filogic MT798x family of networking
processors.

Fixes: d9e31d17ceba ("l2tp: Add L2TP ethernet pseudowire support")
Acked-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David Bauer <mail@david-bauer.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240424171110.13701-1-mail@david-bauer.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_eth.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index d3b520b9b2c9d..2c5853597aa90 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -149,6 +149,9 @@ static void l2tp_eth_dev_recv(struct l2tp_session *session, struct sk_buff *skb,
 	/* checksums verified by L2TP */
 	skb->ip_summed = CHECKSUM_NONE;
 
+	/* drop outer flow-hash */
+	skb_clear_hash(skb);
+
 	skb_dst_drop(skb);
 	nf_reset_ct(skb);
 
-- 
2.43.0



