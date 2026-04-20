Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B8E33B975;
	Mon, 20 Apr 2026 16:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701003; cv=none; b=tEjCjPiaUwzYdA/7Bz2w+Ll68lRCakiMpGLcquCyss+pyg3dnRBfF2ZYe6OxV640Rmf18ruHKAycS4KzNQBIp9+bh+diXPnRXM93aJrYZBo6eyuaCsN26O9OX7gXHiHbfwreC1x2BkQpSSQOZagKOSAlA5iKXXuUYKTMd2Z+eMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701003; c=relaxed/simple;
	bh=0zhVQJlm3lbGiqsF1mQWlK2QksWXOi4x6C2exIrMB24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPWoF9EHVhPwHv1bETJxklZFOycWopM1GABRHj7lvY2lsl8dgI6ybegN4fbrb3M+PYap0rGXbTSnzu/Eo3h8LLec6giB0p6S+oDXZgA9hMUfMJVo5OzOBJgemVofSnhuUXHc3lCWJb1BlBEGSC4s+eS//jFnLA4yCXV2Nlfp0pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U90GIFWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U90GIFWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0871C2BCB7;
	Mon, 20 Apr 2026 16:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701003;
	bh=0zhVQJlm3lbGiqsF1mQWlK2QksWXOi4x6C2exIrMB24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U90GIFWyvthqx3VzTocFImO+6Up+cCHhH7lf8NOgNtPaCmVT4dF8wSSR2jzSdefj3
	 gg4q3eMae4QNYgDtuX1l6yBQeQ+yqI0Spwtyw/+WiBhAyBuWHcZy/gvnc0YLA7vfrS
	 FG7t40qj4G9TSSjbhh27uW3/hG1Jfs9LR5CsN7Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/198] devlink: Fix incorrect skb socket family dumping
Date: Mon, 20 Apr 2026 17:41:29 +0200
Message-ID: <20260420153939.565441283@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 0006c6f1091bbeea88b8a88a6548b9fb2f803c74 ]

The devlink_fmsg_dump_skb function was incorrectly using the socket
type (sk->sk_type) instead of the socket family (sk->sk_family)
when filling the "family" field in the fast message dump.

This patch fixes this to properly display the socket family.

Fixes: 3dbfde7f6bc7b8 ("devlink: add devlink_fmsg_dump_skb() function")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260407022730.2393-1-lirongqing@baidu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devlink/health.c b/net/devlink/health.c
index 136a67c36a20d..0798c82096bdc 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -1327,7 +1327,7 @@ void devlink_fmsg_dump_skb(struct devlink_fmsg *fmsg, const struct sk_buff *skb)
 	if (sk) {
 		devlink_fmsg_pair_nest_start(fmsg, "sk");
 		devlink_fmsg_obj_nest_start(fmsg);
-		devlink_fmsg_put(fmsg, "family", sk->sk_type);
+		devlink_fmsg_put(fmsg, "family", sk->sk_family);
 		devlink_fmsg_put(fmsg, "type", sk->sk_type);
 		devlink_fmsg_put(fmsg, "proto", sk->sk_protocol);
 		devlink_fmsg_obj_nest_end(fmsg);
-- 
2.53.0



