Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5729A46EF78;
	Tue, 21 Jul 2026 18:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659015; cv=none; b=NeteosSDVoi9lzhDxA36zMrBqyHH0lscz5qzBUUiPOXUxNJnzbfBjtqMVrOf/qrS7VD4oKhbdXJGQleEOr2UxttOyLxpbjIQkiyp/WPYzpwWDE7Fg0+20Efeya3maotWaS2VSEEIjeN00z2L1pBE0rN/PxLNfvFFRjoy1iyNM8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659015; c=relaxed/simple;
	bh=HJupQvxQt3EgOzqXyTABa+9/Z79kOmgWJjZ+mPyNEYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZObU4+pwfV3iv/VTUKRkCMPAiQIvJyLinZZt5kCIoNhaq59TltOPL4LrEnfgmAle/VxuxFj0IqAcgvYksNq6e3/A7juu4NxJ5DMAbsk5Tubi/Nj3jDLcyLGWgkCf76eI7pcjJRvziWBhBAORWboCdIHb+jx8pspzPlLmNGtosOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoyCSZXb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoyCSZXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6D31F000E9;
	Tue, 21 Jul 2026 18:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659014;
	bh=hKOYAXOSSPJJk0BHWkb0/aTY8M3H0TXLsKunapxuDYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xoyCSZXbXo/h5KJUAbtY3YjXeJcRuTZ9+aQCZQuH4O667FsJ9ljSwxcTbSclkivoH
	 epzxVbOA4gKvhbmXJLxnYtHNeuT6+ZjoJSYqDnOloT7IkJXTuP72SrYCNTAb7ugwov
	 z0SEZmiD2uVpt7nyfYb1FcvHanWiaq4X5SlMbhV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baineng Shou <shoubaineng@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.18 1362/1611] dma-fence: Make dma_fence_dedup_array() robust against 0-count input
Date: Tue, 21 Jul 2026 17:24:38 +0200
Message-ID: <20260721152546.088984961@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baineng Shou <shoubaineng@gmail.com>

commit 77a9298741f8f9e8b963c977f5582ab21c6d3427 upstream.

dma_fence_dedup_array() returns 1 when called with num_fences == 0:
the for-loop body never executes, j stays at 0, and the final
`return ++j` yields 1. This contradicts both the kernel-doc ("Return:
Number of unique fences remaining in the array") and the natural
expectation that 0 input gives 0 output.

The caller __dma_fence_unwrap_merge() bails out via the
`if (count == 0 || count == 1)` fast path and so is save.

But amdgpu_userq_wait_*() could reach the dedup call with a zero local
count and dereference an uninitialized fence slot in the array.

Make the contract match the documentation by returning 0 early. This
also skips an unnecessary sort() call on an empty array.

Cc: stable@vger.kernel.org
Signed-off-by: Baineng Shou <shoubaineng@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Fixes: 575ec9b0c2f1 ("dma-fence: Add helper to sort and deduplicate dma_fence arrays")
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20260629031346.3875683-1-shoubaineng@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-fence-unwrap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/dma-buf/dma-fence-unwrap.c
+++ b/drivers/dma-buf/dma-fence-unwrap.c
@@ -97,6 +97,9 @@ int dma_fence_dedup_array(struct dma_fen
 {
 	int i, j;
 
+	if (!num_fences)
+		return 0;
+
 	sort(fences, num_fences, sizeof(*fences), fence_cmp, NULL);
 
 	/*


