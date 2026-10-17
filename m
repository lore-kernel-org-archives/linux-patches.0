Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE4438F253;
	Sat, 17 Oct 2026 15:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252538; cv=none; b=eow8eYOwd1mYLQXvykGBcs6ZMnnSaXHE961iB32pfnHhoAAQXhOXKK87ddla6J3kK5ZTShHptQ1V6ZVCf+YmTGHyKAwAK7FFBP4BbmEldOOJYF6X7FNkZQ7P2MWhVFdzrFCJa6ZHclkdrahPztyTrPG1GnouLI1yu4PJFlk48IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252538; c=relaxed/simple;
	bh=9qE944ZzCUV50w8VWnste54ynr1mgELpHrkLRv2VFsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgnmOj30cFPlZsVYz9Kf1S0waIbyqFPML9AKMQQtA9pG556Ve+iSIu7zsWZxAwlv9oeqZZ/hNJ/C7KFM69JIBP6KfOPOnMNL+b3gT28yL5/m/d24ZgHElLPeYcMdSqf20baMMNquRg20XJAUHtpLmUm8MmIi9EzSz1xi126ySuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQVRv/6y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQVRv/6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8181F000C4;
	Sat, 17 Oct 2026 15:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252532;
	bh=bBYV9MI0CP7Z1+QENkDQAKJOjh0INKAVAQ0yiP7/zkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQVRv/6yFrH4TrYM6TXPfSlvEWkwVK+4uqZgtoNmU/ubo1w/GPmz2n0sSWy1h4YSi
	 kBkwoUHQtfNm/MteZtfTJkebZ36gOdjKayXqm4AFdItyayErQhLF+GICqVGIpCKSau
	 bdABqZGg3HxbasGB1JbJELRB8lPM4D43fLu/u6Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubos Rendek <l.rendek@proxmox.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 12/52] nfsd: fix all-zero stateid in CB_OFFLOAD for async COPY
Date: Sat, 17 Oct 2026 17:54:13 +0200
Message-ID: <20261017155105.254897565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lubos Rendek <l.rendek@proxmox.com>

[ There is no upstream commit: this fixes the 6.18.y backport of
  d0beaee498e1. Mainline fixed the problem as part of the async COPY
  rework in commit f307b4f7ed17 ("nfsd: split nfsd4_copy into transient
  and durable async copy objects"), which is too risky to backport. ]

Since commit 9b4e5e9ba5ae ("nfsd: fix stale s2s_cp_stateids IDR entry
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

Tested on 6.18.56 with an NFSv4.2 server-side COPY between two
exports: with this change the copy completes and CB_OFFLOAD carries
the same stateid as the COPY reply. Without it, cp(1) hangs on
6.18.55; the affected code in nfsd4_copy() is the same in 6.18.56.

Fixes: 9b4e5e9ba5ae ("nfsd: fix stale s2s_cp_stateids IDR entry for async COPY")
Closes: https://lore.kernel.org/stable/7cc824c4-632d-49df-ae5e-cfcbb5bf76ad@proxmox.com/
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Lubos Rendek <l.rendek@proxmox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 898aaeea2059a..864eebb1f0760 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2084,6 +2084,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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



