Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD491D8E07;
	Tue, 20 May 2025 14:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749832; cv=none; b=F0WrJbeX/roPlGd/QMkaIZ1I4J2UFxFDq6jPk0Fse0ruZ2uwkMu6b5PYKh3RAAi1wngwITeqyKeKmDdK0HAFt84YiqyHwRUFDidOXXkr+zid83C4SX/B230gmpiNcevotLd5Fk/8lWUvFCbYnbxlTaOSxkHAwNyovn81JGnoUCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749832; c=relaxed/simple;
	bh=mKYuxtI3yza1gb+bhJofO9R9s0ttFa5Dkf2BV2kBBLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gmNsp2lKMi0+nPA6wPJd0MZEWgsNQ38zCID/M32qmVTyv6Yu5fetenbrH/gBY6aCnbbvCmnMbvms+mjou1F16WD/sVShxEZD41q7CR1+HmjGfB5diSVzvEgAdkOzCBET081lF5k+Ya8VCr1FCNb06dGZs2tNovSDYpCjwOh/TxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhcddBdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhcddBdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706E1C4CEE9;
	Tue, 20 May 2025 14:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749831;
	bh=mKYuxtI3yza1gb+bhJofO9R9s0ttFa5Dkf2BV2kBBLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhcddBdhViXJPpB9/BYIfEXr7TknrUu15C/TbKCVBoKNZxLdVjgA2R4PiBo7U494S
	 1nEfiX0noMFSmmkXY16VEOg3oTo+Pq6PWXUU+vdRl0rityU/RxmcdOx/ZXvZCxcazy
	 mCAX+E6iMiQQE4PATz5JlM8j7I2xz9f1liqvv5Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyejeong Choi <hjeong.choi@samsung.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.6 074/117] dma-buf: insert memory barrier before updating num_fences
Date: Tue, 20 May 2025 15:50:39 +0200
Message-ID: <20250520125806.927237146@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyejeong Choi <hjeong.choi@samsung.com>

commit 72c7d62583ebce7baeb61acce6057c361f73be4a upstream.

smp_store_mb() inserts memory barrier after storing operation.
It is different with what the comment is originally aiming so Null
pointer dereference can be happened if memory update is reordered.

Signed-off-by: Hyejeong Choi <hjeong.choi@samsung.com>
Fixes: a590d0fdbaa5 ("dma-buf: Update reservation shared_count after adding the new fence")
CC: stable@vger.kernel.org
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250513020638.GA2329653@au1-maretx-p37.eng.sarc.samsung.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-resv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -313,8 +313,9 @@ void dma_resv_add_fence(struct dma_resv
 	count++;
 
 	dma_resv_list_set(fobj, i, fence, usage);
-	/* pointer update must be visible before we extend the num_fences */
-	smp_store_mb(fobj->num_fences, count);
+	/* fence update must be visible before we extend the num_fences */
+	smp_wmb();
+	fobj->num_fences = count;
 }
 EXPORT_SYMBOL(dma_resv_add_fence);
 


