Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506761863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B61C433D2;
	Wed, 28 Dec 2022 15:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240855;
	bh=hjmvw9sYrkHjcpnlocA9U6ErG2j5QcaPwaRRFsbduD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAl2YtUGtOaO5cPAku713ULK0eK6tPPZiwWBL3pR37w3egew5hrTvGeDMbq/IJuS/
	 lTOOIUWZKZ8NEKsnW7QQoRFXZ/MmiwRQWnkuX5W82vFD0C19CLJIhsyvoKLPbbJFwX
	 n9LAf6Ad+9za3H/5LERmX+FMUElhUjZCpTS32EnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bc05445bc14148d51915@syzkaller.appspotmail.com,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 405/731] padata: Always leave BHs disabled when running ->parallel()
Date: Wed, 28 Dec 2022 15:38:32 +0100
Message-Id: <20221228144308.307424420@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 34c3a47d20ae55b3600fed733bf96eafe9c500d5 ]

A deadlock can happen when an overloaded system runs ->parallel() in the
context of the current task:

    padata_do_parallel
      ->parallel()
        pcrypt_aead_enc/dec
          padata_do_serial
            spin_lock(&reorder->lock) // BHs still enabled
              <interrupt>
                ...
                  __do_softirq
                    ...
                      padata_do_serial
                        spin_lock(&reorder->lock)

It's a bug for BHs to be on in _do_serial as Steffen points out, so
ensure they're off in the "current task" case like they are in
padata_parallel_worker to avoid this situation.

Reported-by: syzbot+bc05445bc14148d51915@syzkaller.appspotmail.com
Fixes: 4611ce224688 ("padata: allocate work structures for parallel jobs from a pool")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 18d3a5c699d8..9395b77fabb1 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -207,14 +207,16 @@ int padata_do_parallel(struct padata_shell *ps,
 	pw = padata_work_alloc();
 	spin_unlock(&padata_works_lock);
 
+	if (!pw) {
+		/* Maximum works limit exceeded, run in the current task. */
+		padata->parallel(padata);
+	}
+
 	rcu_read_unlock_bh();
 
 	if (pw) {
 		padata_work_init(pw, padata_parallel_worker, padata, 0);
 		queue_work(pinst->parallel_wq, &pw->pw_work);
-	} else {
-		/* Maximum works limit exceeded, run in the current task. */
-		padata->parallel(padata);
 	}
 
 	return 0;
-- 
2.35.1



