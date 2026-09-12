Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CF7374E6F;
	Sat, 12 Sep 2026 09:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204819; cv=none; b=T6TrAOFwNaUWoWYOAvxxVDMDhFl71ChxoJbFVAFY+LjDlHN1kQ4NMBUAURSuARmzVGUzj0ULzMwRT240enrehktwk0Uo9Z0KEC1xG9d5R9eKNymjzCg2ptPZmXkHj9LSzRgzoCzpJ1GEzBoQe3XEZHOx5d7y4Pv0GvMdPjwit8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204819; c=relaxed/simple;
	bh=Yw0xdyN0QGXztq6rkeFR09K5J+hSlPq4YIwuu4+zz6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ri1Ti2qVEm2bEYZgv3Dkb4+RLAK3Y1LNHqD78DdQe1Tx0pEW2RTTLioB/Kbpiv4CSbqHxLREbHNPmeKblDlA9EyuAHYkLg6uO605Cy0vXzQQ7EqUFGYFwRIDI6eZ2H92mPh+QClG8JGySfCbZzfsPzT0NDWSdIKjXuvQlq1Okis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GzrT8H4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GzrT8H4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD631F000FF;
	Sat, 12 Sep 2026 09:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204818;
	bh=1bikAxTKFezG/LStzm1mUJifaIzwEGEh34u/ZsFmZ8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GzrT8H4fQiPWoiwGe7ZZaxLn9toNolc03+/C8XsIUKOd3B1CSzplwP3L23+erGtND
	 YolwBeoyjQXwW2McWFAkexILOPv6rTVfCkcSci8QKJ450j2OYqtjrvBdPU+hcvKkoU
	 OROLAKH7H6pyZFh8F9noWgGtdLiRzJCIPWpAIrw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1689/1815] NFSv4.1: zero referring call lists before decoding
Date: Sat, 12 Sep 2026 08:57:19 +0200
Message-ID: <20260912065728.633194672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 fs/nfs/callback_xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 4382baddc9eed..a6406707ede6c 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -417,7 +417,7 @@ static __be32 decode_cb_sequence_args(struct svc_rqst *rqstp,
 	args->csa_nrclists = ntohl(*p++);
 	args->csa_rclists = NULL;
 	if (args->csa_nrclists) {
-		args->csa_rclists = kmalloc_objs(*args->csa_rclists,
+		args->csa_rclists = kzalloc_objs(*args->csa_rclists,
 						 args->csa_nrclists);
 		if (unlikely(args->csa_rclists == NULL))
 			return htonl(NFS4ERR_RESOURCE);
-- 
2.53.0



