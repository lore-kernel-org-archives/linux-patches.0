Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25982143889;
	Tue, 23 Apr 2024 21:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908597; cv=none; b=LmNuBsBcoEk8jXkQPDuMkWhj0bjo5nuocaTGwAUBZwgT0gLlzvQNj9GCMgZsTg5EABeqAL2WQQXCv0RPMVLG5rnROIe292FR3IW3UCTb+nLq+DyaIXt5cG84rLaL7tkoRnjAZr8rutNB0PU5k4ZjjdZupcvvKiPc3+i0SPsV8Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908597; c=relaxed/simple;
	bh=aK1pxSY6eU+PY+j6QJnj+Wk6MviXlRqwtoiMo/+O/Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRQVCimwLfEF1JL0NFYF6+uk8sBKLc6V2nU7pyka652+prK4Xbj7RIbJD4S7MCo9qyoU68AZYImGPVGRxaiMVrTzeD0glz4V1HDrw+Jm4S6+KFgcapk9UbDAMNkevEUYtPm9JWaAxmgaqYdZW4UbQXOSkEo9Iztir4GJ5qZ8Tzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESTZ0TDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESTZ0TDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDEBC3277B;
	Tue, 23 Apr 2024 21:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908597;
	bh=aK1pxSY6eU+PY+j6QJnj+Wk6MviXlRqwtoiMo/+O/Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESTZ0TDZbkm/8kYGxGeVfHZi8esgh9it6ENEcyQ9JG9MUlzFQTetpCGytjQvTkCo3
	 O+OQ4lhoxAqoqgnoPjXh81e52ObBltPVs6kLEqXnJiSl8ROJvSNWmApC0oPJ4V+Vl7
	 bYNS8tictMsX/XnbIOzgGCVvkgaC8s4pxUXMrCq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yanjun.Zhu" <yanjun.zhu@linux.dev>,
	Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/158] RDMA/rxe: Fix the problem "mutex_destroy missing"
Date: Tue, 23 Apr 2024 14:38:17 -0700
Message-ID: <20240423213857.727781334@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Yanjun.Zhu <yanjun.zhu@linux.dev>

[ Upstream commit 481047d7e8391d3842ae59025806531cdad710d9 ]

When a mutex lock is not used any more, the function mutex_destroy
should be called to mark the mutex lock uninitialized.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Yanjun.Zhu <yanjun.zhu@linux.dev>
Link: https://lore.kernel.org/r/20240314065140.27468-1-yanjun.zhu@linux.dev
Reviewed-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 54c723a6eddac..6f9ec8db014c7 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -33,6 +33,8 @@ void rxe_dealloc(struct ib_device *ib_dev)
 
 	if (rxe->tfm)
 		crypto_free_shash(rxe->tfm);
+
+	mutex_destroy(&rxe->usdev_lock);
 }
 
 /* initialize rxe device parameters */
-- 
2.43.0



