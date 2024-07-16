Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6291DDF5;
	Tue, 16 Jul 2024 15:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144549; cv=none; b=cNMmwsAgxJU9o8dPR1LyeaYY0dy9wfxjbYOSlSNYzcwQHXY4O6Avn5jeRZqOMl6CDOQsScys14ZPu3bujo/hF7pT31axwAGzvrZfD94Kl/UDNgcO98odUASb1ogjCAqyk6WQDmYNd4hDVh2jb69CLJ+1hJZ40EilorDczT93Vbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144549; c=relaxed/simple;
	bh=p+zbY3MGbOuQqUBz7N0rnAgskEv0pl3xMokYiZ0vN9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etFrpVgV52L6m4IDct8m81rd9uOkphRqwyqButW3FzJEiYSJqZWGL61zY+cDLn/sxjCN/yZbN8I5Aisw4IWMbf9QYzq5dvcLqXy+7ZVTqbnUutapvjE3PmFt9ZkkI27ixcZM9ZmGJWnGC6lOQ1q/dd4Oq20r1nXguiuSMEDVIq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIt1EFei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIt1EFei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A138BC116B1;
	Tue, 16 Jul 2024 15:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144549;
	bh=p+zbY3MGbOuQqUBz7N0rnAgskEv0pl3xMokYiZ0vN9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIt1EFei+/+OtlF10M9zSENwJdFasigyBS7az/m4tLwsh+ADyCUiRw1dfSoZzWNo0
	 GbRxiMVBkPlYH5+bpaNZ65tuotWmQekf5J5rCwE5iVFnO2y6XpRyO3ZkUWPuwU16yS
	 +sF3S7uNTn1wWTcPdhxl9iNuUl4Ryl6MidGAVRdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/108] tcp_metrics: validate source addr length
Date: Tue, 16 Jul 2024 17:30:43 +0200
Message-ID: <20240716152747.081446159@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 66be40e622e177316ae81717aa30057ba9e61dff ]

I don't see anything checking that TCP_METRICS_ATTR_SADDR_IPV4
is at least 4 bytes long, and the policy doesn't have an entry
for this attribute at all (neither does it for IPv6 but v6 is
manually validated).

Reviewed-by: Eric Dumazet <edumazet@google.com>
Fixes: 3e7013ddf55a ("tcp: metrics: Allow selective get/del of tcp-metrics based on src IP")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index f823a15b973c4..95b5ac082a2f4 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -619,6 +619,7 @@ static const struct nla_policy tcp_metrics_nl_policy[TCP_METRICS_ATTR_MAX + 1] =
 	[TCP_METRICS_ATTR_ADDR_IPV4]	= { .type = NLA_U32, },
 	[TCP_METRICS_ATTR_ADDR_IPV6]	= { .type = NLA_BINARY,
 					    .len = sizeof(struct in6_addr), },
+	[TCP_METRICS_ATTR_SADDR_IPV4]	= { .type = NLA_U32, },
 	/* Following attributes are not received for GET/DEL,
 	 * we keep them for reference
 	 */
-- 
2.43.0



