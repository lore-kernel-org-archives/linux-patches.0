Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5833C26A0F4;
	Tue,  8 Apr 2025 10:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109853; cv=none; b=qi9CBhQpbCfQcslcTTnPDYah0L7kgV08sQQCFjMT4BLPlhpU+EfOSOCswRN1Jhh4KGB6WmkAVuFiThEFVM16Rpibp/D1yH0WkvDl7GG95pdX3Gy6/LJ1btlLE2fZ1D7Fuqf3D3ry5HZtUQL5BUI+Xmrg7d0hxAq/v9CnbUURmlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109853; c=relaxed/simple;
	bh=ORzbuypqkxy43Xws9n5rtUweFq9NnTktEZl9Ab/wa4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIub6MrouSXXhfIZ+n4mt9FnF8m5yAXX2MqWtuxO1SJBdDwxWc/1RCU40+cqyICVRi7+tVmWbecsMeThENtajhRA0UIXSUFoWPSeJ8uV5HkPKGtZ4ggEuT44dM7VsIbaqM3daLPLw0dgJ0vokg6GneyYkFefhTO3uwEnWZxFyQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzLZRynD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzLZRynD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE448C4CEE5;
	Tue,  8 Apr 2025 10:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109853;
	bh=ORzbuypqkxy43Xws9n5rtUweFq9NnTktEZl9Ab/wa4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zzLZRynDnvO3n8zKUmrDc0XM90IvvEVC4o7X3VTGcQyetsDVaA+1Onc0+c6hzgDtb
	 av5wNpB4RKsND9jeKVkH1kEzibuKCA4nsekKJdDAU7hwDFTj+1IkkUb30sEhZ20QYr
	 gtP50E5AH7iPdsGJz5dy5HC0DyFiAl3nirlJ9a2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/227] Bluetooth: Fix error code in chan_alloc_skb_cb()
Date: Tue,  8 Apr 2025 12:47:34 +0200
Message-ID: <20250408104822.669511951@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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
index 7601ce9143c18..7e698b0ac7bc7 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -855,11 +855,16 @@ static struct sk_buff *chan_alloc_skb_cb(struct l2cap_chan *chan,
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



