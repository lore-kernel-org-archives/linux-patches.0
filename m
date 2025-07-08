Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C941B1DB127;
	Tue,  8 Jul 2025 16:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993721; cv=none; b=YK9ZPLy3K48UTLyQ0eCQ2dA3GNA2JmiG02JkLpuPcOqKnBcKB8b/FM+kyG9HpCxMH4Dsy1rpP+uhmui4nu4/g9t+IweDV1ZvAfaO0zenwoRWdyuqAhcr6aRVlT8/WmgrZ6Z9+49Yv9+Eqat0hKkZyTfXQBJ8sIBPKytC3Tn58gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993721; c=relaxed/simple;
	bh=vR/tOs+4iwYGMY0rnVGHF5AdcX+L3rfJ7aNtKE6fr4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tRizwmqfK9xh5Onys/XSO1+PLLnO8ynxZp9ipCjpRdEkT5dg/YyPGhQaB+QvcEkJbzbjj1moUWbRdopE7S596pyxJpnrBS7k1Wz+cSAgKrbBvFWLh/0z0zmL1+nQqCbTetsZD4YidsIPfiAy4WMTjsJQgobTHcsbIQbO58y68y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFlbMm+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFlbMm+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552F0C4CEED;
	Tue,  8 Jul 2025 16:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993721;
	bh=vR/tOs+4iwYGMY0rnVGHF5AdcX+L3rfJ7aNtKE6fr4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFlbMm+Wz/n+KWsyXdiMAiN4Bh29v9dv+7XE2HmNUENXX3976SlCYH1qoPwojxt4g
	 erda3uUPm5bBgmQ0eTDwgxITkM6Vu5XAvWEUfbDq+BiS/S/R7sqMHU1EpIiCuljuiv
	 NNT0RdDmaU+AuRHrE+9nLULrx4fRt6hL3krbzsak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 140/178] rcu: Return early if callback is not specified
Date: Tue,  8 Jul 2025 18:22:57 +0200
Message-ID: <20250708162240.201669001@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 80b10893b5038..37778d913f011 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3068,6 +3068,10 @@ __call_rcu_common(struct rcu_head *head, rcu_callback_t func, bool lazy_in)
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



