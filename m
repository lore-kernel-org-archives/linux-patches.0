Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095D0241663;
	Mon, 27 Oct 2025 19:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592119; cv=none; b=mcPsloUr05tZEHuT1smlP6dCfa56GgtX1j3XA5kbJZYyqSU39xnfzOGBhHMYPGdSYJEPkk/iki4I2KvQAQmbqSbg+6R3J968959yC1wvVQAP8/iMubciQ850HOqSN+jbrFXJQdih3kh5gsK8QibsteCGWZ/d86FTNOEGnEU/EO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592119; c=relaxed/simple;
	bh=U5bV/PCwiBFWwsiQSewW6IEFPt8tcr1Co4Cu639bnOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtZL8+NuYSTY/RtZ9dkwhbGp6k+um/Ug43qbifmYhYMjYfaFPArWWVwiJKjf/TKXUv/F3c9SHTfnz0RuThzHRw6vTdpX8hgdlCZZsP3/FfxosLJ+hdRK+nFSOzWYBxpHKX19oPrQt/G7/fMToc71l3eVvUligJ0TalJX65i6sig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qN7C/bjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qN7C/bjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830D2C4CEF1;
	Mon, 27 Oct 2025 19:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592118;
	bh=U5bV/PCwiBFWwsiQSewW6IEFPt8tcr1Co4Cu639bnOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qN7C/bjSh6PpGFrq7kvF1LGLjZkzHD4pqGANiy4MdfIJaeiY0RJKkLfTVXB8aHzGW
	 A/ehY8tSEK+f+xMaMMuxjentHgJpoQM/DE5Ivt7Yx73HLDFsOW6zowoT2NOQCU9xX0
	 caRjibcKYP1GQdo3zqSYhv92v0TqemQomk/gaUt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/123] padata: Reset next CPU when reorder sequence wraps around
Date: Mon, 27 Oct 2025 19:36:19 +0100
Message-ID: <20251027183449.042846740@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ moved fix from padata_reorder() to padata_find_next() and adapted cpumask_next_wrap() to 4-argument signature ]
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


