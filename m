Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BED21C9E4;
	Tue,  8 Jul 2025 17:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994207; cv=none; b=tmBJ+AImIhOx+bgMDbZfZlramP9lS0uCT+tVRhE/+p2528JDhnpaatpqRLaISPA0/DG8eUSlBSR57jtUPbYWblyqjzU+HHh8/t1LhgE6H8UK+9WxlFNq+2aP+nwFeBnY2iNe4BCeOAmtVS3jFMTTmcu4Fgus64/wNWY0toJI/ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994207; c=relaxed/simple;
	bh=UDB7d3w3sJAyotZzPLibiZB/9Bvygk5leN5phJ7kgec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPNz/ojkIrbu92Zl+Ca000ltiAEPaI3j5/DZ/AEPhWxpIvbaNoDG7TZRbL+aluCJV/34IJQEVEM/CvzxqYlR3lXihknXv53QrwH6ltBI1/To8U9Wl6qOYegyTcGHPrIi4XdOLiWog8vMLZ7MHqWzKJd9kHRcS1rGdNVUAeDGjJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIzCfb+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIzCfb+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B011BC4CEED;
	Tue,  8 Jul 2025 17:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994207;
	bh=UDB7d3w3sJAyotZzPLibiZB/9Bvygk5leN5phJ7kgec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DIzCfb+icUDIye6dA+o04mxzavb8aEV61+QygIZl2ikhVAIleEIk4RNzG1GzinUwI
	 PU0qJLeXati6ef6OaHKBOsZ0YqMXFW9KatF9vxvoCucNqbUd9ql9cGwQEpu91Td6U5
	 DlABa54Y3bs0DzeGM69FLywi8lAPOx1F+VhtVOBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/160] rcu: Return early if callback is not specified
Date: Tue,  8 Jul 2025 18:22:53 +0200
Message-ID: <20250708162235.151700178@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 66c1ca01dd0e9..185d37b02dc9c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2988,6 +2988,10 @@ __call_rcu(struct rcu_head *head, rcu_callback_t func)
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



