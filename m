Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E761ABE5C;
	Thu,  6 Jun 2024 14:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683305; cv=none; b=Sr2+vjDx/1xYesAZzHPmC1FZjSipVVhGTW0yBiIofcsjXH5GQa9BU8twSD8QULFMhZEA0UtIMfY1yayMhqFAnR2wFrbDLPzIaDrIxc6ZIH75jfZc4cv0fuZ3KKj6Gp2zL5jX9x97a1gb6T3Kc6xu/dZQ+bg92L5Xdj26+klSRT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683305; c=relaxed/simple;
	bh=Sj6DK6xhrfn0raDM14rl71TgZWH9Hyp0oV4/7S9m86g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhcMHvhU8Eio9zdgmCOwutti72+sMjg6UjmTDP+XEG8EM4pb7blV4pIJs9gsxmZgtpR32DNrsVpNHOVDTJN1EARyT9Yxtn2CC18jy4WM0GaR4kJRxzEoEGQv0tEJz7rpzab85bSNZYuUqqfXKDQ1zzbHqx7VLm0hwA6fZVHFGFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7bDTJG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7bDTJG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2345FC2BD10;
	Thu,  6 Jun 2024 14:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683305;
	bh=Sj6DK6xhrfn0raDM14rl71TgZWH9Hyp0oV4/7S9m86g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7bDTJG5kNycnaM2Cn4yxorAq+ylrRkYkKnsSumelMEm/lT0J/p6sWEwkWKYyrhZz
	 p3pmb5iJC6abd+iYdP+VepJbSwXv+0l4NX1IdOm8msXT008gAq3E5V6vOEPTNd2s4I
	 33jm4aVAbQuhQMkfpfsS31dRmMchZvbSbeyaMQBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/744] ipv6: sr: add missing seg6_local_exit
Date: Thu,  6 Jun 2024 15:58:38 +0200
Message-ID: <20240606131740.285886717@linuxfoundation.org>
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

[ Upstream commit 3321687e321307629c71b664225b861ebf3e5753 ]

Currently, we only call seg6_local_exit() in seg6_init() if
seg6_local_init() failed. But forgot to call it in seg6_exit().

Fixes: d1df6fd8a1d2 ("ipv6: sr: define core operations for seg6local lightweight tunnel")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240509131812.1662197-2-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 35508abd76f43..5423f1f2aa626 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -564,6 +564,7 @@ void seg6_exit(void)
 	seg6_hmac_exit();
 #endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
+	seg6_local_exit();
 	seg6_iptunnel_exit();
 #endif
 	unregister_pernet_subsys(&ip6_segments_ops);
-- 
2.43.0



