Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED09D1487CD;
	Thu, 12 Dec 2024 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017004; cv=none; b=XU3ROhE7rRx/7sSw3fbkpuW+bkxw5PSGAljKznYlf39h8q326MKrmhPVQlr687Cd5tPa9uuQSYRBro5V9yvNbaicqpS8D/Lh3hxMP9SaNnflKDvvplz7zPi26q9RmwbImkVtDTV+mbo5K6+CZX2AcQxQ1kgx3mfFrwU7KEsM2/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017004; c=relaxed/simple;
	bh=yw1re266byPeuRLYpPRugrxbz80IF+2G4j7RHzlvkKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgLxWpiPIcwSQDYILifrM/6F3SXofgnjQ0YWxDEofd1roq/e1vYtluA926iubG1iUffbjruxkwzyGBBFJ2k6Suah6QVFt+5B1Ia03W1HeEVr4ugKnuqaacZqInN3xWQilGysqO+u5Q0yDhpVRl7q0Ek6n4VG8FA4JOqKJhgCIco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvLIiqBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvLIiqBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C6FC4CECE;
	Thu, 12 Dec 2024 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017003;
	bh=yw1re266byPeuRLYpPRugrxbz80IF+2G4j7RHzlvkKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NvLIiqBRBpjAdNSpcN3Xxj6KqhtZ3pKRlGFXHHiNkOpIalWhpHx72dgv1ya8G53CM
	 faoWV5x4nPKhz8ZM/4f6ggt3hn2EpVdUP643nu6gUO1e+W7zeRSpmG8OWwpuJxcrSV
	 af52Mqoj1ipH5ed1whQupgqArLd3l5LGAyQiMQ8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubiak <michal.kubiak@intel.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 353/466] netpoll: Use rcu_access_pointer() in __netpoll_setup
Date: Thu, 12 Dec 2024 15:58:42 +0100
Message-ID: <20241212144320.730219512@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit c69c5e10adb903ae2438d4f9c16eccf43d1fcbc1 ]

The ndev->npinfo pointer in __netpoll_setup() is RCU-protected but is being
accessed directly for a NULL check. While no RCU read lock is held in this
context, we should still use proper RCU primitives for consistency and
correctness.

Replace the direct NULL check with rcu_access_pointer(), which is the
appropriate primitive when only checking for NULL without dereferencing
the pointer. This function provides the necessary ordering guarantees
without requiring RCU read-side protection.

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20241118-netpoll_rcu-v1-1-a1888dcb4a02@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index aa49b92e9194b..45fb60bc48039 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -626,7 +626,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 		goto out;
 	}
 
-	if (!ndev->npinfo) {
+	if (!rcu_access_pointer(ndev->npinfo)) {
 		npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
 		if (!npinfo) {
 			err = -ENOMEM;
-- 
2.43.0



