Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ACE322759;
	Mon, 18 Aug 2025 13:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523941; cv=none; b=N6LQHs80NFpG+2EEBxQVYMDRny11tX0GsA1L441W3gdlTKhNxoOTdRhfeN1gzApkOnmXWvGn1sJcWAS12h52ukbP6h4/d0y+Q5vgtIQlUgZMR9xjiflJo3C8HR+yNLXa5y1QPQYNuTRTTrA1zafL+OFUWBwSk1dQ/3a89dhuvUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523941; c=relaxed/simple;
	bh=b3sNz48L33yzJmSIyW2N+WD60eVDFqtRdw+f/GimIeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oz4hoPwLSHaKE7DaPmsUErosIsnjZLj8cLeaIeNvD59LOAjyQrtRuHyP3bLSWZV6eM5Wi6XN69rj6YaOTgRqFQWA+6NcXMN3EcRGY0cOt+YJfsuiTLzeRg65zbIvAiRcw8dtPfpsC0DlZvg9wlkNukpIQ+5vTziKi7om/TD0vz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elwH0CsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elwH0CsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF43BC4CEEB;
	Mon, 18 Aug 2025 13:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523941;
	bh=b3sNz48L33yzJmSIyW2N+WD60eVDFqtRdw+f/GimIeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elwH0CsFHUXIXFKZQTo6TCMre4YIfGk4noCbXCo3UJper1eNzQaP/8QHEGfDegRH1
	 pHcaSy/GUA3Lwfvsnnj9Ox/EgIF7Xt8mUq3mGqtL6yqZpQSszEIK65MtkuL3pca4fr
	 3XWnqtfVhAskVS/whXrCros5Xx1fgbU4L/+zfaQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ap420073@gmail.com,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 292/515] netmem: fix skb_frag_address_safe with unreadable skbs
Date: Mon, 18 Aug 2025 14:44:38 +0200
Message-ID: <20250818124509.660406808@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index fad2fc972d23..2c768882191f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3687,7 +3687,13 @@ static inline void *skb_frag_address(const skb_frag_t *frag)
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



