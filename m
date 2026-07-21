Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CA344AB8E;
	Tue, 21 Jul 2026 22:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674240; cv=none; b=gy8LNzdFUHIRgPD39Jx0p9SIq2hnp3koUiYvkh5CkpBB5022B/LU2qFfE5PT/DGFuMimzZtfDS3BT0rE6Cy5w1t5m5442M5bpWwbj3kEEf/NIyWvxfiUd7Jx5jJ9/v8gqea5DnlW2Vn0phLpuiLFFclFz3JFel/nzzwjOWpj+FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674240; c=relaxed/simple;
	bh=78SdAVKSo8AKxeJbseKLPtJFzZFu6DGR/ZzGSUVTE7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uayvlX/FzYWtewgjyvWNjFkRmMvPyrZNW9AnHZ0oq2J7GdxtXc2dH7su8x7ya5NqrW8A0gPwvPOHTQTOagiurnNch3465oZ59tearv0xBfVUAXXySVKKN1ZQYr0aqZ4rRnWTDTfe/usXp488RGkJF1MfKYB+6CWzw5jO2qAUZBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlHPnOCD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlHPnOCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CCF1F00A3A;
	Tue, 21 Jul 2026 22:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674239;
	bh=W5+lY8AxvXVX1Fs22ArGHftXvbz/zQL5ElqkPLkJu6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tlHPnOCDwxIpM8IcqH9bHn8vaUjSFrU63ueu3sV8tbrguiL5kE1Tu0t3oSXkwLr55
	 dH/dyvpP7vSf252Yv4/kpo2/xji67BCLB5yA8eicX5LGLa5ulVDasmJDCUCwd+6CWv
	 paF3m/JsYygfZ5ML32xtQ/isR/++i/EvRdEImbig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 467/699] batman-adv: frag: free unfragmentable packet
Date: Tue, 21 Jul 2026 17:23:46 +0200
Message-ID: <20260721152406.229264909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 6b628425aed49a1c7a4ffc997583840fc582d32b upstream.

The caller of batadv_frag_send_packet() assume that the skb provided to the
function are always consumed. But the pre-check for an empty payload or the
zero fragment size returned an error without any further actions.

A failed pre-check must use the same error handling code as the rest of the
function.

Cc: stable@vger.kernel.org
Fixes: ee75ed88879a ("batman-adv: Fragment and send skbs larger than mtu")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -525,8 +525,10 @@ int batadv_frag_send_packet(struct sk_bu
 	mtu = min_t(unsigned int, mtu, BATADV_FRAG_MAX_FRAG_SIZE);
 	max_fragment_size = mtu - header_size;
 
-	if (skb->len == 0 || max_fragment_size == 0)
-		return -EINVAL;
+	if (skb->len == 0 || max_fragment_size == 0) {
+		ret = -EINVAL;
+		goto free_skb;
+	}
 
 	num_fragments = (skb->len - 1) / max_fragment_size + 1;
 	max_fragment_size = (skb->len - 1) / num_fragments + 1;


