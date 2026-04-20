Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15B32E11C7;
	Mon, 20 Apr 2026 15:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700325; cv=none; b=b8+iMSkb3jmgo5bZJSt7FanAQ4ifMuxefPTM025s/5+vLRlfEXbyN04gt4Ciss720q6Er9ub/oC7BU85B3tdMFO/nzluAvHZwSk9D/MlE0NokVbjqRl+ItsDBlWtl1/dCplm1gMS8Cfb/rskw5wfQWLaSebhDi9QjJbMt51lyNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700325; c=relaxed/simple;
	bh=5ZFgjN8d2AVUj51nP+mZhoxPV0gslhEmmXw9S93kVqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByRpjWRw+YAe/s2mPhnb4KlKXudI2kkP/NhSZ1o6oUVIZMSjVX6LcYvf+j1GYWrRvGuMAROdpcij4fkz/VKuLufCb370uRJHO8JwjJgSfoilUlpjUKMSusgowPQ6xPyyeOCNNMfvYVkO2Dc/8vnWbzgNKhJOn7nXdCqtRD9X1mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgLOIhsB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgLOIhsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE00C19425;
	Mon, 20 Apr 2026 15:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700325;
	bh=5ZFgjN8d2AVUj51nP+mZhoxPV0gslhEmmXw9S93kVqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgLOIhsBwUg8Q/uPpgBrowNzibNjU4qWWEzSMD+G0M7mpZ95IVBcgSXXaIQUJkBKG
	 yy+gthwcj+sYVELWGlHXdAzmYLY5ZAgXTeHCVwTx5GJKDOANBpqlFcATsIa+MccmcM
	 BuaCg4fEALMo54duXj6ZKkYK7BTp7Qvt2ZSk83S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 128/220] devlink: Fix incorrect skb socket family dumping
Date: Mon, 20 Apr 2026 17:41:09 +0200
Message-ID: <20260420153938.636816976@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



