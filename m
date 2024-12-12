Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DDF226542;
	Thu, 12 Dec 2024 16:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021290; cv=none; b=BOkHDVR4NpXISWRtWRWVf7rxj4W7Ih5ZBb2DQgAeLYzWA3Z+qzM/t7oQyW1RtpRCvkB8hdNaFHZmwk/aRBunz6GVD+AqqCMKSxJF/BSPGtdkALlhMEOU01HQdUJcNYVS5FxTRfhv1ft+OShTdcYftd06HmA4ZwmRtyGRZBEBPkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021290; c=relaxed/simple;
	bh=8JGmcecF5Hgut53F4LrAuTtqpT2ap+FwRGIyugOTOu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGRS7pVGtrS0hu4sgunwNaYLOfzB3F3R4VosTN0QGxwByMDVPfqwDaHaSAmEFzi9PF/UI2hcGs+rEwn6GnMsVcRm6ZsxPlleO1swNh5c87kQOWbUdtvt2KN6XDApJyucsaaPEoIxO+3J5G2jWTh/RZ3hvk8m44O/gdrL1VeDbi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZXfXIJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZXfXIJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6B7C4CED3;
	Thu, 12 Dec 2024 16:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021290;
	bh=8JGmcecF5Hgut53F4LrAuTtqpT2ap+FwRGIyugOTOu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZXfXIJBhUIJQ6wq8GINxktprOLHit5Ul+fdR7gAYN94Sacj/Xm/2l/wR6ueIz/pX
	 +z+dh520SeIdlXgcYj9p9+oflsgmuqSmW33y4yDIhPLS4IJ0gtOR3zVDCNP8wAmcNr
	 SADP/f6NjqCmMamFQBmxxHVOJxwnxW08lINnTZC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubiak <michal.kubiak@intel.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 698/772] netpoll: Use rcu_access_pointer() in __netpoll_setup
Date: Thu, 12 Dec 2024 16:00:43 +0100
Message-ID: <20241212144418.742540503@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fd2195cfcb4aa..681eeb2b73992 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -636,7 +636,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 		goto out;
 	}
 
-	if (!ndev->npinfo) {
+	if (!rcu_access_pointer(ndev->npinfo)) {
 		npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
 		if (!npinfo) {
 			err = -ENOMEM;
-- 
2.43.0



