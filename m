Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF13A1EDA0F;
	Mon, 23 Jun 2025 21:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713487; cv=none; b=L8kFPYwe26x/RJ65pwPSqJIMo4oxCn3+oWDmXguj8O6eHTgciyaY8xpVwdGN7G3avN0dNBnDDbdKmJ+NsyrcJsm3dfZHSwghoQD1hfH0p514cD5Lqkx0orsvxJwY4L7kP2LLqWIbRoiFkkawe5m9cZz43xZ/xW3ANP3BHS0Rjxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713487; c=relaxed/simple;
	bh=Spn/OWQqEkdrqAj5onNNE9JY93AbSw18WHnHnBMyqMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmShApxhPCCaNrIk8VBiz9icZqTHI9WO08F9xsaLc+tD+diLahJCMTiq7YgnHeQDN4w/Toi3JGIDQcNncb1cM6X6wxffLA6OhcSacAj7eUS8ul0szmkjAMRgzbslB/l11vs+kuISnjfBxfSptx11euKgK/HSKb5CDL72UCsAI50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIN1PQhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIN1PQhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46354C4CEEA;
	Mon, 23 Jun 2025 21:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713487;
	bh=Spn/OWQqEkdrqAj5onNNE9JY93AbSw18WHnHnBMyqMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIN1PQhWgHHTGwjb6bYSF37cWawvw4s32MqCnKW3eAYisZX5Z6hf6LZPQck8j+CZN
	 rMA2rBGWJ5+vJwK9bytm/ijQD820BMqVQ+KiLSwscRBNe/C2FZuqOouf8i95y6nPt2
	 neKfuQ4DgaQw4uz6DobIOy1a0Hb/jH2QizggU3EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 350/592] net: page_pool: Dont recycle into cache on PREEMPT_RT
Date: Mon, 23 Jun 2025 15:05:08 +0200
Message-ID: <20250623130708.772199303@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 32471b2f481dea8624f27669d36ffd131d24b732 ]

With preemptible softirq and no per-CPU locking in local_bh_disable() on
PREEMPT_RT the consumer can be preempted while a skb is returned.

Avoid the race by disabling the recycle into the cache on PREEMPT_RT.

Cc: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20250512092736.229935-2-bigeasy@linutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 2d9c51f480fb5..3eabe78c93f4c 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -836,6 +836,10 @@ static bool page_pool_napi_local(const struct page_pool *pool)
 	const struct napi_struct *napi;
 	u32 cpuid;
 
+	/* On PREEMPT_RT the softirq can be preempted by the consumer */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		return false;
+
 	if (unlikely(!in_softirq()))
 		return false;
 
-- 
2.39.5



