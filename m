Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7102650B433;
	Wed, 30 Sep 2026 16:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786252; cv=none; b=A58zxsS3+oJy5Siv4AxNk0GWu7KCR0b3TS/nw1aG0NS4Ig2KoZxGefJpa1C2Q74Un+nDvffSRnCtU76FbL7bMY/EYyMOQ1x32Br9fUOopHMXN89PSDTfgTGsHw6vTJCv0pnga3HqpAa21GL1rEnXCmTJntvYXGwEMqpBigFRriw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786252; c=relaxed/simple;
	bh=j4HRCSwzo6fLrhj7LHk8kj8n4b6mNbSbOgx/7MOqsYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=binEQsfP1vFdrl3gF6y2dQEUeiBSBC01ywb461524Xvzm5cUxWfUKKDcuYSs5FPsC7Tn1K0XVCch/vXlK546DeS4cuXdDUaC0X8SOE9TitaNIxIcp36HffE2TlT0wNDlu0g+EGJwSqDONyYsHopqOi/cgTyOVMCNuV83uBjVrgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmtrRZhP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmtrRZhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAB71F000FF;
	Wed, 30 Sep 2026 16:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786251;
	bh=GCad5gmrRySNaQ2oLOpkn+g96wax5VXkdo29dLaZ9Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmtrRZhPWKEfPe3sA80/kYJUaRDCr8CvMGnkA8n3Mn9EB8YboYYCRd3ev4FyDsUIC
	 CC7qvUuNsUXtiNUYyL0cj1YOxXaIoLF3MRNHao9Ey+uL9RZfWBUm4IeCh+2RTOMVG8
	 +MRgbtmDDwe3Ubh0SJjqObCELk0IOlrK40j3k2kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 797/982] bpf: bpf_sk_storage: Fix the missing uncharge in sk_omem_alloc
Date: Wed, 30 Sep 2026 17:25:33 +0200
Message-ID: <20260930152433.874465058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit 55d49f750b1cb1f177fb1b00ae02cba4613bcfb7 ]

The commit c83597fa5dc6 ("bpf: Refactor some inode/task/sk storage functions
for reuse"), refactored the bpf_{sk,task,inode}_storage_free() into
bpf_local_storage_unlink_nolock() which then later renamed to
bpf_local_storage_destroy(). The commit accidentally passed the
"bool uncharge_mem = false" argument to bpf_selem_unlink_storage_nolock()
which then stopped the uncharge from happening to the sk->sk_omem_alloc.

This missing uncharge only happens when the sk is going away (during
__sk_destruct).

This patch fixes it by always passing "uncharge_mem = true". It is a
noop to the task/inode/cgroup storage because they do not have the
map_local_storage_(un)charge enabled in the map_ops. A followup patch
will be done in bpf-next to remove the uncharge_mem argument.

A selftest is added in the next patch.

Fixes: c83597fa5dc6 ("bpf: Refactor some inode/task/sk storage functions for reuse")
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230901231129.578493-3-martin.lau@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 23cbd7b1b810d..9d7dfbb376ea3 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -577,7 +577,7 @@ bool bpf_local_storage_unlink_nolock(struct bpf_local_storage *local_storage)
 		 * of the loop will set the free_cgroup_storage to true.
 		 */
 		free_storage = bpf_selem_unlink_storage_nolock(
-			local_storage, selem, false, false);
+			local_storage, selem, true, false);
 	}
 
 	return free_storage;
-- 
2.53.0



