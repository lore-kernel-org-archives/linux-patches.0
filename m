Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8679E12F394;
	Tue, 14 May 2024 11:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686877; cv=none; b=eL/UmQqiTxgcWBumhR4URu91xnFYPnMgsLwm3tz2SZS8+brwZ9xT0c2/FdHWTAx6y2B5KR+1078gQjq4qnDgP0HKlnXK+fWKEZYsdpyDuE+RPERvOL71+8oTBkcasqQcO1kyGDtq5ein6ht04plvtWZsiWe6J9AevQEMTiOz02U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686877; c=relaxed/simple;
	bh=mTvrySSx2p1lo9n2V+N1MKuBkrQBs+RiVm92ukYAjwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGZeeS06ZqHxLylQdUI4AqOf+678Z6UsKmZVk/qGTvmuZ0Q9d16R2GeG1smCU+PdLq/E1Jav8E4sirjif7fdVSFWeAsoL3K25Uwe+OwOf2C3YzRIoiZ/jrnehHPeAJtIpjUZBLoOMI3RDn6WZ3Kx21lr3iasCmUn9ttmn3tfbVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jev0X4wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jev0X4wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFADC2BD10;
	Tue, 14 May 2024 11:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686877;
	bh=mTvrySSx2p1lo9n2V+N1MKuBkrQBs+RiVm92ukYAjwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jev0X4wYcHQP9HiuNdINh8BzGmtzTHdvIdWo+vkCkTEu85HvtK0iLUVr+13X6fC2I
	 wTtHeWofA/bLqhjBKoLPeexm/fcNgae3GbPTAE+ABx9PPvKuHs9GE8get5dxKRwUmq
	 mGlw3efVJ8oELQGK3eE4uAqp6YQ1swm4JCM125Ng=
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
Subject: [PATCH 4.19 21/63] tipc: fix a possible memleak in tipc_buf_append
Date: Tue, 14 May 2024 12:19:42 +0200
Message-ID: <20240514100948.816808192@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0ac2704449744..911b8f4319851 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -140,9 +140,9 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
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



