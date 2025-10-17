Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9859330B11;
	Fri, 17 Oct 2025 15:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715603; cv=none; b=I1uXr/LzhpVUeS4RhjM8zrhVMxcyf/Q+Rm5RjynysuutV1Mr00jUgOaC5OMWfaoD8lCE6IKRaFL0CIckn4i0E9hk2ZuC2vfrQygF/3iAA/cjvIwijLFr7I8P2bN5eieRf7lyHfcbt5zAAcBrtJUSof/97/UdIH4PKFIdAEUvMYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715603; c=relaxed/simple;
	bh=X88paqly145GE6k6iCgOIzcFqQC1osCuCDSsjFt4Mhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPkbT1Hd+tWBFmHpcrY7plQqxASK5ISrxla/YyHv7bZ5n7YaAgmSNc79rrWLh4I7JCi1uysYV6/QrQX1U1gk6PgA1pheFg83GW/7h7MB9HXZk2XTHRZ4dMMCmBSwOEnnSy5ybqFJGye0lIprmUZIWd5TQSBNGoteMbrznXOsct0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fajYiVyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fajYiVyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A93C4CEE7;
	Fri, 17 Oct 2025 15:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715602;
	bh=X88paqly145GE6k6iCgOIzcFqQC1osCuCDSsjFt4Mhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fajYiVykv3dddYrboKMxWcLTJghJTBo9gCtS4o9UDGO1IJq6Okf6+dSMKzYyvp5jW
	 1Ln2MfnmIyys4BCJrsIAUl3wZdMrNdnMi9w1qA5tiignae2hDXIhQ9X/5K2h/TEzD7
	 3bkMVllF4jdlSYA90dr/VF92VBblyxTmC1Q2XLMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.17 240/371] padata: Reset next CPU when reorder sequence wraps around
Date: Fri, 17 Oct 2025 16:53:35 +0200
Message-ID: <20251017145210.762675574@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Liang <shaw.leon@gmail.com>

commit 501302d5cee0d8e8ec2c4a5919c37e0df9abc99b upstream.

When seq_nr wraps around, the next reorder job with seq 0 is hashed to
the first CPU in padata_do_serial(). Correspondingly, need reset pd->cpu
to the first one when pd->processed wraps around. Otherwise, if the
number of used CPUs is not a power of 2, padata_find_next() will be
checking a wrong list, hence deadlock.

Fixes: 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
Cc: <stable@vger.kernel.org>
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/padata.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -291,8 +291,12 @@ static void padata_reorder(struct padata
 		struct padata_serial_queue *squeue;
 		int cb_cpu;
 
-		cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
 		processed++;
+		/* When sequence wraps around, reset to the first CPU. */
+		if (unlikely(processed == 0))
+			cpu = cpumask_first(pd->cpumask.pcpu);
+		else
+			cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
 
 		cb_cpu = padata->cb_cpu;
 		squeue = per_cpu_ptr(pd->squeue, cb_cpu);


