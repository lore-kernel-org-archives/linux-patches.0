Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707D03F0A83;
	Wed, 20 May 2026 17:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299115; cv=none; b=B0PR5i0oeVT6YBu39dUagqLYlM29jOuoJN1CYonYouOqGcE9EEDq8LGLG1bZD6O//zX7rf8Yd3hE7BZlMKiYgOieC0b27ljBWupBT0xW79SXKNdp3sj1MB36bLjcml/Z4ZfCfAY6aO+UkVDnoq4+FxFV/FlfDOpqiL2Uc1BlHAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299115; c=relaxed/simple;
	bh=XBlm2zds2r9fEuWWGgy3ZmPYlyUYQ9mAT1lQxUwrlaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtVr9nfteAVgPiOrkV88iAAvKa2X0JiPCyaB+f6UhI60G+Q1TurhJ11nnWDhpylMJtYpXBIFqEw3dgrId6WYiUpBqO9ZI8FRfeS3uIH1zcsi6wVexvXwLEqcI49YnxHRWuDZJ0kaxDAbQJFKU1BF02vaQTXwlj3s5wQ3ddZ5E8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=As8d2ZD1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="As8d2ZD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36431F000E9;
	Wed, 20 May 2026 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299114;
	bh=U3inOPqVkBJx3i580ZWaZE/bkZ1IRv7G2jHwta0Scg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=As8d2ZD1OFX9X9YJkqrbaAMVLJqS3OGrorOlh4tbl5ElRytdo9NSvHVcMEptK5o7F
	 /1q4/A+j6hxo9Im8/aFCwPRSj1MbaCRaW8jLok7DF+tRSiddW1QPkMygfKT9b5JTZ/
	 I0gaeEldvabc5SG73Gm3tUky0ofEfCf+EDp5vqLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 616/957] macvlan: fix macvlan_get_size() not reserving space for IFLA_MACVLAN_BC_CUTOFF
Date: Wed, 20 May 2026 18:18:19 +0200
Message-ID: <20260520162147.893389492@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit fa92a77b0ed4d5f11a71665a232ac5a54a4b055d ]

macvlan_get_size() does not account for IFLA_MACVLAN_BC_CUTOFF, but
macvlan_fill_info() conditionally includes it when port->bc_cutoff != 1.
This causes nla_put_s32() to fail with -EMSGSIZE when the netlink skb
runs out of space, triggering a WARN_ON in rtnetlink and preventing the
interface from being dumped.

The bug can be reproduced with:

  ip link add macvlan0 link eth0 type macvlan mode bridge
  ip link set macvlan0 type macvlan bc_cutoff 0
  ip -d link show macvlan0   # fails with -EMSGSIZE

The bc_cutoff feature was added in commit 954d1fa1ac93 ("macvlan: Add
netlink attribute for broadcast cutoff"), which added the nla_put_s32()
call in macvlan_fill_info() but missed adding the corresponding
nla_total_size(4) in macvlan_get_size(). A follow-up commit
55cef78c244d ("macvlan: add forgotten nla_policy for
IFLA_MACVLAN_BC_CUTOFF") fixed the missing nla_policy entry but still
did not fix the size calculation.

Fixes: 954d1fa1ac93 ("macvlan: Add netlink attribute for broadcast cutoff")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260413085349.73977-1-phx0fer@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index e9d288a05e39e..35dcaa985cfdc 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1682,6 +1682,7 @@ static size_t macvlan_get_size(const struct net_device *dev)
 		+ macvlan_get_size_mac(vlan) /* IFLA_MACVLAN_MACADDR */
 		+ nla_total_size(4) /* IFLA_MACVLAN_BC_QUEUE_LEN */
 		+ nla_total_size(4) /* IFLA_MACVLAN_BC_QUEUE_LEN_USED */
+		+ nla_total_size(4) /* IFLA_MACVLAN_BC_CUTOFF */
 		);
 }
 
-- 
2.53.0



