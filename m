Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6893188CCA;
	Wed, 19 Feb 2025 09:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957175; cv=none; b=WFDFOAc+B5JaQvyaGPI6zJR0vcO6DJUxhTXiNfsBVcgmFDZrV9uSy71gXOPufBbegoMvlJgEEv1pjq1WNZznOgaoFEG8ugFwJAsO2CezLAzRtBWzPHdKS3LAdqJ0hwdpcQnAEsCLUeAXB4qok4BjFEACh5nQihqwof3nfMYbCaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957175; c=relaxed/simple;
	bh=t5WGsgCfxSeMbagri7E4u541anHqQqhSDX2jHkx2UWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKQoBHe5YwnnrkeOHIwI56JEyp4K2LTQxQqn1TqWYS+KDeYouWDC1KmfXo12Z0/LGH4vauXX+NCV9mZ13fPiJtTxcBIkgHRHUe0a58cVgleWjBMiTxj5g/jk5870y6jHS2cmJyL+JCZ06XwiqQZ2Uo2SqiVqdhK7v+iJ1pBZpCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFDQF1Py; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFDQF1Py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA94C4CED1;
	Wed, 19 Feb 2025 09:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957175;
	bh=t5WGsgCfxSeMbagri7E4u541anHqQqhSDX2jHkx2UWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFDQF1PyqnLVQaFqFHwM2l/Ycw1zOkU4mGwq7DpeIm1hs6lEny/AY7fWYlJAbYtJK
	 wTWAGJ1YkMg+Z+uyf47Iob8BMOY+u5KLDpD56/86Fo+QP1gskYqwgcFn3O4JwjIRfv
	 GLDf/qfvgWhvf0NyEDNRorlNgQdvkEjWN0+xrW00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 435/578] misc: fastrpc: Fix registered buffer page address
Date: Wed, 19 Feb 2025 09:27:19 +0100
Message-ID: <20250219082710.122223386@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -934,7 +934,7 @@ static int fastrpc_get_args(u32 kernel,
 			mmap_read_lock(current->mm);
 			vma = find_vma(current->mm, ctx->args[i].ptr);
 			if (vma)
-				pages[i].addr += ctx->args[i].ptr -
+				pages[i].addr += (ctx->args[i].ptr & PAGE_MASK) -
 						 vma->vm_start;
 			mmap_read_unlock(current->mm);
 


