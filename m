Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B357419F462;
	Thu, 15 Aug 2024 14:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730844; cv=none; b=qxyQKWHANvwjAyLrKDWnfhcm38tjk9i9cZdO0nzS7cYLMYUHYcTWyBiWMpzFZR98t04AT+cSvWKUQ+qb15BQCsq1Xgewg1AKgc6KxTgfaIrFgDD0hyVo+ymQ6RiS3egJOWrZ6N6wWlUEJVQcw0z3qg87hGce1y5cVog3b5BiC3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730844; c=relaxed/simple;
	bh=dgJtxaTDlmtxcXj+cVYy6/1DWqkVB4tXTizU3cI5aHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERUwMHtO+aopbFUje3XssWNfBZgfdF5Z54wY7vX2DdqF6Ye+OwfXDptjHWn55BuLyRgg7uESdhOlYbfQABea61trlLZvtA3SdLk4BPBQcLqrILuFqPXCk4CQk3sPiO1uE4RZ/VyGF5SFvHUq75sFMe50URXZrFM6pcBZ3SJ6O6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7kAunEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7kAunEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3617DC32786;
	Thu, 15 Aug 2024 14:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730844;
	bh=dgJtxaTDlmtxcXj+cVYy6/1DWqkVB4tXTizU3cI5aHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7kAunEEsVXONM0RaAjDBnMDND89alv1WeBya3uSrd5muytOdk+w8vhoXscCbOQf/
	 edhwjViCPGcd1/EWgMQe0cdlWNn5Mh5T381UvuJ4CnAbIoEmtMFXr3Wf0rmMhZKKWf
	 aAanSJaxFkAYJZLaC5hQeJ3LM7b8U1tWY3Gvka9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 11/67] sunrpc: use the struct net as the svc proc private
Date: Thu, 15 Aug 2024 15:25:25 +0200
Message-ID: <20240815131838.759103238@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -314,7 +314,7 @@ EXPORT_SYMBOL_GPL(rpc_proc_unregister);
 struct proc_dir_entry *
 svc_proc_register(struct net *net, struct svc_stat *statp, const struct proc_ops *proc_ops)
 {
-	return do_register(net, statp->program->pg_name, statp, proc_ops);
+	return do_register(net, statp->program->pg_name, net, proc_ops);
 }
 EXPORT_SYMBOL_GPL(svc_proc_register);
 


