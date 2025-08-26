Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411B1340D93;
	Tue, 26 Aug 2025 13:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214554; cv=none; b=rdX7qAmre8j5WqTxR6pglOHF+B9QbeYW1CO1LXwUdPD805RjjMCzIRbuxBMTydqW8z41uLa2QkzI5LqL+aHt/CjKkij8Ra0zfBF+1ZrQy8dUyfE+SZSgZeiiC8HZDCCoCYKSFkfdWlN9JGXxuw6u2bU5PFbuSCnW2UwbxRl6/sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214554; c=relaxed/simple;
	bh=sKZKdqFzCUqofXEI15BlhwnwcDDVK3HYPEsxbQMCZdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSjDFdDD9SE8s/Lh9foDyUvQMxb2PsN4/9DsGM+GCxOEeEc0J5ipkSi+Hf5JExnLfhti3vYxVQc6BX7/EclUOY/jX+4bOhIMjVJhjfdoWXuVwEgZIGFiu3pPaWVRI6BjE4oAR0RxZvf24wnXytj8bwlhUxNw0C9iC5zfMOV8kHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXQSd7HH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXQSd7HH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F21C4CEF1;
	Tue, 26 Aug 2025 13:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214554;
	bh=sKZKdqFzCUqofXEI15BlhwnwcDDVK3HYPEsxbQMCZdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXQSd7HH8imHxafdhD+2REZC/Bnf8MLkOS+Hd5lwPUsFFdTNR+MBnzkwQno4RAsdJ
	 ouGsmk/URNzcod+nQLx+tsHkrA05CZK4m3uzRjFdoeLbUIsZXxGbCHNxykKuTXPcWd
	 ujRWZjJ79XkJ1m1ZQ4BwCs2afOzautOG+MVkrqSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ap420073@gmail.com,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/482] netmem: fix skb_frag_address_safe with unreadable skbs
Date: Tue, 26 Aug 2025 13:06:44 +0200
Message-ID: <20250826110934.546918722@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit 4672aec56d2e8edabcb74c3e2320301d106a377e ]

skb_frag_address_safe() needs a check that the
skb_frag_page exists check similar to skb_frag_address().

Cc: ap420073@gmail.com

Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250619175239.3039329-1-almasrymina@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8014a335414e..9a04a188b9f8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3495,7 +3495,13 @@ static inline void *skb_frag_address(const skb_frag_t *frag)
  */
 static inline void *skb_frag_address_safe(const skb_frag_t *frag)
 {
-	void *ptr = page_address(skb_frag_page(frag));
+	struct page *page = skb_frag_page(frag);
+	void *ptr;
+
+	if (!page)
+		return NULL;
+
+	ptr = page_address(page);
 	if (unlikely(!ptr))
 		return NULL;
 
-- 
2.39.5



