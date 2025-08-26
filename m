Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A29B770FE;
	Tue, 26 Aug 2025 12:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213061; cv=none; b=pgWpJCnGLo0RRcmN9rZp0Ed3kosj9OFhy+e63EwNimzdBUfxnQNlL6jTl5K6dcbHomn/6DC2VnkTrQPVMdIr47IFYxjXkuJs8mtAQHGY2YTZn5fAxwzCfzmnhLS1JH0gft+HY+Il8Qxu7iIGs0MRUaSRBGvpSO/V+HoFlMgaCV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213061; c=relaxed/simple;
	bh=Q7HVV/ofaNLaJ9VsQHMmxrBuBvAI+sDhh9EoMIIhSIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkoDvub0tQdC6hk4DRLOgXZgv9zgIic37lb3gVIPBoxRliEq2zBMGAeI+UccbSReNmSvcmFAtUuuRMW4nVQ4iwIQXRr2liKa7w0niv9J1V8c9r+qkhhnvKHrlFZwOviUqx53uA2k3lWyCAHuHqYFEAPZO017IjfVppNf8itvYBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpdWrQb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpdWrQb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2AFC4CEF1;
	Tue, 26 Aug 2025 12:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213061;
	bh=Q7HVV/ofaNLaJ9VsQHMmxrBuBvAI+sDhh9EoMIIhSIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpdWrQb6yOArMS7kaqxCSBypGAH1k9K7PmNseQTN6tdMKApV+2qfOw7Qcj2e6wsAj
	 HP0eUN9oXSLas5DNxj96y4wpAadUpC4lTOxdbnxWv5TCiEPkiPtxiMTXf5pJhMHvs5
	 K75gt2C37N+ruf2k/FZA7wwxiML9BKlolbKKccLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ap420073@gmail.com,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/587] netmem: fix skb_frag_address_safe with unreadable skbs
Date: Tue, 26 Aug 2025 13:05:38 +0200
Message-ID: <20250826110957.750078213@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7b7222b4f611..3a558a3c2cca 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3556,7 +3556,13 @@ static inline void *skb_frag_address(const skb_frag_t *frag)
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



