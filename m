Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC5125771;
	Wed,  2 Oct 2024 13:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875395; cv=none; b=CBMM0i9R5OVDb4wHTxSRLfMb8ysEP0L38psSHFLDSB6fm3SD+V0HztksKp6EuCaSLeWjOJtOMP9NUN7l0I9G6Me/bFpT+Q9+wNIjH4jbU46J25ZnKPOZIp0udh43QWvsV3ZfgN1Eunb6VuzAU0cqZUKLVN2pIHmRKQ1+ddJF3e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875395; c=relaxed/simple;
	bh=OXgauTtYtAYaeGtVetKMQZvDvDTuDVy7fPxDjEShmzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dhz0g/IFiKtHCRU/MAG5RxA2QolIwz/8vDdyOSPz10waFwMU7Vl4PoYaWCCcHz7ZanHcVDaZFyjxg0SmQu+lhu6hAEMqCs99p2KOW1A3KiTGeItxkIuyKoJbzY9bcADR/tPe/4GaOU4VXDFCtbfBikt0jD/nUlb8KbAQgF3YHFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1XTmyGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1XTmyGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E46C4CEC5;
	Wed,  2 Oct 2024 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875395;
	bh=OXgauTtYtAYaeGtVetKMQZvDvDTuDVy7fPxDjEShmzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1XTmyGAYrm1Cp1kQUNyd6ScOs2oG49sU40I2osMBeCIOJdwx9E3LxWV8MqEafu+J
	 qeHgzHWpwdASWvu7HS+vt2e+AxxpHp/Gh0wDsG1B9OVqNTQGUgSeY2/px/M43YGmTV
	 BC2wmxXz4r6HzD5nb0P5UQJZJ5egxom61mZX88xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	=?UTF-8?q?=C2=A0=20Waiman=20Long?= <longman@redhat.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 056/695] padata: Honor the callers alignment in case of chunk_size 0
Date: Wed,  2 Oct 2024 14:50:54 +0200
Message-ID: <20241002125824.722532090@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 0fa6c28954603..9e98afe72a334 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -512,9 +512,12 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
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



