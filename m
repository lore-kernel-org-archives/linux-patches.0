Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D5A3672BA;
	Tue, 21 Jul 2026 17:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655742; cv=none; b=iagjnpX4yklf1khmgTrpMUcikUNgFmF+7cTMFizuTlCwHgNWR9ybZP4GeqfdRqtBxFsCbkY5ee8a5xanL+9wQlm5iPPqZz4CEXAtVtCIrRiVrOY2Br3faYbbFylalxp9JyO9vLNCu44K6pMmsAJGBSxjzda5BGOAVFZifpuU1HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655742; c=relaxed/simple;
	bh=IQ8GyIGE63kAPIO46dX1JMryNjdu4AKfkm99eO1bxy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gR6ssSP1yO1wckewZ1rs84M8jpKKkOKCUpaIvzSQBMEM5qlFkofsKZEzgxaEfEED7R5OMk0mrXLnmIITjQBDfMGhWBxOWi0EP19VsPB+rmq6R1MTYY8fCiQnRNR8TfREzkzsIVxQF/dQWNBQl48VGS207PqwISzTaApt+Jm4K9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOSE2+Gz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOSE2+Gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DA41F000E9;
	Tue, 21 Jul 2026 17:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655741;
	bh=1JAYuk9H0YGyoIDPHem+UW7CS7VDsnR1kyT2b+aV0vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOSE2+Gz6cA84uG/Z+uzVnzHN39842m5RJCjB+PrjuAcNbsPl/HPAvzgHxgYN60AR
	 aebX/Mr2191fQ8vp6YakJZmZpZvLPST3PETmW4uxsUcQZ8j9cHS0JZwwGX/mU1I57f
	 OnzwPOqJnCNNHfgYl3Yg/WfmQOOAyuAjRlkE/g6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0124/1611] crypto: asymmetric_keys - fix OOB read in pefile_digest_pe_contents
Date: Tue, 21 Jul 2026 17:04:00 +0200
Message-ID: <20260721152517.650201822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



