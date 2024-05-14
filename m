Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A1748CCC;
	Tue, 14 May 2024 11:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687650; cv=none; b=DH7jwLyJ05FDCKJhpsnQdvv/wVJykyWvGWKgkUj6QeZJRE5QJAwyTL2RBBln4EJCFWnzCHKwTdfoPICX6b6RbyZtfW2OXJbQatCU28orMknG/5xryKYJ680DbBSBMOEGwr8/Dqvrmzdl5VupVprp4jE60V8T6vyfeTuiqx/y9t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687650; c=relaxed/simple;
	bh=Nk/CL1zoiTiQZ+Oorpd9wOwLi0bWOVc8QvVxeG/q1oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxZqIOiwIp9OFokGk48X2n88MsC9GPIaDfM5jt5TOcWD09c2MocXEEVHICdEM5NkDc6Q1P8Dvp4MyYqKvu0ySarMHUS6qT7iG7S/c4E9WtnOdD+ojY6nmEi/Rnq81doozhBL9C67JBDxsUsvj0w/LaskmIsmhhjhuQ1Nlbz+5bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zo7GpLyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zo7GpLyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2303C2BD10;
	Tue, 14 May 2024 11:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687650;
	bh=Nk/CL1zoiTiQZ+Oorpd9wOwLi0bWOVc8QvVxeG/q1oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zo7GpLykR6bjudTSLom8VQ4WBFOGf7XoLyAhpwKHdbeOMKEX7l1w9Z82U44ChDMYm
	 Dc6cyezQzn+dUSG4Hk1WvQl7aJIxuljTkVLw1izZwq7ESkhmNOv3aIShUFoZJRmXsw
	 IAG/4klzRpFMSW3hYS0OkC8dB/xe87NwOgTFSQPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Gobert <richardbgobert@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/168] net: gro: add flush check in udp_gro_receive_segment
Date: Tue, 14 May 2024 12:19:16 +0200
Message-ID: <20240514101008.881300595@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Richard Gobert <richardbgobert@gmail.com>

[ Upstream commit 5babae777c61aa8a8679d59d3cdc54165ad96d42 ]

GRO-GSO path is supposed to be transparent and as such L3 flush checks are
relevant to all UDP flows merging in GRO. This patch uses the same logic
and code from tcp_gro_receive, terminating merge if flush is non zero.

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 7c6ac47b0bb18..c61268849948a 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -434,6 +434,7 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 	struct sk_buff *p;
 	unsigned int ulen;
 	int ret = 0;
+	int flush;
 
 	/* requires non zero csum, for symmetry with GSO */
 	if (!uh->check) {
@@ -467,13 +468,22 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 			return p;
 		}
 
+		flush = NAPI_GRO_CB(p)->flush;
+
+		if (NAPI_GRO_CB(p)->flush_id != 1 ||
+		    NAPI_GRO_CB(p)->count != 1 ||
+		    !NAPI_GRO_CB(p)->is_atomic)
+			flush |= NAPI_GRO_CB(p)->flush_id;
+		else
+			NAPI_GRO_CB(p)->is_atomic = false;
+
 		/* Terminate the flow on len mismatch or if it grow "too much".
 		 * Under small packet flood GRO count could elsewhere grow a lot
 		 * leading to excessive truesize values.
 		 * On len mismatch merge the first packet shorter than gso_size,
 		 * otherwise complete the GRO packet.
 		 */
-		if (ulen > ntohs(uh2->len)) {
+		if (ulen > ntohs(uh2->len) || flush) {
 			pp = p;
 		} else {
 			if (NAPI_GRO_CB(skb)->is_flist) {
-- 
2.43.0



