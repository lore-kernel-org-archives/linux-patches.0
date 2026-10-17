Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F5F4CF477;
	Sat, 17 Oct 2026 15:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252485; cv=none; b=HtqvWZ/HJtfGCKoSzpHDhDEgezmpn2BtAaHSuaQsJ5doi9jWBaNA/PsQdS1M8f1n3QEcgYiw/BSY7xAYZ4orcZYu1XNb66TuAVYrr0Ziqyq0OiRrIamTv04bENnqRthKorKuD/xhlsHbswq7boz6Nq8T6FLEsDueqbOl8+ARwog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252485; c=relaxed/simple;
	bh=Xm+dOrIsB/Pk13R031XDyFOmcXvdC0DxYY8C+snaJyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTysjCMmWGP3fCsBlJPWR8I6aZTHmY/dTj1e5krAeP5277/phlRHxy2sWTAl5O1MeUKBHdR9VsDjJANcACvBHFdajVM78pSsySzepDtiV8DqSVB0cXhGWjIUnvs2+H3DMSvEzZcnxsDRDrueC7LCJnyYAEKOn3kicLvw20sH+M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVOpsuEW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVOpsuEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9CA1F000C4;
	Sat, 17 Oct 2026 15:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252483;
	bh=Hr0Oz9j1Lc+ffQ6c0pynFoVdfAaDeAZ0Mfu28rnUShE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVOpsuEWMS6G6OmQCu0U2NHAh3f4CZFQLGAKNHJwBzL1kjIgXCJiNWLvdBP/F+LLq
	 dx4iSX7rSvLyVOGNgSHDqg5TR0OiLUziNuTq1VI9998AJvYyZXu3tppsdKfBO0ykUr
	 mUTy7O2Dzontru+EquwUH6xvbV4NoGWljF5q6rGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubos Rendek <l.rendek@proxmox.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 01/10] nfsd: fix all-zero stateid in CB_OFFLOAD for async COPY
Date: Sat, 17 Oct 2026 17:54:30 +0200
Message-ID: <20261017155059.760126015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
References: <20261017155059.698368299@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lubos Rendek <l.rendek@proxmox.com>

[ There is no upstream commit: this fixes the 7.2.y backport of
  d0beaee498e1. Mainline fixed the problem as part of the async COPY
  rework in commit f307b4f7ed17 ("nfsd: split nfsd4_copy into transient
  and durable async copy objects"), which is too risky to backport. ]

Since commit 14b978e8d05c ("nfsd: fix stale s2s_cp_stateids IDR entry
for async COPY"), nfsd4_copy() calls dup_copy_fields() before the copy
stateid is created and then writes the new stateid only into the COPY
result. The async copy's own cp_res.cb_stateid stays zero, so
nfsd4_send_cb_offload() sends CB_OFFLOAD with an all-zero stateid. The
client cannot match it to its pending COPY and waits forever in
nfs42_proc_copy().

Also copy the new stateid into async_copy->cp_res.cb_stateid. Calling
dup_copy_fields() after nfs4_init_copy_state() instead is not an
option, because dup_copy_fields() also copies cp_stateid and would
overwrite the stateid that the backport moved to the async copy.

Tested on 7.2.10 with an NFSv4.2 server-side COPY between two
exports: with this change the copy completes and CB_OFFLOAD carries
the same stateid as the COPY reply. Without it, cp(1) hangs on 7.2.4
and 7.2.9; the affected code in nfsd4_copy() is the same in 7.2.10.

Fixes: 14b978e8d05c ("nfsd: fix stale s2s_cp_stateids IDR entry for async COPY")
Closes: https://lore.kernel.org/stable/7cc824c4-632d-49df-ae5e-cfcbb5bf76ad@proxmox.com/
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Lubos Rendek <l.rendek@proxmox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 939749709e416..7c29557962b0e 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2243,6 +2243,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			goto out_dec_async_copy_err;
 		memcpy(&result->cb_stateid, &async_copy->cp_stateid.cs_stid,
 			sizeof(result->cb_stateid));
+		memcpy(&async_copy->cp_res.cb_stateid, &async_copy->cp_stateid.cs_stid,
+		       sizeof(async_copy->cp_res.cb_stateid));
 		if ((READ_ONCE(copy->nf_dst->nf_file->f_mode) &
 			       FMODE_NOCMTIME) != 0)
 			async_copy->attr_update = true;
-- 
2.53.0



