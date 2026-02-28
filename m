Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB247346FA0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302262; cv=none; b=NihBHS9Nl8GOSs6+vUJVtJsZwTEzWRjPUnEN0gLDzfvSt2nfvy6W/pqnGlOwlqk+9X54Q+gauSXBsA2guEQwgFQt4m470GyPn+4cUddWp5MXV9I4Yx6rgEgFal7WMFJvkZkw8NlwI/FzRbdEOCSjZ5Za84LVVQ9mY4f6oGb8+dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302262; c=relaxed/simple;
	bh=2QS7hISOM5XPIcj9TRrVTw0lD0WaHbeivSq4RNFF7I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exaBnPFR4zttAzAHkFoKlEL9yyxHsFe7ywLbPk/Bg9gTsXw5I7cHIL5opPd2GibG9b8WO0ELJxYPvq6laC4kqx00CNrwG87bt7ls/nvKOc81N4JaXp4rEzwDWcSPAZbvTF2h9yr1c3G+zwYN+oQ5KnbVfxgB4lAC485xeMGT0is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+WAOJoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+WAOJoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A029C19423;
	Sat, 28 Feb 2026 18:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302262;
	bh=2QS7hISOM5XPIcj9TRrVTw0lD0WaHbeivSq4RNFF7I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+WAOJoHXYamlMvJwN9q0VP3aHOxbpiTXx84owuU0zHT4Lf5tHd9mw1wk8rxhibt2
	 4ez+ufVYT8U6EiW8JMOy2oCgxoyvAPBHD4VtWU3Nq4Y6AJsx7r/5gcwzJkBtuygdgI
	 MyG4EAC4l/APQMZ4sNepH8uplk0rz1e2Za4tp/hYEtEp5RHvNxkQNmdyTFg3/aiQdU
	 57HFsHgow43dfDqXly+GAVg/YXDC/cByaPNqMWpv0isxrhwmQkBErhzd6vYtmGqRyX
	 Ffxm7D065G7Dgix2LAY2IFJFih7JJBVpHH1KRDrC8FLJSL6fwCkQZ9tPScLkec1plT
	 dyx1OZMkeN0ZA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 278/283] net: remove WARN_ON_ONCE when accessing forward path array
Date: Sat, 28 Feb 2026 13:07:00 -0500
Message-ID: <20260228180709.1583486-278-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 008e7a7c293b30bc43e4368dac6ea3808b75a572 ]

Although unlikely, recent support for IPIP tunnels increases chances of
reaching this WARN_ON_ONCE if userspace manages to build a sufficiently
long forward path.

Remove it.

Fixes: ddb94eafab8b ("net: resolve forwarding path from virtual netdevice and HW destination address")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 206194bb8fcad..890535fa52be6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -701,7 +701,7 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 {
 	int k = stack->num_paths++;
 
-	if (WARN_ON_ONCE(k >= NET_DEVICE_PATH_STACK_MAX))
+	if (k >= NET_DEVICE_PATH_STACK_MAX)
 		return NULL;
 
 	return &stack->path[k];
-- 
2.51.0

