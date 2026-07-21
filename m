Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E3546C4DA;
	Tue, 21 Jul 2026 18:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658258; cv=none; b=KgVZw1kes2+wYPdsYBscDck2b4Y0BUFhQm9bZvG3k5IjAkTTmB5HRCQtEDPTN0v4XeKFby6JQGd/X+xoIgUkimyqMuKm8cLewei8fH1iV+U/QG6OzRwGdox0MdKqxquFbWMmuNCI7MnG38NjfQcodBRjoejXNRDbQul+xx2kcec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658258; c=relaxed/simple;
	bh=jz/ICGppW078Vdx1mQ8VsbqFVmKR3O//yE7F9+j79Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlqfUPsHbm+x/akYDRZUzEIZU0S1mrMYnKRfHykqtMcocug7htAG8/HRaDAmKLDOfFfqmy2Go2GdXwZYal8UylH6HgxSe63giMtg4EQNoep9iEnnD7CaZdUwei/Twqrie1Ix7zBGsJA0SeB0jyTr9+aGG0qtuDamihM/icS4AiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JokF8hjK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JokF8hjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8C11F000E9;
	Tue, 21 Jul 2026 18:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658256;
	bh=whmIKnyfQx1loWkddlHh6sVw/UJ+1Ehncm6iLCRnc4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JokF8hjKF+qEYicTgKvhyx7wZKW9k+e2xj/yrf3ZbZ7eIYX2z7cfCkFNK25KjIfU3
	 n5klmRU1zs6QOg2KaSP8TTab6ncvmHf5VlcqmIQFkVoBg4eBWOQmEGWNaYF7HlVyH3
	 v4eWJJaqXZKZar79veoUFw65LxPYqneMV+or6oUQ=
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
Subject: [PATCH 6.18 1076/1611] ipv4: igmp: annotate data-races around im->users
Date: Tue, 21 Jul 2026 17:19:52 +0200
Message-ID: <20260721152539.612618216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 894b11b79019a4..980f6fa77a6bbc 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1531,7 +1531,7 @@ static void ____ip_mc_inc_group(struct in_device *in_dev, __be32 addr,
 	}
 
 	if  (im) {
-		im->users++;
+		WRITE_ONCE(im->users, im->users + 1);
 		ip_mc_add_src(in_dev, &addr, mode, 0, NULL, 0);
 		goto out;
 	}
@@ -1540,7 +1540,7 @@ static void ____ip_mc_inc_group(struct in_device *in_dev, __be32 addr,
 	if (!im)
 		goto out;
 
-	im->users = 1;
+	WRITE_ONCE(im->users, 1);
 	im->interface = in_dev;
 	in_dev_hold(in_dev);
 	im->multiaddr = addr;
@@ -1774,7 +1774,10 @@ void __ip_mc_dec_group(struct in_device *in_dev, __be32 addr, gfp_t gfp)
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
@@ -2968,7 +2971,7 @@ static int igmp_mc_seq_show(struct seq_file *seq, void *v)
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



