Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AECE18D630;
	Thu, 15 Aug 2024 13:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729090; cv=none; b=pEKMclQHPI8s9kIW/e+4XrM3RoAxnNvGCjpgztn+KUCNRAGFSIHCVsfs/VGY1jFBe/L6EvlWnUm3EYx7LEmyenlR/OaKeZm3JeJ55qyE01k7M8gK2JmdIMXN2s/SMVInzYvgoHqY6aeVQOhsxxVGLQ3LQ3uyhaGCt7Igz4oW2mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729090; c=relaxed/simple;
	bh=wSw7ljRxC+O9lt/Lls2mF2nJ5MtYmjyVmVG+//YqSbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EL2pbWAwumP8G714VBxIDex/ep9tPukBlJvT28TxF7CfcX6xQkZMIZ9w8PX78nrDFc2xwEOqHm6zvntGZ0ccUEQ482+bvUNEhQlT7Ip65Y5M8HnmbeCZ5jHiZKNJEB3njEy2m9eunVShxREKMXGCBbIjTIO2FND1EGPpDNLRwpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEKLqS70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEKLqS70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5245EC32786;
	Thu, 15 Aug 2024 13:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729090;
	bh=wSw7ljRxC+O9lt/Lls2mF2nJ5MtYmjyVmVG+//YqSbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEKLqS70BZ3npghT2Mo20cguBXvTBmcJEfCU/9iLOZ0Wfify4QhvLIM5sxPfZ0JLi
	 ldvcAjUdWPJADz/sZ2a6+yAQ++Wrv37nu8WAixSQd3JAIbJRuoeHeumGO07tc/gBUs
	 tf9q3/dl66RZzlAkbqjAaTT16Bx2n+Jth+hRdBXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 11/22] fou: remove warn in gue_gro_receive on unsupported protocol
Date: Thu, 15 Aug 2024 15:25:19 +0200
Message-ID: <20240815131831.696126419@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit dd89a81d850fa9a65f67b4527c0e420d15bf836c ]

Drop the WARN_ON_ONCE inn gue_gro_receive if the encapsulated type is
not known or does not have a GRO handler.

Such a packet is easily constructed. Syzbot generates them and sets
off this warning.

Remove the warning as it is expected and not actionable.

The warning was previously reduced from WARN_ON to WARN_ON_ONCE in
commit 270136613bf7 ("fou: Do WARN_ON_ONCE in gue_gro_receive for bad
proto callbacks").

Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240614122552.1649044-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fou_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fou_core.c b/net/ipv4/fou_core.c
index a8494f796dca3..0abbc413e0fe5 100644
--- a/net/ipv4/fou_core.c
+++ b/net/ipv4/fou_core.c
@@ -433,7 +433,7 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
-	if (WARN_ON_ONCE(!ops || !ops->callbacks.gro_receive))
+	if (!ops || !ops->callbacks.gro_receive)
 		goto out;
 
 	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
-- 
2.43.0



