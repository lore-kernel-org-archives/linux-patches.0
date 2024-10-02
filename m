Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245E01D07A3;
	Wed,  2 Oct 2024 14:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879250; cv=none; b=KOU6CPID0EVrp9M3npsBWeFMzknB0MkByx2WUQ8IJQCNX8sC7yJS5grC7YbtTlFIpDOvHn1m4Q7ZS0nLYBsfYJzjXdCdjbSbqRgcMQp87TCLrkD0kXOgBGy7uGBVbJIFYTC+g5FcLNWBYWjZ/4ZqzFAlLEBIQ8nL19EVn6hxLCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879250; c=relaxed/simple;
	bh=Bi16uHbI22TnRZM6HB2rJNMU00eTQaAPws4O7hUBbAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fTwtd/YEqJrOvAmWYlSdn9wwjke7RRZg7+5G2JkemGPotaeRTx9RjD5m7S6HEEb7DfR08QSIbbm+al37iELncPgquSTLAord1/lCQ97uJxdPmsqYdq49J8fmInFVe/CvGuSaAK1e6i/ALxy2Ee1eqMknphc1S8XlpfMaTJaqF5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qf8wfHGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qf8wfHGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F290C4CEC2;
	Wed,  2 Oct 2024 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879250;
	bh=Bi16uHbI22TnRZM6HB2rJNMU00eTQaAPws4O7hUBbAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qf8wfHGJx0GkufW0K17fciKMFVIQAshAqATwGroBmL0i8Zom7ZCW7D/K6I5j21ON5
	 2jFs4AliiiEAc2CyiGJcvIw2oMdrTzZou3ZKfMN1XWfQBG5z0iAR9NlKRONfBPzeX4
	 XqRtmCCftZm3/Ao57otNd4IIJAxn8Ziyunb2D2Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	=?UTF-8?q?=C2=A0=20Waiman=20Long?= <longman@redhat.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/538] padata: Honor the callers alignment in case of chunk_size 0
Date: Wed,  2 Oct 2024 14:54:26 +0200
Message-ID: <20241002125753.090936299@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 29545dd6dd53d..da788a58d19cf 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -511,9 +511,12 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
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



