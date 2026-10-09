Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261F14E56C6;
	Fri,  9 Oct 2026 14:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555675; cv=none; b=uY86cAA7++yistM6SJCrUQjC8Urw0nYxKS8HUxZnsWfwuXvMqno/vdlaVaQqQR6AChijxIlTfpfhjNB0CMJsM2Z3xk1Dgybg+1PdTGFFxIWa+DMTaQ8GXYJiGoNBjR3BuVmn1L4SxCrfRLjuYkNX6ENUY6D23pcUOK23AFLSisw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555675; c=relaxed/simple;
	bh=qyEhJzjjcVpQ4tiLH9Dm3UQdeq28wLzAriQLVqkU7SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yij3wFm+d3y5UJu4bs8E4vEua+Kd8Bqsw4tlbMsSM7/R2utHcvVILKcnoZjhKSYKJ6se1Gy+YHZw67fswAL4eLHWcHIDBRE5RbMSxC0m+W/bPXIQ2NDQdpZXnY/wPGsEMRLxvNEhxkakB6LOkTKBDtJe/CzhE7ztXDwq2F4zqks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRTeuPzZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRTeuPzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F02F1F000FF;
	Fri,  9 Oct 2026 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555674;
	bh=yurmya1p+vXkmtpUynWvRi7brYf5+QNwwrlTRXV7FVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRTeuPzZ3fdLzkEW97qOAe7pWigWbzd8kbZ0Z5tpAwEHA9vcQv4kMHn7yCHrYomWr
	 oJAGthdut1C+3f4c0ELX7X2N5ji9KM33UN0fxeYfpzw1ml1PitMAwzW2FZ7I06AABa
	 4EF5LZZRBKYjjjCuhUP+4cgs/C4f2Qqmkp40nz2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH 7.2 020/428] crypto: x86/aes-gcm - fix always true check for last AAD segment
Date: Fri,  9 Oct 2026 16:05:57 +0200
Message-ID: <20261009140946.503095071@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>

commit 226154ea87952ad7141ce2dcf52a6c2edd71b8fe upstream.

In gcm_process_assoc(), a segment that is not the last one must have its
length rounded down to a multiple of 16 bytes, as required by the
assembly. The check for a non-last segment is `if (unlikely(assoclen))
/* Not the last segment yet? */` where assoclen is the number of AAD
bytes remaining after the current segment.

Since the conversion to the new scatterwalk API, assoclen is decremented
at the end of the loop body rather than the beginning, so it still
includes the current segment when the check executes, making the check
always true.

As a result the last segment was rounded down as well, causing some
avoidable extra work: an additional memcpy into the temporary buffer and
an additional call into the assembly after the loop. The GCM
authentication tag is unaffected either way, so the self-tests pass and
this went unnoticed. It is purely an efficiency issue rather than a
correctness one.

Fix this by moving the assoclen decrement back to the beginning of the
loop body.

Fixes: e9787deff49e ("crypto: x86/aes-gcm - use the new scatterwalk functions")
Cc: stable@vger.kernel.org
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Link: https://patch.msgid.link/20260926145903.6061-1-raizudeen.kerneldev@gmail.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/crypto/aesni-intel_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1293,6 +1293,7 @@ static void gcm_process_assoc(const stru
 		unsigned int len;
 		const u8 *src = walk.addr;
 
+		assoclen -= orig_len_this_step;
 		if (unlikely(pos)) {
 			len = min(len_this_step, 16 - pos);
 			memcpy(&buf[pos], src, len);
@@ -1320,7 +1321,6 @@ next:
 			kernel_fpu_end();
 			kernel_fpu_begin();
 		}
-		assoclen -= orig_len_this_step;
 	}
 	if (unlikely(pos))
 		aes_gcm_aad_update(key, ghash_acc, buf, pos, flags);


