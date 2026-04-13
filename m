Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D1130C359;
	Mon, 13 Apr 2026 16:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098161; cv=none; b=oeNnPiYaj0D71/iGOjIGhUCxGhFLU9i93AxOIw7UkAP/ZVz80qrAdEuut7RnMjT6PeRWOMC+NGNr21BLKc4q5WFxBITdb7QJZC6ADvMonUc7rYWKw5ZlAeBThrFso+IbztD1UL9JyUZeSWM3+PVlDkBR36RqihyHp51+g5tQjCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098161; c=relaxed/simple;
	bh=u4WJGrvIMo94GMp/zvF+9NZsvaeRsd10Qa0EnI+GQMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDmJXl1oFW+Ltjnt5SZzEdQpnMwoy5FJJEYV9zstxhrVtKJ0Uo32UDppn7TVs1GehCm23sAMpoMPmM85u0tv39YKCGkls6CcuGU6mfTHLVRnVpmI68O/1LFJbTzveAMognuz6msggSL6oaDYdOF+QDqTbKkggRIaf8m3gdvHEVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMFK01UX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMFK01UX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43CAC2BCAF;
	Mon, 13 Apr 2026 16:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098161;
	bh=u4WJGrvIMo94GMp/zvF+9NZsvaeRsd10Qa0EnI+GQMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMFK01UXg+Y9AtEQINZMOD7Y48QrXIcjILUDaIdLfYxox0qK8ZJYtyKGS9wMb4kaU
	 2jyXTa0zXN9poN6GcgZSLxtTmiYIduYjNp3b3EEhwfoiZ8rV0erCD5p5VMShHrIH2O
	 6y21xKOKJQLEqx/0aCgKccubHrzWhi6/z30eHNWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/570] net: ipv6: flowlabel: defer exclusive option free until RCU teardown
Date: Mon, 13 Apr 2026 17:59:09 +0200
Message-ID: <20260413155846.131867028@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchuan Liang <zcliangcn@gmail.com>

[ Upstream commit 9ca562bb8e66978b53028fa32b1a190708e6a091 ]

`ip6fl_seq_show()` walks the global flowlabel hash under the seq-file
RCU read-side lock and prints `fl->opt->opt_nflen` when an option block
is present.

Exclusive flowlabels currently free `fl->opt` as soon as `fl->users`
drops to zero in `fl_release()`. However, the surrounding
`struct ip6_flowlabel` remains visible in the global hash table until
later garbage collection removes it and `fl_free_rcu()` finally tears it
down.

A concurrent `/proc/net/ip6_flowlabel` reader can therefore race that
early `kfree()` and dereference freed option state, triggering a crash
in `ip6fl_seq_show()`.

Fix this by keeping `fl->opt` alive until `fl_free_rcu()`. That matches
the lifetime already required for the enclosing flowlabel while readers
can still reach it under RCU.

Fixes: d3aedd5ebd4b ("ipv6 flowlabel: Convert hash list to RCU.")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/07351f0ec47bcee289576f39f9354f4a64add6e4.1774855883.git.zcliangcn@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_flowlabel.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index ceb85c67ce395..bb528d0ddb73a 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -133,11 +133,6 @@ static void fl_release(struct ip6_flowlabel *fl)
 		if (time_after(ttd, fl->expires))
 			fl->expires = ttd;
 		ttd = fl->expires;
-		if (fl->opt && fl->share == IPV6_FL_S_EXCL) {
-			struct ipv6_txoptions *opt = fl->opt;
-			fl->opt = NULL;
-			kfree(opt);
-		}
 		if (!timer_pending(&ip6_fl_gc_timer) ||
 		    time_after(ip6_fl_gc_timer.expires, ttd))
 			mod_timer(&ip6_fl_gc_timer, ttd);
-- 
2.53.0



