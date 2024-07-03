Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B718717E900;
	Wed,  3 Jul 2024 10:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003417; cv=none; b=MSnJ2Mhpq7DdWACAI3Njaw9YXASWQZTAvPP3O34Zvvw21f7w6eNyP+LOpt3eLmt39hAfR11M3qZNWqp6K+nvK+/UjGHhFQ7SZxKRAx7MC7dCDDFvSlgWuH67upQLvthxkYypxPczTvgw/imveH6n4fLlliNOsXSA+EJPTnkjkic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003417; c=relaxed/simple;
	bh=rljJlgN5IuEie2NTbNyDFELSarIqqi4kFdXGECQsQpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lONBtTLddyvkC252UikkJue7IPH9L1V27wVHk70GFrf4XFIHv1cfq9mgD8ejNQR6gRuQt+VC/eey93A1lVlAt4lBa1gdYUN9sq6XeSZ6cJFwAVk4fFGCEMQAzMmhwNWImKZi/Sg/KnrwHrsNLZJltSZGlMUJ5QXCCeABVZWWmBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4SGSPCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4SGSPCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C4DC2BD10;
	Wed,  3 Jul 2024 10:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003417;
	bh=rljJlgN5IuEie2NTbNyDFELSarIqqi4kFdXGECQsQpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4SGSPComUwBRP4VhVU4zg1OFeumBl5+qFQpidCOhdW8fERn3pyizKI2E8WPX0iQa
	 HobmKJZeKPIf1B83dYtIvbnhKVeJ7zMpmYOS9JTk3YXGQrCrqtrIzDwqFHJhPRMalf
	 PjsGOSZz4pA/iSx28M5GHDqD9Pn6lSPgtFjjmE34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Pakki <pakki001@umn.edu>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/139] ipv6/route: Add a missing check on proc_dointvec
Date: Wed,  3 Jul 2024 12:38:59 +0200
Message-ID: <20240703102832.027031602@linuxfoundation.org>
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

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit f0fb9b288d0a7e9cc324ae362e2dfd2cc2217ded ]

While flushing the cache via  ipv6_sysctl_rtcache_flush(), the call
to proc_dointvec() may fail. The fix adds a check that returns the
error, on failure.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 14a20e5b4ad9 ("net/ipv6: Fix the RT cache flush via sysctl using a previous delay")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index db349679b1127..50bf2ffe1f2a5 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5166,12 +5166,16 @@ int ipv6_sysctl_rtcache_flush(struct ctl_table *ctl, int write,
 {
 	struct net *net;
 	int delay;
+	int ret;
 	if (!write)
 		return -EINVAL;
 
 	net = (struct net *)ctl->extra1;
 	delay = net->ipv6.sysctl.flush_delay;
-	proc_dointvec(ctl, write, buffer, lenp, ppos);
+	ret = proc_dointvec(ctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
+
 	fib6_run_gc(delay <= 0 ? 0 : (unsigned long)delay, net, delay > 0);
 	return 0;
 }
-- 
2.43.0



