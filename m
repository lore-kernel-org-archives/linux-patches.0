Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FA53233F8;
	Wed, 17 Sep 2025 12:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113478; cv=none; b=SZCGXI8iTKxLhAVmFZZZ1TTlMECoziItfvkhoCvNae57KLG0rkAFXTlYouGDxUTj4ZAlHW/r4dzC3eSHTQV1womf5/jSeupkXOEtEWPkJjv4hLrHsc8n9ZlXvxcndrJq+hTMWoBP2TUgmaqmds40Yh0aKG9aNLR7dRsTtHtR/vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113478; c=relaxed/simple;
	bh=qBlQYQiEikr8M4F0yrnYVfo4U2rFw3KTjzUPo6eicFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpA/+6XKBAIXAR29p8V2GRHLeL3RoyADuvOfKgVO5OqP9/2E8YUxb5FBH0FjhsB+Smq9aA2P+kINwDubj8HHramx6KzfHqDGgYo+XOuYhBbW4lOAuX7oIAP/LGnlECcKAf+6Q4ygDyAZsvRjcKdWfFYasg6tNmdXFCl60VP45e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESWqhebu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESWqhebu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4079AC4CEF0;
	Wed, 17 Sep 2025 12:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113474;
	bh=qBlQYQiEikr8M4F0yrnYVfo4U2rFw3KTjzUPo6eicFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESWqhebu3CISZWecLvN6XP285360xtV+vK9/P0UaPTh9/WZIfJ2kDSW9MXB2LxuIU
	 jL3PDR8qbhK0Ul92UpB3gfk7Jao8CUyS5dLiJp62kUMq43yyOrbyvMiFrOccX5TbTS
	 KirYPl0HfuZcYINB+LYKaX8iK3gdV+Dp/HcwzhGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/140] genetlink: fix genl_bind() invoking bind() after -EPERM
Date: Wed, 17 Sep 2025 14:34:29 +0200
Message-ID: <20250917123346.674107872@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 1dbfb0363224f6da56f6655d596dc5097308d6f5 ]

Per family bind/unbind callbacks were introduced to allow families
to track multicast group consumer presence, e.g. to start or stop
producing events depending on listeners.

However, in genl_bind() the bind() callback was invoked even if
capability checks failed and ret was set to -EPERM. This means that
callbacks could run on behalf of unauthorized callers while the
syscall still returned failure to user space.

Fix this by only invoking bind() after "if (ret) break;" check
i.e. after permission checks have succeeded.

Fixes: 3de21a8990d3 ("genetlink: Add per family bind/unbind callbacks")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250905135731.3026965-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/genetlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 07ad65774fe29..3327d84518141 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1836,6 +1836,9 @@ static int genl_bind(struct net *net, int group)
 		    !ns_capable(net->user_ns, CAP_SYS_ADMIN))
 			ret = -EPERM;
 
+		if (ret)
+			break;
+
 		if (family->bind)
 			family->bind(i);
 
-- 
2.51.0



