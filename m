Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43118225A21;
	Thu, 12 Dec 2024 17:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024888; cv=none; b=dbKWU11xHJtugikSaoMRvLRBbDLMjWsieHkKnnV1pCrXt6+GJpZjLlyPWiWanGH2pcuybc1/UuqJFgfTFdf0p/FAqSIjd6rVb3nOMqtTn19O1WjrcIuTtzDwiLPAOytTcFm1+SB8Q6GcI0NhKPUsitdoJpZs3IrpXFKYHqViIlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024888; c=relaxed/simple;
	bh=jTd/ratYnguyXraGPKe7wNFyW5aAFdYdjcRZo+ip7b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bV31Hp7/xMlt4nWpJZ/fqi85+TaLAmQyy8KTywycLjfce1adSNnJ0GPKYxgpqtwHGPdiVx/3GFHwUt4ImWtAo0l3PwDO9BmuPKyBUAKCpi1rc+SYmS9zup0Smx/Mk1SxxLbnbZXDl7FbjFWw6pFhGjqDqRHJWcle5B4Mf7dz5s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wx3RAszB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wx3RAszB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2C3C4CED3;
	Thu, 12 Dec 2024 17:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024888;
	bh=jTd/ratYnguyXraGPKe7wNFyW5aAFdYdjcRZo+ip7b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wx3RAszBbAmSxXCo+T7tTJeNIqOzvHnbQOC/51mGRmJoj2jStk4vbfeIkGQj6kRt+
	 M7VPfcbikIHD3M9AsmHDh1dR991oyKHXkakMVN7jouBvBTvb75ZVy95TMLt/T0Enmw
	 ObQesgADNkvqNXeXd9gVJc5bSSyPQCx5dcxFJm6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 415/459] net/neighbor: clear error in case strict check is not set
Date: Thu, 12 Dec 2024 16:02:33 +0100
Message-ID: <20241212144310.152751124@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0de6a472c3b38432b2f184bd64eb70d9ea36d107 ]

Commit 51183d233b5a ("net/neighbor: Update neigh_dump_info for strict
data checking") added strict checking. The err variable is not cleared,
so if we find no table to dump we will return the validation error even
if user did not want strict checking.

I think the only way to hit this is to send an buggy request, and ask
for a table which doesn't exist, so there's no point treating this
as a real fix. I only noticed it because a syzbot repro depended on it
to trigger another bug.

Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241115003221.733593-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 432e3a64dc4a5..c187eb951083b 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2739,6 +2739,7 @@ static int neigh_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 	err = neigh_valid_dump_req(nlh, cb->strict_check, &filter, cb->extack);
 	if (err < 0 && cb->strict_check)
 		return err;
+	err = 0;
 
 	s_t = cb->args[0];
 
-- 
2.43.0



