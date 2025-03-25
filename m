Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC8B25A2C0;
	Tue, 25 Mar 2025 12:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905787; cv=none; b=O6kYYwQ3jgPaY+MYFE6gtvnSH1n0KYAq1AAEoeG1NdzfXEvCcJL/Gm5g3aWkdqUUqWuSduUJgNlGCApRiUd6K88l84xBsbqj9R8I9ZQzUZQKaOATiRyfzdQ75XRHqQSE1xx5R1d+F50Q5gxpAkHRt7KO9NR7hS+z+YAjVCkKc/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905787; c=relaxed/simple;
	bh=PXknEKuyUXcLay/DZsg1ZW4QRYJE+tjQR3TQ2MwP+LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8cdVHbwhYoSCo6eCZpVqqJ8yeSTOuwwo6ml9BMnLkSyXPBGb5M5dqbR63AwTt9oLSHTuY+XOdS/3mJqIF95h4tQ+2kWhXLwoZ09y+iiAgOcynhohMZRGnHWvfLMWE2NGoG1FhBZdlmKVo92I+DinXAwT+BoutwkarNaQP79AQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tP88GOoW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tP88GOoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CEAC4CEE4;
	Tue, 25 Mar 2025 12:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905787;
	bh=PXknEKuyUXcLay/DZsg1ZW4QRYJE+tjQR3TQ2MwP+LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tP88GOoWlRGDx4eJmYyr58YEPOQwlSJOhw1VIYpuz9n6r4kFsJ/8nlLU01FgNpsdi
	 FtIDDEuYKhpsuIGYrjEu1/BkYi415OyVvXnolIINFPDQAq7UDkPmbWeWsAV8INd0VZ
	 45gshAcuTlHkNQFFdMBSD/h0VswUjJjqEhteoEKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/198] ipv6: Set errno after ip_fib_metrics_init() in ip6_route_info_create().
Date: Tue, 25 Mar 2025 08:22:05 -0400
Message-ID: <20250325122200.930171343@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c72b4117fc757..5cf6e824c0dff 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3798,10 +3798,12 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
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



