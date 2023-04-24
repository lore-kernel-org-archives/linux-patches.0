Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882087C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC56C433EF;
	Mon, 24 Apr 2023 13:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343122;
	bh=8P34wgrPucba7calZnGun3FgSUEsAJcwMhGPrJMugXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m12j0EEkdyXFetPumMEiyu55FpAaTJSc1ROKGplbVDc0cPNcsr9qieT4evVD5gtGC
	 qRlMrAQPIRlrTZj4mjf0IBhL5WJ7B9rhwo7GJOao9b3D9Shaqpbu6djlOq+tYFCfR8
	 igzqSPogqzudkkDtcnWOgDmGnVcHJrk5W72xUc4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shakeel Butt <shakeelb@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 085/110] mm: fix memory leak on mm_init error handling
Date: Mon, 24 Apr 2023 15:17:47 +0200
Message-Id: <20230424131139.677173051@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit b20b0368c614c609badfe16fbd113dfb4780acd9 upstream.

commit f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
introduces a memory leak by missing a call to destroy_context() when a
percpu_counter fails to allocate.

Before introducing the per-cpu counter allocations, init_new_context() was
the last call that could fail in mm_init(), and thus there was no need to
ever invoke destroy_context() in the error paths.  Adding the following
percpu counter allocations adds error paths after init_new_context(),
which means its associated destroy_context() needs to be called when
percpu counters fail to allocate.

Link: https://lkml.kernel.org/r/20230330133822.66271-1-mathieu.desnoyers@efficios.com
Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1177,6 +1177,7 @@ static struct mm_struct *mm_init(struct
 fail_pcpu:
 	while (i > 0)
 		percpu_counter_destroy(&mm->rss_stat[--i]);
+	destroy_context(mm);
 fail_nocontext:
 	mm_free_pgd(mm);
 fail_nopgd:


