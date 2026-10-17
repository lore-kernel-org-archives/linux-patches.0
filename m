Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83A73A1A3F;
	Sat, 17 Oct 2026 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259937; cv=none; b=gjE3y/v/AXJrorfrGewbWwfylf8j4+HYhE4Y7ysxOGtie1vowU5rap63w8IMXmps3uc94BBgQQZnp8NLhWBFRd7/pxGvLXm1lxTu6m55hUiYVHL2w5vf/1TnAdL5+NahYy5jLStOqphNzlEr0rbmyFx2hApM0c5SYm/ub7zct8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259937; c=relaxed/simple;
	bh=c31DlQoQcZ4VwRdAf4SdIloPHYxoy68WIl3czGb+o/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=baQczEcjUpY1wa4duXJOD/m2gnE818BVyTtomHRhSdNi60fSwiESnwwcRyovPXFa56Y7yX6G3nbq+mIeM7jp5Kvnh7eJ7NurTHpXlLiYpSQNljGdhZvh8mi0AzN4Ypefr0SKPUjq59chrCu83/qSzmm/vx7qG6gVKlfLspZQ0aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JvIjke/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JvIjke/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDE41F000C4;
	Sat, 17 Oct 2026 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259936;
	bh=zfZQXnwu87rpg/lmivaezAFKhz4JNH4kdLXdcYzBkY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JvIjke/KksldtUUso+HsfnbieRTlAZE913H/3L236ZAICQiz1pq7/YE8jeLL0RIk
	 UWfvFFGe2MZ80yRm9F2JY/XeaJzhrW3XkgccRZF3Cgp5+EMwHATfMEDjYEc85f3Dfy
	 Z8VDKiGxtI2LROaFqZGcnLJld+wS+lSul5njS1kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1380/1674] NFSv4.1: zero referring call lists before decoding
Date: Sat, 17 Oct 2026 18:00:52 +0200
Message-ID: <20261017160506.587750604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d5f6437da352d..a03e7e1e48679 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -419,9 +419,9 @@ static __be32 decode_cb_sequence_args(struct svc_rqst *rqstp,
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



