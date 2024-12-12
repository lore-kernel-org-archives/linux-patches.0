Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815BE2144C4;
	Thu, 12 Dec 2024 17:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024339; cv=none; b=jL2/vF+eUqWhu3d0G6y4TF0yNGi3jL/STAmmYfGD7DkmR4Tx1QKqN8HIE2Dmo82DLz1Vjj4DdnpkIiPIV759dGtHbDkA2Rql8xs55ip94V+rmJBxNy0g5NEdJ2JINf/PahHNvt6CjJOee7RJEwZo/u0KEYPrTnmroR5mAHxjvKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024339; c=relaxed/simple;
	bh=2HC5Xax6AdfbIZq7nXgsS2DSQ50ykdjsKgn+466bCFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wp9EVGGqzI9hi2Qq5F2B3tm7TM6y0hUuhFPgKU79Njvzf7gITbKIw13y59aUyoNy61cVz4AIsJAOi0UeBtG2R8z34VtOA2aJaRwsz6yacgngWU1Wm3PLHB2Omkh0qO/YMmbqFeMTqsOFcAHvXev8JC8eLFUw4DLn7gQszYFSjOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2Nu0zrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2Nu0zrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037E2C4CECE;
	Thu, 12 Dec 2024 17:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024339;
	bh=2HC5Xax6AdfbIZq7nXgsS2DSQ50ykdjsKgn+466bCFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2Nu0zrAmJuPfiiILvVK/OX2XqQybh63Fh/glyjEepeng6qXwMdQB3kljpxntlo9A
	 u6alBxK0dQkbHo61uTHPM1RUUFVMxVPuGc4BRtfAQugYQoLQ7vLlc3TeYcD7UM5hXe
	 Ll0K4dSrIT1j7tJXeVYKYgBgg/c+GZtkMRLLGQfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 264/459] netfilter: ipset: add missing range check in bitmap_ip_uadt
Date: Thu, 12 Dec 2024 16:00:02 +0100
Message-ID: <20241212144304.031728478@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit 35f56c554eb1b56b77b3cf197a6b00922d49033d upstream.

When tb[IPSET_ATTR_IP_TO] is not present but tb[IPSET_ATTR_CIDR] exists,
the values of ip and ip_to are slightly swapped. Therefore, the range check
for ip should be done later, but this part is missing and it seems that the
vulnerability occurs.

So we should add missing range checks and remove unnecessary range checks.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
Fixes: 72205fc68bd1 ("netfilter: ipset: bitmap:ip set type support")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -163,11 +163,8 @@ bitmap_ip_uadt(struct ip_set *set, struc
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
 			return ret;
-		if (ip > ip_to) {
+		if (ip > ip_to)
 			swap(ip, ip_to);
-			if (ip < map->first_ip)
-				return -IPSET_ERR_BITMAP_RANGE;
-		}
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
@@ -178,7 +175,7 @@ bitmap_ip_uadt(struct ip_set *set, struc
 		ip_to = ip;
 	}
 
-	if (ip_to > map->last_ip)
+	if (ip < map->first_ip || ip_to > map->last_ip)
 		return -IPSET_ERR_BITMAP_RANGE;
 
 	for (; !before(ip_to, ip); ip += map->hosts) {


