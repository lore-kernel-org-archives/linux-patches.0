Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7814235DA67;
	Thu, 30 Jul 2026 15:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425996; cv=none; b=gNu+y7liD7rHFF3Vfx+TLPv6iQ7VCMPTwccDG7TWqIQVNICWLjOPRHgCogS7zmR4b5rsRiDMaNN76rZYRH3YV48IcRilGWSElF9S3fxvj/ZDPmYnJp2P0ipofr4athxzXW+dirq0yUEJp6MjNw5jnJCY6Q8toYCPd0vv2cpezUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425996; c=relaxed/simple;
	bh=H2fU+J+wdge+s+jngaWPnwH02Mv0JeaQyy57+6Uuk9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyiC2VJYAuN6wZ0PQxYgK9/Gu8t4Kcv+baR4bP8u/yP1cefw2PkItcCOnCxHqy4UzvTn2KkBjN1ndzCYMEH3pVqorzW7l2Pupbc/nQUU9vNRaJi0AB/057aLRqJyndAJB4XMcvUcRdyViXIAO7W+5e2QlR/jY65g/Xm5yBozFgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4ZMTpoz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4ZMTpoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9268A1F000E9;
	Thu, 30 Jul 2026 15:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425995;
	bh=oYgT4chHZax+OISOqF7PjJ2U5yMJUGAZjztNart5O+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4ZMTpozARKnC6WtnkadesiCWIOwwAhtzRkMJulkvaWcWOUJNRHICqFgfWVx+5DTi
	 pYIQB2wwCzzBRhmMZw0pcwtUzMGtYmpOD7nT1n6Fz6TQIPcKVNOVEWlyu5avN29jx8
	 KwclCTXH3K8N/xr6E58slprEidZzWxNzWwUNXJtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 263/602] drm/nouveau: fix reversed error cleanup order in ucopy functions
Date: Thu, 30 Jul 2026 16:10:55 +0200
Message-ID: <20260730141441.498575903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit ab99ead646b1b833ecd57fe577a2816f2e848167 upstream.

nouveau_uvmm_vm_bind_ucopy() and nouveau_exec_ucopy() place their error
cleanup labels in allocation order rather than reverse allocation order.
On a u_memcpya() failure for in_sync.s, the goto to err_free_ops (or
err_free_pushs) frees the first allocation and then falls through to
err_free_ins, which calls u_free() on args->in_sync.s.

Since args->in_sync.s still holds the ERR_PTR returned by the failed
u_memcpya(), and ERR_PTR values are not caught by ZERO_OR_NULL_PTR(),
kvfree() proceeds to dereference it, which can result in a kernel oops.
A failure for out_sync.s instead jumps to err_free_ins and skips freeing
the first allocation, leading to a memory leak.

Fix by swapping the cleanup label order so resources are freed in the
correct reverse allocation sequence.

Fixes: b88baab82871 ("drm/nouveau: implement new VM_BIND uAPI")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881484D91A6F80271415F71AF1A2@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_exec.c |    4 ++--
 drivers/gpu/drm/nouveau/nouveau_uvmm.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_exec.c
+++ b/drivers/gpu/drm/nouveau/nouveau_exec.c
@@ -327,10 +327,10 @@ nouveau_exec_ucopy(struct nouveau_exec_j
 
 	return 0;
 
-err_free_pushs:
-	u_free(args->push.s);
 err_free_ins:
 	u_free(args->in_sync.s);
+err_free_pushs:
+	u_free(args->push.s);
 	return ret;
 }
 
--- a/drivers/gpu/drm/nouveau/nouveau_uvmm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_uvmm.c
@@ -1708,10 +1708,10 @@ nouveau_uvmm_vm_bind_ucopy(struct nouvea
 
 	return 0;
 
-err_free_ops:
-	u_free(args->op.s);
 err_free_ins:
 	u_free(args->in_sync.s);
+err_free_ops:
+	u_free(args->op.s);
 	return ret;
 }
 


