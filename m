Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7CF3CEB9E;
	Thu, 17 Sep 2026 18:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671094; cv=none; b=EVK7uaSs0iGCK2PRk4UU5hFfs6aUuRGLyEye8+QiYJ2AHRCPuTaDIgAb11gO3XpqCirzxEcr/B+mT2+e0xd7m3MQJy3dLEMtNrHdSaLSw/w2KGyLZVNX9VBY8m7FmWV9x9hEp6YyChhmvvFkRMCjLe3QycOJy+TOkD287UjTx+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671094; c=relaxed/simple;
	bh=TO6bK2JMnBfKl6BzPYqS+3IOVNQmD4XWiIOQKFi7k+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+Wj3NM4oGAfVbIEHp7ku15eEjELuV63EmQ8ZXXhDfFfi/22myO4LYgnCMkZVwXOhcMn9fSh3wIafQamRk/vzELLM54U8PxADeSikqvYCdCn7gDBu5YZBbk0ZyQKkQFTONXwmfVo1sOUZ2nn+fJR+0o9KdpCCwYK1O91scqGsRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6xDcNGs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6xDcNGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD121F000FF;
	Thu, 17 Sep 2026 18:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671093;
	bh=bnqMP4drx8xKac6XVaQ5spofM7aAMQQF608GCI3GBug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6xDcNGs9qrBf34FTfXJs6LJ/VzfivMyG2z79O/lE1z9nBZRhWbWVHlh0qtnxCnBS
	 IvsTbQw4PD0c+0AWU5w8YIDicvnfE65ru8ybPUfPwJIHwCBo7oiWiWHXRmpLhiHUjK
	 nu4ojPYLcbOLw5eetuwSIxN7ri3C/iLbVP3vI7BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 0865/1102] s390/crypto: Fix missing scrub of temp buffers with AES ctr and gcm algorithm
Date: Thu, 17 Sep 2026 16:13:28 +0100
Message-ID: <20260917151602.270028950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit 8b7c3b6914f19caf648d05726a86af6326d3c2c6 upstream.

In function ctr_aes_crypt() there is a buffer used to process
remaining bytes < AES_BLOCK_SIZE. This buffer was not scrubbed and
thus could lead to expose of unwanted data. When the buffer is used
explicitly scrub it at the end of the code block to avoid exposure of
maybe sensitive data.

In a similar way the function gcm_aes_crypt() hat an error path where
the CPACF param block was not scrubbed. Instead of return early now
these error paths go to end of function where explicit scrubbing is
done. Similar with the buffers which are part of the gcm_sg_walk
structs from the variables gw_in and gw_out.

Fixes: d07f951903fa ("crypto: s390/aes - Fix buffer overread in CTR mode")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.8+
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/aes_s390.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -726,6 +726,7 @@ static int ctr_aes_crypt(struct skcipher
 		memcpy(walk.dst.virt.addr, buf, walk.nbytes);
 		crypto_inc(walk.iv, AES_BLOCK_SIZE);
 		ret = skcipher_walk_done(&walk, 0);
+		memzero_explicit(buf, sizeof(buf));
 	}
 
 	return ret;
@@ -1027,10 +1028,14 @@ static int gcm_aes_crypt(struct aead_req
 			  gw_in.ptr, aad_bytes);
 
 		n = aad_bytes + pc_bytes;
-		if (gcm_in_walk_done(&gw_in, n) != n)
-			return -ENOMEM;
-		if (gcm_out_walk_done(&gw_out, n) != n)
-			return -ENOMEM;
+		if (gcm_in_walk_done(&gw_in, n) != n) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		if (gcm_out_walk_done(&gw_out, n) != n) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		aadlen -= aad_bytes;
 		pclen -= pc_bytes;
 	} while (aadlen + pclen > 0);
@@ -1042,7 +1047,10 @@ static int gcm_aes_crypt(struct aead_req
 	} else
 		scatterwalk_map_and_copy(param.t, req->dst, len, taglen, 1);
 
+out:
 	memzero_explicit(&param, sizeof(param));
+	memzero_explicit(gw_in.buf, sizeof(gw_in.buf));
+	memzero_explicit(gw_out.buf, sizeof(gw_out.buf));
 	return ret;
 }
 


