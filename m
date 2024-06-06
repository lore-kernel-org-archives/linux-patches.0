Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BED196C77;
	Thu,  6 Jun 2024 14:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683314; cv=none; b=rngdxyFGL7lYsByD0vwUyajtWOXvTf5jlLZFJ0RiXNJrEH+D3LEIjkT3Xk/r8yzjoM+JGu8mNnwAzmBtTTnbiBitShFx/UjGchjvA/l7z6D1J6pcnyoqJhpsSzFkIY/ZKSFueITgvpIbY3sS3ZTteABiQtt84oCwN+daTPjZq80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683314; c=relaxed/simple;
	bh=khiuUU9Kdq+Xmx7ARgWxzpbndxUBjYJGaIJhvzkJBfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHsFh0JrXtgYX/MiLQV5KXKPwAOLCVZK3jjf5icgDwXd+FgxFtL6tuuTVbJSjIUW1I8flo6M0af6YcLzrs7s9IGwVm+C+3LOyzkj2G2FRiJeJA7MBdGRQslvKroNBkfGEIanGZkfd/GH1dCV10GbEJYc+fdzwyPr1pkZz95t9Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/Wi9+/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/Wi9+/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD35C2BD10;
	Thu,  6 Jun 2024 14:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683314;
	bh=khiuUU9Kdq+Xmx7ARgWxzpbndxUBjYJGaIJhvzkJBfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/Wi9+/UWVJB07aq5sVvP62QBB0j+52znEP61aiaw06SipIkr6I/V29sz9wHgQJp+
	 RU/EhHe7WgVzcDYLdMnl79N3XVTUziPI3Mnm7jLA8vlWSbxconMYgftPMzurKqEcCl
	 rTSoZRQXJ/saQAjgJ0d8v6BOYlgeyXNhorhd+Li4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/473] ipv6: sr: fix incorrect unregister order
Date: Thu,  6 Jun 2024 16:01:45 +0200
Message-ID: <20240606131705.748439095@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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



