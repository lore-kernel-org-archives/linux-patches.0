Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF87A17E900;
	Wed,  3 Jul 2024 10:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003420; cv=none; b=caohWzSdmZeAfuVlttVPQ8Z/i23LsGZwfE8fiA9FK35LBj08OyYkOKhcqsReEVoqw+4p4/VkPxgErOJUpx4l43EWgaYJfejLNPCXVzP6M2XZArelebUlFfIqS3ImoE4kyo9IqAyTJroZ5qKQrtOHXNdFKJKNdie5y8sGWY+jXcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003420; c=relaxed/simple;
	bh=MKBmYSRje58BM2nxljEYGKMIItkyj+N3SCJ9tpOBbw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3uHJSBCjmyqCkxZXE/rItxYlXYwBGB4K9J/N4yoTerN2CtDgVxzCzi6rqs9//sA7QaYj6mXbpjHgdxYvQdAYWzJGH8Onk0Vy3DH1MwWkl+0yf/EPXa6VHhUTPzmKmv7eD+UvqHwby+Rf7nuGcppeFjtPxFQ2twNXCEmY7WhGKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDYy4gs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDYy4gs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1E9C2BD10;
	Wed,  3 Jul 2024 10:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003420;
	bh=MKBmYSRje58BM2nxljEYGKMIItkyj+N3SCJ9tpOBbw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDYy4gs/+Ppd2lHZo3wa46vd+6cGe8b3qiM6CtQvYi3tbgKNdJpcnOd2Z4oVO8pEw
	 iQvEwhQAOZg7F1gnzLBg7PRqZSDX7w+Fnl1fIkXKs7ApRAHs73w73ULPW9a9ummZXt
	 WRD5h4cpzXJ7isnn3mmZSdwjQDWU/93Gpw6Xpm5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 043/139] net/ipv6: Fix the RT cache flush via sysctl using a previous delay
Date: Wed,  3 Jul 2024 12:39:00 +0200
Message-ID: <20240703102832.064015130@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit 14a20e5b4ad998793c5f43b0330d9e1388446cf3 ]

The net.ipv6.route.flush system parameter takes a value which specifies
a delay used during the flush operation for aging exception routes. The
written value is however not used in the currently requested flush and
instead utilized only in the next one.

A problem is that ipv6_sysctl_rtcache_flush() first reads the old value
of net->ipv6.sysctl.flush_delay into a local delay variable and then
calls proc_dointvec() which actually updates the sysctl based on the
provided input.

Fix the problem by switching the order of the two operations.

Fixes: 4990509f19e8 ("[NETNS][IPV6]: Make sysctls route per namespace.")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240607112828.30285-1-petr.pavlu@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5170,12 +5170,12 @@ int ipv6_sysctl_rtcache_flush(struct ctl
 	if (!write)
 		return -EINVAL;
 
-	net = (struct net *)ctl->extra1;
-	delay = net->ipv6.sysctl.flush_delay;
 	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
 	if (ret)
 		return ret;
 
+	net = (struct net *)ctl->extra1;
+	delay = net->ipv6.sysctl.flush_delay;
 	fib6_run_gc(delay <= 0 ? 0 : (unsigned long)delay, net, delay > 0);
 	return 0;
 }


