Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C62232B108;
	Sat, 12 Sep 2026 15:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226733; cv=none; b=CaNDh/t/ut+G7VRc1c7IbIMynyOhyC1UutajZNrQJAcSUVcDn1YNIk2lwqimVtQgkj5prgc37c+F6tYlvH5BbV1VWeyqyp8NuRgyMQvqP3RulYZ11Ug+yqvR4jyEtUuLj8k9ICN4P5Yi3iLIx/vRQNGoVCoWW1BvNsyeBdznZPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226733; c=relaxed/simple;
	bh=C8eDw+s+IMUK963gziQ7MPSyqAeT30JLjaMn5Y3IjSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2WxUIEIf/0Qnr1n88eRo36X6G1C2Yp4xlFKJTPN0siCGQy9cNAvvDx5g4QAbrw+kzyIwzZSQX9jVC/pB0dnfHbVLs82yo1hgzNRzwIHcWZoArJ3NKEKYqmN3YJEjzEZH7RRQZ0dzITRZcCpl98wnMfUnT3UY9BUTYx8GX1cXmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQP8fdHI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQP8fdHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06DD1F000FF;
	Sat, 12 Sep 2026 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226732;
	bh=AgMiaLkBYtywymKl6bDWxZZhOlMHR0lFYtZfN+kU2Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQP8fdHIg78hPmKd3INj0rMOG6WYvs61koh7GBFcyFFk/mPYEIbmo43gHx/ZpO2rw
	 aUSgKMxZQ1JMfxVBJPbYLZiufBLQP/g06PnaB6WDjPrit+DaW4Q1YQlKDRV9zBDWal
	 SZM3JMoQILaPgerjCklKOZMED+Udd+JSZRkmQr/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>
Subject: [PATCH 6.1 0037/1191] ubifs: fix out-of-bounds read in signature length check
Date: Sat, 12 Sep 2026 08:46:05 +0200
Message-ID: <20260912065548.963955687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ibrahim Hashimov <security@auditcode.ai>

commit 95d27c1708bb6e8823c8e7c623f9abc2a91bf4bf upstream.

ubifs_sb_verify_signature() bounds the on-disk ubifs_sig_node->len field
before handing the signature payload to verify_pkcs7_signature(), but the
check has the wrong sign:

	if (le32_to_cpu(signode->len) > snod->len + sizeof(struct ubifs_sig_node))

The signature bytes start sizeof(struct ubifs_sig_node) (UBIFS_SIG_NODE_SZ,
64 bytes) into the node, so the payload is at most

	snod->len - sizeof(struct ubifs_sig_node)

bytes long. Adding the header size instead of subtracting it accepts a
declared length up to 2 * UBIFS_SIG_NODE_SZ larger than the node actually
holds -- past the end of c->sbuf, which is vmalloc(c->leb_size).
verify_pkcs7_signature() -> pkcs7_parse_message() -> asn1_ber_decoder()
is then handed that inflated length and reads beyond the allocation while
walking the DER headers. The node length comes straight from the mounted
image, so a crafted signed UBIFS image reaches this via
ubifs_read_superblock() before the signature is cryptographically checked.

snod->len is guaranteed to be >= UBIFS_SIG_NODE_SZ by the node scanner
(c->ranges[UBIFS_SIG_NODE].min_len == UBIFS_SIG_NODE_SZ), so the corrected
subtraction cannot underflow. Legitimately signed images are unaffected: a
correct superblock never declares a signature longer than the node it is
embedded in.

Fixes: 817aa094842d ("ubifs: support offline signed images")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
Reviewed-by: Richard Weinberger <richard@nod.at>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/auth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -218,7 +218,7 @@ int ubifs_sb_verify_signature(struct ubi
 
 	signode = snod->node;
 
-	if (le32_to_cpu(signode->len) > snod->len + sizeof(struct ubifs_sig_node)) {
+	if (le32_to_cpu(signode->len) > snod->len - sizeof(struct ubifs_sig_node)) {
 		ubifs_err(c, "invalid signature len %d", le32_to_cpu(signode->len));
 		err = -EINVAL;
 		goto out_destroy;


