Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD6B1BDA95;
	Thu, 30 Jan 2025 14:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246806; cv=none; b=V7J0zbeW2JgTy1QcXS04nZRfygUREK3GDZ6DBWzgcT43fVxdQfYYYh5WYbn+yjHeup/u0FGGaJU3x839jvbUOV5W+sW+C/4+WCi73x2e+vV14aDSSEmhh7Wg7FKhzAbblrVnDztI6UKPEJs/Ar+/aTQnFIlXVKQeBBVgNtH/ZA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246806; c=relaxed/simple;
	bh=U9e6Gv8eQ5qoMH2rsWFA3StL/Uo/p7q6mVuV9yMCkac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVjGhIpcK4+Yo48u8SlIhYB3UL71BdOCcnlAOT3Lt1l8vu1vN7wF1Xmhc5NXp/M8YSzFK8+tpdYA9d3sM2HjSdGJskpQWC3kuBMv5JBcTt47vTrFhDIq2cTOhxezoUfVu0nwNXSoW6L53XOgmaTxY8t75SB7RGQQEtfJiIKCswI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yAIkcBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yAIkcBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7994CC4CED2;
	Thu, 30 Jan 2025 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246805;
	bh=U9e6Gv8eQ5qoMH2rsWFA3StL/Uo/p7q6mVuV9yMCkac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yAIkcBMCclykmPIacqdGTGttvIMkDRrLFWM93MtSSZZmW2ZY5YYQ+dTiX4CbVq8m
	 HJ/KHklxyLvFkMmRhzZFvc061t/SutNMNrxGl/nEsJzgW4km/vBMTCe3Lc0fENFoCK
	 5Md6Ry8z/Lb+OEK6kfa3VGk2FGR9fLYYeIz4mmVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 46/91] sctp: sysctl: rto_min/max: avoid using current->nsproxy
Date: Thu, 30 Jan 2025 15:01:05 +0100
Message-ID: <20250130140135.514659923@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 9fc17b76fc70763780aa78b38fcf4742384044a5 ]

As mentioned in a previous commit of this series, using the 'net'
structure via 'current' is not recommended for different reasons:

- Inconsistency: getting info from the reader's/writer's netns vs only
  from the opener's netns.

- current->nsproxy can be NULL in some cases, resulting in an 'Oops'
  (null-ptr-deref), e.g. when the current task is exiting, as spotted by
  syzbot [1] using acct(2).

The 'net' structure can be obtained from the table->data using
container_of().

Note that table->data could also be used directly, as this is the only
member needed from the 'net' structure, but that would increase the size
of this fix, to use '*data' everywhere 'net->sctp.rto_min/max' is used.

Fixes: 4f3fdf3bc59c ("sctp: add check rto_min and rto_max in sysctl")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/67769ecb.050a0220.3a8527.003f.GAE@google.com [1]
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250108-net-sysctl-current-nsproxy-v1-5-5df34b2083e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sysctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 4513d8d45e55..7777c0096a38 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -372,7 +372,7 @@ static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp,
 				loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.rto_min);
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
 	struct ctl_table tbl;
@@ -401,7 +401,7 @@ static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
 				void __user *buffer, size_t *lenp,
 				loff_t *ppos)
 {
-	struct net *net = current->nsproxy->net_ns;
+	struct net *net = container_of(ctl->data, struct net, sctp.rto_max);
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
 	struct ctl_table tbl;
-- 
2.39.5



