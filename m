Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B29C35690E;
	Tue, 26 Aug 2025 14:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219105; cv=none; b=oJ616nAk8NLgM6pnGERd+gwU0l5lqERGzPlPC9wRwxAelzCmm8se1Fhyp5Oys3MJgFTXNiZA6Rju00yNDpEYL7GKdwKv6mXJDISEtNbszUfFy7oaZL/t9S5lvB6nvdJ3nai97R05Uitp9IcOVR+VWaN5IrhgAgx14MMSBQ0DwJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219105; c=relaxed/simple;
	bh=mJ9Ljmwd5hze8flgwAsQJLDVde/auEVf3A+sMpdOp0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCc6IZgRPINne9mnzQ4JrnXK+WgtdVVIYUVGgdBzfNYtaE42b0dE2ch54rxHGlhVW3VLJ6WJTmV6brjFcWqfFVQJAYHyxiBAmfmhPwqIdf3o8EbHMSMGUheg7i5svrzzv041f26eqdjtUCnho8qd+z9do1peL59S4cwjEetcTu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuEhzrvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuEhzrvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE82C4CEF1;
	Tue, 26 Aug 2025 14:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219104;
	bh=mJ9Ljmwd5hze8flgwAsQJLDVde/auEVf3A+sMpdOp0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuEhzrvR0+D8t31sYG2NULWJn0pkszy2xdm1JThfsCNesqf4TVa+yUDssBzijQGhP
	 trgSC4tPp0ZFgm1gnvDift+hNjhd7nkB1ez51rsADAjgc/LKVIfoKW9MiXQ9HM6edl
	 y6nd8xLK8CfgoSkjJ+118lmePbf8dPYU9rGm4eW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ap420073@gmail.com,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 223/403] netmem: fix skb_frag_address_safe with unreadable skbs
Date: Tue, 26 Aug 2025 13:09:09 +0200
Message-ID: <20250826110912.992795542@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d9abd9e6833e..101ac3d6581e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3073,7 +3073,13 @@ static inline void *skb_frag_address(const skb_frag_t *frag)
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



