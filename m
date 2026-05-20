Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E267E347515;
	Wed, 20 May 2026 18:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301148; cv=none; b=nG3dmFhH+/bzzqW5qEwoxA4bX25JLVnnYLcuXGi3ZVfpI9G2LJbmq8HRAmoPUcxMqOaDMe4+HdRPxIT/5XdbXBiqgz7OW0PDgti9DnJKzBbvZOPt1wIFojUfq1HMuR6nEl/tGx61PFpMKcg/5Vdt69mUQeZc6z70n3lagMXKru0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301148; c=relaxed/simple;
	bh=w/d3Le4xsE9S9jJyOnxcYWFRHgVH14aSJu8Q2FvhkAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xob2IIP6Hxxhv6CkgsaLrA90Cr6TzN5VB1Xk6kLF4FvHkx/YBhQdLDyM/9wjJEiS78s/AnO5fbqzWq/jQQqMrrehwvJO3je0imxU2A92OyLSfjXYnk+ox+UXfFpcAI09XpLNfazXBv6b2q/mPhMUWluwVAwHraOI/sW15//sEP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hG5jT7oZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hG5jT7oZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023FE1F000E9;
	Wed, 20 May 2026 18:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301146;
	bh=8JYREuzL1OuzzIo+vSAyaWr+OyXXEH3Pt4kOC3guJ90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hG5jT7oZKmfQTW7C/CtoPV7uyHVeCVXoxkpSNzO8VUB42KMpanJiDJub/+zO64kU7
	 jndtGnapQekb1/Tg90h62e6Jc90AT1EOVFjiaRVnugM1jSMrAtZnO4llaX3JpLm6Dr
	 R1vtE0/5bWpSWY23zmUHV+pfra+2kmbzaVoZVGXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 445/666] macvlan: fix macvlan_get_size() not reserving space for IFLA_MACVLAN_BC_CUTOFF
Date: Wed, 20 May 2026 18:20:56 +0200
Message-ID: <20260520162120.915519891@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index b43a1221a5908..e778367c1d296 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1678,6 +1678,7 @@ static size_t macvlan_get_size(const struct net_device *dev)
 		+ macvlan_get_size_mac(vlan) /* IFLA_MACVLAN_MACADDR */
 		+ nla_total_size(4) /* IFLA_MACVLAN_BC_QUEUE_LEN */
 		+ nla_total_size(4) /* IFLA_MACVLAN_BC_QUEUE_LEN_USED */
+		+ nla_total_size(4) /* IFLA_MACVLAN_BC_CUTOFF */
 		);
 }
 
-- 
2.53.0



