Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFD2318B9D;
	Thu, 28 May 2026 20:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001205; cv=none; b=KIVPkNrgAmCYF99KThCDClpMmDEIm8a/2iHDxvArvjhFX+joOmhcC4kriYKu6sBSQ0QO9ebRzqn/adBTzXTFGtIiVvgodgIkKWVzJAd28xwY1R/X2nILNJSRJ0yn13vWuEaY+nI+Wlzxc9cixB/gbG1QT7CHqeMfNPqY6EMxiTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001205; c=relaxed/simple;
	bh=aXKzdbU8IdvmNb0WBJDItqh0LQIAy8Kf11mGgKY3Kr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyM9IeI1SR39BQipmmXd5quC23eTd/WcIJZ0TEBnGfP4hr8PWdzANMi5E+lDDcBmMNtSQPsSsqYec5oyT9msXPLeRc/lmcc1hg0gXgrPSiknriyODL1KWrQ1Y6DBZHc8J7sb2IQnwAyQfrcGO6YvkegYMnTLuEF8TSiyLjtY+Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfOnP6PS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfOnP6PS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619B31F000E9;
	Thu, 28 May 2026 20:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001203;
	bh=Km9APm/ynSMiqNeUVZGg/q0HcAvnqVjTw8EFy9lX3CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfOnP6PSyiU8askfjUpRxSCiaN2114iSQsMnFbJhxOE5TOsjPn15en1c3xCFPgYI7
	 R2Jb3IcyUPHP7Ls5ID0oMNeXX3dOM/qJ6gNRTTFNoFn3kUwWDDNgDEJgvPAAgVOtDk
	 tJQSp2WRYG7Hm9TIGO0KpBAS891BCAmsFXtyB1I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 044/186] netfilter: ip6t_hbh: reject oversized option lists
Date: Thu, 28 May 2026 21:48:44 +0200
Message-ID: <20260528194930.154938696@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchuan Liang <zcliangcn@gmail.com>

commit 4322dcde6b4173c2d8e8e6118ed290794263bcc8 upstream.

struct ip6t_opts stores at most IP6T_OPTS_OPTSNR option descriptors,
but hbh_mt6_check() does not reject larger optsnr values supplied from
userspace.

Validate optsnr in the rule setup path so only match data that fits the
fixed-size opts array can be installed. This follows the existing xtables
pattern of rejecting invalid user-provided counts in checkentry() and
keeps the packet matching path unchanged.

`struct ip6t_opts` has a fixed `opts[IP6T_OPTS_OPTSNR]` array,
where `IP6T_OPTS_OPTSNR` is 16, then off-by-one array access is possible:

[  137.924693][ T8692] UBSAN: array-index-out-of-bounds in ../net/ipv6/netfilter/ip6t_hbh.c:110:29
[  137.926167][ T8692] index 16 is out of range for type '__u16 [16]'

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/netfilter/ip6t_hbh.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -168,6 +168,10 @@ static int hbh_mt6_check(const struct xt
 		pr_debug("unknown flags %X\n", optsinfo->invflags);
 		return -EINVAL;
 	}
+	if (optsinfo->optsnr > IP6T_OPTS_OPTSNR) {
+		pr_debug("too many supported opts specified\n");
+		return -EINVAL;
+	}
 
 	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
 		pr_debug("Not strict - not implemented");


