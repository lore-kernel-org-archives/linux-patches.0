Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D819846AA9C;
	Tue, 21 Jul 2026 15:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648356; cv=none; b=B8aOJmAe7hw2qoSB6QSo3+eMh+JDjKPud7b/vToaFToruvyRdJnUuGoKJ7PIde3efFkJoQvmgtM80Xn94J1Uc7yESVKoBOFJeZj1kDFi5FPXKASBgFTC2S1t7m3+rpNOcl6+xO5HDbumyQQPhIKYCpQwqJDsS6p8SDe9487rTkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648356; c=relaxed/simple;
	bh=r9sbxiPlAG+aaL926ueDXIp8jOeE0JIa0i2VWJ2cZ/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8a7U0M7AkZWPc0gYu+cQL5OV3RjtZKwSLAZKDlDOqRM6i3HtcJXNpsZK91sYX52mgw+wbGW3QEF7SpGZnHfafmqTaHLZSf2TE5nVgADNwlGEWEPpu39el/6FZMR/oBbjNZ7FFoU7lE4gaz9+HV/UyV6nC0qTu4+Aia33t1R4OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+R7FTLt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+R7FTLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493251F000E9;
	Tue, 21 Jul 2026 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648354;
	bh=IONfQiXYg+pm4uZAfCyPI5dQwgR+xDW7ZlWkmNbsAbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+R7FTLteUubdn+w7Bu/C1oI8GP5jjIbeASCOnXCEdqR4H4Wnx7aclaPxnl99rot7
	 zvwIm/toVGTU1zl4CCWkIIDc4ytIB44myt9DEWruPIFybAW/dRK7aytMmj7M0FTTQh
	 wYT34ocQyLLSmrnaAXAL2yfDSYF80aWaPlwyd364=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0167/2077] crypto: asymmetric_keys - fix OOB read in pefile_digest_pe_contents
Date: Tue, 21 Jul 2026 16:57:20 +0200
Message-ID: <20260721152556.630702809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit f7dd32c5179d7755de18e21d5674b08f9e5cb180 ]

pefile_digest_pe_contents() computes the trailing-data hash length as
pelen - (hashed_bytes + certs_size). A crafted PE can make the addition
exceed pelen, causing the unsigned subtraction to underflow to ~4 GiB.
This is passed to crypto_shash_update() which reads out of bounds and
panics on unmapped vmalloc guard pages.

 BUG: unable to handle page fault for address: ffffc900038d8000
 Oops: Oops: 0000 [#1] SMP KASAN NOPTI
 RIP: 0010:sha256_blocks_generic (lib/crypto/sha256.c:152)
 Call Trace:
  <TASK>
  __sha256_update (lib/crypto/sha256.c:208)
  crypto_sha256_update (crypto/sha256.c:142)
  verify_pefile_signature (crypto/asymmetric_keys/verify_pefile.c:436)
  kexec_kernel_verify_pe_sig (kernel/kexec_file.c:151)
  __do_sys_kexec_file_load (kernel/kexec_file.c:406)
  do_syscall_64 (arch/x86/entry/syscall_64.c:94)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  </TASK>
 Kernel panic - not syncing: Fatal exception

Validate that the addition does not overflow and the result does not
exceed pelen before the subtraction. Return -ELIBBAD on failure.

Fixes: af316fc442ef ("pefile: Digest the PE binary and compare to the PKCS#7 data")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/verify_pefile.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index 1f3b227ba7f221..cec99db14129af 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -305,6 +305,8 @@ static int pefile_digest_pe_contents(const void *pebuf, unsigned int pelen,
 
 	if (pelen > hashed_bytes) {
 		tmp = hashed_bytes + ctx->certs_size;
+		if (tmp <= hashed_bytes || pelen < tmp)
+			return -ELIBBAD;
 		ret = crypto_shash_update(desc,
 					  pebuf + hashed_bytes,
 					  pelen - tmp);
-- 
2.53.0



