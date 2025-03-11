Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF3725BACC;
	Tue, 11 Mar 2025 15:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706936; cv=none; b=pJHTmtlnjZj3IO/8QeqjJqobEwrh4CcdwlcCff8Em+NNbaOv5iJ/A1E/XR96c7mEZg+O0PanZnJ7X3JzunPB4NvIMkMvGKcSaZgJ4+mmwcDscnsG1J7/lIvUT1YvzJ8Vfb3exmGm8Uml93uSelRvjq0BP1X587S2ZjIx+WYNha0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706936; c=relaxed/simple;
	bh=vG3K+fApvXWk21ClmTCg2mZJuJeO7lb8jE4a2ZP1Blg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWg55Cp9Y3BvZtNrmnvS1db36sDREdJvmEmEMEIvKmKJomP1mRIb7j+bl6X+5xQha7a2FePqa0eCTImWYSbILN/O106Fn2QW+b4Tlj1SsAgnZtskRqgi0knlpsqGpXRUUAbtN4J6LYGGZu9crnDuzcxK7P4fPD2vvPDU8DAOJ4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yt3YIcc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yt3YIcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6904DC4CEEA;
	Tue, 11 Mar 2025 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706935;
	bh=vG3K+fApvXWk21ClmTCg2mZJuJeO7lb8jE4a2ZP1Blg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yt3YIccg/mQr2oEo6QyWu1benJRFclat30OJ5a1mKAcNOMVRfKOuEVIUHM30SqQo
	 t4Dbj50aGBWNSRnEKQkPVt8Eb4IIN1k3uA+hAT2Kgvdk38QDdlCyJCDkIrMlbYNUnd
	 7g19s6McMvt3DWJZFGhFoEJiF2meL0tO54qYZbUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.10 219/462] misc: fastrpc: Fix registered buffer page address
Date: Tue, 11 Mar 2025 15:58:05 +0100
Message-ID: <20250311145807.015697109@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -826,7 +826,7 @@ static int fastrpc_get_args(u32 kernel,
 			mmap_read_lock(current->mm);
 			vma = find_vma(current->mm, ctx->args[i].ptr);
 			if (vma)
-				pages[i].addr += ctx->args[i].ptr -
+				pages[i].addr += (ctx->args[i].ptr & PAGE_MASK) -
 						 vma->vm_start;
 			mmap_read_unlock(current->mm);
 


