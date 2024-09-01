Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D07417C;
	Sun,  1 Sep 2024 17:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210213; cv=none; b=SDZ8BsejVo94JJy+T+leZ4ju6SM3kGfIiYrrW8cs/3FWF22ThtX8xEIZyGsyc7NDhEk+axHRZIx67T9uouxgKlDjhNwSBBKhusNqABuJ1dFk8iRvccQz8vyoBtUqmGvGjF+NyH8glBSwSGQ3N+gagA23its6XGE//OHgFElCTbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210213; c=relaxed/simple;
	bh=SB/udyInT3EVw/ykxDXIaOQBqBynYwiP16K3VPn2IP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/auZp8HNbZnzHPjodqqMoANlhImfubEJXwSByHWyN37re5SVXr40PfeLNoM09uRwknRwgVUsnlHywlDgfFpQjE+G0vejnCdHjFdl2//lpiWfZnZdB88Ek3kRuFZWBTJxtsTRyU2r0dq5Uf0x98er9vYU/38SYd+6g0LPGcolZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7OUFKFo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7OUFKFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDF3C4CEC3;
	Sun,  1 Sep 2024 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210212;
	bh=SB/udyInT3EVw/ykxDXIaOQBqBynYwiP16K3VPn2IP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7OUFKFoLtkKXbCEf+NW4g9qJkKnAgNJGFtuA3HbHKR+eHOJnHtmNfEcc8cRcmVY0
	 IeFKkbG+HLkVe+uXzX9BZppd4LT2d2e+xd2xPprN4i0pJjJntPc/JjB2dLUUHPe4NZ
	 01ff4tzrblV3wv005xEFd/zaSVmFNp3mZP12pPB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 122/215] sunrpc: use the struct net as the svc proc private
Date: Sun,  1 Sep 2024 18:17:14 +0200
Message-ID: <20240901160827.967793543@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 418b9687dece5bd763c09b5c27a801a7e3387be9 ]

nfsd is the only thing using this helper, and it doesn't use the private
currently.  When we switch to per-network namespace stats we will need
the struct net * in order to get to the nfsd_net.  Use the net as the
proc private so we can utilize this when we make the switch over.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/stats.c
+++ b/net/sunrpc/stats.c
@@ -309,7 +309,7 @@ EXPORT_SYMBOL_GPL(rpc_proc_unregister);
 struct proc_dir_entry *
 svc_proc_register(struct net *net, struct svc_stat *statp, const struct proc_ops *proc_ops)
 {
-	return do_register(net, statp->program->pg_name, statp, proc_ops);
+	return do_register(net, statp->program->pg_name, net, proc_ops);
 }
 EXPORT_SYMBOL_GPL(svc_proc_register);
 


