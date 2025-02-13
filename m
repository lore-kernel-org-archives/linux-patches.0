Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDBB13D8A4;
	Thu, 13 Feb 2025 15:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460042; cv=none; b=LSCW/QUW0pKVMLcg5YASLqdlzjpl4/inJJQUbATHM2LqUgbNhdnx1X6VkXa3C8NID1ByjLvyEKJHy6jTWDN52QBx1H5jVMsHmOC2LtSnBAvpF8FxELCeIJICeNk0I2eVPaJZhuDEPWCwxxJbNws6RFYR/ua++V3tA3kinV+iLk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460042; c=relaxed/simple;
	bh=33sL/vl29KtyG/3T0ASbmZexkxMXSrxtUClWCM2+fOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6diygCencvfNfFpVStTh7omWP+Llth0rBrcQEDHQX0IhPVwDqc6ArTJlDXIiakbDAPnWSBWjPwRctgU6R4vg1urn7qMHpD/Ek9iKAkGqBdP9fwk4lzmapdiv8hGojbqJgXsMjeWES1B1gmk1oB1utizxCCFXZLesfjFbUxKrlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqPiG3DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqPiG3DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7691CC4CEE4;
	Thu, 13 Feb 2025 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460041;
	bh=33sL/vl29KtyG/3T0ASbmZexkxMXSrxtUClWCM2+fOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqPiG3DYw5aVpKFnwUQbqFBaiJHMuCKJjwhMRJEhReGoSLs024vYv5HBuXD2pnje5
	 3jyRnHMUNKOA/PhQJYMehlwx+uVTS38FJy8dmyEacKooJWOwB4xJ1meSqFlSUykTxG
	 vmW6dVMFg5YFClDlfAidS2ogoSPz2xWmdGKMDNDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.13 413/443] misc: fastrpc: Fix registered buffer page address
Date: Thu, 13 Feb 2025 15:29:38 +0100
Message-ID: <20250213142456.546932692@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -992,7 +992,7 @@ static int fastrpc_get_args(u32 kernel,
 			mmap_read_lock(current->mm);
 			vma = find_vma(current->mm, ctx->args[i].ptr);
 			if (vma)
-				pages[i].addr += ctx->args[i].ptr -
+				pages[i].addr += (ctx->args[i].ptr & PAGE_MASK) -
 						 vma->vm_start;
 			mmap_read_unlock(current->mm);
 


