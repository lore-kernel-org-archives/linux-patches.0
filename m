Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE881433A8;
	Tue, 22 Jul 2025 13:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192041; cv=none; b=l3f6kdvP+sc5etAUmUsYoGX/L4N9D8uqCalNe47H7IGUz9CugPljzDHukFz1aIwLgfYIa12MAdXcMZIroamarhTHeHCqypoUFVoTTJNrY4HFzrGu4IZLPHQ6icB5AJ93Md7xoUH0UMd8pYDGlzl2UmqwKLUKSBmRsJTTNy+HVaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192041; c=relaxed/simple;
	bh=9bMIiWhLPqqJqjoC5NJ9QkaT0Gm84MgScawmQ/E0CMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quzCbEJRUKqbQIpZ09BpNNiXxL9qNI0iSD/kzWWPsKjuL2fQAHHuQv757gdc8xC8KNOLK30KAtM3ual59RWu0LoSJCXcAAYMbf0LTGlluOP1MmePAohOymuxS14wi/ECnpF0RdkteXhr2SXtaXTASi0U5aIsHSwFM8K+DyAw/HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqHXWan3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqHXWan3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F57C4CEF6;
	Tue, 22 Jul 2025 13:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192040;
	bh=9bMIiWhLPqqJqjoC5NJ9QkaT0Gm84MgScawmQ/E0CMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqHXWan3HBdNo0Tks3PO8MCE2ei8S6s2RV0FgXsLYUWnZ8eEEMlg87Nl+FGPh8Fs6
	 JbPST6VzQUgjnjIcR4Ar6lJ9m3jpVb4eP6YZ65ieGPjWvZcF387CjJ2rj4sXFQhXxb
	 OI6oPbfsMZ2gh6k2zq+nqtWcB897YQUfQM+8OarE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Wang Zhaolong <wangzhaolong@huaweicloud.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 27/79] smb: client: fix use-after-free in crypt_message when using async crypto
Date: Tue, 22 Jul 2025 15:44:23 +0200
Message-ID: <20250722134329.369300470@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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
@@ -4497,6 +4497,7 @@ crypt_message(struct TCP_Server_Info *se
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
 	struct aead_request *req;
 	u8 *iv;
+	DECLARE_CRYPTO_WAIT(wait);
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	void *creq;
 
@@ -4545,7 +4546,11 @@ crypt_message(struct TCP_Server_Info *se
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


