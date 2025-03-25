Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FC8269CE6;
	Tue, 25 Mar 2025 12:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906107; cv=none; b=uG4/afPkYhim1kt93MAFxN4yLa6Z/BieQ+mvn8SIpXb0IjyIWoKqfHUaTKXdzDy7nInoxftTORYMzqPYaKVzhJuECc56ebPC+AdUp82jUCNtpOBPyzNDtVVRR/wPQ/FNadWZPMdpvaM8OxW9ax5YjwB4fElSl7IXC/KHFd8o9g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906107; c=relaxed/simple;
	bh=SjpVfmIq8lRSp1ky13lVCE5vZCrtyOkIqE8yI51jC1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4QL95pusfzXNfU3L5zkjuoHV5xeaGcXaQsh6yogIcJXKml1IcXjuFhc5bytpM++1QoVKNUeefBRcW7wFXSnIvc1Y9KYwM/9Om63DgSzs4hPAxsTpcnAyRx0WPJgtSAe/oGt0GVo/PDXZNi5+mDCRGI/7cSJU7HnTEUg+42geN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEm9JJWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEm9JJWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F500C4CEE4;
	Tue, 25 Mar 2025 12:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906107;
	bh=SjpVfmIq8lRSp1ky13lVCE5vZCrtyOkIqE8yI51jC1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEm9JJWEKx88BUHSy0wQbM5PAFvUWBcWPDj9IUSIplIo5hNhSLhmy+PnvPoFdrkIV
	 yDu5pdDAihWP9IPS42KzL5PPHEhHxz/COsE7cry9wXaYviHRwdp38FAANhhTiBYOOO
	 kPRMCna80Xm6eHXGnmHlzpYi+DbnpH7VL1enu3PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 19/77] Bluetooth: Fix error code in chan_alloc_skb_cb()
Date: Tue, 25 Mar 2025 08:22:14 -0400
Message-ID: <20250325122144.852897881@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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
index 3bcc15c9415fc..13b752c169bed 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -825,11 +825,16 @@ static struct sk_buff *chan_alloc_skb_cb(struct l2cap_chan *chan,
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



