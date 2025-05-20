Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9722248F4B;
	Tue, 20 May 2025 14:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750261; cv=none; b=srNGoOi/glT9/iTzsUueRBPp/J+e/3Q1pfCQPyIFLA9gNM8rsQAyZi1drnIdTk0A0dGJYDimVo55fUkWlZJOE1ToOlsBHUVu7DEqU4Fx6LdS+IBkM4JKK8mmaiCNPqkEWmUeJPrGvrHUeKmRov3+8U+Vz2t0iw+14jTO/BhEzEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750261; c=relaxed/simple;
	bh=/mcVZAQze70PzvL7TO3S24K5axllHEJW9DZ/tZ8Kot4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=byCGVXCHc+tuFL4DhRXyFDTmjPMcy0jb1WRu3YPEjNcktAWC9jNa3i8OW54wPGA6QSx4KTuQ5uFMFZj8eCNQ1Hyrj3GOURNjta3/Y6v59qM8Oi/crGIDwi4x1BwsaBitOR3fWtAt/Tmw/iLeF3itHnE1bcucEj1B3iwUx8Sx78g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpnpO5ms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpnpO5ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D999C4CEE9;
	Tue, 20 May 2025 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750261;
	bh=/mcVZAQze70PzvL7TO3S24K5axllHEJW9DZ/tZ8Kot4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpnpO5msLHMDV+ZqoUEexE3neEM8J2nLYqRo1FUTpmb1zFHc8PeWvvolXchbIUZu3
	 um9PUyPw+CXmJ31I7PI7XwygyfMN0Hvla8ilnsgHFgv0bIhx1E8Zq8nndF0Jos9Ht/
	 oWNWKZdIUVTuzy5AE+oHhtJzWxJpmCJXrIDQHffg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyejeong Choi <hjeong.choi@samsung.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.12 094/143] dma-buf: insert memory barrier before updating num_fences
Date: Tue, 20 May 2025 15:50:49 +0200
Message-ID: <20250520125813.749036376@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -320,8 +320,9 @@ void dma_resv_add_fence(struct dma_resv
 	count++;
 
 	dma_resv_list_set(fobj, i, fence, usage);
-	/* pointer update must be visible before we extend the num_fences */
-	smp_store_mb(fobj->num_fences, count);
+	/* fence update must be visible before we extend the num_fences */
+	smp_wmb();
+	fobj->num_fences = count;
 }
 EXPORT_SYMBOL(dma_resv_add_fence);
 


