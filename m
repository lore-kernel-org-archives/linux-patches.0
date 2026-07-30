Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CB94457AF;
	Thu, 30 Jul 2026 15:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424280; cv=none; b=jctbS9uw69+AqQ4kBE+mbAOM3KKGwZdezzgtG1N5j/SnfEOJnX+7ahMSZWvLnawWcdvSeiuzP+A3W05SA8k3MAayBoKdBiuMG8jkJ4eUya39ehrGoj8E39tfTVeD9vEYM6QG3Dwt/xIRXkfwSLbDJdQdGAUxIL+YPnvCZatNvbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424280; c=relaxed/simple;
	bh=67XRbdVoh9kuw1NRUir+iHkVvwMAljs6sydn6aB9+3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6mIzIn4rzAb25v7l5rVvN1t1SY9CqS9E5GCce1NurVmHeBBWmmpgGY7k/Ke+ON0mTBfP35mekBdFUmKY/C04fzVj8OG3iQPdDgltzIcvTSS2X8xww6NxCoxYMSTbim3kI2IZap6Ciuh5HYLY3ZyNFFCkzTXpNSM0cgudGCCTLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQt+R6az; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQt+R6az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7E21F000E9;
	Thu, 30 Jul 2026 15:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424279;
	bh=amIN6yEq/bNCB7ZctTnwB+YqJgsAyTkWbtUWEWWBdFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQt+R6azac/1PurLVTKTgiFwhNIin8wKy+k5HO1a1kb8Y5VKcoamWRKd9z44RV5NU
	 tEzM5hVWheSBLMtHcVgFhkCIODDkviqT9rpelxgCPoEdm897joVXqLQRmUZwdRP84U
	 6KM8gr6vuYQIJPs82p0Y+n+NDHx96FI7g3So9gSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 338/675] drm/nouveau: fix reversed error cleanup order in ucopy functions
Date: Thu, 30 Jul 2026 16:11:08 +0200
Message-ID: <20260730141452.313290599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -331,10 +331,10 @@ nouveau_exec_ucopy(struct nouveau_exec_j
 
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
@@ -1711,10 +1711,10 @@ nouveau_uvmm_vm_bind_ucopy(struct nouvea
 
 	return 0;
 
-err_free_ops:
-	u_free(args->op.s);
 err_free_ins:
 	u_free(args->in_sync.s);
+err_free_ops:
+	u_free(args->op.s);
 	return ret;
 }
 


