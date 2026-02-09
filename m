Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E7A2222B2;
	Mon,  9 Feb 2026 14:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647954; cv=none; b=rAyRFulNb8U8akab8Rk0+pIb9HLAi5WlY2SVTRyBdg1uzFxe5SqQxxGVi3byq8SanjrlU0xu9oGfXQeTIfvx8+JGeOMsZge9d/VZi1rsEJInowdvrys3zBShToY5YaThBW2j4K12QKQr3orPSot2HkGH4eni7/5s15H/A7U6+uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647954; c=relaxed/simple;
	bh=7u8C4o6ofCrKC7S4y1piQSYU6YER0w4QvLIATy1Bukc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXGlFkWgjdftkPLUsFloiIvomR35YDgdXVFbKMP+qzp3fXWSdSWtEA7iF6RyhTwm+L143qbTyVwPHclwo/byG9oM5wpglWSE4OGzIxhCLYLnJBgCYEQ/rpyV7Mp1QlgBJymhLDysFFOJt3I+JlkKUVwsRDH9qjqHdau8MWAyk3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrNigEPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrNigEPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A800C116C6;
	Mon,  9 Feb 2026 14:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647954;
	bh=7u8C4o6ofCrKC7S4y1piQSYU6YER0w4QvLIATy1Bukc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrNigEPCxwMmlIlu0m0jtAo9Xj4mdS7zDrh+QRTVdpSigVlCutBwA2afuNtYvM+7E
	 d8nIVF55XchaNXzl9DD0IFbNXiPpOxOiep8SPocgpFdQ27SFoNs6azzEtppNA90cHz
	 CImgGSV64blYbFx3Ni1dXwgexrHHFHykIdbNluSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/113] net: add skb_header_pointer_careful() helper
Date: Mon,  9 Feb 2026 15:23:47 +0100
Message-ID: <20260209142312.987747462@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 13e00fdc9236bd4d0bff4109d2983171fbcb74c4 ]

This variant of skb_header_pointer() should be used in contexts
where @offset argument is user-controlled and could be negative.

Negative offsets are supported, as long as the zone starts
between skb->head and skb->data.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260128141539.3404400-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cabd1a976375 ("net/sched: cls_u32: use skb_header_pointer_careful()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 1e07a54602032..2e26a054d260c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4202,6 +4202,18 @@ skb_header_pointer(const struct sk_buff *skb, int offset, int len, void *buffer)
 				    skb_headlen(skb), buffer);
 }
 
+/* Variant of skb_header_pointer() where @offset is user-controlled
+ * and potentially negative.
+ */
+static inline void * __must_check
+skb_header_pointer_careful(const struct sk_buff *skb, int offset,
+			   int len, void *buffer)
+{
+	if (unlikely(offset < 0 && -offset > skb_headroom(skb)))
+		return NULL;
+	return skb_header_pointer(skb, offset, len, buffer);
+}
+
 static inline void * __must_check
 skb_pointer_if_linear(const struct sk_buff *skb, int offset, int len)
 {
-- 
2.51.0



