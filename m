Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEFF47D46A;
	Thu, 20 Aug 2026 16:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244497; cv=none; b=BauYRj0dtHrfc4rZ+tCRWU2D0XZlzrZBkA2IbuGKcKhP5R32iOpBUOZb5OGGxL6WzrDabhnp8tbhdesCl0a43e9J/y805egCMP0nUF/xzvK0YCRhg6g06R8F1JZXjIlracWPr90gqWNGe8p53oXn2BOwSzAF5fsKzwHSo0uPcTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244497; c=relaxed/simple;
	bh=S58GJmzfuvJZnuX/sRn0Mly3Bck4BPcAXX/w5A5rlgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bka9mOnVwuuu4t7owtkMOhjRDYFYBTfNij87zKP7sKBdS1Ng+oPOMNDoIZZP88DHhk1LQJW/MKIRvgbYukaG3Tq21oPeBr//L1ImPkp0xU6S97d/jMmTMm4XTVa30ByF7+n9Eq1c2+1fpq8TCcngJU+5CaqIlykFVM+6ResVrT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhCDv6M0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhCDv6M0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4762D1F000E9;
	Thu, 20 Aug 2026 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244496;
	bh=2WZ9VvQTpe3FmwQxwQo6AW7XYDqDnMpUAdeaAiJFuVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rhCDv6M0p4wXGQ9S6J7rveoUQ1Kxqir87pqKs7ctwpRhqcXIDiw8zUMQr8Gulym2g
	 kiMAi9ysLs+h7CpY5Q4l/pJ0av2hF0IaNcud8JVL+dWhGcaMMf0og+KoMon3I2DG/Y
	 T++jEQYVJzmgadnA5pQfC8yUQ24Sop94dHuxCT9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/235] skbuff: introduce skb_pull_data
Date: Thu, 20 Aug 2026 16:57:06 +0200
Message-ID: <20260820145222.301158638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 13244cccc2b61ec715f0ac583d3037497004d4a5 ]

Like skb_pull but returns the original data pointer before pulling the
data after performing a check against sbk->len.

This allows to change code that does "struct foo *p = (void *)skb->data;"
which is hard to audit and error prone, to:

        p = skb_pull_data(skb, sizeof(*p));
        if (!p)
                return;

Which is both safer and cleaner.

Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: 47778d2c2087 ("Bluetooth: HIDP: reject frames without a transaction header")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    2 ++
 net/core/skbuff.c      |   24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2317,6 +2317,8 @@ static inline void *skb_pull_inline(stru
 	return unlikely(len > skb->len) ? NULL : __skb_pull(skb, len);
 }
 
+void *skb_pull_data(struct sk_buff *skb, size_t len);
+
 void *__pskb_pull_tail(struct sk_buff *skb, int delta);
 
 static inline void *__pskb_pull(struct sk_buff *skb, unsigned int len)
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1977,6 +1977,30 @@ void *skb_pull(struct sk_buff *skb, unsi
 EXPORT_SYMBOL(skb_pull);
 
 /**
+ *	skb_pull_data - remove data from the start of a buffer returning its
+ *	original position.
+ *	@skb: buffer to use
+ *	@len: amount of data to remove
+ *
+ *	This function removes data from the start of a buffer, returning
+ *	the memory to the headroom. A pointer to the original data in the buffer
+ *	is returned after checking if there is enough data to pull. Once the
+ *	data has been pulled future pushes will overwrite the old data.
+ */
+void *skb_pull_data(struct sk_buff *skb, size_t len)
+{
+	void *data = skb->data;
+
+	if (skb->len < len)
+		return NULL;
+
+	skb_pull(skb, len);
+
+	return data;
+}
+EXPORT_SYMBOL(skb_pull_data);
+
+/**
  *	skb_trim - remove end from a buffer
  *	@skb: buffer to alter
  *	@len: new length


