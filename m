Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD532EBDD6;
	Tue, 15 Jul 2025 13:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587692; cv=none; b=WzOxg3kLPI2axdycauK21zlejjqcsMaHNdip4rb021R4KbJD76jE5yEJif0uNr1GAs6viXk8Wpj7mvE62nZmYfBIsYOK39p5zCSF3u8DaIl0yFZn9k8P2FiggRHdwPJnsdSfTw57vTR8VBDfiDLauGuHBUpXYKa/uj6HqkdNYt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587692; c=relaxed/simple;
	bh=IpecSAZlYwn47hUZG3zd++jyX0UUp0nYr8ojEINqHUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kF/oP/hAUbD8nrg7Ts4cDCYXtEm53dqjYSsuJdHl1UJ+9xSC3loGKJHmAawYkX8NWBfU+tEXrlx3eOe+TzDk1yYwK9/cijNiyMUGvgOBqKdQgvmkLEQMjfr0x2KEAm8fp/6AVRFoKcsOjicophLOuleRzw7mooJ4CFYHbfyayVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9RKjwtn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9RKjwtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116B1C4CEE3;
	Tue, 15 Jul 2025 13:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587692;
	bh=IpecSAZlYwn47hUZG3zd++jyX0UUp0nYr8ojEINqHUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9RKjwtnEW/NVzY+zrnCuxGkd4STFcY7RLyK+l6fTo+UHas+roX7EjFBFHV7u/EA3
	 F7fP3kr47ZaFHeUCEvHyqHLQlSU4izvBHcuXG9KOfn5aWjUr1Dds9px5T0aokVI5ny
	 axEVg4abw8RQv5Dx0bdvMtDS3zJQVKrUN0AkYY/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/208] rcu: Return early if callback is not specified
Date: Tue, 15 Jul 2025 15:13:37 +0200
Message-ID: <20250715130815.275336178@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 06bfe61d3cd38..c4eb06d37ae91 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2959,6 +2959,10 @@ __call_rcu(struct rcu_head *head, rcu_callback_t func)
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



