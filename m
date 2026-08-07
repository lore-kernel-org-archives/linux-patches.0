Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2FA37F334;
	Fri,  7 Aug 2026 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116712; cv=none; b=ln7jWi3v/hclFUmILd5ET0Uds16jNnCxC7stDwpaVCZWu1ReTXNJG80fayn22g5IcfwasNedFAHenSYEChs5otUgc7LquqsqcQc6TGyxZx2tgPLyDBNZ47iroObPsOGuUmy6tZdV3JEc1X6tPY42Xn5qqmc8qlK30SEnWFJPEjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116712; c=relaxed/simple;
	bh=xP/dubjCIYRtDXyksNy+FF+vTpdDNs2GwoIBQBeUoQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rqd11c50KkZ3GjxUXcX0jd7vupPVzQ3xDysEob2KfTzwdS1o4oDaUBIyTghyD6+j8BxGcwALqsetsEacD+LGTEdTm5Ia7Rj10XYzMyqRz3YVpIVoHX07KSrVqfjlKy18L71Q/L8SOs0MX/vkhXz8TEItG7qvi51K/qFjl4eq/3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0tMKq0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0tMKq0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5BB1F000E9;
	Fri,  7 Aug 2026 15:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116711;
	bh=x6kaz4ewMSbOb8DdpYekAlP92EvMPqsrrPDRGCxlvtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W0tMKq0oNM+wOwObbNHX5fovpQHFbyyc6p4XlHPuSdIj48dmU4XAakpvLEhfSjQlK
	 qfZHPYDq++4NvQBQO70IpYnDDbDhH/Ffr9BPbzUyAs77QtZisUt980Q9rvYCu3EFz4
	 rqmW39bUh5S3XC1rL9dpq64BP2yy4JgA3P4zVC8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 062/438] ipvs: clear the nfct flag under lock
Date: Fri,  7 Aug 2026 16:34:18 +0200
Message-ID: <20260807143429.313384306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit da7d894c41d5910daae2b8ffa024c52ff0a4df6a ]

Sashiko warns that cp->flags should be changed under cp->lock

Fixes: 35dfb013149f ("ipvs: queue delayed work to expire no destination connections if expire_nodest_conn=1")
Fixes: f0a5e4d7a594 ("ipvs: allow connection reuse for unconfirmed conntrack")
Link: https://sashiko.dev/#/patchset/CALMqdkR704S2BG_QD_bgHTFp2%2B1QCi7n0T4zoZyTo8mDZevYSA%40mail.gmail.com
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 7efa209a517b1..6b79e0c4d9e28 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2194,8 +2194,11 @@ ip_vs_in_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *state
 		}
 
 		if (resched) {
-			if (!old_ct)
+			if (!old_ct) {
+				spin_lock_bh(&cp->lock);
 				cp->flags &= ~IP_VS_CONN_F_NFCT;
+				spin_unlock_bh(&cp->lock);
+			}
 			if (!atomic_read(&cp->n_control))
 				ip_vs_conn_expire_now(cp);
 			__ip_vs_conn_put(cp);
@@ -2211,8 +2214,11 @@ ip_vs_in_hook(void *priv, struct sk_buff *skb, const struct nf_hook_state *state
 		if (sysctl_expire_nodest_conn(ipvs)) {
 			bool old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
 
-			if (!old_ct)
+			if (!old_ct) {
+				spin_lock_bh(&cp->lock);
 				cp->flags &= ~IP_VS_CONN_F_NFCT;
+				spin_unlock_bh(&cp->lock);
+			}
 
 			ip_vs_conn_expire_now(cp);
 			__ip_vs_conn_put(cp);
-- 
2.53.0



