Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CFE30AAD8;
	Tue, 26 Aug 2025 14:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218248; cv=none; b=FiJEUrtMlf9mC5mQroPNU3KSbgosEOdvGoeBm0ocuD5KQM2sbW3VLfynM5Fwk3bRivhcLFCDOdrexArJhTJVHXOD/awOCOC46a2XfQC8/+LoKAtj+dBfXDfZNhsqbsnhQTXuouCGOjsOH5vpUvtvpNWEcMW7F7p6Qhoehopes+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218248; c=relaxed/simple;
	bh=K64wgAFwuVzTUjg1Flvw1pTrwlEWeGrTUPC/s9IH0p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GGYYtMxP83kvv4Cuk3GZgFFqR8hGKh6A9eVijPO4z8NcDYFQ+r8rTogUAe6ilk2r1Qs2piLJAdD4r90pYmlSiMMnhqrSr5cM4L1bElvhwuRdOJnzAdebNO5Y6954zrT5REYLQNVwP4wulAx9zSn6w1V2yrKEmqAJmPKI01uUWKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00BeEUo5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00BeEUo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75850C113CF;
	Tue, 26 Aug 2025 14:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218247;
	bh=K64wgAFwuVzTUjg1Flvw1pTrwlEWeGrTUPC/s9IH0p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00BeEUo5XysjAy1c0GFBrgOoPRNGLj+sDwU14I+bg0pzfjoqTMAuqfGgk8ggM/VN3
	 3LY8vtkI2OsDlNDvIgHz7RWLRpdkw4aFL4NTR3pSwkeYbTEKETC8THHNZiM4v06uUE
	 pdFhdRcPArzjwymcXEK5LPmbNJe2j2XIMhlE+IXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyejeong Choi <hjeong.choi@samsung.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jay Wang <wanjay@amazon.com>
Subject: [PATCH 5.10 450/523] dma-buf: insert memory barrier before updating num_fences
Date: Tue, 26 Aug 2025 13:11:00 +0200
Message-ID: <20250826110935.552499769@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[Conflict resolved by applying changes from dma_resv_add_fence() in the original fix to dma_resv_add_shared_fence() in current code base]
Signed-off-by: Jay Wang <wanjay@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-resv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -290,8 +290,9 @@ void dma_resv_add_shared_fence(struct dm
 
 replace:
 	RCU_INIT_POINTER(fobj->shared[i], fence);
-	/* pointer update must be visible before we extend the shared_count */
-	smp_store_mb(fobj->shared_count, count);
+	/* fence update must be visible before we extend the shared_count */
+	smp_wmb();
+	fobj->shared_count = count;
 
 	write_seqcount_end(&obj->seq);
 	dma_fence_put(old);


