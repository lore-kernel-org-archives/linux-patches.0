Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3542472AF;
	Mon, 23 Jun 2025 13:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685877; cv=none; b=Nv42g4sJ7+tyemlLwOTmCqKOtab+6WyNUO0+LEURdDFNDunfnbfmhv8WYi4P2mwFr82ukoLJMlG9QAAKLMqmvu4Sw5+NPcVsIvKPALl8sDW+tnK7u3sMglPYJtGwurC5ZRnmLozWNegAyin3qUHZ2WikZc52rFMEu3AJj4wg4Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685877; c=relaxed/simple;
	bh=N4qjVFz6TkmDIaGDfp5N+0WZCnhkXTAioqES/q+pawM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPDGpPTMaxeBkEG6oeuK/QFf0JqDXwFoWp8qOCgpql1bEdKqpljKck0AcDBIBRZBsHu5H65co0MhKO+jinFpOr2W642NPS5QPFCuon5mQbZCzOpDl0HUSD2XE68ZjOPZDAk0oE5Svd+91QYBkgvVO1YEEr2ZrS/L6VGKeAjmvzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n4uaZ7Nv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n4uaZ7Nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E67C4CEEA;
	Mon, 23 Jun 2025 13:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685877;
	bh=N4qjVFz6TkmDIaGDfp5N+0WZCnhkXTAioqES/q+pawM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4uaZ7NvpsS4CGI2Vk6IfnXCXyqzNw7BaJzvcLxazCGERLjuxX2XDNr/gz+XUswwI
	 x+mEV4I3Iom1PBLX7R9uOV0tISgz5gSPSwFMpwWJP4VoAqAyAhNHqhDI30Y5bsFfoF
	 hIPJnuq9IaWb68YKcPElABBAqVZ+Ytck5KhPLfpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/508] bpf, sockmap: fix duplicated data transmission
Date: Mon, 23 Jun 2025 15:01:41 +0200
Message-ID: <20250623130646.623026530@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5a790cd1121b1..72f4949cbb70f 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -654,11 +654,6 @@ static void sk_psock_backlog(struct work_struct *work)
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
@@ -668,6 +663,13 @@ static void sk_psock_backlog(struct work_struct *work)
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
@@ -695,6 +697,8 @@ static void sk_psock_backlog(struct work_struct *work)
 			len -= ret;
 		} while (len);
 
+		/* The entire skb sent, clear state */
+		sk_psock_skb_state(psock, state, 0, 0);
 		skb = skb_dequeue(&psock->ingress_skb);
 		kfree_skb(skb);
 	}
-- 
2.39.5



