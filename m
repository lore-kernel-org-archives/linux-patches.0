Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C8715FCFB;
	Mon, 27 May 2024 19:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838336; cv=none; b=P2018cDt8mfbjWPBUy4wPfdDYxyCs0u2X2RJKDm9Zxf0P8j7cpsqz+75oZUJJu1kZA1Jzsk2Y44tIKf73H9zRhEy/Pdqk3ibQBXKTiCCZh0KwL/kaYV/+nMghv4oWG1VFBUp18Ams4puQLl7s8oBZyDVxaDtD+AntiQm0u1cTKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838336; c=relaxed/simple;
	bh=MMXFZX4MSDIDZZkU7Ht/YbMmUwX2phgfx5fH+n4yixM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNmm2lB1EBq5s5NdxuR3AlUabF4TKjJhGbDzBNJ6M6nOUd8E2tiNN6kFVpasZwtQrq7Mf4kbHIyF+HAeLLdxxYqOcxIxSzEQORtsh4BoQmQZjm6BCGz8vLFMLFvrsUNFy9Zfnu+SRWwz110MIbRVzSTEuC7znhxSUl+8VItXRaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfbBPoUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfbBPoUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D51C2BBFC;
	Mon, 27 May 2024 19:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838336;
	bh=MMXFZX4MSDIDZZkU7Ht/YbMmUwX2phgfx5fH+n4yixM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfbBPoUWLzwYlmjc4RjNuXEnMf3272YSFwqXjOoy6YjvDm8iHZ8gDDXQh3dvXpZy4
	 lvroLFni9M177X4qcwI5wiBl+XfH+I1o8KrF34B55HE7k2fLgmRdKvkTWZmaMhIVXT
	 2kCEvf9eOinuArkthSB1kd5eR43x5RKRs7LRX0WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 313/493] ipv6: sr: fix incorrect unregister order
Date: Mon, 27 May 2024 20:55:15 +0200
Message-ID: <20240527185640.529959032@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



