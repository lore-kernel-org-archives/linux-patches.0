Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3796112C48B;
	Tue, 30 Apr 2024 11:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476124; cv=none; b=iTIJe7Ondu7WzMZybaJe8R8syOm1B3K+hJKUCj5s214il7epWlsgQ/t0igfHLbxDZFDwL3URpNIcKo4+gbG6c9ooXMiHKThifpIAZS3OrPlOq9wcloBnmn8B6KTCTJM8zhw5JHtmG/Y/+A8yXRTTyigoLMf81F5GNx9DviPHRdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476124; c=relaxed/simple;
	bh=dnUWs7/Vo0gU6bTH7asGcZmio8TIYi+zOjNYZ0vKPmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INUTLyVo3VmOFFtPkixO5SD/W+7MYCtdCtPc21QFvhdBe/Mq6WSL7cH7orBKncRwl04Gs7zXYuyplJR3bHGkdbEGIqBhqbSZeCnnh46gOdLG9t3HpVEjUCh6HGE22mllhq+RnFfGiWRP6iPoyXvHgFwYSifGlFbJ1HtxyZkSDGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bX11Tyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bX11Tyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC15C2BBFC;
	Tue, 30 Apr 2024 11:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476123;
	bh=dnUWs7/Vo0gU6bTH7asGcZmio8TIYi+zOjNYZ0vKPmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bX11Tyy7YDd0F9ZTw8LhNwxaRrsisdkB9K2J3PUu790r3kuws1JcJ7wllQfE2uMu
	 A2fVCO/q9pSkeVMIAT1sfz3jYeyFdCh3/C9Jvl4o6YHzGQrq6Y65XHpzKgzVqhioFV
	 2aq8gUYAGFUE0pXAXvlxeqpzos8Pg2ZDVhiD5dd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Eelco Chaudron <echaudro@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/107] net: openvswitch: fix unwanted error log on timeout policy probing
Date: Tue, 30 Apr 2024 12:39:24 +0200
Message-ID: <20240430103044.787872870@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 78448b6888ddc..90c5f53007281 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1687,8 +1687,9 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
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



