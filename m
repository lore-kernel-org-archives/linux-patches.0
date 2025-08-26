Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CBE2E88B7;
	Tue, 26 Aug 2025 14:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217795; cv=none; b=nx3V5qVnB7HklvPqV3TfVkrQ4Y8jE9kvSD1nHeWE3CNDaQFdww+XLmkXJ8mpW1oyYTgI/La/jy8T7BARaiqL26ix8icBgy5WikE3fbmUiuBJL8jUuZxrbtgZ+I7MsaMvYJw08H0TsgT7qPS1pCoTWnTbqQLgrhK8+Xn26gwGHWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217795; c=relaxed/simple;
	bh=NAdFMQtaATjtamObcCO5OoxUThUExZMfL2YbYQuXwiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BN4WeA0W9u+5kIWgC9BD+eqyE7MLHndZouuI23y8W6z3NsQH/2SVaxRrEipisyjZA9NqxvtPH/6BCJFCR6Z1JMan3E5pnZnrJ//nrOxV1hHmllZCKjYp3lvokbjfLRq271nYM3EQiUl+OjZvm0/Gnd0nJM3L3Ue6jWS+0jYTNNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCL+WaUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCL+WaUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E22C4CEF1;
	Tue, 26 Aug 2025 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217795;
	bh=NAdFMQtaATjtamObcCO5OoxUThUExZMfL2YbYQuXwiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCL+WaUCeHDf3j/Myk9mN/tNq7hNOGYr9gLe/sHvvWfxpm8lWaRVLcOB92I3OAt9n
	 faGhl/3NCMiTgjHIGw85NmwVOkuD1juGCiUmO1hCzH4waeRQtxrd3OBP9j5Tr7j5Cr
	 22HAPLF9pTdU6lXsaz5dgqgyhmYkWFFpJlbxgGrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ap420073@gmail.com,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 278/523] netmem: fix skb_frag_address_safe with unreadable skbs
Date: Tue, 26 Aug 2025 13:08:08 +0200
Message-ID: <20250826110931.288558817@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ca7f2a2c3e3f..4b5731245bf1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3104,7 +3104,13 @@ static inline void *skb_frag_address(const skb_frag_t *frag)
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



