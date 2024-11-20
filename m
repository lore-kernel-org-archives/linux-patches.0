Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAEB1B3B2E;
	Wed, 20 Nov 2024 13:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107612; cv=none; b=sgTfWZEYN6RvG7VUIRuUbbijT9UedyouS8Aiy3jutrvcGACUXt3xWkGSOQpBVKdkUtL5yOiWk2z4F3dfO2DaqyhfZe+G/jNTjfb0TtArcgAAamNk1Vq2jFX0SWXyClnUt/1BjjlrbZdUlU6XvzngkA+SyMrJAzcgq6OK2jIaHlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107612; c=relaxed/simple;
	bh=uLc3fAiXvmXvetb+vecjabVfEYU7RtA7s/mMRDAyh+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GETT47A863437pxNjI9NfNGt2Jo7C4GDpgPUk8GtA2Mgn44mciFRYOoctcG+fgejzS6luoeQQg4TdHZxF9T2j5tp0z85j0iWdHwpt6hidD8be7020TjYwTBX+2JtmHEhUSR2MU8dlaVGISusIlJZeBY8OuXbwa6WEqhjX5rVobY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNPIFm5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNPIFm5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802FCC4CECD;
	Wed, 20 Nov 2024 13:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107612;
	bh=uLc3fAiXvmXvetb+vecjabVfEYU7RtA7s/mMRDAyh+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNPIFm5Jr7W1GpmY9hKGURhTKAh/+8sPHZ8CeG7X3Yfky7AkdTXPm8Bm/4bnK9PrD
	 8dmdGcHy0EZrvrtTg3ucJH2gLT30HISv7g4wKQww0OgqqT1UcrcanSnKyL7P4Q8hTX
	 FxySr7/UQj4rwzsMdwrulT6FpUCp2WSGhpdWPsYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 64/82] NFSD: Initialize struct nfsd4_copy earlier
Date: Wed, 20 Nov 2024 13:57:14 +0100
Message-ID: <20241120125631.053618552@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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
@@ -1816,14 +1816,14 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
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


