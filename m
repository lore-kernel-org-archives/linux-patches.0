Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCB52F2371;
	Tue, 17 Jun 2025 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176289; cv=none; b=gaN+3RRZy55LLi9fHr8r4jAUt6WgyUGUnfvilRJ+MLMFl/B2gYqrj8N3wJ/MtqXgbhN2oqONo/su7ZRW3Rt2woWfr3YVm1/BTIY8YZ4KA1YmhXhSOnYG0/HL/MEtD8yPFJYQ4ARoLlrpG46486Y0YZNDgsqYNCSrop+XOro67Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176289; c=relaxed/simple;
	bh=jI3xYAWnOByhZo3RBizzvlHmR2z/iBAOUDYKyxr2i6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BC6QW28fG5RuXqWuBTA6UTZg+BDJG7yPYpilzqKACungxe6+xJ755Epo/N3yW7+l6iCDLThXe2S2j36b3GEEOMdCpxjuW0tMqIF2qT0NVghLZS5wSGLjiVp0E2/b3v6TG5aCQt6NtYNrR2CdGE31mkN/DD80Q7hk900RI+7Arn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzzcT3qz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzzcT3qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0093BC4CEE7;
	Tue, 17 Jun 2025 16:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176288;
	bh=jI3xYAWnOByhZo3RBizzvlHmR2z/iBAOUDYKyxr2i6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzzcT3qzI+Hz5EYYs0f65Z+9edHJ/aNrAGM5Av0q6Kq+I7WE5bT9bhMgjzzrksvBj
	 78DkJ3Kz1sjEZg0u/Db+HuuiIv/qwgGyKgz5o1H4RwAfp5muZOeX5CxaA05Wm8YNEY
	 lkItd2mCuCWN0mXBy7HDahDeqkGLVuk6x9XLPSkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 172/780] bpf, sockmap: fix duplicated data transmission
Date: Tue, 17 Jun 2025 17:18:00 +0200
Message-ID: <20250617152458.489960808@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0ddc4c7188332..dc136603c42ce 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -656,11 +656,6 @@ static void sk_psock_backlog(struct work_struct *work)
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
@@ -670,6 +665,13 @@ static void sk_psock_backlog(struct work_struct *work)
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
@@ -697,6 +699,8 @@ static void sk_psock_backlog(struct work_struct *work)
 			len -= ret;
 		} while (len);
 
+		/* The entire skb sent, clear state */
+		sk_psock_skb_state(psock, state, 0, 0);
 		skb = skb_dequeue(&psock->ingress_skb);
 		kfree_skb(skb);
 	}
-- 
2.39.5



