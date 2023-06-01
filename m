Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBE7FBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4F1C433D2;
	Thu,  1 Jun 2023 13:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625943;
	bh=8PxLH7uMhGIjLOjtRkRgDRDt/MoTg6Gwa1niyUtXc3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7SXHZyPDL69LFVeIu7PNAt7takixMH993nXbDJd91uzwCKCgH3rHGjFiOYcG2AVD
	 RjcdCe5GH7neglOXbGvrzZN+dHMDJ/Qan25sR/qMpKn71ZJh4IKJ4F6jjpWVDlitkB
	 YzlbI+KYYClXDZsxVb/tqURIoDiyHpCWSfezq0js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shai Amiram <samiram@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 13/45] tls: rx: strp: fix determining record length in copy mode
Date: Thu,  1 Jun 2023 14:21:09 +0100
Message-Id: <20230601131939.318781693@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>
References: <20230601131938.702671708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8b0c0dc9fbbd01e58a573a41c38885f9e4c17696 ]

We call tls_rx_msg_size(skb) before doing skb->len += chunk.
So the tls_rx_msg_size() code will see old skb->len, most
likely leading to an over-read.

Worst case we will over read an entire record, next iteration
will try to trim the skb but may end up turning frag len negative
or discarding the subsequent record (since we already told TCP
we've read it during previous read but now we'll trim it out of
the skb).

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Tested-by: Shai Amiram <samiram@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_strp.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 24016c865e004..9889df5ce0660 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -210,19 +210,28 @@ static int tls_strp_copyin(read_descriptor_t *desc, struct sk_buff *in_skb,
 					   skb_frag_size(frag),
 					   chunk));
 
-		sz = tls_rx_msg_size(strp, strp->anchor);
+		skb->len += chunk;
+		skb->data_len += chunk;
+		skb_frag_size_add(frag, chunk);
+
+		sz = tls_rx_msg_size(strp, skb);
 		if (sz < 0) {
 			desc->error = sz;
 			return 0;
 		}
 
 		/* We may have over-read, sz == 0 is guaranteed under-read */
-		if (sz > 0)
-			chunk =	min_t(size_t, chunk, sz - skb->len);
+		if (unlikely(sz && sz < skb->len)) {
+			int over = skb->len - sz;
+
+			WARN_ON_ONCE(over > chunk);
+			skb->len -= over;
+			skb->data_len -= over;
+			skb_frag_size_add(frag, -over);
+
+			chunk -= over;
+		}
 
-		skb->len += chunk;
-		skb->data_len += chunk;
-		skb_frag_size_add(frag, chunk);
 		frag++;
 		len -= chunk;
 		offset += chunk;
-- 
2.39.2



