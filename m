Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4854A205A;
	Tue, 13 Oct 2026 12:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894330; cv=none; b=mw/ToeXK6ddfreLvTimzdEicQOCZwt2iWko30JBEZ5YjNmTco7USe1i3NepJhTbhqPa53Gkc0UyLUzBjnrzSqQknBSI1mlh/kG6Gny46ULYG2taeiICF+OD6pKEOsa+a0ckLRWTf3+/fBtOKVQxJZfSq8lwmD1DLRTGwX0Q/frQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894330; c=relaxed/simple;
	bh=azTO/tdfwErruAkBLCh3CKTHzhtD/+acL2RXjMt2U/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6owYQSUDfHCgjpM5haE8Koe84l4GavuYFPEFmwo/dTjFow+n6aVpP/V8Nfk2pow4p4qPH1OgfTcmh5xf37FgfE5fxYO3p2m30PA7lyDlGl77Jc2yZtSRhfCdWCWpy3Gx3lLddZo0UICtaxqj2+x0nanml+yNDRwVGGze0YSCV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTzRKtqt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTzRKtqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2701F000FF;
	Tue, 13 Oct 2026 12:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894329;
	bh=mU+JenpCJUtf1HE5VFu6BBIVmvIBfcWegMw9kjyvzt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NTzRKtqtpdTWGZRu6HV3vq6KivPS9PwWIzqy1w6jSi5K5LzlR5pus5sA7khknpVtG
	 SPoyf88W0EvZVh1Dq7jWQ+PjoymN8/f3MuwkJ5VdW6ItvBWebOulC7xYvqN1WlosgX
	 8SLP7lo/TR34kchhXgRce3/ARe48QTdw89TmXs+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuyang Huang <sigefriedhyy@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 522/621] ipv6: mcast: annotate data-races around mca_users
Date: Tue, 13 Oct 2026 13:38:37 +0200
Message-ID: <20261013112933.209232070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Yuyang Huang <sigefriedhyy@gmail.com>

[ Upstream commit 56ed77ff6022271e172f043b44193889226e42b0 ]

/proc/net/igmp6 walks IPv6 multicast memberships under RCU and prints
mca_users without holding idev->mc_lock, while multicast join and leave
paths update the field while holding idev->mc_lock. Annotate this
intentional lockless snapshot with READ_ONCE() and the matching writers
with WRITE_ONCE().

Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260524022456.20689-1-sigefriedhyy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0c8f56c583c3 ("ipv6: mcast: use rcu_assign_pointer() for __rcu list updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index c560f3e3b11fa..6d1653da17c4c 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -890,7 +890,7 @@ static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 
 	mc->mca_addr = *addr;
 	mc->idev = idev; /* reference taken by caller */
-	mc->mca_users = 1;
+	WRITE_ONCE(mc->mca_users, 1);
 	/* mca_stamp should be updated upon changes */
 	mc->mca_cstamp = mc->mca_tstamp = jiffies;
 	refcount_set(&mc->mca_refcnt, 1);
@@ -964,7 +964,7 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 
 	for_each_mc_mclock(idev, mc) {
 		if (ipv6_addr_equal(&mc->mca_addr, addr)) {
-			mc->mca_users++;
+			WRITE_ONCE(mc->mca_users, mc->mca_users + 1);
 			ip6_mc_add_src(idev, &mc->mca_addr, mode, 0, NULL, 0);
 			mutex_unlock(&idev->mc_lock);
 			in6_dev_put(idev);
@@ -1009,7 +1009,10 @@ int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 	     (ma = mc_dereference(*map, idev));
 	     map = &ma->next) {
 		if (ipv6_addr_equal(&ma->mca_addr, addr)) {
-			if (--ma->mca_users == 0) {
+			int new_users = ma->mca_users - 1;
+
+			WRITE_ONCE(ma->mca_users, new_users);
+			if (new_users == 0) {
 				*map = ma->next;
 
 				igmp6_group_dropped(ma);
@@ -3021,7 +3024,7 @@ static int igmp6_mc_seq_show(struct seq_file *seq, void *v)
 		   "%-4d %-15s %pi6 %5d %08X %ld\n",
 		   state->dev->ifindex, state->dev->name,
 		   &im->mca_addr,
-		   im->mca_users, im->mca_flags,
+		   READ_ONCE(im->mca_users), im->mca_flags,
 		   (im->mca_flags & MAF_TIMER_RUNNING) ?
 		   jiffies_to_clock_t(im->mca_work.timer.expires - jiffies) : 0);
 	return 0;
-- 
2.53.0



