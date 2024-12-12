Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4736A2210E8;
	Thu, 12 Dec 2024 15:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018445; cv=none; b=K9fCWla87Oywy1ulgoCvRXeJX+WLC4npQ5hUR6ME1rO/+X6eWfIyFA6LCGDoUBo5Re2Xmppztjf1IqNXBrI4Kg9BlQRULHKNQGEQ+zMs6zMHCd+gGYJWU2kQsVk4OSncavnWgqJWn60T17hG9V8qaC6hlRIizwijjdQQp8HDCBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018445; c=relaxed/simple;
	bh=Re/SSBAZfaxoZBmTa0fklRQPLyrkS51pxoLbnD2HsX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Inqzmw8wz+Zv+9PBqtcYwj1cxMsGYsXiR1N8aYmaesE6XZfy7rJNij2PkZV09DA+Yp5Z7R8ehm2UZlEgsOeXTPlzb5by5OOJOKp3NQCp2fmH4DGydooYMFLX4vM4J85t9bx6LpY7LfieqSkQeXOaM4hABFOrvdHhs0mdvL/Qfdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rs+7e7RX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rs+7e7RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5DDC4CED7;
	Thu, 12 Dec 2024 15:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018445;
	bh=Re/SSBAZfaxoZBmTa0fklRQPLyrkS51pxoLbnD2HsX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rs+7e7RX1yFbE4JC76/wcq2Zu7AivlnJGTAnI88Vt7bUsOdh0v0smFWBS1WwxrQtn
	 PfhLKHqg8hpq+M330D+aaoWGFDj1HSywgtzRAa8V0HCMhhHb7p9WwNNg2ZXhM6FGsf
	 r2eYMJq/yLRt2JD9hZFuGLex+Ffzzz1WfU8SC8to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubiak <michal.kubiak@intel.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/356] netpoll: Use rcu_access_pointer() in __netpoll_setup
Date: Thu, 12 Dec 2024 15:59:43 +0100
Message-ID: <20241212144255.024827021@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e082139004093..1791462f1600a 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -633,7 +633,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 		goto out;
 	}
 
-	if (!ndev->npinfo) {
+	if (!rcu_access_pointer(ndev->npinfo)) {
 		npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
 		if (!npinfo) {
 			err = -ENOMEM;
-- 
2.43.0



