Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AD413776F;
	Wed,  3 Jul 2024 11:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005432; cv=none; b=T4SxQjgt5M2crSvPTinudEotIeGL2grE+nm2QjJdwhQZ+v0SiGQCAvQqevRJISRb3+rE2kdcesXbqjTkqk/qvRQr2jDQP7lmCsEw9dUUC3svZveRw1VF6MXo6yLntVbWAuvyodb2bfgZvr3Nce73++Blc+MxphR+bhNwIUt1Kg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005432; c=relaxed/simple;
	bh=37zQFbXQpx2RSlUgjAxvnuicUJsXTMyflBkWg26iSnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiSgcp6or0227pm708XUvpQdwP4wDB/cZhpsZuah4dFspJrm1Fr8JKwY1YW9M8FTfxZ2wYe6npfc66JQtgUrbr2UmcwKVU6DHXZtaKjOIX3sDPIbwwGSffVF58LBocc/Y/D+yw6OIXxHrGNrA+WvCfhxRcNAdwLEOUyHwG9fuaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEPsk+g4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEPsk+g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53171C2BD10;
	Wed,  3 Jul 2024 11:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005432;
	bh=37zQFbXQpx2RSlUgjAxvnuicUJsXTMyflBkWg26iSnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEPsk+g4C4pLnq7Ghb2LZI1npFEXg2z22c7txjAnmkkXo1pB+rKNlGvDBsLCWsaxs
	 zHDBc93urD4nVFRgYlFOy/DZTwj9exVKkYfLDEzjkq9/+bYGrD0GHF1HdqTp2UVFt1
	 5V9urUhpGUHge3xVInp7ZArZT5P2k87w7UGr5RH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/356] skbuff: introduce skb_pull_data
Date: Wed,  3 Jul 2024 12:36:24 +0200
Message-ID: <20240703102914.912442169@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
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
Stable-dep-of: cda0d6a198e2 ("Bluetooth: qca: fix info leak when fetching fw build id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h |  2 ++
 net/core/skbuff.c      | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 15de91c65a09a..b230c422dc3b9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2447,6 +2447,8 @@ static inline void *skb_pull_inline(struct sk_buff *skb, unsigned int len)
 	return unlikely(len > skb->len) ? NULL : __skb_pull(skb, len);
 }
 
+void *skb_pull_data(struct sk_buff *skb, size_t len);
+
 void *__pskb_pull_tail(struct sk_buff *skb, int delta);
 
 static inline void *__pskb_pull(struct sk_buff *skb, unsigned int len)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4ec8cfd357eba..17073429cc365 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2071,6 +2071,30 @@ void *skb_pull(struct sk_buff *skb, unsigned int len)
 }
 EXPORT_SYMBOL(skb_pull);
 
+/**
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
 /**
  *	skb_trim - remove end from a buffer
  *	@skb: buffer to alter
-- 
2.43.0



