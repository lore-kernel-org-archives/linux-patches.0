Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D8525FA04;
	Tue,  8 Apr 2025 11:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110887; cv=none; b=Fn/l1odk0b15wviSEVKC/oj1EqzBX8EjURUKMQ+XBI6ST3jahpuLUSbih2w/HS2J4Xm15Q/Ocl9PX/0iJmyhF4L7otPHcztxdCK/G88qki6jGMo0IbRMG8eJqiyO4udlEZFlcrEYySxFEbjeW+g8pPEodjCmd2/idgmyfsVKT68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110887; c=relaxed/simple;
	bh=K48Z6FIbjb67ynb3IbOEOfDGOUh/0lbVXXme4/v7G1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cu48Tw1NYIMDyb7S97V0RoHV2bKf8/MyDlXNvh+iQu3sk1b5s9hkAQGWgzn/tezj21IPjP3sKSi2EWtBICb9NRQZq/6OfRd12l8mpDtcbC3ojT47X7iXHoEwxB4oPHXikyFnVU0KeQsI9BqJXdg/1qvCYCqU989fexmFuhZ6VxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsyFTCg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsyFTCg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8ACC4CEE5;
	Tue,  8 Apr 2025 11:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110887;
	bh=K48Z6FIbjb67ynb3IbOEOfDGOUh/0lbVXXme4/v7G1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RsyFTCg2V7AqNkLVpSC/0OmwZ0Lu7EQBSmAZIOAurzTlOiGgULV4w/LcVksQY/cqH
	 0klTSv8kaf7FuiZVRSu3dqpBl82YhABujpkiEf2G5JrHUOENCbDnI/R546LT+2Rk7l
	 lyvo+jwQ/zJLhSaU/unDN94w0uyLmpTIwjSgacGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 231/731] netfilter: nfnetlink_queue: Initialize ctx to avoid memory allocation error
Date: Tue,  8 Apr 2025 12:42:08 +0200
Message-ID: <20250408104919.654723065@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 778b09d91baafb13408470c721d034d6515cfa5a ]

It is possible that ctx in nfqnl_build_packet_message() could be used
before it is properly initialize, which is only initialized
by nfqnl_get_sk_secctx().

This patch corrects this problem by initializing the lsmctx to a safe
value when it is declared.

This is similar to the commit 35fcac7a7c25
("audit: Initialize lsmctx to avoid memory allocation error").

Fixes: 2d470c778120 ("lsm: replace context+len with lsm_context")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 5c913987901ab..8b7b39d8a1091 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -567,7 +567,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info ctinfo = 0;
 	const struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
-	struct lsm_context ctx;
+	struct lsm_context ctx = { NULL, 0, 0 };
 	int seclen = 0;
 	ktime_t tstamp;
 
-- 
2.39.5



