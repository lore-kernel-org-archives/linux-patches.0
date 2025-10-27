Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E7C32C92A;
	Mon, 27 Oct 2025 19:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593209; cv=none; b=MhBxdfPenlNBvjIbdpfA3roJ9ArvVpi9fM9mZxM/WWRX41L8PXHyaV35Ym8ukNMGdqdC57S4wfwjq6v8Cp/lKmsxxWDJDzu50EdosqPHcyshGbYGAxquK7pWpqzDvTljwigpZ9UOfrBHGYlIK6XCZKDYT1xFjT8B8+vtEpchFII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593209; c=relaxed/simple;
	bh=4sVcJZzf25mHxu9dnBE+Qm5RWd2Nx1AScljsVb4hJoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xul5f6xmsN3HgOBW7tSGLKSt0RnNumWnNuMTlxes3VI0p9Sbxj1PQO9F2v6bADz4CNT6VylcHjWIw8QKloo3bYJkWFyQxEP1mr6vZ2o1kU04dF5H2+4B8WKUKGcazMSfaNqCw9CFWEf9jfjFqrM3prK5KqHjEPhU4hQet4DVXps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1SYAMlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1SYAMlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1584C4CEF1;
	Mon, 27 Oct 2025 19:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593208;
	bh=4sVcJZzf25mHxu9dnBE+Qm5RWd2Nx1AScljsVb4hJoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1SYAMlUY2qIHBzVhYpENa13CtzyA7YeGUqClrQgCu/8mB4LJsWbYd/iN9GClNedd
	 fp6GnxbmdvLXTsFWfsha8MGFFyum6CZN0H7T07Jlb6K1SsepeRYPZ2Ovarx6bFXNXu
	 +RzMlEsPfFF35CojxJNVAL/82sh8yZVRoTPhdFmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Simakov <bigalex934@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 054/184] sctp: avoid NULL dereference when chunk data buffer is missing
Date: Mon, 27 Oct 2025 19:35:36 +0100
Message-ID: <20251027183516.352812233@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Simakov <bigalex934@gmail.com>

[ Upstream commit 441f0647f7673e0e64d4910ef61a5fb8f16bfb82 ]

chunk->skb pointer is dereferenced in the if-block where it's supposed
to be NULL only.

chunk->skb can only be NULL if chunk->head_skb is not. Check for frag_list
instead and do it just before replacing chunk->skb. We're sure that
otherwise chunk->skb is non-NULL because of outer if() condition.

Fixes: 90017accff61 ("sctp: Add GSO support")
Signed-off-by: Alexey Simakov <bigalex934@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://patch.msgid.link/20251021130034.6333-1-bigalex934@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/inqueue.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sctp/inqueue.c b/net/sctp/inqueue.c
index 5c16521818058..f5a7d5a387555 100644
--- a/net/sctp/inqueue.c
+++ b/net/sctp/inqueue.c
@@ -169,13 +169,14 @@ struct sctp_chunk *sctp_inq_pop(struct sctp_inq *queue)
 				chunk->head_skb = chunk->skb;
 
 			/* skbs with "cover letter" */
-			if (chunk->head_skb && chunk->skb->data_len == chunk->skb->len)
+			if (chunk->head_skb && chunk->skb->data_len == chunk->skb->len) {
+				if (WARN_ON(!skb_shinfo(chunk->skb)->frag_list)) {
+					__SCTP_INC_STATS(dev_net(chunk->skb->dev),
+							 SCTP_MIB_IN_PKT_DISCARDS);
+					sctp_chunk_free(chunk);
+					goto next_chunk;
+				}
 				chunk->skb = skb_shinfo(chunk->skb)->frag_list;
-
-			if (WARN_ON(!chunk->skb)) {
-				__SCTP_INC_STATS(dev_net(chunk->skb->dev), SCTP_MIB_IN_PKT_DISCARDS);
-				sctp_chunk_free(chunk);
-				goto next_chunk;
 			}
 		}
 
-- 
2.51.0



