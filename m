Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5D44248BA;
	Tue, 13 Oct 2026 12:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893963; cv=none; b=iO++w+tNz/hGttpF0wCuGTAoM7OraCip6YZuDu3UgeVPSaNSx8AXdLdIKBoibVl2jfZY6PQsKpRXe/ZjHz+HMj2dOtn05EbPi+1vtpA6ktXdBumjOmIqtqzLiN5kcToHEwrLCRaMwPViLsoobjf2cxwkIbM4K5z6HISBv9YrwiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893963; c=relaxed/simple;
	bh=Rj/tk8vpCn64W0+12oeYzbm2cHdAMKvgKv55jBG6EMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RB1KPNJ2XlOb9HRoEgPnZ4kkFymKPbHLF7zHd9+BUFx2GiUPrdRDwNrwPuKSYrOtk7TpM6b71TqwsedpzIu/V3A5PDj8wWmNNyTTOvejffzTKuCfwtrUN5KHgwPDoU0yYd0QDJFGa5rAt5BwrOFNGKFZ53BTIQFZRUl+8LDlTBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGKBwkpG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGKBwkpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D851F000FF;
	Tue, 13 Oct 2026 12:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893962;
	bh=BQiBwqXBlG/4Vgf9DaXC6YXgca8K4YN9tAD1K666cQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGKBwkpGaM29M1W7m+9W3H96pKD4Qkf21lqEf797vqHqaMsZwEYLFEX0qZroB5Xds
	 wINLaB+LA/RACNRwWjCrOYqGGa7KVxfXKhI0OAiX4xLPd8rGZODgX+h+j3PsYA6dQb
	 ua5RURu8ba3tRR+kQJ5vmobpPjhAPEj/nTQKGn6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 402/621] NFSv4.1: zero referring call lists before decoding
Date: Tue, 13 Oct 2026 13:36:37 +0200
Message-ID: <20261013112930.380728442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 8fa4804fe62ca4155a2d8fc2789d630376cbf2fc ]

decode_cb_sequence_args() allocates csa_rclists with kmalloc_objs(), so
each referring_call_list starts uninitialized. decode_rc_list() assigns
rcl_refcalls only when rcl_nrefcalls is nonzero. A valid list with zero
referring calls therefore leaves the pointer uninitialized, and
nfs4_callback_sequence() later passes stale slab contents to kfree().

Allocate csa_rclists with kzalloc_objs() so every rcl_refcalls member is
NULL from the beginning, including valid empty referring call lists.

Fixes: 4aece6a19cf7 ("nfs41: cb_sequence xdr implementation")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 4254ba3ee7c57..ada04a7230c22 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -422,9 +422,9 @@ static __be32 decode_cb_sequence_args(struct svc_rqst *rqstp,
 	args->csa_nrclists = ntohl(*p++);
 	args->csa_rclists = NULL;
 	if (args->csa_nrclists) {
-		args->csa_rclists = kmalloc_array(args->csa_nrclists,
-						  sizeof(*args->csa_rclists),
-						  GFP_KERNEL);
+		args->csa_rclists = kcalloc(args->csa_nrclists,
+					    sizeof(*args->csa_rclists),
+					    GFP_KERNEL);
 		if (unlikely(args->csa_rclists == NULL))
 			return htonl(NFS4ERR_RESOURCE);
 
-- 
2.53.0



