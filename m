Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96404BE43B;
	Fri,  9 Oct 2026 14:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555515; cv=none; b=DCL2gd/Ph3YRilUXhPbVQQi7CeXOEc5l2uMLOXTIXU2AmwvD1asXhpbSOIu+xJPjBqFlajTDNB4rLJh5AivPvQ4q9DAsEwWQFefDH7u/MAe27vYciLp3hxRAXgbfOBXNf0Wi/FBu+5zCAPGCb5lnguax7xjX9wMiGqa0EuV3XsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555515; c=relaxed/simple;
	bh=VvMCiWl2olbK3rn41csB/in/ZJDard3fjrljzJJlE9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUJSPDqXcuajvJ2A/oitCvgHhZd9vPi8vmhyOIKh6MTmeQes9Xg4OZM54ssHoGaB98HuXIw6qSSmlZ9jFXSdxW1gxbPccNy/tiNhqOLNytHs2phNxbA+DsLISriL76O7R8wzh489NY80dFWLFwfSaKvG+4i4q44ABJ0Jo8ocAP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4isXeZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4isXeZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405BF1F00893;
	Fri,  9 Oct 2026 14:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555513;
	bh=BmbbUdsWQtxvuFHhznuBmdxX1Fn/gRvUtwCJO3WorpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4isXeZcKStWm//9jhUeYnWKalbtB2pZN5zFN0jy9fcYD6W/BT2EfRpv6SDhS+L3K
	 s61/5Rd1cqO7CippDLuLeRRmuHtIxxwKIvT3gdz08DyAEuErucPlDCpBmR4E+M6y70
	 isRrHu+g24hD6VcIYsFALcbEPZdv+QYy4nTqun6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH 6.18 021/403] crypto: x86/aes-gcm - fix always true check for last AAD segment
Date: Fri,  9 Oct 2026 16:06:22 +0200
Message-ID: <20261009140952.612783301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
@@ -1286,6 +1286,7 @@ static void gcm_process_assoc(const stru
 		unsigned int len;
 		const u8 *src = walk.addr;
 
+		assoclen -= orig_len_this_step;
 		if (unlikely(pos)) {
 			len = min(len_this_step, 16 - pos);
 			memcpy(&buf[pos], src, len);
@@ -1313,7 +1314,6 @@ next:
 			kernel_fpu_end();
 			kernel_fpu_begin();
 		}
-		assoclen -= orig_len_this_step;
 	}
 	if (unlikely(pos))
 		aes_gcm_aad_update(key, ghash_acc, buf, pos, flags);


