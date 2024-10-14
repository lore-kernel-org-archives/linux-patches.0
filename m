Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA641AB52B;
	Mon, 14 Oct 2024 14:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917501; cv=none; b=G+o5u/qetRK+76wmo3aADRTj0UwOft7+lrzULlsOqpsI5I5gMYDadr9Zkv0Fp0ySrEN1AWuenTD2UnghBLtIyGCZLWSQ4HeAHFtv+t8irb+KLjIoOosLrKmxYyjQpb5VUMBx7WyVakJggu0zthhaG/FBbRRPXaFPPZ+aSiS8+yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917501; c=relaxed/simple;
	bh=0G+NJemiJu4eULsvgEB2mKh0uCk26G0n/rbmYp/3Iik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rVJ65HFWCnBP7noynnKQApedo5z4cwhcVt48z2IKlwf43wVhi26NW1spWWUIQ1oCBBp+8w/vXq+68eAZlVauC/cJ3IwHx4G3A1rwOh09vDSBKxSQ0s/Wbu71KVcpxf3oB3YnD6oM9urKkwerq1xOtWC6KnogWiLvVROlTzRVg+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3a3tH0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3a3tH0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB8EC4CEC3;
	Mon, 14 Oct 2024 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917501;
	bh=0G+NJemiJu4eULsvgEB2mKh0uCk26G0n/rbmYp/3Iik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3a3tH0khoTsI0+N4SSuCrkXTrKS2IG89mmrIoRSLqqByoI9j/uhp32JVl6kULnYZ
	 aXbG1n5BLSFHT4tvBRKq5UPXkMO2p2EHnsCYncRT+SZ8DE9p0jO3a2+m87O6H8cCv3
	 SS8M+CylYtuvF8rKg9Ti83PqdeZfZfAb/ub8u208=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	=?UTF-8?q?=C2=A0=20Waiman=20Long?= <longman@redhat.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/798] padata: Honor the callers alignment in case of chunk_size 0
Date: Mon, 14 Oct 2024 16:09:36 +0200
Message-ID: <20241014141218.821447137@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 11270ffca54e0..87b4db3772866 100644
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



