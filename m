Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDB6321454;
	Mon, 27 Oct 2025 19:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592449; cv=none; b=jZnEIHNhg85wszvRiy2jnHdJFg24ii+cYs5LeRFzvcDicoufE8SKogVqKh0PfqeZcfk46Ko5dlAz1CTEgqPxZNIbWaEHMGHGYrJ+szYDQsD3tbEHoq95UT4Spx1NP56Af6Fb3I3LguK7mele248xqQqzcjJZXNqI2krLAwh1Ouw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592449; c=relaxed/simple;
	bh=l+t0vBEGJPUkdMaWLqaA8K9TG67p6KPSTmAxyEbwbvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zze405kfgMEORvdn/Fhx1BIwY8+T/jyD5zkU9MPBhRfEG54DkMvAAo2qaYU4Q0NU8YBpyYliEQdcq9LT/D/hOazQIuOkLtj/SO9lCGlfUN2gHXogSeXOhhq9XIFcThYTEpeoHBmVim5F1UuZTi5QDVaVv+HFWZvemroaqjvdGzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOh6x6rZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOh6x6rZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B572C4CEFD;
	Mon, 27 Oct 2025 19:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592447;
	bh=l+t0vBEGJPUkdMaWLqaA8K9TG67p6KPSTmAxyEbwbvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOh6x6rZF+iScZH0QnSBNZ+8ym2RiJ/wWaNL+rV11QEzpep3GJ7GBYl4q5Oo/x6Lq
	 i+MSFgCzhHJn9a4m6S/Os4ot42hDZEcsJOZcIh+DewIXWlFf2jBoyNRtcuPXyj9MCI
	 wtQRKRqfOjyhqWjksi12Gowy3Setsx+cCpSoeRRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/157] padata: Reset next CPU when reorder sequence wraps around
Date: Mon, 27 Oct 2025 19:36:26 +0100
Message-ID: <20251027183504.603861114@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Liang <shaw.leon@gmail.com>

[ Upstream commit 501302d5cee0d8e8ec2c4a5919c37e0df9abc99b ]

When seq_nr wraps around, the next reorder job with seq 0 is hashed to
the first CPU in padata_do_serial(). Correspondingly, need reset pd->cpu
to the first one when pd->processed wraps around. Otherwise, if the
number of used CPUs is not a power of 2, padata_find_next() will be
checking a wrong list, hence deadlock.

Fixes: 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
Cc: <stable@vger.kernel.org>
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ applied fix in padata_find_next() instead of padata_reorder() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/padata.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -282,7 +282,11 @@ static struct padata_priv *padata_find_n
 	if (remove_object) {
 		list_del_init(&padata->list);
 		++pd->processed;
-		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false);
+		/* When sequence wraps around, reset to the first CPU. */
+		if (unlikely(pd->processed == 0))
+			pd->cpu = cpumask_first(pd->cpumask.pcpu);
+		else
+			pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false);
 	}
 
 	spin_unlock(&reorder->lock);


