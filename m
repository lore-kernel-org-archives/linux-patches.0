Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF683AA4F8;
	Mon,  4 May 2026 14:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903747; cv=none; b=o0Q0u83oFXq3++J55uGfajo/HHu5CJxHB+FxMogISa0c8lAqRcA7fS2biOG9OFg4JLQ+SOLaRcenqAsvPGUghBQilbyVXONSbt/wDxVUFHvu4aCAd/em6eC1d1ULEE6RIUUoquZFftNiKP008yp9Bg8jZiAziFWM58B59WgJ514=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903747; c=relaxed/simple;
	bh=RlAn4A+rLoGwxIn4ZKwnAFMRoP6f7As0Jkp6g2qCipU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCSajjEQ7a5HxhAB3Z5Mpk9U8urJ5Ug31oDy7xias3ZFhYEGRgwtTglXpcLshOJcqW4fzV+illiex7gK6JHf9WkGmuFtltZgAZhG0J/up/syMJvYBwoxySbKCAGQaoCfPiAOTXK7gSJnyhlTdK3O5m7YS+XeqI0k3Z1hae3MyEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuKnCqqq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuKnCqqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57921C2BCB8;
	Mon,  4 May 2026 14:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903747;
	bh=RlAn4A+rLoGwxIn4ZKwnAFMRoP6f7As0Jkp6g2qCipU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuKnCqqqGpQoCnKjgvFDYjEX8Azw/fbAL4ntiUEyc5rdLy50ejq9pDYcvjB0wM1IP
	 IPiFrv8rWt0xhCF16Zt1O5KbpDC0gaMyNtV6ezNI4j4Y2XOniWvVflhuiNR4QKDqCJ
	 NhYkC85VHuMsiAod2CH5Q6ZhXvOWoVJMJOyoxLmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Gary Guo <gary@garyguo.net>
Subject: [PATCH 6.18 019/275] rust: dma: remove DMA_ATTR_NO_KERNEL_MAPPING from public attrs
Date: Mon,  4 May 2026 15:49:19 +0200
Message-ID: <20260504135143.652242283@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit 18fb5f1f0289b8217c0c43d54d12bccc201dd640 upstream.

When DMA_ATTR_NO_KERNEL_MAPPING is passed to dma_alloc_attrs(), the
returned CPU address is not a pointer to the allocated memory but an
opaque handle (e.g. struct page *).

Coherent<T> (or CoherentAllocation<T> respectively) stores this value as
NonNull<T> and exposes methods that dereference it and even modify its
contents.

Remove the flag from the public attrs module such that drivers cannot
pass it to Coherent<T> (or CoherentAllocation<T> respectively) in the
first place.

Instead DMA_ATTR_NO_KERNEL_MAPPING can be supported with an additional
opaque type (e.g. CoherentHandle) which does not provide access to the
allocated memory.

Cc: stable@vger.kernel.org
Fixes: ad2907b4e308 ("rust: add dma coherent allocator abstraction")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260321172749.592387-1-dakr@kernel.org
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/dma.rs |    3 ---
 1 file changed, 3 deletions(-)

--- a/rust/kernel/dma.rs
+++ b/rust/kernel/dma.rs
@@ -232,9 +232,6 @@ pub mod attrs {
     /// Specifies that writes to the mapping may be buffered to improve performance.
     pub const DMA_ATTR_WRITE_COMBINE: Attrs = Attrs(bindings::DMA_ATTR_WRITE_COMBINE);
 
-    /// Lets the platform to avoid creating a kernel virtual mapping for the allocated buffer.
-    pub const DMA_ATTR_NO_KERNEL_MAPPING: Attrs = Attrs(bindings::DMA_ATTR_NO_KERNEL_MAPPING);
-
     /// Allows platform code to skip synchronization of the CPU cache for the given buffer assuming
     /// that it has been already transferred to 'device' domain.
     pub const DMA_ATTR_SKIP_CPU_SYNC: Attrs = Attrs(bindings::DMA_ATTR_SKIP_CPU_SYNC);


