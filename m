Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C4289340;
	Tue, 22 Jul 2025 13:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192363; cv=none; b=sOs8Pm8trxaBnFeCGnZ2pz/lsPKf5qu9V+L6MuHB+rOw6vO4lQBGlQSFPU46GsLpjYBcXpsFfmf/AARAa4cJDxJYgjvoZCT2azCkh2df02/pl/OeTOmuLRzfvOYKYzbmkkuzfM6MTddbH0Hi+EhszwRcwwqdkJZ4R2Npalh6lYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192363; c=relaxed/simple;
	bh=BoTbcfSwMoZtKwrYsJvCGKVfGVVzeUqF2ao/XlTyI4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOhHWTgJI0muqdRPCHoBGavgFFmqC2YR5i/kYo7El9s+ZNHFG5RvtcBk8rQvo2uVwZtQsYDVtEnu+Y3ibMy/tRokloOz4LLCy5WZsHsy0FGZUOFl/BEOPXwmQPm2Sn2CPSAaKdJ4jiEZc4/31rXmL39TWUTOCnTmu7w4TsKPMos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x076ErPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x076ErPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496A1C4CEEB;
	Tue, 22 Jul 2025 13:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192362;
	bh=BoTbcfSwMoZtKwrYsJvCGKVfGVVzeUqF2ao/XlTyI4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x076ErPSI2SH7IvdsVPjj91Ghck9HeyF06AjLMCx7Padz22lzTen0RxM/u4lscrqV
	 hW3Kqxw1oBhkPIlDyPFX2ORYbgkOKWXe+c2hZ/OgST4cJeDR2JNdBamQ4xgvhtSDYs
	 vYPJ/NuAHlTJoupCZg5OBGbwaQs8tlQAZA+Le/rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 044/111] smb: client: fix use-after-free in crypt_message when using async crypto
Date: Tue, 22 Jul 2025 15:44:19 +0200
Message-ID: <20250722134335.035778766@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Zhaolong <wangzhaolong@huaweicloud.com>

commit b220bed63330c0e1733dc06ea8e75d5b9962b6b6 upstream.

The CVE-2024-50047 fix removed asynchronous crypto handling from
crypt_message(), assuming all crypto operations are synchronous.
However, when hardware crypto accelerators are used, this can cause
use-after-free crashes:

  crypt_message()
    // Allocate the creq buffer containing the req
    creq = smb2_get_aead_req(..., &req);

    // Async encryption returns -EINPROGRESS immediately
    rc = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);

    // Free creq while async operation is still in progress
    kvfree_sensitive(creq, ...);

Hardware crypto modules often implement async AEAD operations for
performance. When crypto_aead_encrypt/decrypt() returns -EINPROGRESS,
the operation completes asynchronously. Without crypto_wait_req(),
the function immediately frees the request buffer, leading to crashes
when the driver later accesses the freed memory.

This results in a use-after-free condition when the hardware crypto
driver later accesses the freed request structure, leading to kernel
crashes with NULL pointer dereferences.

The issue occurs because crypto_alloc_aead() with mask=0 doesn't
guarantee synchronous operation. Even without CRYPTO_ALG_ASYNC in
the mask, async implementations can be selected.

Fix by restoring the async crypto handling:
- DECLARE_CRYPTO_WAIT(wait) for completion tracking
- aead_request_set_callback() for async completion notification
- crypto_wait_req() to wait for operation completion

This ensures the request buffer isn't freed until the crypto operation
completes, whether synchronous or asynchronous, while preserving the
CVE-2024-50047 fix.

Fixes: b0abcd65ec54 ("smb: client: fix UAF in async decryption")
Link: https://lore.kernel.org/all/8b784a13-87b0-4131-9ff9-7a8993538749@huaweicloud.com/
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4271,6 +4271,7 @@ crypt_message(struct TCP_Server_Info *se
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
 	struct aead_request *req;
 	u8 *iv;
+	DECLARE_CRYPTO_WAIT(wait);
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	void *creq;
 	size_t sensitive_size;
@@ -4321,7 +4322,11 @@ crypt_message(struct TCP_Server_Info *se
 	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
 	aead_request_set_ad(req, assoc_data_len);
 
-	rc = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &wait);
+
+	rc = crypto_wait_req(enc ? crypto_aead_encrypt(req)
+				: crypto_aead_decrypt(req), &wait);
 
 	if (!rc && enc)
 		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);


