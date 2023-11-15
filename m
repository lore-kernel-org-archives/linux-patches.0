Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF303A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zatbASYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35C4C433CB;
	Wed, 15 Nov 2023 19:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077628;
	bh=hgQWP0EFKNkVCLJrVpNliBJ4ghd4xqr7/VV0SySA7Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zatbASYttKCL417pbPstFGf5X+/kkveiK+5C3IFjRxTe7UaE4E/L1g/WOQu/M2+zP
	 9ApEgjUS8CSnqzy8yrhz3nHWTIcIZfdO06JuSneHDeyqCuTIxJotsAYTjAem7wGNGJ
	 5qu4p+/ONiV7jG7WskSn7+7joGPoAZQM58XESpOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangJinchao <wangjinchao@xfusion.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 398/603] padata: Fix refcnt handling in padata_free_shell()
Date: Wed, 15 Nov 2023 14:15:43 -0500
Message-ID: <20231115191640.600185662@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: WangJinchao <wangjinchao@xfusion.com>

[ Upstream commit 7ddc21e317b360c3444de3023bcc83b85fabae2f ]

In a high-load arm64 environment, the pcrypt_aead01 test in LTP can lead
to system UAF (Use-After-Free) issues. Due to the lengthy analysis of
the pcrypt_aead01 function call, I'll describe the problem scenario
using a simplified model:

Suppose there's a user of padata named `user_function` that adheres to
the padata requirement of calling `padata_free_shell` after `serial()`
has been invoked, as demonstrated in the following code:

```c
struct request {
    struct padata_priv padata;
    struct completion *done;
};

void parallel(struct padata_priv *padata) {
    do_something();
}

void serial(struct padata_priv *padata) {
    struct request *request = container_of(padata,
    				struct request,
				padata);
    complete(request->done);
}

void user_function() {
    DECLARE_COMPLETION(done)
    padata->parallel = parallel;
    padata->serial = serial;
    padata_do_parallel();
    wait_for_completion(&done);
    padata_free_shell();
}
```

In the corresponding padata.c file, there's the following code:

```c
static void padata_serial_worker(struct work_struct *serial_work) {
    ...
    cnt = 0;

    while (!list_empty(&local_list)) {
        ...
        padata->serial(padata);
        cnt++;
    }

    local_bh_enable();

    if (refcount_sub_and_test(cnt, &pd->refcnt))
        padata_free_pd(pd);
}
```

Because of the high system load and the accumulation of unexecuted
softirq at this moment, `local_bh_enable()` in padata takes longer
to execute than usual. Subsequently, when accessing `pd->refcnt`,
`pd` has already been released by `padata_free_shell()`, resulting
in a UAF issue with `pd->refcnt`.

The fix is straightforward: add `refcount_dec_and_test` before calling
`padata_free_pd` in `padata_free_shell`.

Fixes: 07928d9bfc81 ("padata: Remove broken queue flushing")

Signed-off-by: WangJinchao <wangjinchao@xfusion.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 222d60195de66..ff349e1084c1d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1102,12 +1102,16 @@ EXPORT_SYMBOL(padata_alloc_shell);
  */
 void padata_free_shell(struct padata_shell *ps)
 {
+	struct parallel_data *pd;
+
 	if (!ps)
 		return;
 
 	mutex_lock(&ps->pinst->lock);
 	list_del(&ps->list);
-	padata_free_pd(rcu_dereference_protected(ps->pd, 1));
+	pd = rcu_dereference_protected(ps->pd, 1);
+	if (refcount_dec_and_test(&pd->refcnt))
+		padata_free_pd(pd);
 	mutex_unlock(&ps->pinst->lock);
 
 	kfree(ps);
-- 
2.42.0



