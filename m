Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29132209F27;
	Thu, 12 Dec 2024 15:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015687; cv=none; b=KCrPTHboNyWYZBaeYcqcJMvAMmvAFiXCxzfc0J0IIPqRUlP3/q81nJ/YPSwG30JKzvQKscMAOzfJ22WENyQ0FfltEz26sE9mCFLTz0+W9roLMwB7GmEz4m5w2Q7WoppG3egYyRoSUIqhsMlG0s/WhtOz+iKmX6zlYtLIcAmkjv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015687; c=relaxed/simple;
	bh=7mue2m8HCSurmgndi7OYQOrYrV61ROyvCIoKa/nODYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6VshnPRz5YE7E7jcTSBL/IVBpUFS91mqaSLymwIc9HCjDBMfe7s446aAKCRA7N3oeZs7cbURgdfr6wUuGcQ5brqeehrzuTcbQkzEd65XeOHIho55RVqDG48MaieR41OkHTfE5MA/nP33w+fSEDEOxCkLUhgmQtb7Qmk8MddIx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SrFm5nW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SrFm5nW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98787C4CED4;
	Thu, 12 Dec 2024 15:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015687;
	bh=7mue2m8HCSurmgndi7OYQOrYrV61ROyvCIoKa/nODYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrFm5nW9r6H7HtXSDrIK4pYN/LQZpFLfeorUeLWyHLwoTdXE7iS+yCFgOpEJLablP
	 2Lx0BrTcVll/2BkUS1VS8j90FG7AwmZdkgzpbUK8bZHK3hOatHw3cJF9aBIKu557+a
	 kll5IvFP5jU6qK9ikHtepq3mACaLy4+379Z4lDC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+57bac0866ddd99fe47c0@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/466] netfilter: nft_socket: remove WARN_ON_ONCE on maximum cgroup level
Date: Thu, 12 Dec 2024 15:53:07 +0100
Message-ID: <20241212144307.407799807@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b7529880cb961d515642ce63f9d7570869bbbdc3 ]

cgroup maximum depth is INT_MAX by default, there is a cgroup toggle to
restrict this maximum depth to a more reasonable value not to harm
performance. Remove unnecessary WARN_ON_ONCE which is reachable from
userspace.

Fixes: 7f3287db6543 ("netfilter: nft_socket: make cgroupsv2 matching work with namespaces")
Reported-by: syzbot+57bac0866ddd99fe47c0@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index f5da0c1775f2e..35d0409b00950 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -68,7 +68,7 @@ static noinline int nft_socket_cgroup_subtree_level(void)
 
 	cgroup_put(cgrp);
 
-	if (WARN_ON_ONCE(level > 255))
+	if (level > 255)
 		return -ERANGE;
 
 	if (WARN_ON_ONCE(level < 0))
-- 
2.43.0



