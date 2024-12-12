Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995BB223E89;
	Thu, 12 Dec 2024 17:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024891; cv=none; b=CQl0VdvZ4ZNz+BZaitPwWUfR5hkJi7YhpZUadMX2NBdG7/Xv+8wE+ivBKA8CtytUMKRNaJckpr8SzJH2F/YGq9Zm67TWOzEnVNLvhFN5CP7wTHRY80eOhEUuPaV53CKwn2EFKbBYYhUvZo5QPtIdeknG0ekiFgtTP7aCrAbaYzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024891; c=relaxed/simple;
	bh=5/ljwEZLZhQStnG52WNMYk/v34WztArtowvzl2YOrbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfEa1o0wzTur3szou1lY2bMXLNgN9ZcH1tQ81hni5zztWwQpAGFFUSAClt+xYeombzvzi/r/0jQi1DNuet/4maEgTJ5HjwzO6i/+NqyEibV/s7ASsx36f6erueYMRrYo7pGrGugf90sj3YF6QAAswrtVOI8yjwLi48Qz/O+d8qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMKjLSS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMKjLSS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7F1C4CED0;
	Thu, 12 Dec 2024 17:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024891;
	bh=5/ljwEZLZhQStnG52WNMYk/v34WztArtowvzl2YOrbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMKjLSS1UFX1MMYdI837/E6iBdUYXvOEvDOEvZZk4SRAlPrsgD+DaWSr5hls+xoeb
	 pM9K34YpQLbM15SsQwXN5PSQM5dSb/zeKURa0vgFt+xc0t3D34fi1dfB/Qf8LdxbU0
	 f7yGe4LSewmI4TOBOf8ytNYxMXBHbSsbk1Q965Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubiak <michal.kubiak@intel.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/459] netpoll: Use rcu_access_pointer() in __netpoll_setup
Date: Thu, 12 Dec 2024 16:02:34 +0100
Message-ID: <20241212144310.195783950@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
index f76afab9fd8bd..4475b2174bcc4 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -635,7 +635,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 		goto out;
 	}
 
-	if (!ndev->npinfo) {
+	if (!rcu_access_pointer(ndev->npinfo)) {
 		npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
 		if (!npinfo) {
 			err = -ENOMEM;
-- 
2.43.0



