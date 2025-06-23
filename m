Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476582571C7;
	Mon, 23 Jun 2025 13:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685514; cv=none; b=YYYO5jXEMzjTPQHFlWoqa6pwwGeH26SDv5Qmntwb73njeHWo026nEwlVGhzExNWUfySsQ2otpIDYwQGTxssH41HU0Ud+n56e+S1uQpCYmHIgI9PQQKKF47n4Aaj3m/q+cCPibj6+rc2YsSoPnXyYm5z4ZE7j7MK7gfFQ+ziuetY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685514; c=relaxed/simple;
	bh=uvjuNTThKJA0OPDQ/gLhJgV9Vd7kC961hNdM8uey0JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKmZvBb2TNSIJja7ukQR2wzbPNDwk670v5Frkz+RhOyapmKnIvjODxPZ3BrDI3q+BS2BqMHSBYwk5/FYR3QnfbeqSVedYopbGZNq+nmV0QKWsj8m7adNZcPZ1A7CfddX1o0DFJ2n1y7U8KUY5G89VhW2aJQe7Flij94U913Ufek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jYbRfNv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jYbRfNv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836FDC4CEEA;
	Mon, 23 Jun 2025 13:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685513;
	bh=uvjuNTThKJA0OPDQ/gLhJgV9Vd7kC961hNdM8uey0JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jYbRfNv4E1FRGWdUBfQWJyahlhV5GzRPsbT4inENJ01geI2y+L6Eo+V5N2czciEIW
	 SmaPmkW79f/MiK4gJgT4uyUUz1AC3iOa1rdlMuxO6mLFedKFWSz8EGRYLToK33oSrz
	 WloRHmkm2XFTUh9VKysf6R5JInGV3Md5qes6BYrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/411] bpf, sockmap: fix duplicated data transmission
Date: Mon, 23 Jun 2025 15:03:03 +0200
Message-ID: <20250623130634.178442198@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 3b4f14b794287be137ea2c6158765d1ea1e018a4 ]

In the !ingress path under sk_psock_handle_skb(), when sending data to the
remote under snd_buf limitations, partial skb data might be transmitted.

Although we preserved the partial transmission state (offset/length), the
state wasn't properly consumed during retries. This caused the retry path
to resend the entire skb data instead of continuing from the previous
offset, resulting in data overlap at the receiver side.

Fixes: 405df89dd52c ("bpf, sockmap: Improved check for empty queue")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://lore.kernel.org/r/20250407142234.47591-3-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index a5947aa559837..f4186d4980b92 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -639,11 +639,6 @@ static void sk_psock_backlog(struct work_struct *work)
 	int ret;
 
 	mutex_lock(&psock->work_mutex);
-	if (unlikely(state->len)) {
-		len = state->len;
-		off = state->off;
-	}
-
 	while ((skb = skb_peek(&psock->ingress_skb))) {
 		len = skb->len;
 		off = 0;
@@ -653,6 +648,13 @@ static void sk_psock_backlog(struct work_struct *work)
 			off = stm->offset;
 			len = stm->full_len;
 		}
+
+		/* Resume processing from previous partial state */
+		if (unlikely(state->len)) {
+			len = state->len;
+			off = state->off;
+		}
+
 		ingress = skb_bpf_ingress(skb);
 		skb_bpf_redirect_clear(skb);
 		do {
@@ -680,6 +682,8 @@ static void sk_psock_backlog(struct work_struct *work)
 			len -= ret;
 		} while (len);
 
+		/* The entire skb sent, clear state */
+		sk_psock_skb_state(psock, state, 0, 0);
 		skb = skb_dequeue(&psock->ingress_skb);
 		if (!ingress) {
 			kfree_skb(skb);
-- 
2.39.5



