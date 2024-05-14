Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04C343AD7;
	Tue, 14 May 2024 11:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687271; cv=none; b=VIMLHQdU+nsAOj5+wffxZj1yAk28WTYNfxvxTNv3s9Mce64MjdoXPvkHp4oJaSO3BIK6Y6H87knpL+0LxSgMTIHN085179RNP2F8EOzKWEBJLaeJMmstA5WfhFBtEBh7WtFI3TCPy6t9/1rWn5l7SxozW33d2XgmzJyYRow+LKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687271; c=relaxed/simple;
	bh=kc+Z63ttr5ZhEvA7sc+dnYX0/uq7o/IskxnPkRNGGdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRE87X/4GWTkezBJkz1L9JmIaiAHT2siYRlb3VTBHIAU9Qi0a2tBgAs3AyUCrGXYX5YBORVyxE1UdE/BAS0tDkIt+5+AN2P01ALWhGEVgIW8kYp4JBVXPqaESmJhoDurS8r0dNCO1PZ1h3/YY93watBeGNy7q8qSDymDp1VHvzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LesZtUuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LesZtUuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78575C2BD10;
	Tue, 14 May 2024 11:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687270;
	bh=kc+Z63ttr5ZhEvA7sc+dnYX0/uq7o/IskxnPkRNGGdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LesZtUuFBz/63VNsNRIQ3BRVHR/F1dx6ioF+jt0RnrOy4H3YlBAEabXxSo8zkqcaJ
	 SnIucsJSoiKtPXkESsjeF3kRxRL/Yu1+lVovnfzXWle/a75Iiy3wb9L6T79CZMWxc4
	 PZt148FmgSYrrIncaFBsktNHks7tV8EVtB+azxAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/111] tipc: fix a possible memleak in tipc_buf_append
Date: Tue, 14 May 2024 12:19:37 +0200
Message-ID: <20240514100958.612151243@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 97bf6f81b29a8efaf5d0983251a7450e5794370d ]

__skb_linearize() doesn't free the skb when it fails, so move
'*buf = NULL' after __skb_linearize(), so that the skb can be
freed on the err path.

Fixes: b7df21cf1b79 ("tipc: skb_linearize the head skb when reassembling msgs")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Link: https://lore.kernel.org/r/90710748c29a1521efac4f75ea01b3b7e61414cf.1714485818.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/msg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 91dcf648d32bb..b2b102d6f5819 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -148,9 +148,9 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
 	if (fragid == FIRST_FRAGMENT) {
 		if (unlikely(head))
 			goto err;
-		*buf = NULL;
 		if (skb_has_frag_list(frag) && __skb_linearize(frag))
 			goto err;
+		*buf = NULL;
 		frag = skb_unshare(frag, GFP_ATOMIC);
 		if (unlikely(!frag))
 			goto err;
-- 
2.43.0



