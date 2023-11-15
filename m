Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFE9446B6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftyrDBzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35ACC433C7;
	Wed, 15 Nov 2023 22:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085874;
	bh=Q5f9oFa1WEQV8FV8O/aWnf+pRjwf4x0n07GMaTPm7Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftyrDBzOUD4DozTYv60VuK06V/HxFt1F4yJwmkYeijxJmCY+xH3OuvSUNToSqe6mt
	 ZHwiR2R3JzqNDkk56kmJ4xP2OnJyP9SJQ/MyUFAiFY5zwJD21Py2znbclNLp/ZdiB/
	 73TxGvzG8LXeWA2aRfOc37y9kczEZ5SBDp/jgkRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/119] netfilter: xt_recent: fix (increase) ipv6 literal buffer length
Date: Wed, 15 Nov 2023 17:01:40 -0500
Message-ID: <20231115220136.068515674@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Żenczykowski <zenczykowski@gmail.com>

[ Upstream commit 7b308feb4fd2d1c06919445c65c8fbf8e9fd1781 ]

in6_pton() supports 'low-32-bit dot-decimal representation'
(this is useful with DNS64/NAT64 networks for example):

  # echo +aaaa:bbbb:cccc:dddd:eeee:ffff:1.2.3.4 > /proc/self/net/xt_recent/DEFAULT
  # cat /proc/self/net/xt_recent/DEFAULT
  src=aaaa:bbbb:cccc:dddd:eeee:ffff:0102:0304 ttl: 0 last_seen: 9733848829 oldest_pkt: 1 9733848829

but the provided buffer is too short:

  # echo +aaaa:bbbb:cccc:dddd:eeee:ffff:255.255.255.255 > /proc/self/net/xt_recent/DEFAULT
  -bash: echo: write error: Invalid argument

Fixes: 079aa88fe717 ("netfilter: xt_recent: IPv6 support")
Signed-off-by: Maciej Żenczykowski <zenczykowski@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_recent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 3469b60736103..6fc0deb11aff2 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -561,7 +561,7 @@ recent_mt_proc_write(struct file *file, const char __user *input,
 {
 	struct recent_table *t = PDE_DATA(file_inode(file));
 	struct recent_entry *e;
-	char buf[sizeof("+b335:1d35:1e55:dead:c0de:1715:5afe:c0de")];
+	char buf[sizeof("+b335:1d35:1e55:dead:c0de:1715:255.255.255.255")];
 	const char *c = buf;
 	union nf_inet_addr addr = {};
 	u_int16_t family;
-- 
2.42.0



