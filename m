Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B17A646;
	Tue,  3 Dec 2024 15:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239681; cv=none; b=Qf5OY3H33vpaX1ijoHaEqcYOiriCb8CjCgQ3KhSgDITMv2d7HX1lwa1zGI5V9QB95+VqcoT/kbRLZnN3jzBr1EpqYQLp7r4pPqUMyQbpY+NAWYLWDg6m/rfhUHOt2mMKhn3IlstPZi87mNZ3c7aKBTgkFMH7EiyAHEMy/ALY+Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239681; c=relaxed/simple;
	bh=DMVyc2aaorqUuzI56dBPzB7Q2mNN5+vgnD9g9dNfm7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxiWYSvWM+mVDDtlYXXQrLhxG0VedQELqMUh7232AwYogQIv+guhz5d2DfswQH4bUaJl0DXDbOlcZOfEbRbPAqXp/QOlkvSqOvzCYR543HGKifkbiHJ21h+8K0sNRfWlmDYtaq4/6OMXG5Za8928dI4zZSwPAJ/V4H4Z6QcWwQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5WVP7tq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5WVP7tq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7234C4CECF;
	Tue,  3 Dec 2024 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239681;
	bh=DMVyc2aaorqUuzI56dBPzB7Q2mNN5+vgnD9g9dNfm7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5WVP7tqpdvpn6Yw9g0zmgD0uteHMBRu6LIUgg9QjeHyHqZShE0RrKxpzUoerHfxs
	 C/c7qbTijtnDXGiY4fzvv5M64V+V1cXOa7s8nhOeQFUJM48BvFdPp1hCBor78fkf+4
	 dK9h4+1lvAKe/IJ5oK5A1nOEgZQ02H/IuUP2t2w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.11 697/817] netfilter: ipset: add missing range check in bitmap_ip_uadt
Date: Tue,  3 Dec 2024 15:44:29 +0100
Message-ID: <20241203144023.184740369@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


