Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589A825D918;
	Tue, 25 Mar 2025 12:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906347; cv=none; b=ERnUxlfmBiUat30q6LBcrxlMxnEAnV8HXy+I2PKlhgBF9DzxJd1xTQr6+kWWOEYTk2JW/8hll+4/2YOdb0YPQrXozBl0Hr6J9hSMO24wk+es7ZccVCLzK0vOBeBDq8E66o2hg5rXIYZEK+/UifCj51AumSmveLDLZOjnkNb0Sho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906347; c=relaxed/simple;
	bh=gRKH46RJOomSLNn+OVHxdLIVGWH9wP24Z/V1LfvxNWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAaxaAMANL7iY95gADBExcxYu0PqjCCFrscR8ie5xNVNzNHSUge4jF6vAz8DPzoYB8wA9hbgGpHXy1xeGCbh9E/Q8/XdaS/7AbXK4nN7bd386y4bjm9z6Y2Ps7xE4p/Yj8UbcEC4kve5wAH8B7jRvWasKUWREmU+ZGCgwVs1CNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hQAJtOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hQAJtOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAE3C4CEEF;
	Tue, 25 Mar 2025 12:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906347;
	bh=gRKH46RJOomSLNn+OVHxdLIVGWH9wP24Z/V1LfvxNWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hQAJtOcGKbyUu4ACb2/7MsdRVgC4uGTuyFHmWdnRy0udtw3WmJuIoxV95qlwGC10
	 Ij6W+be6rnW1cSNfqJ2ItWfXeRNnvmirVJ1k6WlPPiNUpmzlRhSRZ8hOl27fKv4Uaj
	 jhTs4BvRPm7+ZWjUtviCVdLbpe4URGIeEKorkUBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/116] ipv6: Set errno after ip_fib_metrics_init() in ip6_route_info_create().
Date: Tue, 25 Mar 2025 08:22:06 -0400
Message-ID: <20250325122150.206772981@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e9a30978abac1..b393c37d24245 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3803,10 +3803,12 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
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



