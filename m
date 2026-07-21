Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4253DC4D7;
	Tue, 21 Jul 2026 20:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665807; cv=none; b=PG1KCcGHuRbTHJ4IWOI5PHCeoZs4Aq+hUAWnGFhxkpC9vLv4XBBOwcZ65UDVduJQv7nauLzEiS+YUaZ3gIaZT73tx8buWEIXA66KcVtNGxZbYZQj2GfMxgL1p86EAjM2frKN6c3g9ddguHkLCk+Q05XHh09DUOSWixvgZLiEKvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665807; c=relaxed/simple;
	bh=ZsU0wsyUbn/SqtVz70phQELY7kpGOhc3p6v0lYE1O9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfoiJXc1SbuucUoFLtfjDv8zOzyVTX5cYPS7/zhbrsgsBrof1VVqgEJ8n0cYQy5BmGWBPCj77tFDyIoHxkzK7BDV8y5LgT/klOA2njN379mkPhKwiPKfXwH4pnhFnUD8ORWLG02YANwExoxljHbVtDU0sZQVAO0zNDu/HfDvxSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2IPT/2H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2IPT/2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904BD1F000E9;
	Tue, 21 Jul 2026 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665806;
	bh=DuDg8KeXEyuZv0NMUTFQZ8DsljZAJYws58VmfWhHSYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2IPT/2Hq+S+erIQJHCAPA8JxYgcaJyqlr9RTqigrgaBUOZO5c5ZkOu+CUptHnWas
	 vf8OV/mTCt7h4T45ZAXVBFTbIUhO+LramtUNcObnhs0qmWcHLFiKrW5G1yUWx1oI9v
	 qYQrXRJmjKkLipo8M5WbVxaehOou1kvD4WB3CG4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0442/1266] workqueue: drop spurious * from print_worker_info() fn declaration
Date: Tue, 21 Jul 2026 17:14:39 +0200
Message-ID: <20260721152451.729934202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8692e75aa6d808..b59cc9f86d1595 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5119,7 +5119,7 @@ EXPORT_SYMBOL_GPL(set_worker_desc);
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



