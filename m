Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98421403E9E;
	Tue, 21 Jul 2026 17:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654445; cv=none; b=UW+6bW6F9rHcgytcvjGIE7OKIWOYE/9y7rR+lbakqGpZ8w0kwfoHj81YPStzTnWq78hEZnJQEZ6wAEortljoVEW+Qq4RicTrIDCGRaxS+k1ygDu1n9QTQVLDL4KPYjkU0OoJ7RBDWNS8zX4SaIx4YgDK0raLZKnho0oLvEgDF1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654445; c=relaxed/simple;
	bh=45iPc8olVIO7KXs/fJJEASoMs4f3lOgJNC/Mx+CAKZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2oytxJguhrVTuw43igmoSZCUaoj3YCNCXHDmhMmMCH+8tlwoalRmOsMTGi7/ILzObXu/UNKPyR7YL0I4vrfCSxmL6OXnScE8FTvQzirjZncBtiMr0QX1xAfksC2VKmNTj2cucx3tjXq6TeBjGWOo0hhJTHCzYXSZkGqpEniwhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pt2NhkfT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pt2NhkfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B941F000E9;
	Tue, 21 Jul 2026 17:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654444;
	bh=LFySp4GdhckngXajX3cpgJfmo0BXgbupK+BszRjUIIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pt2NhkfTrbhGVXCboge7BpczeNgRofb8VEFc7yS0z7gRA3Ihc0LgmoIPRSqS6j9Zo
	 79hBP+3n4xWCAlWQ2sm51HJ59UUuC6dmCrZOQSF9F8peHOUj8X2obYxkgG7Tz5NrY8
	 4/wg/+aPqUvtxxgJ+IfFUQh38V0ECTzP14mnRBfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.1 1664/2077] lockd: Plug nlm_file leak when nlm_do_fopen() fails
Date: Tue, 21 Jul 2026 17:22:17 +0200
Message-ID: <20260721152631.994479812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit f16a1513452edb532fec81e591c64c320866719c upstream.

A client can repeatedly drive nlm_do_fopen() failures by presenting
file handles that the underlying export rejects. After kzalloc_obj()
succeeds in nlm_lookup_file(), the freshly allocated nlm_file is not
yet inserted into nlm_files[]. The nlm_do_fopen() failure path jumps
to out_unlock, which releases nlm_file_mutex and returns without
freeing the allocation, so each failure leaks one nlm_file.

Route the failure through out_free so kfree() runs before the
function returns.

Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svcsubs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -165,7 +165,7 @@ nlm_lookup_file(struct svc_rqst *rqstp,
 
 	nfserr = nlm_do_fopen(rqstp, file, mode);
 	if (nfserr)
-		goto out_unlock;
+		goto out_free;
 
 	hlist_add_head(&file->f_list, &nlm_files[hash]);
 


