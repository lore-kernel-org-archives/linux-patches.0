Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E33F263C6D;
	Tue,  8 Apr 2025 11:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112495; cv=none; b=KkB32MCo12UhQAIQi4V7CzdPcs9krF27K4I845ilHeoqnjO0Ildn1f6M6qQrGZv+z/a37Ap7Gg/eiyUzM4trFAyRr0wswPtrY3fWoqUqicrH6oXcedkGf6dg0foGl6Fl2bEDC+109LeHksoeoe4c+uLzyDWfIGsk/i7ItXq7Zjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112495; c=relaxed/simple;
	bh=iybF2sVI2TfIEFHE/ZG5nVO4CZh9MUV9+VVnGEsqFF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFYXjVmu1BLj16nW5CS4IUVbQPoy2YfxkFEF30u9l8BKcmri9ZzDJg+cepMtWpocKAZTvSnh7YlMG3eJz7SpM1NJi1biTLfxefridPiemL31fvup3WY2V/PfpWjnElAVwKTqy2MVPm2THdm+uUfVXNfVhRCUfGSZcjt0ADgMwE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pw6IFehk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pw6IFehk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922BCC4CEE5;
	Tue,  8 Apr 2025 11:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112494;
	bh=iybF2sVI2TfIEFHE/ZG5nVO4CZh9MUV9+VVnGEsqFF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pw6IFehkIk0wQAcwje5qnLf6DqwtvbbUYu08cD8JOARvGzgMSsl++hNt65iiowfNf
	 dmpV9XtqNNMmzZHKBd+jZOzq/HjxNUEF0rpnSzA6iJL0j5fWzJTa8SOPE2NrgwDsDo
	 bcjDToExbmvoY76pcsmlrQndcLDbsxSE4dcUHT0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/279] Bluetooth: Fix error code in chan_alloc_skb_cb()
Date: Tue,  8 Apr 2025 12:47:53 +0200
Message-ID: <20250408104828.780343687@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 72d061ee630d0dbb45c2920d8d19b3861c413e54 ]

The chan_alloc_skb_cb() function is supposed to return error pointers on
error.  Returning NULL will lead to a NULL dereference.

Fixes: 6b8d4a6a0314 ("Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 580b0940f067a..c4a1b478cf3e9 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -824,11 +824,16 @@ static struct sk_buff *chan_alloc_skb_cb(struct l2cap_chan *chan,
 					 unsigned long hdr_len,
 					 unsigned long len, int nb)
 {
+	struct sk_buff *skb;
+
 	/* Note that we must allocate using GFP_ATOMIC here as
 	 * this function is called originally from netdev hard xmit
 	 * function in atomic context.
 	 */
-	return bt_skb_alloc(hdr_len + len, GFP_ATOMIC);
+	skb = bt_skb_alloc(hdr_len + len, GFP_ATOMIC);
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+	return skb;
 }
 
 static void chan_suspend_cb(struct l2cap_chan *chan)
-- 
2.39.5



