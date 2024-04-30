Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A3C7464;
	Tue, 30 Apr 2024 11:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474808; cv=none; b=mB2kk0Bdu7/eC+OHwgAaMEch/OG2LOyWzJEgvSbeOa0o3INT9krcurj7xJmRHYDRapwkj8rbsj5tzaCizDzvi3afjH1ouTQQhrtINShLae/qYzL23+TaNeqyrygr5TkgM58k25XjLoh6JQsFty7XAqWMa+V+afKE57LraBGkHk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474808; c=relaxed/simple;
	bh=II+N1u6SlLiy14KXyVGv+yZJwc2L2ZP71EDQzQ8tgZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZQ7dpfOO0gXoCiF/VKV9XTM5SIJAUi6qwXS9GpLjsvZo7U9yffyZEg8K4uDkOFAc3zR/vyQZ4I0U2o5fCztp9U39Wz7FcBJpu8Q83ThkyOEQpW4OtdeKIouT8abA+DSdGNAwVYzOgoNvio/p3+ye+DdUVQb2wKmVWcazZG3Ljs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaV3Rf6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaV3Rf6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B3DC2BBFC;
	Tue, 30 Apr 2024 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474808;
	bh=II+N1u6SlLiy14KXyVGv+yZJwc2L2ZP71EDQzQ8tgZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaV3Rf6BXdaiF+Q8/7b+DOBx+ZoTZmxjCJxsEWbzpCb9fIJWVFDqmkUTbb3Fv7WQy
	 wonIhZieGZO5oRKTl5W4U6fTgyWxQJm82nYfTwZqgqtaDDYIor35pKTJRl/4QuBPbH
	 fNACIY5su8fkNylcXmcA9885Eq9V/aRhWU5QUdMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Eelco Chaudron <echaudro@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/138] net: openvswitch: fix unwanted error log on timeout policy probing
Date: Tue, 30 Apr 2024 12:38:10 +0200
Message-ID: <20240430103049.583910862@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 4539f91f2a801c0c028c252bffae56030cfb2cae ]

On startup, ovs-vswitchd probes different datapath features including
support for timeout policies.  While probing, it tries to execute
certain operations with OVS_PACKET_ATTR_PROBE or OVS_FLOW_ATTR_PROBE
attributes set.  These attributes tell the openvswitch module to not
log any errors when they occur as it is expected that some of the
probes will fail.

For some reason, setting the timeout policy ignores the PROBE attribute
and logs a failure anyway.  This is causing the following kernel log
on each re-start of ovs-vswitchd:

  kernel: Failed to associated timeout policy `ovs_test_tp'

Fix that by using the same logging macro that all other messages are
using.  The message will still be printed at info level when needed
and will be rate limited, but with a net rate limiter instead of
generic printk one.

The nf_ct_set_timeout() itself will still print some info messages,
but at least this change makes logging in openvswitch module more
consistent.

Fixes: 06bd2bdf19d2 ("openvswitch: Add timeout support to ct action")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://lore.kernel.org/r/20240403203803.2137962-1-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 0f0f380e81a40..d452a63d2f4b0 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1692,8 +1692,9 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 	if (ct_info.timeout[0]) {
 		if (nf_ct_set_timeout(net, ct_info.ct, family, key->ip.proto,
 				      ct_info.timeout))
-			pr_info_ratelimited("Failed to associated timeout "
-					    "policy `%s'\n", ct_info.timeout);
+			OVS_NLERR(log,
+				  "Failed to associated timeout policy '%s'",
+				  ct_info.timeout);
 		else
 			ct_info.nf_ct_timeout = rcu_dereference(
 				nf_ct_timeout_find(ct_info.ct)->timeout);
-- 
2.43.0



