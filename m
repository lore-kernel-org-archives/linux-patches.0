Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0DC423A9B;
	Tue, 31 Mar 2026 16:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975744; cv=none; b=PuNRLLi57osmEF0g8yXNPP21XXjvAX1GBcFl3AYkeeSre2f7+nRh6vgdZybhP+NrITrswa/KgipGaj05s+I9UH7FFRUjC1EPhWPEB6pfOPnHUTP5VdQTbYF3Y95Yj4JTJ92lq2BdoEdPQ4Ma2u9EI23gFDiDq7PNfLokP5n0EW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975744; c=relaxed/simple;
	bh=0NLLhAHWwsZhGlK9mLLy/mVlepQYbJEqbHQj0mC8GmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P018FA3pwVFUkQIZ2wqDsdlbVL4gWOoho6lDyHLKgtQSUoEkO/FxKf4WzLuzXPnPtiMwSjavnul5fNO1DmZTwYKHpyQsseFhw5sz1TIOD8T/8aqfP8Gx0AAaE9aUYeJ4f8mN8XD7HW/GPuQrg/jqyG7dyV4vgVnwzxn0QyQOfBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCMtgb9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCMtgb9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9A4C19423;
	Tue, 31 Mar 2026 16:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975743;
	bh=0NLLhAHWwsZhGlK9mLLy/mVlepQYbJEqbHQj0mC8GmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCMtgb9ngpCsr9CeVVKOs+4fMbzhuhDayOk6gXLtOfBi+/g9TjvADHrmQchYLx6ZQ
	 s7IghTG88YQA1zi88Q3KkFtCrucIHUVYTFgnEyijWYcSjV0/vU2EuERPb+zhQU+Eim
	 iHGys90EwADIDDrF4DFX6352V6K7wdG5Z1BRYl1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhidao su <suzhidao@xiaomi.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/244] sched_ext: Use WRITE_ONCE() for the write side of dsq->seq update
Date: Tue, 31 Mar 2026 18:19:46 +0200
Message-ID: <20260331161743.034151026@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: zhidao su <soolaugust@gmail.com>

[ Upstream commit 7a8464555d2e5f038758bb19e72ab4710b79e9cd ]

bpf_iter_scx_dsq_new() reads dsq->seq via READ_ONCE() without holding
any lock, making dsq->seq a lock-free concurrently accessed variable.
However, dispatch_enqueue(), the sole writer of dsq->seq, uses a plain
increment without the matching WRITE_ONCE() on the write side:

    dsq->seq++;
    ^^^^^^^^^^^
    plain write -- KCSAN data race

The KCSAN documentation requires that if one accessor uses READ_ONCE()
or WRITE_ONCE() on a variable to annotate lock-free access, all other
accesses must also use the appropriate accessor. A plain write leaves
the pair incomplete and will trigger KCSAN warnings.

Fix by using WRITE_ONCE() for the write side of the update:

    WRITE_ONCE(dsq->seq, dsq->seq + 1);

This is consistent with bpf_iter_scx_dsq_new() and makes the
concurrent access annotation complete and KCSAN-clean.

Signed-off-by: zhidao su <suzhidao@xiaomi.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 545f197d330c1..86ef9c8f45dae 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -1775,7 +1775,7 @@ static void dispatch_enqueue(struct scx_dispatch_q *dsq, struct task_struct *p,
 	}
 
 	/* seq records the order tasks are queued, used by BPF DSQ iterator */
-	dsq->seq++;
+	WRITE_ONCE(dsq->seq, dsq->seq + 1);
 	p->scx.dsq_seq = dsq->seq;
 
 	dsq_mod_nr(dsq, 1);
-- 
2.51.0



