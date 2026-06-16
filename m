Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2E746AF14;
	Tue, 16 Jun 2026 16:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627177; cv=none; b=tUj+eXrUMyrAhQGZq4KDZ64zGNPiHF6v/R+qR7MnKxBkxTU/WswryPr7TKdycqTWEZCu70+Vn79FiiGNGS1bly9tvHh34ounWBonHZVtl9W3ebVpA7vQPlBmGLr8s+Zf7lShIwLfFXBKT6Z25H9HMWnzrORieW3le0KiNO6NQcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627177; c=relaxed/simple;
	bh=HNQZm17WUxqAF2DEMg9qeskWPl73jJTWw7cZClDNP1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrJ1udrxDzqaKfI7ip2ZuWyFRT7b47NRkQe38Zak2ec/SLzEjn7Tu1rZjP+R4vjpq+QTe12CtxY3aPP6Ts24kiDLIkataUKxabSlT7NpTq9TG8GvFobT9mr66Tw5bY/AE+Xs4oUMvwyhalXXO1nIWihxDwihZoIeqcRkC6okSiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ip0Xs3hS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ip0Xs3hS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EE51F000E9;
	Tue, 16 Jun 2026 16:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627176;
	bh=9e44sXUogFdfMjGNoefho8kSV6a7ZIhDWQVBFJObtCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ip0Xs3hShX4WLg28gDgmNy8gMkE047OK2n6zfRmgOS685MpYTiv/UZSLb0It7k8tW
	 pR6tIvTiFFDXMLWoourN7H3Dy62OprxgLeITLmaDVCX4VsKui3iuD4ffLRksV6VKTF
	 14SVspwDxNr/2m5V0+KhYBxvfWxk6k8Aj4OjiFTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/261] netfilter: x_tables: avoid leaking percpu counter pointers
Date: Tue, 16 Jun 2026 20:28:57 +0530
Message-ID: <20260616145049.625248449@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
index 97ead883e4a13b..b752c9eac998e4 100644
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
index 3d101613f27fa5..0ba456c4c63416 100644
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
index 7d5602950ae72a..6c5022242cf0b0 100644
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



