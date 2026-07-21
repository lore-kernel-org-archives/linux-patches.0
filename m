Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9F740B11B;
	Tue, 21 Jul 2026 15:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648797; cv=none; b=V1RDXvZxRVjAAjm5WXirQKQ6l4cB7gyPgCA8XQzbSvUOgpRFVIRWC+6eJ7Q3WelyGH+x/Ulc5T+VcXKL4tFWum8iJafN1QdpWKp0ElOSeilKNPIwhVcduppX7kOolPS/T1nJA8VHtbfUpn/IkptgInHjLRWRR/nSIsUnJZzeaII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648797; c=relaxed/simple;
	bh=/p5FxDEq86VjcpJFPAd7Iz7OGXU++6UXB3XzY6Su9GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5dbWwXgdl0FhrBtf/sBPbD/mway94d8OwP10OKp3o2XvZaE3W7CNaZheLI4KhxQ5+ug5n3fRt0wDBFDThlpZs1NFzZn2vWpV0LgTQwTS4nK1EB3O6GaYNtXEbbHFMKJlx1INDHibpYHoHZ4/YhRupcMAU7a3vhq/nw3wmRehsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2EyqmbE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2EyqmbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CBA1F000E9;
	Tue, 21 Jul 2026 15:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648796;
	bh=+BuR6/0XIM2qGjYY/Q3WJlNVHXsxjanzfXXPf6ctNm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2EyqmbEiFH9beZyqB3JsL8+UHMLULHtdZJRlB/wD6Vk0y2xjTcCHqyVmdNN02KK0
	 QT/Zif0/0dLc0AOkTapw9h8gMC/MvNMxVH2pLXZD+lx9PaK2tk66kGq95HQfvdxTss
	 H8dwTLEN927QbNRoT65LQErnBKTsbF5+zd+O/Trc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0335/2077] workqueue: drop spurious * from print_worker_info() fn declaration
Date: Tue, 21 Jul 2026 17:00:08 +0200
Message-ID: <20260721152600.585065812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 33b721a9af0223..bd79b3b5ca878f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -6310,7 +6310,7 @@ EXPORT_SYMBOL_GPL(set_worker_desc);
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



