Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD341209695;
	Thu, 12 Dec 2024 17:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025804; cv=none; b=jVu8yaBhxPwmaTIz4FucLma+tKZCaKHTH+6T0jzyBNGjST0DzLI6fWo1Bab1VM2ZZ72sH74ycOo//04FuNE7qmST57A/hffV7g1VtdclHDs7l08FY13Yva+e2FtYDyqwsOO3EErKvrSfI5hvcd60FmlujB+IVEKTq9xyJkjEsVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025804; c=relaxed/simple;
	bh=2EWKsV7sdQNV5OMA8kRdvw/HGA6/lwVCu+6yL+bgkgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCFVZjv8mv20LhPMLrhD/hWsczi67jLDA0U3nk4qunA3ejFuqMFx/DFdr7Kqlfz5k3pVIghpR/trDraF3xyPsahxugiKzJNyUBA2/X7EeZd10ciub0CS3XfiWFwkFtRPhRr3Z4jONmJrbVQlK2MPyVvjTWK8tEPgs/5rRpZkSUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlNVZQrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlNVZQrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30093C4CECE;
	Thu, 12 Dec 2024 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025804;
	bh=2EWKsV7sdQNV5OMA8kRdvw/HGA6/lwVCu+6yL+bgkgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlNVZQrOQ4HxndvDQz9XWO9NSxMsF6UMjk8mfV575E8z/gSfiYe1KYGfrBi2I+LCN
	 19ete2jPbZ4qM3E0p7Laz/kzT34ht1GY8DDI50DHaDeHC1ulLo2G6xJUqlpWWIE1+k
	 uLqc3NESf8QzpJpa00E9nO7CM29F4dMFBQhUgyA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 292/321] net/neighbor: clear error in case strict check is not set
Date: Thu, 12 Dec 2024 16:03:30 +0100
Message-ID: <20241212144241.516774361@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e571007d083cc..4dfe17f1a76aa 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2734,6 +2734,7 @@ static int neigh_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 	err = neigh_valid_dump_req(nlh, cb->strict_check, &filter, cb->extack);
 	if (err < 0 && cb->strict_check)
 		return err;
+	err = 0;
 
 	s_t = cb->args[0];
 
-- 
2.43.0



