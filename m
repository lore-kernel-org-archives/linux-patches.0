Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED454372EDE;
	Wed, 20 May 2026 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295415; cv=none; b=JhurmWN6bfC1x2ZpoQOdv4vrqCSgxZB7zyZ+bh9FIOAaRN7w92Jz4QMJv0B9VXnRDjgrvKdqlwDadPXIPpCusdsZ3T6AI+L5A2dfAADKmHl/rUkhtIpIn/itloWdi5RzXo8DuF8xEd5/al1Sp4cgPHDmYqI/HASQAuVThU+LK+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295415; c=relaxed/simple;
	bh=9oKamaMKYmVCdXM/nT7E6WiK5TTq36ojHVfvIEB9DyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMmXZ4dqLEqKuxKtvu0Dvy23GP5sx8iXLeatT7FZ2pksJVIKsUQNB0Quu3bTR4tXxlJjeaLNTLShgMYxBf27n6O56oAtcBy+tKbhzoQIcNiK/hHPjd5VTSIODmestVtkS+Hm1r8zBZSj2chj8h+ngtbFiicWg1vD6+hNAeJUYtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Im3fzvzZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Im3fzvzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4BE1F000E9;
	Wed, 20 May 2026 16:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295413;
	bh=cKjsDEOSkrwuVju9+Duhw5qUN3KPbzs4AHscOZhKc1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Im3fzvzZqXf+mqlUAWsTamdAH3w6qy9mENBDZLFJWHuO6XppclxXHngPuoSQXf/Kn
	 c9AUJdrizK8JbpcX+wveAhijfxalYuMp6zFN7WKT8Yi21bIcOOWxEGPZW/d5HMOJKU
	 aC8HN4BmQS9iUaP72jORMBA1CeS9v7y5yf0HkHtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Yang Chou <yphbchou0911@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0410/1146] tools/sched_ext: Fix off-by-one in scx_sdt payload zeroing
Date: Wed, 20 May 2026 18:11:00 +0200
Message-ID: <20260520162157.476697783@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng-Yang Chou <yphbchou0911@gmail.com>

[ Upstream commit a3c3fb2f86f8a1f266747622037f90eab58186ad ]

scx_alloc_free_idx() zeroes the payload of a freed arena allocation
one word at a time. The loop bound was alloc->pool.elem_size / 8, but
elem_size includes sizeof(struct sdt_data) (the 8-byte union sdt_id
header). This caused the loop to write one extra u64 past the
allocation, corrupting the tid field of the adjacent pool element.

Fix the loop bound to (elem_size - sizeof(struct sdt_data)) / 8 so
only the payload portion is zeroed.

Test plan:
- Add a temporary sanity check in scx_task_free() before the free call:

  if (mval->data->tid.idx != mval->tid.idx)
      scx_bpf_error("tid corruption: arena=%d storage=%d",
                    mval->data->tid.idx, (int)mval->tid.idx);

- stress-ng --fork 100 -t 10 & sudo ./build/bin/scx_sdt

Without this fix, running scx_sdt under fork-heavy load triggers the
corruption error. With the fix applied, the same workload completes
without error.

Fixes: 36929ebd17ae ("tools/sched_ext: add arena based scheduler")
Signed-off-by: Cheng-Yang Chou <yphbchou0911@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_sdt.bpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/sched_ext/scx_sdt.bpf.c b/tools/sched_ext/scx_sdt.bpf.c
index 31b09958e8d5f..2e2179d0f509e 100644
--- a/tools/sched_ext/scx_sdt.bpf.c
+++ b/tools/sched_ext/scx_sdt.bpf.c
@@ -317,7 +317,8 @@ int scx_alloc_free_idx(struct scx_allocator *alloc, __u64 idx)
 		};
 
 		/* Zero out one word at a time. */
-		for (i = zero; i < alloc->pool.elem_size / 8 && can_loop; i++) {
+		for (i = zero; i < (alloc->pool.elem_size - sizeof(struct sdt_data)) / 8
+		     && can_loop; i++) {
 			data->payload[i] = 0;
 		}
 	}
-- 
2.53.0



