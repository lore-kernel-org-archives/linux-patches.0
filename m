Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81C32FF178;
	Wed, 28 Jan 2026 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615881; cv=none; b=rYCBb7W1Ayk3r5yFLX2LW60dSBM000mBdIfIHpP9itmrbLzd6K05g7ayFNBYZM5HxfeeZW2kBTGS9A+CrQ86Sw6wmAjXv2BaFO+B2QxiI9YaaRPafKTc6ofqVx+QrQkUo86JNluxVUspv1tqgqgBwYxCPD9VaRjWPCLolT+h6Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615881; c=relaxed/simple;
	bh=OvHseY/A9D3AKACAg9LjkQQHln/d7VtcuRYzEb0Bbt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gd66H9yfN4+YV3jyc6hmkv7iSrYD7UOEnzoOtFC40Q7MTG+w7lmMk3OmCg2Ifvw9ebrsYJoM++5OCI9oVksl7uNv3Yg3medbr1dC/LO0WGZwz/zs4ER0pRA+h840LhjqwZHC/QytC6fO/hXbUTy1jjbS9Stv9vZ87quWCsvwhU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/zv2Qf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/zv2Qf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD790C4CEF1;
	Wed, 28 Jan 2026 15:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615881;
	bh=OvHseY/A9D3AKACAg9LjkQQHln/d7VtcuRYzEb0Bbt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/zv2Qf9mNRCW1P3CLr9L+2pL2LdVZ1v9tQLLFIVTOpsicgWFBXJ2ElUuYcMjvrgM
	 b1SvGflHmZIh9eEnaMmdVJLt17NLN8mSmzW5cdPNk+Xp6l5AFK7az/qvkPRZ0F91an
	 JLtomNmDhIPObiOUqg6kXGVgExNh43PB1ay1NHBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Eric Dumazet <edumazet@google.com>,
	Aaron Conole <aconole@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 142/227] net: openvswitch: fix data race in ovs_vport_get_upcall_stats
Date: Wed, 28 Jan 2026 16:23:07 +0100
Message-ID: <20260128145349.569521208@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit cc4816bdb08639e5cd9acb295a02d6f0f09736b4 ]

In ovs_vport_get_upcall_stats(), some statistics protected by
u64_stats_sync, are read and accumulated in ignorance of possible
u64_stats_fetch_retry() events. These statistics are already accumulated
by u64_stats_inc(). Fix this by reading them into temporary variables
first.

Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall packets")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Acked-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20260121072932.2360971-1-mmyangfl@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/vport.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 6bbbc16ab7780..f0ce8ce1dce0e 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -310,22 +310,23 @@ void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
  */
 int ovs_vport_get_upcall_stats(struct vport *vport, struct sk_buff *skb)
 {
+	u64 tx_success = 0, tx_fail = 0;
 	struct nlattr *nla;
 	int i;
 
-	__u64 tx_success = 0;
-	__u64 tx_fail = 0;
-
 	for_each_possible_cpu(i) {
 		const struct vport_upcall_stats_percpu *stats;
+		u64 n_success, n_fail;
 		unsigned int start;
 
 		stats = per_cpu_ptr(vport->upcall_stats, i);
 		do {
 			start = u64_stats_fetch_begin(&stats->syncp);
-			tx_success += u64_stats_read(&stats->n_success);
-			tx_fail += u64_stats_read(&stats->n_fail);
+			n_success = u64_stats_read(&stats->n_success);
+			n_fail = u64_stats_read(&stats->n_fail);
 		} while (u64_stats_fetch_retry(&stats->syncp, start));
+		tx_success += n_success;
+		tx_fail += n_fail;
 	}
 
 	nla = nla_nest_start_noflag(skb, OVS_VPORT_ATTR_UPCALL_STATS);
-- 
2.51.0



