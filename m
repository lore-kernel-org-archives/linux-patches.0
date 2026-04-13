Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5661D280CFB;
	Mon, 13 Apr 2026 16:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098401; cv=none; b=CRFsbAWWlXQSFA325XowjQpTyp7tU4zOdMhcE7L3JJ1sZvy/aEqwseXJ/Q3vMCm43A87yrGsHH8fbT/+vlqWv/cLICUAqiJYPurCpy25asI+D3fboUhXlYWlFoelNQsbUQ77gwnlxetPChfd529UTzcUSLTJ36+FA0a8XjgrSXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098401; c=relaxed/simple;
	bh=K93ZGlO0rUn7OaOFel7iC0Nc63Ag+s25HuOv2YRsViE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mejZlbehMUsEPdiAe95/l1IAqCCpD8OL9yHtONhhx6i3ZYU/fcdVSn1oKXviHSzj6terzhSQIN9UQws8MJOvvt2tTBN8wxJEAnH9ZSVotKZRAiSn5ytcqkD2450k/JVgCD2U29BcyszChNNOmKmDDs+mXoIDDApgMeCz3vTNXz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypOU2hof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypOU2hof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FD1C2BCAF;
	Mon, 13 Apr 2026 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098401;
	bh=K93ZGlO0rUn7OaOFel7iC0Nc63Ag+s25HuOv2YRsViE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypOU2hofNqFgimrh7nqrIsdCx+lmpsn+h1JY1IlEakvLNU/TskJu0c4dWtQiWXkqe
	 PkS0kYyXhuc1VKDuuG1yAYzg6Kh0MR90BER/5LGTcUbp51Au3WPZLruL9BzYpjnQ+1
	 FBiV3Iqhr2yDwL+30yVTMUZhKSYwzbKMEodT+CW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Ao Zhou <n05ec@lzu.edu.cn>,
	Yuan Tan <tanyuan98@outlook.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 478/570] bridge: br_nd_send: validate ND option lengths
Date: Mon, 13 Apr 2026 18:00:09 +0200
Message-ID: <20260413155848.367971664@linuxfoundation.org>
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

From: Yang Yang <n05ec@lzu.edu.cn>

commit 850837965af15707fd3142c1cf3c5bfaf022299b upstream.

br_nd_send() walks ND options according to option-provided lengths.
A malformed option can make the parser advance beyond the computed
option span or use a too-short source LLADDR option payload.

Validate option lengths against the remaining NS option area before
advancing, and only read source LLADDR when the option is large enough
for an Ethernet address.

Fixes: ed842faeb2bd ("bridge: suppress nd pkts on BR_NEIGH_SUPPRESS ports")
Cc: stable@vger.kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Tested-by: Ao Zhou <n05ec@lzu.edu.cn>
Co-developed-by: Yuan Tan <tanyuan98@outlook.com>
Signed-off-by: Yuan Tan <tanyuan98@outlook.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yang Yang <n05ec@lzu.edu.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260326034441.2037420-3-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_arp_nd_proxy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -285,12 +285,14 @@ static void br_nd_send(struct net_bridge
 	ns_olen = request->len - (skb_network_offset(request) +
 				  sizeof(struct ipv6hdr)) - sizeof(*ns);
 	for (i = 0; i < ns_olen - 1; i += (ns->opt[i + 1] << 3)) {
-		if (!ns->opt[i + 1]) {
+		if (!ns->opt[i + 1] || i + (ns->opt[i + 1] << 3) > ns_olen) {
 			kfree_skb(reply);
 			return;
 		}
 		if (ns->opt[i] == ND_OPT_SOURCE_LL_ADDR) {
-			daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
+			if ((ns->opt[i + 1] << 3) >=
+			    sizeof(struct nd_opt_hdr) + ETH_ALEN)
+				daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
 			break;
 		}
 	}


