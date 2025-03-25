Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B018269CE6;
	Tue, 25 Mar 2025 12:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906119; cv=none; b=mbI8mi/rVBGCmHmRe1O+yj5KCxESjOitxhTrFHB/obL2jnyDz8PYYYMUO8ULxRtp0SQcGhSCTRDl7nSrFkHMM0EkdqCdsKHePzk5n/H6DYGTf8g6WRQudbQz0DGshOdjXBft9IoMfKZiinuZ5zz+jTawrPy4L/bLN9x2P9aRo3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906119; c=relaxed/simple;
	bh=VEgZ969WZaHYrCT3uN53jGdsLXK2uL2eQkRsnHbEJkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flGvQRnrMMPwYFo5znRr+iQCefK3w7gP16C4V80yra5oLRqMyFwxGop15aYFJJsqBwHr8SxOiv2zXWsvoKvyrUe7SgF5kpkYOHn+383pSZfEFyaPCYwhhKyqgA4PLHigSs9s/2qwpFbiGAUwZ8mAzholOSRNccCZV+c9akbLLb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dl9xJRBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dl9xJRBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDEAC4CEE9;
	Tue, 25 Mar 2025 12:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906119;
	bh=VEgZ969WZaHYrCT3uN53jGdsLXK2uL2eQkRsnHbEJkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dl9xJRBn+kr/dAxTWU4oc4F3+UbUeQQoTxy5wFtJFXKhYa6zkTi6yfgVoo4V8uy0f
	 qELdY5tvJBJLAsQ6iZr6Vb9y+hSJLszx7ssjjXdVquTo+U9Q8VRD+DvpvNk2FFouc/
	 5QYKmgbdjwnqQCzQA2ZCSyW1d3VKaklosMuNG9Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 24/77] ipv6: Set errno after ip_fib_metrics_init() in ip6_route_info_create().
Date: Tue, 25 Mar 2025 08:22:19 -0400
Message-ID: <20250325122144.986680404@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 9a81fc3480bf5dbe2bf80e278c440770f6ba2692 ]

While creating a new IPv6, we could get a weird -ENOMEM when
RTA_NH_ID is set and either of the conditions below is true:

  1) CONFIG_IPV6_SUBTREES is enabled and rtm_src_len is specified
  2) nexthop_get() fails

e.g.)

  # strace ip -6 route add fe80::dead:beef:dead:beef nhid 1 from ::
  recvmsg(3, {msg_iov=[{iov_base=[...[
    {error=-ENOMEM, msg=[... [...]]},
    [{nla_len=49, nla_type=NLMSGERR_ATTR_MSG}, "Nexthops can not be used with so"...]
  ]], iov_len=32768}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 148

Let's set err explicitly after ip_fib_metrics_init() in
ip6_route_info_create().

Fixes: f88d8ea67fbd ("ipv6: Plumb support for nexthop object in a fib6_info")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250312013854.61125-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f13b2eb904633..3ab5ea55ff8c3 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3797,10 +3797,12 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 	if (nh) {
 		if (rt->fib6_src.plen) {
 			NL_SET_ERR_MSG(extack, "Nexthops can not be used with source routing");
+			err = -EINVAL;
 			goto out_free;
 		}
 		if (!nexthop_get(nh)) {
 			NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
+			err = -ENOENT;
 			goto out_free;
 		}
 		rt->nh = nh;
-- 
2.39.5



