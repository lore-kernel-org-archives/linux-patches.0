Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D53A4C74;
	Mon, 23 Jun 2025 22:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716034; cv=none; b=tX+EMFiqKIA1ESy5ol1HPzFnZK+g9gkitusBO4AFCdtYlYGEBy08R1tbh85AOas5lZtUtwFv4sUKeDWyOv1WH/+5Df9xPkKgloDQDbxryCsz3ObMAPPu9buT7IVdK60DJ9h/HxuvoPE4KD6ROVrt6l42Yq2Rs4QqO03XQ5l2588=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716034; c=relaxed/simple;
	bh=N293jCppDIKTE6EW8HLA2gO9tnZ7lALoaDnfErZ5l2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEHsrQIR0PucQ/tbR9h4OaFhKqynISUfv9gZp0leSmcPUSvZj9ZTSaBqVQsiadGM72PljlOlxQCIxwyMUv4fb7VQGWuzmB////coL/uSIOlkxFhrZShJvbEHKITkZY3dcHWUrSTv/6qr51q6ptR6qt3WLZ2OuZfC9WNgSEgpodU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ff7R7K08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ff7R7K08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA3EC4CEEA;
	Mon, 23 Jun 2025 22:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716034;
	bh=N293jCppDIKTE6EW8HLA2gO9tnZ7lALoaDnfErZ5l2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ff7R7K08MFnW9tYs1sXphP9cALFWUByRlKtpkt0gv9aJJcksjGetxpcHsWaV6oZTt
	 YrBcGufOXMO26UK3eLGbjO6Dpy1QCq1yXeinPzFMEKYGQ728ve3DnPP2TT8J/8aZ+h
	 UMPSKWRiefKVVG2T+ub+x4mcvpDXJ7Rsw+NihFTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/414] net: page_pool: Dont recycle into cache on PREEMPT_RT
Date: Mon, 23 Jun 2025 15:06:00 +0200
Message-ID: <20250623130647.602002171@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0f23b3126bdaf..b1c3e0ad6dbf4 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -829,6 +829,10 @@ static bool page_pool_napi_local(const struct page_pool *pool)
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



