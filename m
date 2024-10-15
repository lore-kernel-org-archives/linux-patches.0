Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B769E1E9078;
	Tue, 15 Oct 2024 11:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992410; cv=none; b=aid99Q1MMmGl9X1AETjNElFeHTrNSpkO9TXv0/p2d8SLNtSFU7Peh4KU7gqb4x1T8LiYIWx+xZzspEtaeRoCsEuhKlrUxGZf/3Ge2LR4CjDp3XMF2QSCB92QFDiR2YeQ/hyiKEOxbfYqXvNQ2vIm4yVuNhXlJgi9EYt57Vx2x7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992410; c=relaxed/simple;
	bh=1nO4Y8eCh2rhxlJHUOqAb+guTv6L7ELKP5qGzqXoHiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YibHcv2W45QzfL5EdMkqPR0mxznfiftivmbfEE98Ji3RJyF18J90VYCq2Pf88pNcjCVzZuimPtEqQEmWH45Y2goOrFJ95/jM9dv1MDi6oH7oVR/O2EVIh0Z59XivPVXwASv1xUHPjx3Fc2K61ZcciDolJ7pklvRzH9qMadJFseQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rj8RlZQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rj8RlZQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2017C4CEC6;
	Tue, 15 Oct 2024 11:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992410;
	bh=1nO4Y8eCh2rhxlJHUOqAb+guTv6L7ELKP5qGzqXoHiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rj8RlZQyn0FnInlOOfQqSbuFG7T27tGr52mk1fIU1RVLL94L5Oiwxn+VsNL9wEDql
	 blzSrqlvop+dKpZOCwIR9+NsDrTRgvTo3R1CJb6LNTGb6456OgVdXMyxof03aFs9Hq
	 5feqsZrf5vY2zGpQK1rEU+mih3OUnHVl/l0KSejA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	=?UTF-8?q?=C2=A0=20Waiman=20Long?= <longman@redhat.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/691] padata: Honor the callers alignment in case of chunk_size 0
Date: Tue, 15 Oct 2024 13:20:55 +0200
Message-ID: <20241015112444.606293841@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7c52f9de5d4ec..f567b54d79639 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -503,9 +503,12 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
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



