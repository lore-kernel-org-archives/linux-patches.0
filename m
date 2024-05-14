Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A46757CA1;
	Tue, 14 May 2024 10:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682579; cv=none; b=MQVs4k/ZmoaZOjRCZo6Kr97ohs2lHHvaYnzg8hJ8Qbl+K4qt9KRS1ucwu8FhRjGzVnS9JhYiP/WY0p4z3RxB58ZQnT/l8i8GLTwfMRMFpA8wx6mWtYA4qXxyFpOguWhDXz9q++vLs1Nk/p+3jtRyTI1sUUwTYiMrDtS7Bn49Rs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682579; c=relaxed/simple;
	bh=DGbZEBB+2scUKWQIdgDSQKdn02cnAg+7xclLGz8AzaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyqXsky45+CHY/6dhePvhRrK70lwxzWqDDjFi6n5Ungs4lTMqLMm/AiRaGSI/5qSn4aabay7Vuutxa/bRR8BT9G/bZLDs5KXbjHLQkfAfaI71BZt1TB9vA3/AZXbLFOp4yH1usOIJoxk8dqAq/jdwLHF50qcPl3LLlPVcUuhzG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5N3D0NA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5N3D0NA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B83C2BD10;
	Tue, 14 May 2024 10:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682578;
	bh=DGbZEBB+2scUKWQIdgDSQKdn02cnAg+7xclLGz8AzaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5N3D0NAo0YRKw5WWledVZXvSsto/M2w3DuRKI2sPaMv7/Q537E7rnLIr8jKY5d9L
	 vqURmbJvP27gfDjPlSG5Ce0D9mXaWNnEzQPz+Z8lF3S8Wz+OJlUgr2GEYZtlNH52lW
	 gLSYBOt297AHMQOJLT9OavZMQ1FCZJNLnewUFjG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Gobert <richardbgobert@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 085/336] net: gro: add flush check in udp_gro_receive_segment
Date: Tue, 14 May 2024 12:14:49 +0200
Message-ID: <20240514101041.816616946@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 889d4926fc0c1..e5971890d637d 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -471,6 +471,7 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 	struct sk_buff *p;
 	unsigned int ulen;
 	int ret = 0;
+	int flush;
 
 	/* requires non zero csum, for symmetry with GSO */
 	if (!uh->check) {
@@ -504,13 +505,22 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
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



