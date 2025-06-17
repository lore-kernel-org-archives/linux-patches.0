Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF8B21FF44;
	Tue, 17 Jun 2025 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175293; cv=none; b=s8sECh5DYkmShH0z4ghzS19F4ssFRb6WjVxx6ZOJBxGPiinB14lrw5jjG4rPWab7rx3NrrvM2n9+TlPn5LaDUaswQpYRpFOkhb07OCBY8OX9mjtuuxoT80hNLKXUYCn5csDhVqcafgrc3XgMHq16fEovGH6PVawQBmVXA4JoLaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175293; c=relaxed/simple;
	bh=VidjBmUl/OPL92RD/8K4bvGGEHYAUu5W20NXE190XJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyR/IMz+bjdGxSHULzcCiBTRFUDylkVRO4jNHQhnuODK64ykGF/m2BQHQhNoG9sP5d6XEynTukPWPceLl/yjslRe5Y/yozWkVuO0A0sAljbof+WfYneC5PvdO2bN4xUcaTKN8DWBHRoCKAUZkUgMFhVZ5ujK+EQ7C6U9xxicLuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1vaBjP4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1vaBjP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3142C4CEE3;
	Tue, 17 Jun 2025 15:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175293;
	bh=VidjBmUl/OPL92RD/8K4bvGGEHYAUu5W20NXE190XJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1vaBjP4nn8I3npq2+umNtXeSNhFiR5N3+jIhy8590GmCXegIY8KUclp0w9i2TJq6
	 orASz8M1+NnT4+cHEuwJteBImsPuaLvEgikQXQe8vYhEp+vIqXkpHX4LXLn7kkJpo6
	 SA0i8kqSS3JBwSLZzqu9KVhtwiURWh+Fuaj8fCH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/512] bpf, sockmap: fix duplicated data transmission
Date: Tue, 17 Jun 2025 17:21:18 +0200
Message-ID: <20250617152424.127924351@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index f76cbf49c68c8..74eac311faf25 100644
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



