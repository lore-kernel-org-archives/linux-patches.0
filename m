Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FF518661A;
	Tue, 10 Sep 2024 10:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965016; cv=none; b=uyMYMG1FB4HURUoXUtq2aStC+47+eyLj9cGqX0QZXcdTzwFhoGS4RWkaKqUZGqwGGa3pt0unaBHoMuYOTbZa+02dLEn4qYKaHX8fRQEtM4ZTcpIiwyI0qHu0VmcusMiVNjYORntvSxu1QPKd009Y9NbQKe7goGiI2AYZV4+XUuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965016; c=relaxed/simple;
	bh=T7iPF4fvz9r3dKCitfDunrZqflZV/XSff0bZUAzISL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbazkfvYMrzchlOPTziLMdsbEHjsImitq0WpM0a2BJoz2oGM+CZW1l/fRBO2UMfKKqmSRqXhCNTt2YzAsIIitjVSlsNTVfG0u1QvfVKoFl0KAKpc8/H3SF58EoYM1xOmu5btHq3Mqm6+LdZPYwUsjv2bj9etBL+8CJzFda5hWvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSicev52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSicev52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CA3C4CEC3;
	Tue, 10 Sep 2024 10:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965016;
	bh=T7iPF4fvz9r3dKCitfDunrZqflZV/XSff0bZUAzISL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSicev52iqt4LESvrVbBjyqnPU8wb6PAaJWnR5FgGTT97+H9Oi69yKJO42XRum0wk
	 Ze4ajD1AfW0em7TZ/QIKkuIJONY5HMTr6ldQ5dawiquHjH9ewm244JwF9bE6aD3lO3
	 U/bGrrk9V9a60fRbBAzm2BOCpVxgdn7dBqNz6QO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 091/186] sunrpc: use the struct net as the svc proc private
Date: Tue, 10 Sep 2024 11:33:06 +0200
Message-ID: <20240910092558.261668887@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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
 


