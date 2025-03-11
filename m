Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD97249F9;
	Tue, 11 Mar 2025 15:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705793; cv=none; b=I6QszYwCMhpimnkA5NHGw2SnhoqMRiMG7vO6fxfGyRko9/gbiDnPoXhU8vB/3eZbfT6zJ+vcN7LzvyINrGli3Efju40BivmsoHi4I2Gu/w6eY+OSN6waMI60aigR8QhAAAlfjKiG9euSsL42Q848j3mJeFp0/g6oeUTGJBpGZcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705793; c=relaxed/simple;
	bh=nTvGUiJy18WIv4rqglqGj2aPg0YnX4gdCQO39D3V/MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhB5AQUW4QemlHroeKwDeyJ3+u+Gz49XDHK7pila0ZaHm0zue/PJKhgFGvXPA+UrHgs77OQl7UqlNZjRvPB3DTPBBKdfJozAod6NG7H0z2isl8xO4MS4fMqW8jxXDtW1z3vDrbk6SFy2CCfqWILDMIlSDKNfjtMpzZtKpQ77ZSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4qyY9Fj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4qyY9Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DB4C4CEE9;
	Tue, 11 Mar 2025 15:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705793;
	bh=nTvGUiJy18WIv4rqglqGj2aPg0YnX4gdCQO39D3V/MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4qyY9FjiIGWcTX9QLf13x9AhuF5EHJTEv0JByax0MBnswAMWDMZwg6edOjL6wOUE
	 Mv3r9p89tUM3D+tHR0NRyLkHFKB8V3lsVd0Cf9+wC5Yt0/hqxgLtznOKgYhmGVyi7Z
	 OkVeWNNqZQsZjrF7WREzTyjNqeOS/2HUp4eXNXNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.4 157/328] misc: fastrpc: Fix registered buffer page address
Date: Tue, 11 Mar 2025 15:58:47 +0100
Message-ID: <20250311145721.149846869@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -801,7 +801,7 @@ static int fastrpc_get_args(u32 kernel,
 
 			vma = find_vma(current->mm, ctx->args[i].ptr);
 			if (vma)
-				pages[i].addr += ctx->args[i].ptr -
+				pages[i].addr += (ctx->args[i].ptr & PAGE_MASK) -
 						 vma->vm_start;
 
 			pg_start = (ctx->args[i].ptr & PAGE_MASK) >> PAGE_SHIFT;


