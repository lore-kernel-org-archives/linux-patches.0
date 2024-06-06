Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F52619308A;
	Thu,  6 Jun 2024 14:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683306; cv=none; b=jtMFeCgULDfulu9mPwUNA2KZ5L+dcBF5Jq96D3NVc9Qmsard1ijJvkPkW/zyGCtWvzLGvP9TbkBezxjxxWYQDzGjluBckcb8cWdMAbloRhA1gDETahka8T2uzGqOWeQ/GKMJLi+/czwcd3L/u0zgxb42oEd5iIssZLNRPdutNfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683306; c=relaxed/simple;
	bh=n/Q5AhP2de+NbhDpwAWRXK3IUhLCBPN7C94IFf8mVjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivDTbPFaKdUJLIZGXDQuzoxBDcD3ZuaU/6DfNkHcwIIVyYEhig2QERkKUzXaVUp1IgSNW6GEwFLcfFngvQKhn6dvqornfPxVKBz7xbc0LoeQqQW/SSoQTyjKgAj9YBmF1SAqx/qZzwYp5yqeZppNtpIDku8xxV9rnSm9mEyJNLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDX8gozR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDX8gozR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E609C2BD10;
	Thu,  6 Jun 2024 14:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683306;
	bh=n/Q5AhP2de+NbhDpwAWRXK3IUhLCBPN7C94IFf8mVjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDX8gozRYfl45XyS5UuVgJC8unqyS9LRQ094dLffRsNiN7ErcEO6L9XlxtMtkKQKu
	 iEr4hfmJIMraJW7TUKTiaUnwDD90UWVVUVub7oEV0m6goeHpjqwlaJAtkRg9q5AXxi
	 tKgA4Km0Viuwcf0mKhpxGFF4XUCLA2bLR1fgsDK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/744] ipv6: sr: fix incorrect unregister order
Date: Thu,  6 Jun 2024 15:58:39 +0200
Message-ID: <20240606131740.320448142@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 6e370a771d2985107e82d0f6174381c1acb49c20 ]

Commit 5559cea2d5aa ("ipv6: sr: fix possible use-after-free and
null-ptr-deref") changed the register order in seg6_init(). But the
unregister order in seg6_exit() is not updated.

Fixes: 5559cea2d5aa ("ipv6: sr: fix possible use-after-free and null-ptr-deref")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240509131812.1662197-3-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 5423f1f2aa626..c4ef96c8fdaca 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -567,6 +567,6 @@ void seg6_exit(void)
 	seg6_local_exit();
 	seg6_iptunnel_exit();
 #endif
-	unregister_pernet_subsys(&ip6_segments_ops);
 	genl_unregister_family(&seg6_genl_family);
+	unregister_pernet_subsys(&ip6_segments_ops);
 }
-- 
2.43.0



