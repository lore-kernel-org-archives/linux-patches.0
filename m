Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B66431A4E;
	Tue, 21 Jul 2026 22:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673563; cv=none; b=jUd1KvfFRB+RXUliJ1KTCwMy5Buwu3nW9hgjDGBkwfKJ7P274A2TRltCYnjf7XYp3yFD6aL34wYoeyjKZGdGLgjNLi1AvciaQZJoylt7WVlzxoYZDeqlku9Rgisu7yT0JRCExZuXQICpiDknuG7hmpjul9opAKexVwv0YE8MDUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673563; c=relaxed/simple;
	bh=+PyEi4SkV9rugCJYgBE6OOePi9SImvWORu/pHF+pXaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSffluHWgMfrzWctw1rrIgK4krgC8kq9it/VB9EQWRIh8go0D937z0sMy7H6i1L+j9VnnRKoIxLbtB9yrI3O9rNGK5UwFq4Icb4ieiiZjzesc2z1bu03iqO+BaTyMYXmV7v8jSNGBFEVdclrgAB4Nzz/u8WL+jgq0GM8RmxsW+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeZ+yET/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeZ+yET/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848A41F000E9;
	Tue, 21 Jul 2026 22:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673562;
	bh=P0e6BjprtYGCc7NwLE2zwIvYUrpIMsMPz5vpgFdchDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LeZ+yET/+kpr5Ta+SIMEoP4iuPcdDFr8gY2jI8UvS6MJ8bgh0cblICKxL216TzFtM
	 IJ4csiSvvCOIvi6SYvRBhGgCGAW3lkH+d9Jw/Uti/EytN4+6s9NiqKTPgUjvFmU4wB
	 G+ppkEbuNYFp+pOXfraL8zSgUseGV7XlIbii9qKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/699] workqueue: drop spurious * from print_worker_info() fn declaration
Date: Tue, 21 Jul 2026 17:19:27 +0200
Message-ID: <20260721152400.390666861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 63140e4dd5dfca..eeda0e263cbfa1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4651,7 +4651,7 @@ EXPORT_SYMBOL_GPL(set_worker_desc);
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



