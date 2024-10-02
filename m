Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD561D0499;
	Wed,  2 Oct 2024 13:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877335; cv=none; b=sHKZ3cCny3fjh4VwJ2EiXGgOWQweg/u5CD+3aMRpIDey0rmITYz06H10FqxekUNJWcJNbjB3Mai4b5fy7mxOsbD6ZhdYhVHTbITeqJSW2hfKRNOurbpHVr3c1GETRLZonyLN3C9x+byJru5wXRn1RjPBrPhx+PXoA0FxW0E1O6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877335; c=relaxed/simple;
	bh=FDvsKKHW52m3SmosQx0nwSthRc1Z4VgNpkKsM5KQFeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GP/sgYQ6rtkztAyH8adwrx5T2YntvBM5nSR31b4Jk0f7weAGdcTd0kk9cBnUPw89eRkP2QEnV6sX3FSdBv6pMtAWzE0Czvkf+JSc1kNSnKhwPwg9icq27q6v8bRG6sIg0/Ddt7mgJLUN9LxZzsy3Lbi6WJyNwFaisDiq4nCLPhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRnZk9bR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRnZk9bR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C003CC4CECE;
	Wed,  2 Oct 2024 13:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877335;
	bh=FDvsKKHW52m3SmosQx0nwSthRc1Z4VgNpkKsM5KQFeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRnZk9bR/66kW40Dhp6hbL/i6NF/Zb8DTuUKUKK8C9Iv0GL7w7sGyI4z8SiHqIoH0
	 1G95MLCkR50OaeLR4exda/BtYmOL6DcauICUujdE2U358+CZyhdyfkxaJIC6HyEc+z
	 8xhbyeNQ5nzIijTFe3Kydcqh1YjY6/E99Bfdu9Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	=?UTF-8?q?=C2=A0=20Waiman=20Long?= <longman@redhat.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 047/634] padata: Honor the callers alignment in case of chunk_size 0
Date: Wed,  2 Oct 2024 14:52:27 +0200
Message-ID: <20241002125812.960790064@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



