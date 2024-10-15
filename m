Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF2B1C07C4;
	Tue, 15 Oct 2024 12:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997116; cv=none; b=UAFEvf/MJ/y4L7GIWjbFDvm5wvJNlRYT0Hb9SFX0J1D42L/zN+GoN6WgGhtK4AZXff+He3+txlwvYlyvgKp1Fxz1RRGnOQj6LquSIXM6nDepmsGXAeMOjEU3oMG+IHJKKG6rOVO84k8KDrjBMr7+obGO346TravaAvyEXgdaWgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997116; c=relaxed/simple;
	bh=ysYXStonbOmtYT5gH9e4xKWfMaCN6tiPtE8zytiu+Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TRf/RV2hJZtUI6TLgNbwoCqs58B9NKbkVWX3V1d6ST7AyPk73hb4muAyKNYUa4sr3TyG6mnnWvPYATi9VM/VTLrNf4PMmGOoSZjKKXj3PqAcPZVFH4SeGGkTt5nl7C1sZi9As5xKGoUMDqjFKXasQKPB6dJ98Lp8HpZ1fYxNxTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d2qKjYaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d2qKjYaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE3DC4CEC6;
	Tue, 15 Oct 2024 12:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997116;
	bh=ysYXStonbOmtYT5gH9e4xKWfMaCN6tiPtE8zytiu+Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2qKjYaMkR7d6FxDoFT/Y+CnUnNtR1WYKMKunR+OxSy5WQ7iJ+Tz1nMbE0qTzCg3q
	 PoakjGbf89dJuPCeDxIe337l62BcDcDHm50QtkBCB6td/LC7n0MVLmv4AVDSgtTt0o
	 LwWPiwERgKBH/lFd4MxxI8DDjpaEyHyUF4M921fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	=?UTF-8?q?=C2=A0=20Waiman=20Long?= <longman@redhat.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/518] padata: Honor the callers alignment in case of chunk_size 0
Date: Tue, 15 Oct 2024 14:39:29 +0200
Message-ID: <20241015123919.515269611@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamlesh Gurudasani <kamlesh@ti.com>

[ Upstream commit 24cc57d8faaa4060fd58adf810b858fcfb71a02f ]

In the case where we are forcing the ps.chunk_size to be at least 1,
we are ignoring the caller's alignment.

Move the forcing of ps.chunk_size to be at least 1 before rounding it
up to caller's alignment, so that caller's alignment is honored.

While at it, use max() to force the ps.chunk_size to be at least 1 to
improve readability.

Fixes: 6d45e1c948a8 ("padata: Fix possible divide-by-0 panic in padata_mt_helper()")
Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
Acked-by:  Waiman Long <longman@redhat.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/padata.c b/kernel/padata.c
index 2a514cf8379b4..41d5bf2fa2ad9 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -516,9 +516,12 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
 	 * thread function.  Load balance large jobs between threads by
 	 * increasing the number of chunks, guarantee at least the minimum
 	 * chunk size from the caller, and honor the caller's alignment.
+	 * Ensure chunk_size is at least 1 to prevent divide-by-0
+	 * panic in padata_mt_helper().
 	 */
 	ps.chunk_size = job->size / (ps.nworks * load_balance_factor);
 	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
+	ps.chunk_size = max(ps.chunk_size, 1ul);
 	ps.chunk_size = roundup(ps.chunk_size, job->align);
 
 	/*
-- 
2.43.0



