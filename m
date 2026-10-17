Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE573C1D78;
	Sat, 17 Oct 2026 17:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259690; cv=none; b=pN1GsDVdjEXz92l8GDnqaG0qerPN2DqOvMphhM/C8jDU7AcKLHypIK3816RP6NyBH7hzmk6Aus2cYB7+PLzcJgqLNggwgcRo3PMo+k36iIO4JcPS9ae3SuEO9H6st9503/PPH5aXf1zXIGlsXCPl9US9T8kbKoyJNNR+/5anu30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259690; c=relaxed/simple;
	bh=gHCSzCMzWq1g/To6TiPz8Fwy70Ynkh7YggVwhCMTbbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNBwMB0xtl/izNCvq28F03EuQ9flg9LeXuZ5J1RJNPXMKdwBx3UjOLv6g8aAanPxsIWGiN2f8qzsmOFWBGS2BExhahhTM599Gw4N9pzOQDysYrpzSGHz7AqRLfhc6BU8FuEcOHy//pf1UgiFTWfshqLlRRSi/v6/bxaxKI6zeU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHFjXvw0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHFjXvw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0881F000C4;
	Sat, 17 Oct 2026 17:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259688;
	bh=/HmCi5F+sp+91CnJxyq4uNB6ZpigmCH1kxHWkTsUyBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bHFjXvw010Y6U9mQ3tduyjf9kgFluUcsRCk8WM75CQc+hITLtnXSBl6k+/f71UfMS
	 ByBJu6ebYFCo5T7fsvHYlH+DnOFb2igU2a0pIVfWbg38N1ZW4HCOwSWSRhweP38jZy
	 FoWJRel2nAba3teOsYRDb7QNE9NtMMprdOe+GT/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1297/1674] ipv6: annotate data-races around devconf->rpl_seg_enabled
Date: Sat, 17 Oct 2026 17:59:29 +0200
Message-ID: <20261017160504.437490871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit 3a5f55500f3e93cf4d62351c753452279b088b4b ]

devconf->rpl_seg_enabled can be changed concurrently from
/proc/sys/net/ipv6/conf, annotate lockless reads on it.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Link: https://patch.msgid.link/20250901123726.1972881-2-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f826df95332c ("ipv6: rpl: fix NULL dereference of idev in ipv6_rpl_srh_rcv()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/exthdrs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index bf319cbe76592..e21093ab20ebf 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -503,10 +503,8 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 
 	idev = __in6_dev_get(skb->dev);
 
-	accept_rpl_seg = net->ipv6.devconf_all->rpl_seg_enabled;
-	if (accept_rpl_seg > idev->cnf.rpl_seg_enabled)
-		accept_rpl_seg = idev->cnf.rpl_seg_enabled;
-
+	accept_rpl_seg = min(READ_ONCE(net->ipv6.devconf_all->rpl_seg_enabled),
+			     READ_ONCE(idev->cnf.rpl_seg_enabled));
 	if (!accept_rpl_seg) {
 		kfree_skb(skb);
 		return -1;
-- 
2.53.0



