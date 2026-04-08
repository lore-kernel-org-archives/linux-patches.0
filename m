Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9183D8912;
	Wed,  8 Apr 2026 18:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674387; cv=none; b=rENlDs/q3b9QSbl6wCtydSO7o6NCENLDkbP/8he71EgcFscMF4r07GUvmrsnXbGEu0iezgvnYoko8Uy3VnCugcZwyftGzFlUlXNhIJ3sNiZv7tSxCFP4xaHd4yuT84hE5PUeBeQR937SA697/2Mg+mBEXqGFc7so6NYyLYLA3Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674387; c=relaxed/simple;
	bh=tlgqDEt8imPottXEcB8+9nseD1BAkXsJTG27xV7KpUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLdCANgMxHlwiW0nGAHWJ2FhLwdWXXNsquzGX+edIKvWs3a/JjwqN47jY63ISYpy5RNtvn1J3u5NmRzCjvIALbob4xHVmGnI0TTTfbnFoqqcebguGwJp8kUI10PDm6woMVevGuqtVxWE67dmzhe6N79Ow3u4U3AAFSliSap+lP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E03H8ZQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E03H8ZQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819FEC19421;
	Wed,  8 Apr 2026 18:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674386;
	bh=tlgqDEt8imPottXEcB8+9nseD1BAkXsJTG27xV7KpUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E03H8ZQxOejeA/I03EuCBovHIFSZfLC1s+TzuxboZATMpkdDvB18oz38VHIssTXV8
	 9w0SmzBqfBUw2Q412fHfZxjXs7wum4ziubW5RhOOu7TfV0/UpOTH8m+MIzUofdKqJI
	 nyWK46kFlxnLmFtJmUH4AjmuJp1FcjYTxFxNizys=
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
Subject: [PATCH 6.19 078/311] net: ipv6: flowlabel: defer exclusive option free until RCU teardown
Date: Wed,  8 Apr 2026 20:01:18 +0200
Message-ID: <20260408175942.327016329@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 60d0be47a9f31..8aa29b3d3daca 100644
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



