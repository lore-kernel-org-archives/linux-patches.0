Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB341C3F34;
	Mon, 10 Mar 2025 18:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630408; cv=none; b=kM91UYFu9qCN3BJ1gajL5XYWOGKt6mCIZ0Rz0E4G7vzyPUtjtwLzyeDiGuipMZFPJP/+o84O/qNJ0GNo5+sE4iYvgZt2HAC7fbICie731wQvqtkjryBYdCLPFX5RTDpjaDwqXGuE4ni8ZYIm+cl4+OyyBm5jgNFXB+Fma839rYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630408; c=relaxed/simple;
	bh=JuihhxxGmv8Ehc4yuD9wtGLztx6+1ZQ169EzZXTKlZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGKyjByNJ1v8YkYDzJ+ie0SMIP/x9tcpqksxQ/bx3sIAmnBDhYLLwiY7Nw+vMAbovGi4CAx1FwUQZFndmV77HxX5/LuMe2hHr26xCAh8mJJlrjWeywWRf0HdlzPm79IC8IRP1/ip0IXPevvnU1fYPz/R+M0Gjiq6pFZWRcXxPxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8542KSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8542KSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2474CC4CEE5;
	Mon, 10 Mar 2025 18:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630407;
	bh=JuihhxxGmv8Ehc4yuD9wtGLztx6+1ZQ169EzZXTKlZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8542KSoQ27yX9weZHKL2rB5z8ij07PWV5lyYoKRm+FVYvEhSJTR3bxWadAd/C266
	 lWIeOAhl1MvKrHC0z3rLu+3kSW6zQF3nwHvfUswdue5RIfXs2HstwAeNFyaAo3+hKk
	 ligPpqjFSELkiMfG9nSSFaJRjuExRSqcN6QziDEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 396/620] ipv4: use RCU protection in inet_select_addr()
Date: Mon, 10 Mar 2025 18:04:02 +0100
Message-ID: <20250310170601.223215257@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 719817cd293e4fa389e1f69c396f3f816ed5aa41 ]

inet_select_addr() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: c4544c724322 ("[NETNS]: Process inet_select_addr inside a namespace.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250205155120.1676781-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index dcbc087fff179..33e87b442b475 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1316,10 +1316,11 @@ __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
 	__be32 addr = 0;
 	unsigned char localnet_scope = RT_SCOPE_HOST;
 	struct in_device *in_dev;
-	struct net *net = dev_net(dev);
+	struct net *net;
 	int master_idx;
 
 	rcu_read_lock();
+	net = dev_net_rcu(dev);
 	in_dev = __in_dev_get_rcu(dev);
 	if (!in_dev)
 		goto no_in_dev;
-- 
2.39.5



