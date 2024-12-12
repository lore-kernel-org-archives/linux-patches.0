Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA58218594;
	Thu, 12 Dec 2024 16:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021721; cv=none; b=dg+lLuY6H8SEksWZiH/P5+2Q+TuLeSseWFkjK2iyowc6F3QE7tgiPMOmJweS1NhBqwv2ua/bgOo6By+hmvTgYp3ijG5SsiDuNttW3gGtchppQvv3m5YRE3JDUUp55MUs6SdLebtas1J3ROu04bxNDsNdp0WO/y4496FNoUaO1wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021721; c=relaxed/simple;
	bh=gOk4X5hvuWVFKJtRmO1+YxxwdO8igcwkpU+5L6i6Ubk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0rVscQQxlLJpK59eZcuoh4q3w9zigxW2e3hf+AVkjudmvntD6sELU33YTGJiI6/gP6dYBYM7+I6EUR7M4A3B8DRtQbC9IWsDpmQWkqGcr1IE0F7aFhu0ehfjCM0faxniN/zNfWibDWL/tLJ92c7S9Y7oroEzcMlhbNOTR0XN2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P19vQu71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P19vQu71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6B2C4CECE;
	Thu, 12 Dec 2024 16:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021720;
	bh=gOk4X5hvuWVFKJtRmO1+YxxwdO8igcwkpU+5L6i6Ubk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P19vQu7154tVha7LF+57d5wWcwRMhnsH6cba66GivFCX/mkQlA+UPMD2rfliy29Pq
	 GiqYs1WLev3CLPQlF2P/2tZZZOXvMttcqsONSaaeYEHAw/BB5ExnUpzsGiKB9CJowG
	 J032EovOZOsCNeIRlSr3Zuh8xoy67ZFj1ukZ56j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 043/565] NFSD: Never decrement pending_async_copies on error
Date: Thu, 12 Dec 2024 15:53:58 +0100
Message-ID: <20241212144313.176520684@linuxfoundation.org>
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

[ Upstream commit 8286f8b622990194207df9ab852e0f87c60d35e9 ]

The error flow in nfsd4_copy() calls cleanup_async_copy(), which
already decrements nn->pending_async_copies.

Reported-by: Olga Kornievskaia <okorniev@redhat.com>
Fixes: aadc3bbea163 ("NFSD: Limit the number of concurrent async COPY operations")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1791,10 +1791,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 		refcount_set(&async_copy->refcount, 1);
 		/* Arbitrary cap on number of pending async copy operations */
 		if (atomic_inc_return(&nn->pending_async_copies) >
-				(int)rqstp->rq_pool->sp_nrthreads) {
-			atomic_dec(&nn->pending_async_copies);
+				(int)rqstp->rq_pool->sp_nrthreads)
 			goto out_err;
-		}
 		async_copy->cp_src = kmalloc(sizeof(*async_copy->cp_src), GFP_KERNEL);
 		if (!async_copy->cp_src)
 			goto out_err;


