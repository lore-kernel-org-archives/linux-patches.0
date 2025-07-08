Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2C72E659;
	Tue,  8 Jul 2025 16:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992097; cv=none; b=mm8i2W3CoilFAHbanptziELsttCpCwQ+pGRV+L/2N3Oquj749aDcf9Z9LU6Q/Tc/wuuU0JMEaTDrm2Qu1RcP/KaPguxLn5+rwRw8rkfBWaCnceMBkkkQZ/Q8DRW4REQPXuOaa7w0416vaQp6AFm6Ege5W42t3gnvJGIVVr4z4T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992097; c=relaxed/simple;
	bh=QVLwFWqJReJc9uiYe0GcRacMnXtix6B2IXh98YZwIZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0e53hpN/ETaftC4xW7ICrzPofsv5pjKpWCmh5xxPLjEIlrw11m+056mISGk3XB3iGMHJtmyMagECQKGWot33S4iAflOrl/f5FAkEwFPqU38By5zESH99YUhBgDmtrMEHp64xhL70gGyD7BkrOqZoirqwiCcBWM3Z8GMuNe8ze8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPt5g0R0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPt5g0R0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50AEC4CEED;
	Tue,  8 Jul 2025 16:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992097;
	bh=QVLwFWqJReJc9uiYe0GcRacMnXtix6B2IXh98YZwIZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPt5g0R0VCiDkwB1AlVB1v6WpVyUoG/Kz311pbKOGeNAN1mtgu0djbbt7XSgl+6Mg
	 KWqSHnxV04sF9PRhYmT5zbV0Zf77wHowUZXy5apoqrS/gDRKetgV6rgh2Ahs545cSG
	 BuzwqouUWs6IL0p7HMg5EWJb3JyruJQrREUCXG8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 58/81] rcu: Return early if callback is not specified
Date: Tue,  8 Jul 2025 18:23:50 +0200
Message-ID: <20250708162226.835204194@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dd6e15ca63b0c..38ab28a53e108 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2827,6 +2827,10 @@ void call_rcu(struct rcu_head *head, rcu_callback_t func)
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



