Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F415126A0C5;
	Tue,  8 Apr 2025 10:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109859; cv=none; b=SIgBrjjObpgbygkraxDwGhJDUAJLqHJd6Ta8HZv//TqB0Mw2L7SQaB2mA4HYctbjBXOEI8M8pF5+Vb6HvILQrXw1d5JeX8WiVfICSruINBl2Nlk8Hpiwt2Iecw3q5EqjAdv1OCfiuFo5X5C5PkT3nXhTOGs/vuHm9rmV93onRzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109859; c=relaxed/simple;
	bh=IYV7z5Vmly/2OlHVJlf9pHaZom5nTQEgIuuYKjvof+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qw056fwzP2AIFD3iZCOuN/9+3bfg82/wjVe5wflDMzGxOuz+lKyZahs1MwVTiootLNpJ+yh0moPeeEvfTHIcCiXoWjSYy8hOaiIObDAbq15BX1Aeg2qRubJ32j+osbvN3bS1B23OB5UtBcsTmq57/W4tYF0IDRkJYNSSuuECYPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPSH0HpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPSH0HpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0D7C4CEE5;
	Tue,  8 Apr 2025 10:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109858;
	bh=IYV7z5Vmly/2OlHVJlf9pHaZom5nTQEgIuuYKjvof+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPSH0HpBNbej1lwZ3dJBr4/roeHsnJ1+GiTtTsT1o/8MJi2hi+StypXB1VCmOU3uj
	 E9NIjP7nIEqIv/qf3hJxhIiyeFQ5LMteYFI8b+k/KywiNfy9RLi87vEdv1JPk2+xXS
	 3aU6EuzqHQbu40u+2UO3U3+AF7lSWZwLkVY5GBKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/227] ipv6: Set errno after ip_fib_metrics_init() in ip6_route_info_create().
Date: Tue,  8 Apr 2025 12:47:36 +0200
Message-ID: <20250408104822.729163161@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 802386b3937f7..b47f89600c2f8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3697,10 +3697,12 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
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



