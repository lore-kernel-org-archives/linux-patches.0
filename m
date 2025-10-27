Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD4D32D0C5;
	Mon, 27 Oct 2025 19:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591803; cv=none; b=Cd+lUwRgDOLtPwmW2YU9/5ynrUPGpzpvGDudgKW29oi8OKMkXbveck/DFBwfGA8tK1ruGTaB0+eoLEpTIXNG+efygbDzwiDE+Mn2AesqtSxyd3KIWqaduSeoel7F6/Psl8XlXBsDfMV14FvGMBBcvBuqyjCOajgLPHMzUMmGijY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591803; c=relaxed/simple;
	bh=3W+Xp35AzNhXVDcjCbMH4C7LX1nkCk3jmYB4X4Yp4Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLW8phTlYFM11IutGDfTsW50L3sPe1Ckzkk9I6vMWxsyE0AD9ahh8MJKnJv7rh4D+ibunSG5L3jf3R38FiG4BSJSTrUeLEtwIVH9JL2nPbml9PirLgNAkKDzMEwWiROdKnJP89lF6aImcv8GFfCkrSVnQvJfsFSh2UyHpH49ySM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VG0gpmDs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VG0gpmDs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F46C4CEF1;
	Mon, 27 Oct 2025 19:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591803;
	bh=3W+Xp35AzNhXVDcjCbMH4C7LX1nkCk3jmYB4X4Yp4Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VG0gpmDseDfTR1OpXT/SprDZqVpNzeBLcISAuPRNKS3FNxxkNo1ml04vLKG+tNw/n
	 9UK3X5WS8cKG+6kTlwM5T8M5MelVof5TqMTgjox6cOZm1GNad/+t3Sv0thTwMBsfsu
	 HoUXbgYMxeovhK9nWb+/fXx92GaZcEbUSwceI/1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/332] padata: Reset next CPU when reorder sequence wraps around
Date: Mon, 27 Oct 2025 19:36:00 +0100
Message-ID: <20251027183532.958690848@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ moved from padata_reorder() local variables to padata_find_next() using pd->processed and pd->cpu struct members ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/padata.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -295,7 +295,11 @@ static struct padata_priv *padata_find_n
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


