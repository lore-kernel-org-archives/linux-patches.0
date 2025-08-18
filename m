Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B628C21C9FD;
	Mon, 18 Aug 2025 13:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522179; cv=none; b=CwOh0ycFPKiTEQPpOmRaXm6KZB7Z0nokkcEboz8RaCT3RGgPeFzjizGHDgD2H1p4ipqYYvD1ajdwz+iho7euowicYVIS2nof/SDH0TjuKPJjas7WFoKvi/gmPejtIRWbw2n8gPDLuAFUoRAOWsYAay0zOUka1V+4ytBKRol/hpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522179; c=relaxed/simple;
	bh=8PPjL42Q1xyNZ6TYGY501BiNU7Ji14bWD8cBJmiEtGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFvcvf/lk1+sTdWq37t8jv3DdsKk4nsk+bpH97VciD6o1CcwTYTXNN3J/BPm+0LHS+meeoenqD76scVrgfVg4nCqCGEiY4Q4bua9vtfAG8rWzs26we+99XTUDAbLpd50bynAVhmqNTDvIRZ443ZbLA3YaMgHbYhdrFWk6jMN/fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOpg6ZVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOpg6ZVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2385CC4CEEB;
	Mon, 18 Aug 2025 13:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522179;
	bh=8PPjL42Q1xyNZ6TYGY501BiNU7Ji14bWD8cBJmiEtGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOpg6ZVbvNNH59MUqYxXEzM8oy19F88Er8YP+9zABwmnTzOedN90zydMtZv+h+6Bb
	 370URjtAGldnpBwCX4eHL25kruI7+MFOoaOxKtvts0jQWDECZtctPWSerl4V/lV/sR
	 qSJFKcrsjKQPihtPq3VpbxTuFscD14hPbSWl3q24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ap420073@gmail.com,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/444] netmem: fix skb_frag_address_safe with unreadable skbs
Date: Mon, 18 Aug 2025 14:44:25 +0200
Message-ID: <20250818124457.790368403@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a726a698aac4..b2827fce5a2d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3638,7 +3638,13 @@ static inline void *skb_frag_address(const skb_frag_t *frag)
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



