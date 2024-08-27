Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D6B1C461D;
	Tue, 27 Aug 2024 15:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771258; cv=none; b=NjqEcC+bBNAFfuI5oUMO6EjKzhG1FWLah3joUnKO4doJGUmBjJAZb/uUzD8RIzFf6lvZLwvl5p3y/oHINID0cdVFXEf9QoQcn7e2xdHsh+JwE7jBGI44In0dh/e2dM5xCF8Xoi0FDXOWcQC0gD6jhFDqV+ashDu/yKTq3fEZnNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771258; c=relaxed/simple;
	bh=WvoJqAGV/Vq4tLWEVO8lfqvvSAVerT1CAKrsGKsougg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUtVuzrUShMDkan7HdKf/aGJ89AstM3cHd7XRy22GOnjOkwwzEk/8adkqQnNVa3UFNevKhsEWMucD3XeGEoCL+CnZy9/d3ggN5eeRjI7XJYm5zl42x+Xyj+hP336Nl+lRGrXDcO90Y8rxWHCQZjjpnywPxoIJO3LMoW2f7PpE74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzBrGPWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzBrGPWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBBAC61040;
	Tue, 27 Aug 2024 15:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771258;
	bh=WvoJqAGV/Vq4tLWEVO8lfqvvSAVerT1CAKrsGKsougg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzBrGPWYSj0ltkb5RlOIRWpDH4yMUpt7vqqP1AuaKMDCUsHVRIDhyoH0gN8eEzOY2
	 gvD1MWZkN59S7LHL9fx2iMkIL4G+a7eEJWaGaiS/YP8Ucc0v69apsbqZvGbKN9u5x3
	 Fx2FEdL0oo/d1SRKHKEQ0sKMSzp3TpOP8ZT8Xs7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 103/273] netfilter: nfnetlink: Initialise extack before use in ACKs
Date: Tue, 27 Aug 2024 16:37:07 +0200
Message-ID: <20240827143837.329769323@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donald Hunter <donald.hunter@gmail.com>

[ Upstream commit d1a7b382a9d3f0f3e5a80e0be2991c075fa4f618 ]

Add missing extack initialisation when ACKing BATCH_BEGIN and BATCH_END.

Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch messages")
Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 4abf660c7baff..932b3ddb34f13 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -427,8 +427,10 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	nfnl_unlock(subsys_id);
 
-	if (nlh->nlmsg_flags & NLM_F_ACK)
+	if (nlh->nlmsg_flags & NLM_F_ACK) {
+		memset(&extack, 0, sizeof(extack));
 		nfnl_err_add(&err_list, nlh, 0, &extack);
+	}
 
 	while (skb->len >= nlmsg_total_size(0)) {
 		int msglen, type;
@@ -577,6 +579,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			ss->abort(net, oskb, NFNL_ABORT_NONE);
 			netlink_ack(oskb, nlmsg_hdr(oskb), err, NULL);
 		} else if (nlh->nlmsg_flags & NLM_F_ACK) {
+			memset(&extack, 0, sizeof(extack));
 			nfnl_err_add(&err_list, nlh, 0, &extack);
 		}
 	} else {
-- 
2.43.0



