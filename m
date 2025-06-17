Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E8B18A6AE;
	Tue, 17 Jun 2025 15:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174666; cv=none; b=egoS2EwEd/2qzewOft3M5zR+NCnYDYvs4TI6NqVegMcDaobkhhh9f25u823jF168dxPDflJx81xmMXptJYlZjapinEbNy2p+bmEAZ2y22vToheJMwS/7w3NMjiii46dVbJPbGUkNJz/DqXyHdzz3q9MTyhZHyny//5vkUbubsYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174666; c=relaxed/simple;
	bh=BEsG/HiFYH/HM73bSOyd+dfvBrR1NZYiB8pDrIhdfws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yr0lbkzd1HMw9mni+v44tuf+yHmbGhuwZWMboChw4oM6byiivNJPEYm/3b5RdSFbQH5D6sVQKyWtipcRgmDCRvxD081Rl3awZh1BcMRmaMbeN091clI3up8ajKftuPhhyJvnNGUW7Ss+RZu4EE/oXBynfjlNCBwVMnzIyFYzmiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpsNk0Uc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpsNk0Uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4C6C4CEE7;
	Tue, 17 Jun 2025 15:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174665;
	bh=BEsG/HiFYH/HM73bSOyd+dfvBrR1NZYiB8pDrIhdfws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpsNk0Uc4Hlypt2Waj4UZhISqG0NmNEji3FUfL0KXHgX68tscv6PbiQ/4O2uhUvkg
	 l3/g2yXv5Y1kjFZJeoDUzfM4Lxhpbrw98BfzM2R20W5skX1C7M+1hpOg6EzYJ1HFWy
	 PUy9GmuSkMAAWTz1HKwuX1eOth6qtW4oroZd88Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/356] bpf, sockmap: fix duplicated data transmission
Date: Tue, 17 Jun 2025 17:23:19 +0200
Message-ID: <20250617152341.601995096@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
index b9b941c487c8a..c284c8a3d6792 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -655,11 +655,6 @@ static void sk_psock_backlog(struct work_struct *work)
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
@@ -669,6 +664,13 @@ static void sk_psock_backlog(struct work_struct *work)
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
@@ -696,6 +698,8 @@ static void sk_psock_backlog(struct work_struct *work)
 			len -= ret;
 		} while (len);
 
+		/* The entire skb sent, clear state */
+		sk_psock_skb_state(psock, state, 0, 0);
 		skb = skb_dequeue(&psock->ingress_skb);
 		kfree_skb(skb);
 	}
-- 
2.39.5



