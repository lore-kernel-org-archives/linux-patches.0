Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A30343E9F5;
	Tue, 16 Jun 2026 15:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623503; cv=none; b=BQj9WZPnKKwhSTqbmCpNbMtmYV1uW7ELThetWAxu30Zbcr3kqcmiJ+zNAKUmzPRjs3v/ZHD70Q9RQZ8+OiUDcsK4xq+LW0vzBtIkck8F4hpVcnaRDjYgmx1QhiKgIPXzlGok6JtIrkUrG2AuETDihVlWw1YKg3EFSLxK8SO/OQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623503; c=relaxed/simple;
	bh=FyzYTMN0ViQXz0SBlxENVdogUfRBIfuy1uWbBVKzJ4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvbID9ucAto5NWyoUgmwua/z76zNGwRSzDhsyuhErhuUggAJFQxxdWrMR3rrXUgtAokxwzTo2CBEQDz4wU092xETqQ0TGpKMkGG+iQcPsF3MSfrb0SkAZlreDid6VUmgZ6t07pTSFTxjrXnLOuOuMTMvTG3MUrzom34EyyjNL3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2dcoAoQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2dcoAoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244251F000E9;
	Tue, 16 Jun 2026 15:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623502;
	bh=0+AhksaUa1y/xr5bv/gQtVwhYdX0/xABSm/CrUhvPX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2dcoAoQHExxFdiCroimelGTVqJRaciNpAnNUgWSm4h/ykMmQeZFiz2yqkbjIErtG
	 SfT61j1Y95KHrXeXJHK7V52TMDZvLX/EnXsoLULStfP7st56xUDajFM8rA0Jgy/lID
	 FW3DhsYSWjIRx3FoVqdGe7JASZvzqNm932J26Xbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 143/378] netfilter: x_tables: avoid leaking percpu counter pointers
Date: Tue, 16 Jun 2026 20:26:14 +0530
Message-ID: <20260616145117.796556251@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit f7f2fbb0e893a0238dc464f8d8c0f5609bec584f ]

The native and compat get-entries paths copy the fixed rule entry header
from the kernelized rule blob to userspace before overwriting the entry's
counter fields with a sanitized counter snapshot.

On SMP kernels, entry->counters.pcnt contains the percpu allocation
address used by x_tables rule counters. A caller can provide a userspace
buffer that faults during the initial fixed-header copy after pcnt has
been copied but before the later sanitized counter copy runs. The syscall
then returns -EFAULT while leaving the raw percpu pointer in userspace.

Copy only the fixed entry prefix before counters from the kernelized rule
blob, then copy the sanitized counter snapshot into the counter field.
Apply this ordering to the IPv4, IPv6, and ARP native and compat
get-entries implementations so a fault cannot expose the internal percpu
counter pointer.

Fixes: 71ae0dff02d7 ("netfilter: xtables: use percpu rule counters")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/arp_tables.c | 15 ++++++---------
 net/ipv4/netfilter/ip_tables.c  | 15 ++++++---------
 net/ipv6/netfilter/ip6_tables.c | 15 ++++++---------
 3 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index ad2259678c7854..0ea513bf77fb6a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -702,14 +702,12 @@ static int copy_entries_to_user(unsigned int total_size,
 		const struct xt_entry_target *t;
 
 		e = loc_cpu_entry + off;
-		if (copy_to_user(userptr + off, e, sizeof(*e))) {
-			ret = -EFAULT;
-			goto free_counters;
-		}
-		if (copy_to_user(userptr + off
+		if (copy_to_user(userptr + off, e,
+				 offsetof(struct arpt_entry, counters)) ||
+		    copy_to_user(userptr + off
 				 + offsetof(struct arpt_entry, counters),
 				 &counters[num],
-				 sizeof(counters[num])) != 0) {
+				 sizeof(counters[num]))) {
 			ret = -EFAULT;
 			goto free_counters;
 		}
@@ -1327,9 +1325,8 @@ static int compat_copy_entry_to_user(struct arpt_entry *e, void __user **dstptr,
 
 	origsize = *size;
 	ce = *dstptr;
-	if (copy_to_user(ce, e, sizeof(struct arpt_entry)) != 0 ||
-	    copy_to_user(&ce->counters, &counters[i],
-	    sizeof(counters[i])) != 0)
+	if (copy_to_user(ce, e, offsetof(struct compat_arpt_entry, counters)) ||
+	    copy_to_user(&ce->counters, &counters[i], sizeof(counters[i])))
 		return -EFAULT;
 
 	*dstptr += sizeof(struct compat_arpt_entry);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 5cbdb0815857f4..ca8ff0ae6cdb9f 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -832,14 +832,12 @@ copy_entries_to_user(unsigned int total_size,
 		const struct xt_entry_target *t;
 
 		e = loc_cpu_entry + off;
-		if (copy_to_user(userptr + off, e, sizeof(*e))) {
-			ret = -EFAULT;
-			goto free_counters;
-		}
-		if (copy_to_user(userptr + off
+		if (copy_to_user(userptr + off, e,
+				 offsetof(struct ipt_entry, counters)) ||
+		    copy_to_user(userptr + off
 				 + offsetof(struct ipt_entry, counters),
 				 &counters[num],
-				 sizeof(counters[num])) != 0) {
+				 sizeof(counters[num]))) {
 			ret = -EFAULT;
 			goto free_counters;
 		}
@@ -1228,9 +1226,8 @@ compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 
 	origsize = *size;
 	ce = *dstptr;
-	if (copy_to_user(ce, e, sizeof(struct ipt_entry)) != 0 ||
-	    copy_to_user(&ce->counters, &counters[i],
-	    sizeof(counters[i])) != 0)
+	if (copy_to_user(ce, e, offsetof(struct compat_ipt_entry, counters)) ||
+	    copy_to_user(&ce->counters, &counters[i], sizeof(counters[i])))
 		return -EFAULT;
 
 	*dstptr += sizeof(struct compat_ipt_entry);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 9d9c3763f2f5e9..e34d5ba1460ca7 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -848,14 +848,12 @@ copy_entries_to_user(unsigned int total_size,
 		const struct xt_entry_target *t;
 
 		e = loc_cpu_entry + off;
-		if (copy_to_user(userptr + off, e, sizeof(*e))) {
-			ret = -EFAULT;
-			goto free_counters;
-		}
-		if (copy_to_user(userptr + off
+		if (copy_to_user(userptr + off, e,
+				 offsetof(struct ip6t_entry, counters)) ||
+		    copy_to_user(userptr + off
 				 + offsetof(struct ip6t_entry, counters),
 				 &counters[num],
-				 sizeof(counters[num])) != 0) {
+				 sizeof(counters[num]))) {
 			ret = -EFAULT;
 			goto free_counters;
 		}
@@ -1244,9 +1242,8 @@ compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
 
 	origsize = *size;
 	ce = *dstptr;
-	if (copy_to_user(ce, e, sizeof(struct ip6t_entry)) != 0 ||
-	    copy_to_user(&ce->counters, &counters[i],
-	    sizeof(counters[i])) != 0)
+	if (copy_to_user(ce, e, offsetof(struct compat_ip6t_entry, counters)) ||
+	    copy_to_user(&ce->counters, &counters[i], sizeof(counters[i])))
 		return -EFAULT;
 
 	*dstptr += sizeof(struct compat_ip6t_entry);
-- 
2.53.0



