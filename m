Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9423123588C;
	Thu, 12 Dec 2024 16:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021716; cv=none; b=n5v9NykJ27wWiQm4zCms3c8N+7OQu5Gi4iFFDSZHpYJqWJ94gqTaRmnRs/q9+VOlY0pJ1yb+Wx7mN973fqsFsThRofcfr4z9aBY2KAt3xWtxuCF6gTZLmT76/BOtodOndQ+uvlWtmDoRlE5qL43GnkR8Njhganjmd4EuAX4pXgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021716; c=relaxed/simple;
	bh=/NLbJpLLG1QvxqxaQ6wIb5xMYMylqrWONwzSZGrCyw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fe1BN4vRuCrqIAnjdgWDwhNL8IFZxHmQ9jzMsxCgvBFCi21MLgCjabhzDNrgYobWLKmRilXpGNvM5PpqAkHcbgDL5ndU1Wjil+dfDH920faGJKyz7lApEOfkMbfi4+eece21wetPY6o47Fzxks0bb9G+uh8MVq+VLqfLZZbn7So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tKJpo1+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tKJpo1+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF80EC4CEDD;
	Thu, 12 Dec 2024 16:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021716;
	bh=/NLbJpLLG1QvxqxaQ6wIb5xMYMylqrWONwzSZGrCyw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKJpo1+UjtcQw8YjprkEUJNXGbt822eUiiJn2ywH+v1yaq31hEt2HEJm5XAhNHOQ/
	 kQyHfn/iaHvg3eGY7tMEafqN+9u/HscU4qGEN35ql0O1pxnRqIzrB94MgPuwfhCI59
	 zdwuGBMuz9K1o9nENIT1hE/rDeIWi722XJU6Vkl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 042/565] NFSD: Initialize struct nfsd4_copy earlier
Date: Thu, 12 Dec 2024 15:53:57 +0100
Message-ID: <20241212144313.134169453@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 63fab04cbd0f96191b6e5beedc3b643b01c15889 ]

Ensure the refcount and async_copies fields are initialized early.
cleanup_async_copy() will reference these fields if an error occurs
in nfsd4_copy(). If they are not correctly initialized, at the very
least, a refcount underflow occurs.

Reported-by: Olga Kornievskaia <okorniev@redhat.com>
Fixes: aadc3bbea163 ("NFSD: Limit the number of concurrent async COPY operations")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1787,14 +1787,14 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 		if (!async_copy)
 			goto out_err;
 		async_copy->cp_nn = nn;
+		INIT_LIST_HEAD(&async_copy->copies);
+		refcount_set(&async_copy->refcount, 1);
 		/* Arbitrary cap on number of pending async copy operations */
 		if (atomic_inc_return(&nn->pending_async_copies) >
 				(int)rqstp->rq_pool->sp_nrthreads) {
 			atomic_dec(&nn->pending_async_copies);
 			goto out_err;
 		}
-		INIT_LIST_HEAD(&async_copy->copies);
-		refcount_set(&async_copy->refcount, 1);
 		async_copy->cp_src = kmalloc(sizeof(*async_copy->cp_src), GFP_KERNEL);
 		if (!async_copy->cp_src)
 			goto out_err;


