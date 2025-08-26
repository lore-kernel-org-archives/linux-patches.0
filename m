Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C610E34DCE5;
	Tue, 26 Aug 2025 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216318; cv=none; b=VKTTPnZIz1zGzJjKJDKcf8mOrIBrLmcVBt/xtAZHdYUANM/Dh6H2aoxGXnNkKDRD6xoYLg+ptURcRZdTi0kDi23xEZDZP/pEBo9OdTIT3Hzmcbm9UkvXkNtnT1olb2iytGXdXfnq2NZILxEir8AfQZh6XsDHG044gH2HJ18Gy4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216318; c=relaxed/simple;
	bh=y58n61OEhNSqcxLidItxHKWChuNugN4UOZzEK8uoPck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrCntjm5hX6GZTfES4y2x2xErZD6mxcjg56WsNqNtKCjuI6KDUjaaEoapLBk7TO1V7KyhErjGw+LiZW25NUbIAYKsY1ZKXkhj6I/Dv6ejZBCls9YwYBddq1AXG3z6k4LUWpMt3ksrF+6MsTNuxAmhAVk0Ej1rOqmCdQ25XPUbYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06GOHzMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06GOHzMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D58EC4CEF1;
	Tue, 26 Aug 2025 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216318;
	bh=y58n61OEhNSqcxLidItxHKWChuNugN4UOZzEK8uoPck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06GOHzMb3uyTPO8CMnrl1JZdroQZQt5T4yhvhBiW2lAfWM0VWQFrCdaqM8CsaEtAT
	 67H4mIRna8KeDIfKmTFXT7RcB4zYGDX3QQomTzEEMQuIr1ZoaNFkQKWk/GsC8H5rZX
	 wwkh9RtgrGR2pvk3zA6v/XFDB1CFMLXz/2Avbd00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ap420073@gmail.com,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 366/644] netmem: fix skb_frag_address_safe with unreadable skbs
Date: Tue, 26 Aug 2025 13:07:37 +0200
Message-ID: <20250826110955.484225754@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9155d0d7f706..a8d6e976507e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3287,7 +3287,13 @@ static inline void *skb_frag_address(const skb_frag_t *frag)
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



