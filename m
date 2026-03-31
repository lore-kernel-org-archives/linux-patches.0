Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EAA3DFC7D;
	Tue, 31 Mar 2026 16:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974918; cv=none; b=GoKWK8Y33nhkZhWxQoowZnKYhA/Fbwu1j/I3VltfioCZAH7fEC9XXfWQ/Hkf9vCB/8WE0UIRn8JDr00e0ggP0F9ZHdAmIeEkfmTDDD7xAm8298AAeGQUsL6wHIeLOc6cPjJcDtlTumEoif2TZnV+2xurpYzVxAZ0s/hT1ad/VMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974918; c=relaxed/simple;
	bh=3k91VsR8VSjlvi17686v47iazsFfxCAqfU+BTwv3Was=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mR1m08+Avv4bECTvcVmE67C6ChZKPgg9HQfUjyu2BOSigVuqx44qYbU/9tEGkzWvFTAEiCHhV0V8ULMdYwpYR4GspmTD6pEpll28ku/AJrI1s8fgDFLc14oyiAu316vmrYWhxmy/iV+gBHGBtvxH7M2QmI/A1rstpFKYwe+xfRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xp5ri/+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xp5ri/+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A036CC19423;
	Tue, 31 Mar 2026 16:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974918;
	bh=3k91VsR8VSjlvi17686v47iazsFfxCAqfU+BTwv3Was=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xp5ri/+zwRhVEI4+Jnp0cjjip0V8g3krtCqWxcKxIy6hLJMuEavB9u0kNCBQ3uLVA
	 55rxJIMPe4KEZ2i0FSqvIdeqAx/6NB93J9HrWrcGsJw2LV+YqUiIA/9zMj79bljupu
	 xS3hxJQcZAIfk+klsiuam3aRepabNZD27AUvpnGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhidao su <suzhidao@xiaomi.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 062/342] sched_ext: Use WRITE_ONCE() for the write side of dsq->seq update
Date: Tue, 31 Mar 2026 18:18:15 +0200
Message-ID: <20260331161801.177144713@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index f7eeccbd893af..2c32e12af435d 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -1097,7 +1097,7 @@ static void dispatch_enqueue(struct scx_sched *sch, struct scx_dispatch_q *dsq,
 	}
 
 	/* seq records the order tasks are queued, used by BPF DSQ iterator */
-	dsq->seq++;
+	WRITE_ONCE(dsq->seq, dsq->seq + 1);
 	p->scx.dsq_seq = dsq->seq;
 
 	dsq_mod_nr(dsq, 1);
-- 
2.51.0



