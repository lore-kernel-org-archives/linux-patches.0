Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2292646AEE1;
	Tue, 16 Jun 2026 18:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635951; cv=none; b=DW8bDwiH1P+HVaOwq0LgJjTnnmhw9wrhwW6gIlP11TKAhvUDm5BXhaiTdH6Q2j7vKsmfMMD/1aecpa5w0YtDxf0tsL66HOz0enkd2ztq/ZNwP1pKllDU7HFevHmtAfyog42Ol6BCZ1ZCmnYBgya82SkrKeoqr5ezF9Vf1hN2Cdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635951; c=relaxed/simple;
	bh=j5gDrlTAkTss6KbLnyMdoa+7CFQFE41x21lprpBTEQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnXRLPCcLgfv40BmXDiPf9J+HJL9kMbFh2/XVRDDL1WRFK9qNykLJhLqOrGdRFaXwx2F0F1lW4vcxB+mFnKFIyumscjPFPdnYRb6ITFlzadm5WxU0AnluiHWaVYHYzpytVHrzpMEZrCGY6AJ85blRZ1UkA0hPHQTmvStRHBFcNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPv7wyeS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPv7wyeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F591F000E9;
	Tue, 16 Jun 2026 18:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635950;
	bh=vWDEdS/FAFx5NIckqGyP6OeNkcPng5kstZ+PuDsi1ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPv7wyeSSOO/FbUKqdWpgjwap9QAW2eCwDzwTPueEdyO7Y8kjUSExZw2reSI5izpw
	 LjUIocJnOzvYlZ3IJ+Od54epPp1gdm8773KzDg4EQSQXlSxAI0eHcVN3h4G5X/WziB
	 f5X6z3Vizu8h+YbYz4EJO/PLQpmowoHza92oQUgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Shahar <tamirthesis@gmail.com>,
	Amit Klein <aksecurity@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/342] ipv4: restrict IPOPT_SSRR and IPOPT_LSRR options
Date: Tue, 16 Jun 2026 20:27:22 +0530
Message-ID: <20260616145054.978022614@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d3915a1f5a4bc0ac911032903c3c6ab8df9fcc7c ]

This patch restricts setting Loose Source and Record Route (LSRR)
and Strict Source and Record Route (SSRR) IP options to users
with CAP_NET_RAW capability.

This prevents unprivileged applications from forcing packets to route
through attacker-controlled nodes to leak TCP ISN and possibly other
protocol information.

While LSRR and SSRR are commonly filtered in many network environments,
they may still be supported and forwarded along some network paths.

RFC 7126 (Recommendations on Filtering of IPv4 Packets Containing
IPv4 Options) recommend to drop these options in 4.3 and 4.4.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Tamir Shahar <tamirthesis@gmail.com>
Reported-by: Amit Klein <aksecurity@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260602161547.2642155-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_options.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index da1b5038bdfd04..4afdaaab616239 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -543,6 +543,10 @@ int ip_options_get(struct net *net, struct ip_options_rcu **optp,
 		kfree(opt);
 		return -EINVAL;
 	}
+	if (opt->opt.srr && !ns_capable(net->user_ns, CAP_NET_RAW)) {
+		kfree(opt);
+		return -EPERM;
+	}
 	kfree(*optp);
 	*optp = opt;
 	return 0;
-- 
2.53.0



