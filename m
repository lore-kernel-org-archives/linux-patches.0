Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B0622B8A5;
	Mon, 10 Mar 2025 18:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629615; cv=none; b=DAdNfqm4euoI4aGoP/NzwmMGkioTlLKRVyh1wOC7bIRN9O+peD3tLj0VjtIB4zPqB0S6Xm2kzBolrctTkVI87CuHAnYAHVrXy2p8Ey7LVHaL9kdWSJeuLckVdfoD5RVlhWV/6dFmkAm1E+nvDG2n9/eRCOrpT3JPwAJoRwEIY1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629615; c=relaxed/simple;
	bh=5e0EmPFqIdY/rNEIXODIik21Gm8fDqkQCbXeHJfBIlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWh/B7s2nG6s6B62aAdzMJWc5vplC4IIbPaIgytUMsx5+3W2q7aJBr7qHXal7QkAGGcoPjgCmDF+k2K0y2wg0ret/58Cz6sh180Gc1zmd5mNVETUvJhPXEm3qiRnHwFRE2qhAbJxRetjBANRYIHVmcglAnyMnaklSmTFqjqRJmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0N/8l7D0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0N/8l7D0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870D3C4CEE5;
	Mon, 10 Mar 2025 18:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629614;
	bh=5e0EmPFqIdY/rNEIXODIik21Gm8fDqkQCbXeHJfBIlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0N/8l7D0ZqHc8EP4QFcsIyargARYd16LF12d0tRbyuHgTb/kwJhc+4o5YjYRmybTL
	 hbtxZziaHYkoar3MRiKaiyW18Qr8pJZJEuSj8N9XOpgNM5E/cEB3cy92464JqKzT52
	 UUiDdKg+cFy9ZwSUmWPYlXQpWsUvumCmFbL3xoMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.15 324/620] misc: fastrpc: Fix registered buffer page address
Date: Mon, 10 Mar 2025 18:02:50 +0100
Message-ID: <20250310170558.396109604@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit 6ca4ea1f88a06a04ed7b2c9c6bf9f00833b68214 upstream.

For registered  buffers, fastrpc driver sends the buffer information
to remote subsystem. There is a problem with current implementation
where the page address is being sent with an offset leading to
improper buffer address on DSP. This is leads to functional failures
as DSP expects base address in page information and extracts offset
information from remote arguments. Mask the offset and pass the base
page address to DSP.

This issue is observed is a corner case when some buffer which is registered
with fastrpc framework is passed with some offset by user and then the DSP
implementation tried to read the data. As DSP expects base address and takes
care of offsetting with remote arguments, passing an offsetted address will
result in some unexpected data read in DSP.

All generic usecases usually pass the buffer as it is hence is problem is
not usually observed. If someone tries to pass offsetted buffer and then
tries to compare data at HLOS and DSP end, then the ambiguity will be observed.

Fixes: 80f3afd72bd4 ("misc: fastrpc: consider address offset before sending to DSP")
Cc: stable@kernel.org
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20250110134239.123603-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -828,7 +828,7 @@ static int fastrpc_get_args(u32 kernel,
 			mmap_read_lock(current->mm);
 			vma = find_vma(current->mm, ctx->args[i].ptr);
 			if (vma)
-				pages[i].addr += ctx->args[i].ptr -
+				pages[i].addr += (ctx->args[i].ptr & PAGE_MASK) -
 						 vma->vm_start;
 			mmap_read_unlock(current->mm);
 


