Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F8B1D798E;
	Sat, 12 Sep 2026 17:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232572; cv=none; b=ADzkGtS6iCUx4YCiJBZYaqethRSxZ+NMpDp8883hP1oCAzafuJmw6vM+34LEAsxy6OMsUqMhJjYOz0cIu7g31bYRWsrSzNL74YAG4BkDqfGb3kvvenz8YcchqneBG2xnHr+s1/2eKwWp1SgzH/9DKQYIEkPr3SP1QD6piXFPi4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232572; c=relaxed/simple;
	bh=cuwoS1YUklfObdo5ukJDYvfCQuXFOYNwvfObmbnkdSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H28+Rhudl2LGzA4NgFFa2gYvh0FOXm0vZDrSR6BFkxnv9IlExJdEY4pUo6GPAzVDwfZaXRMD8yNCdxwEAGJN3bb02Fzgqc0chXy914MmjOGODBGK+NF63uqkc8/gHHLvcVssATDNUXdaSsINhNUjpjG7ya1qa4XRp6Imvbkk/7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrYZQsCL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrYZQsCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29BA1F00893;
	Sat, 12 Sep 2026 17:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232570;
	bh=WbHYG20UoZpUDLzk1ugwA/Vt0pJcW+vyP1JOQHA39no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrYZQsCLu3q1RnF0KEN1TmbLa49elasyEaBPrJHy5q+3sutJoLkWTB6OL57mxIKR/
	 1MhwFqrqu+U49DgOc/+Yu9nSPl23xPhjOz7ObH7OKGN3cVmUKMIKGrn772cldZeWl6
	 XeEPd+kYsZDYIhR90hEd6GWh6ecPMzh5GWUvetR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ibrahim Hashimov <security@auditcode.ai>,
	Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>
Subject: [PATCH 5.15 030/935] ubifs: fix out-of-bounds read in signature length check
Date: Sat, 12 Sep 2026 08:51:00 +0200
Message-ID: <20260912065527.531341566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


