Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE74A3E9C37;
	Tue, 21 Jul 2026 17:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653863; cv=none; b=uIMLL0+vjXZ+xx55DlyybfieQ8326rqrnQg6asQu8FWJsxYCi7pRjk4HZMf6/DCo1gji5uBE52/2AMwf3D8LCZbMz8frZxIMmS4OZ5F+tbjCnMiRKvOrPIGSNTmRvXLD8aia3Eg8MKYuoLUBzelGq/oKtEt593ZUcH8q1kNS3kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653863; c=relaxed/simple;
	bh=8LBGK55SluSINw08yNfuoesBqHROIq9tUyWfdJLzd54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDkhgSFZwl3Qp8TLUrGcwRitiJpz6ILZ3no8tQu5hRuDOwGf9kaECkEM2+5Xck8oN+GmV3TJuySvT0HtZSm6u+kr/pCXglnZRMaPpFfNFt5n4WxINbHobMWbxN5WIlC2xPWclnKibiwlH5JWWBsFeRfEryYssrQ5WlrFqhj1vDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Noa4DzWO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Noa4DzWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB6F1F000E9;
	Tue, 21 Jul 2026 17:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653861;
	bh=Xm3+xyDFONmcVlIFnmP3WsyqW47DJtq1bclO4ljLPDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Noa4DzWORBwcCxoAgItJPHRgtABsBGvVy+r9ACAeltBcVm5uAG3agK4iTkzUKUSSm
	 CCdDS9fT7IafwC6yimdgZkXLNNyUMgMbhMHoA/0vpcf+Xo1ITtYM0la9uC0K9nufo2
	 7D1KUBrn7+qnOctQbenPOE9Qy/InQuMzRfba5hTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuyang Huang <sigefriedhyy@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1488/2077] ipv4: igmp: annotate data-races around im->users
Date: Tue, 21 Jul 2026 17:19:21 +0200
Message-ID: <20260721152627.893602200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Yuyang Huang <sigefriedhyy@gmail.com>

[ Upstream commit 061c0aa740d5d3847cd600a74c66a165bee1fbe0 ]

/proc/net/igmp walks IPv4 multicast memberships under RCU and
prints im->users without holding RTNL, while multicast join and leave
paths update the field while holding RTNL. Annotate this intentional
lockless snapshot with READ_ONCE() and the matching writers with
WRITE_ONCE().

Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260522093906.39764-1-sigefriedhyy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3546deaa0c30 ("ipv4: igmp: Fix potential memory leaks in igmp_mod_timer() and igmp_stop_timer()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 73e9ebb17afaa1..8ae71dd6f76bd5 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1545,7 +1545,7 @@ static void ____ip_mc_inc_group(struct in_device *in_dev, __be32 addr,
 	}
 
 	if  (im) {
-		im->users++;
+		WRITE_ONCE(im->users, im->users + 1);
 		ip_mc_add_src(in_dev, &addr, mode, 0, NULL, 0);
 		goto out;
 	}
@@ -1554,7 +1554,7 @@ static void ____ip_mc_inc_group(struct in_device *in_dev, __be32 addr,
 	if (!im)
 		goto out;
 
-	im->users = 1;
+	WRITE_ONCE(im->users, 1);
 	im->interface = in_dev;
 	in_dev_hold(in_dev);
 	im->multiaddr = addr;
@@ -1788,7 +1788,10 @@ void __ip_mc_dec_group(struct in_device *in_dev, __be32 addr, gfp_t gfp)
 	     (i = rtnl_dereference(*ip)) != NULL;
 	     ip = &i->next_rcu) {
 		if (i->multiaddr == addr) {
-			if (--i->users == 0) {
+			int new_users = i->users - 1;
+
+			WRITE_ONCE(i->users, new_users);
+			if (new_users == 0) {
 				ip_mc_hash_remove(in_dev, i);
 				*ip = i->next_rcu;
 				in_dev->mc_count--;
@@ -2982,7 +2985,7 @@ static int igmp_mc_seq_show(struct seq_file *seq, void *v)
 		delta = im->timer.expires - jiffies;
 		seq_printf(seq,
 			   "\t\t\t\t%08X %5d %d:%08lX\t\t%d\n",
-			   im->multiaddr, im->users,
+			   im->multiaddr, READ_ONCE(im->users),
 			   im->tm_running,
 			   im->tm_running ? jiffies_delta_to_clock_t(delta) : 0,
 			   im->reporter);
-- 
2.53.0



