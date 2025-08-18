Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C78207A0B;
	Mon, 18 Aug 2025 14:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525621; cv=none; b=hNS50nnuxZeOZvuJ0uC+PJKYfAukFKj5U7MGsb3b0veA0JdHdwKApG9XXmVSKY9RDL9pYlEkX33ctQdC2uJv4SE9FC7/OZqzeWkBgr4VlwfLYTXbrrl4mfY2l0WKZlhzW6qx/7moEGJtpmO7LdzQ2YrDLHLyg4Q6ITAnXgwHZ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525621; c=relaxed/simple;
	bh=Re0hP8YYrPvbPiHA9E6DZbuigQM/75Eu3wGPP20Ch2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGHcKwlUfi18xBTqAzjMBCaesoyZXJEKHQeDDAwwsI5S4PfmlaRLb9LzwNTSCJGs0yXxehF1LTmSq24tXXcZvy7BAzWiBN93XdYq4NaAzf+3zmnqJfV5PK997O88fldMuHVBpzhgVJdIaREqMrwWr24BZe8Ke/2kXAya7pTVP30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kz+hOCn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kz+hOCn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FE5C4CEEB;
	Mon, 18 Aug 2025 14:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525621;
	bh=Re0hP8YYrPvbPiHA9E6DZbuigQM/75Eu3wGPP20Ch2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kz+hOCn3qqtw1TYCgE3iFKK4OdJVCxHNER+86C6tz2y6iXTVIHsjDwMp0tZ/GeroM
	 44/9c8OaZglP8obdN90/YK2PqLaniIfMIaoea6IpjKiHSRNUcvF9uBmYWnRff+DVoJ
	 4vQHdCp9RwWd+UNUFJJ0T8Sh4bdLASBR17i3t1Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ap420073@gmail.com,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 318/570] netmem: fix skb_frag_address_safe with unreadable skbs
Date: Mon, 18 Aug 2025 14:45:05 +0200
Message-ID: <20250818124518.112486141@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 37f5c6099b1f..67a906702830 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3688,7 +3688,13 @@ static inline void *skb_frag_address(const skb_frag_t *frag)
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



