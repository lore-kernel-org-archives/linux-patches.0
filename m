Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AF5352FF5;
	Tue, 26 Aug 2025 14:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217787; cv=none; b=lAQM91JqQGQg2LaYjrjcB8WvFZRSXbiHLGLHILg/7yUaw2iiiuYXodrgfx808xSI4V8asxuLCX1NYfpVsW5byUk9d5fVvXwDW3Fpe7NGn9Sy5g+45UteminrakwnTr6Maud+gC/F3v2tIhG6SjTWuaFmxLV9UvYegJ5ch22rUbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217787; c=relaxed/simple;
	bh=9/KAl0iwa/vr8t1SnQEMUKbSE3daiFLJ0nor1ISFzyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WzvRq6y0x/9drTWHRl5J6tpN9BaO1DDNut8S93VsEMp81EuKhbUpsdUvMbX0PgjZ3DWVSsf91T/a3WAT9YRwLBQoVG2pwyvso8bijK5qpiUbYQZfkdHbF/yVQEEZB7k7M428G7+pPqlwbbGfvkk/rjinz90XvPkiIXcI1Nw4EME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iO8uwKa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iO8uwKa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6604AC4CEF1;
	Tue, 26 Aug 2025 14:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217787;
	bh=9/KAl0iwa/vr8t1SnQEMUKbSE3daiFLJ0nor1ISFzyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iO8uwKa0jJQNZ9xzSzaDej0SD8qBbOhiI/2S94sWBxYQFvSi+4KuncObHqZnI7qpm
	 E+7YbhNr7aDOD0w064Y++Mq6oudFnGgV+bjcJnDjeO/DBLRlorW+qqUGKPreoaN9C1
	 fjvZEsReUt6s3lOLgAjslnVdj6hC8fqeSbQVzgyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Maes <oscmaes92@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 267/523] net: ipv4: fix incorrect MTU in broadcast routes
Date: Tue, 26 Aug 2025 13:07:57 +0200
Message-ID: <20250826110931.012345409@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oscar Maes <oscmaes92@gmail.com>

[ Upstream commit 9e30ecf23b1b8f091f7d08b27968dea83aae7908 ]

Currently, __mkroute_output overrules the MTU value configured for
broadcast routes.

This buggy behaviour can be reproduced with:

ip link set dev eth1 mtu 9000
ip route del broadcast 192.168.0.255 dev eth1 proto kernel scope link src 192.168.0.2
ip route add broadcast 192.168.0.255 dev eth1 proto kernel scope link src 192.168.0.2 mtu 1500

The maximum packet size should be 1500, but it is actually 8000:

ping -b 192.168.0.255 -s 8000

Fix __mkroute_output to allow MTU values to be configured for
for broadcast routes (to support a mixed-MTU local-area-network).

Signed-off-by: Oscar Maes <oscmaes92@gmail.com>
Link: https://patch.msgid.link/20250710142714.12986-1-oscmaes92@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 815b6b0089c2..7c4479adbf32 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2465,7 +2465,6 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 	do_cache = true;
 	if (type == RTN_BROADCAST) {
 		flags |= RTCF_BROADCAST | RTCF_LOCAL;
-		fi = NULL;
 	} else if (type == RTN_MULTICAST) {
 		flags |= RTCF_MULTICAST | RTCF_LOCAL;
 		if (!ip_check_mc_rcu(in_dev, fl4->daddr, fl4->saddr,
-- 
2.39.5



