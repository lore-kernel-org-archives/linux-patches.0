Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0538644AB61;
	Tue, 21 Jul 2026 21:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668983; cv=none; b=jhhWFiCf2Y3yMSm/aJOSV/FiHmLz7Vv8byWAG3Kio1eDENXZttiWP10j1DV8bk4Qi8kUV4Xnt2lwwHWYb1/g1OC/DP2oJOWNm0wyRDb7mCrUvnyQ2IG1c0qvsHAKZXAFFA3ropvRREntevIH1e7dsr7TjPJ2fKdW4dY2PTQEbjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668983; c=relaxed/simple;
	bh=h/IZ9LhcsyOb8JFpsdBn1sUPDqawrHXF7qnI8KjK1/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=teiKWu3jzYQGM1lN8GV9SmLQLxIjm88y6WK/WBYpNfwsZIl/P3/Xf/3xrWcK2cm2l4uxG5p/pCWHKity03F5blMr2BhBX8JEu9KeD3AkS3qTCSHUBz6LEOTJvINPGbTOGyLLJjPfWSTxc2R8wdsjpX6Nj1X9VCSOlWLTFyH2wNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXY7i46K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXY7i46K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611281F000E9;
	Tue, 21 Jul 2026 21:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668981;
	bh=4jqNn7/8WlKp8hqz78K5FtX39zybZAnuMprQbT1b3CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXY7i46Kr7WWsjjofr2R1+S/uSJlSCUGw5jZTiBku1kjaEOnO7eE+v3Ej+6TeNeh6
	 L9ZM36wvF8lBkUFTiQFReYTRVZhDeoXjQQavLPz2O9BcqgneJX7zQFFuNXqcJ/WDMs
	 MU52uVWzn62pWdPaa61455GY1UcSPyzMHTIS+YrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0339/1067] workqueue: drop spurious * from print_worker_info() fn declaration
Date: Tue, 21 Jul 2026 17:15:40 +0200
Message-ID: <20260721152432.179628532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 93303148a434f4..7eb712b88e2a41 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4672,7 +4672,7 @@ EXPORT_SYMBOL_GPL(set_worker_desc);
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



