Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6B42E5414;
	Tue,  8 Jul 2025 16:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992463; cv=none; b=j0v/OHJfsi3kFRn/BX0MarcGMrQ46aUYae4FEmnkWdESTrdrYhEAeQ0XT0St5kmuMp9QTYoS9/RI+J0uJXMBbu5TOW//JBM4bMQ4KEzSZnKzxeoSISaCxAWqwgfm6ezedkMJmAIy+DC8/tRvVoc+hCm6xijaoWOZzvCC2ddkJVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992463; c=relaxed/simple;
	bh=d0JE6yWSujr6ZLEtV2ZAITHAGFcB8fSdFhpZi/H0Ri0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utAO5Od8W95Xy3zfOiw/kP2mM72rVMDH6kfD4QcTh1ia48JZ4siiXXt5DA4prsPdhzMN3BFujmNi365XVnSDYP6xl0bqHAuk6fwaHxdFObN9S8UnDcwvcy5fPBWGvpy1zFG//myIe7d6mzM7iC6/QU5+/+XoAv7H6cUDxr2zuB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTs8NA+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTs8NA+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85442C4CEF0;
	Tue,  8 Jul 2025 16:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992462;
	bh=d0JE6yWSujr6ZLEtV2ZAITHAGFcB8fSdFhpZi/H0Ri0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTs8NA+SvY5NzJRMtjyxKmRBrFEegWIROuGXoQXU/1b+afnV1l+b85XdiXNPUOVwU
	 RjSqBd1RcrlA6iqKenPtIQNe1y6CG9Z3XnZk/lCsyzIdnBJLqNP1QllmwWDleB2LyJ
	 EWfRSy8XvqjFnrx8UgPwVrH2HHd7ELzmjsFcBtbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/132] rcu: Return early if callback is not specified
Date: Tue,  8 Jul 2025 18:23:30 +0200
Message-ID: <20250708162233.507861324@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

[ Upstream commit 33b6a1f155d627f5bd80c7485c598ce45428f74f ]

Currently the call_rcu() API does not check whether a callback
pointer is NULL. If NULL is passed, rcu_core() will try to invoke
it, resulting in NULL pointer dereference and a kernel crash.

To prevent this and improve debuggability, this patch adds a check
for NULL and emits a kernel stack trace to help identify a faulty
caller.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1fb3b7a0ed5d2..536acebf22b0d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2699,6 +2699,10 @@ __call_rcu_common(struct rcu_head *head, rcu_callback_t func, bool lazy_in)
 	/* Misaligned rcu_head! */
 	WARN_ON_ONCE((unsigned long)head & (sizeof(void *) - 1));
 
+	/* Avoid NULL dereference if callback is NULL. */
+	if (WARN_ON_ONCE(!func))
+		return;
+
 	if (debug_rcu_head_queue(head)) {
 		/*
 		 * Probable double call_rcu(), so leak the callback.
-- 
2.39.5



