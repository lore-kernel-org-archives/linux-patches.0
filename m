Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994C546D091;
	Tue, 21 Jul 2026 17:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656163; cv=none; b=AH8ATvHt30CloS4ABrXKTXyWir7+BDd5nu65K233TFt3LbWxQt2BjYCZSpl2cSbn5vvgJJv2K9RxPnN2QLE3xBJfVN3A5ABcwkpNIEsMKALXdF3YMRWbpmNkPv/Avl1AFYhQJ5+76PXMkvOuhXlfRSnbwDZiMOVvMgGHNG1mHe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656163; c=relaxed/simple;
	bh=LMieHmeZHhTRFlijrKH145NICRCxRB+Xt2MpkzZoR7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flTbAxHCrBpCcNRuJxkyyzG68M7HGjWN7WcYiReKvz1p5+qfs7fX4SBVSYaiJZtbxnSegFY5QKZ4VZMiQ6TjpQfrPWLNgLsn+CUjVZcQr0J3cm+/VcFMcc/JGJm/Ne+YHGJ46N5KRN8pUdItqWrtJP41VkoHNDfuToKzIL66UpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWsgRU33; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWsgRU33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BB11F00A3A;
	Tue, 21 Jul 2026 17:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656162;
	bh=g06OIZCjFR/I84tXwoL2Au/qqUw36zjlFlZp2z9LR8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWsgRU33Z/mdsgzwNbAw6DmXNue1GRMAWGRsp72eNqnotOOvcpOkfEZUVk8QndG9S
	 WglNm9fo2Lzq1OofsYQNyQ6eKNzeJfFKt7ik1wdhRb1jNrGSI4Rlj+aKf7lex/kZFd
	 HEywetNPcjOzyTpgq/K+luIvF7v9KamxtQ4RfzRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0240/1611] workqueue: drop spurious * from print_worker_info() fn declaration
Date: Tue, 21 Jul 2026 17:05:56 +0200
Message-ID: <20260721152520.413116924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 611583a76ea97991b0f65ec1ff099eac7fe0bae4 ]

print_worker_info() declares its local 'fn' as work_func_t * but
worker->current_func has type work_func_t (a function pointer). The
extra level of indirection is wrong and only happens to be harmless
today because every supported Linux architecture has
sizeof(work_func_t) == sizeof(work_func_t *):
copy_from_kernel_nofault() reads the correct number of bytes by
accident, and %ps still resolves the printed address because the
stored value is the function address regardless of declared type.

On any future ABI where sizeof(void (*)()) differs from
sizeof(void *), the nofault copy would transfer the wrong number of
bytes and the subsequent %ps would print an incorrect address.

Match the field type so the intent is explicit and the code does not
silently rely on equal pointer sizes.

Fixes: 3d1cb2059d93 ("workqueue: include workqueue info when printing debug dump of a worker task")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a7793c471cfd8a..20c79180fbfa9f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -6232,7 +6232,7 @@ EXPORT_SYMBOL_GPL(set_worker_desc);
  */
 void print_worker_info(const char *log_lvl, struct task_struct *task)
 {
-	work_func_t *fn = NULL;
+	work_func_t fn = NULL;
 	char name[WQ_NAME_LEN] = { };
 	char desc[WORKER_DESC_LEN] = { };
 	struct pool_workqueue *pwq = NULL;
-- 
2.53.0



