Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5798F30F547;
	Mon, 13 Oct 2025 15:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367843; cv=none; b=JfnNw2A1TFXlcRSKKiu05U0w44Pve14hfGXT/Yhb1nS6MGVCc+DE7jU9hbyWqkd9EShw2Pdz4QRkvYBaPgNBPotKuclP2xbGIXMs7mUZhgUB4NVr6FGHoXXlnMFmHA9ABMCNvMS0Sn5d9emW9yW/f4k8rKsNp2HbfdkhN7SEue4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367843; c=relaxed/simple;
	bh=oG5MM8tYym7O2Z8oguWXjp4+0eELiCBTbbJrW9OWhrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIpQX5oNU12M0v2fJAjBaIdTvoJec4N5RoVg6R+SJuxaZN9JsgKBZcjxU4Ide/IMxBJo23yzHKc4Dur5T0/PYCoJdmro+oO13OMkrxrCO2An8em5QfEAiycSCkYF+7q8WzlhWKwh4RXVVs+1QAWtqZF0dQrzEkG7dLxmMEUF/ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfTDSnQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfTDSnQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FC4C4CEE7;
	Mon, 13 Oct 2025 15:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367843;
	bh=oG5MM8tYym7O2Z8oguWXjp4+0eELiCBTbbJrW9OWhrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZfTDSnQTmoqdkFSNzes8Pv8h9/+bPiwdvoXTUBCQnR3r1Y5j5Y/5WeTX4s1nL5/TG
	 iDRNR57ZPcJRU2CRU/pWEdOh6MtULnfn6sLozwnRItMcbdqBEiirEdBgBJ6XWVJKq8
	 0e5KXUvDQ7FsfTReXRza/jx/XtDLVlOR/aHC37Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <wufan@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/196] KEYS: X.509: Fix Basic Constraints CA flag parsing
Date: Mon, 13 Oct 2025 16:45:45 +0200
Message-ID: <20251013144320.881266839@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <wufan@kernel.org>

[ Upstream commit 5851afffe2ab323a53e184ba5a35fddf268f096b ]

Fix the X.509 Basic Constraints CA flag parsing to correctly handle
the ASN.1 DER encoded structure. The parser was incorrectly treating
the length field as the boolean value.

Per RFC 5280 section 4.1, X.509 certificates must use ASN.1 DER encoding.
According to ITU-T X.690, a DER-encoded BOOLEAN is represented as:

Tag (0x01), Length (0x01), Value (0x00 for FALSE, 0xFF for TRUE)

The basicConstraints extension with CA:TRUE is encoded as:

  SEQUENCE (0x30) | Length | BOOLEAN (0x01) | Length (0x01) | Value (0xFF)
                             ^-- v[2]         ^-- v[3]        ^-- v[4]

The parser was checking v[3] (the length field, always 0x01) instead
of v[4] (the actual boolean value, 0xFF for TRUE in DER encoding).

Also handle the case where the extension is an empty SEQUENCE (30 00),
which is valid for CA:FALSE when the default value is omitted as
required by DER encoding rules (X.690 section 11.5).

Per ITU-T X.690-0207:
- Section 11.5: Default values must be omitted in DER
- Section 11.1: DER requires TRUE to be encoded as 0xFF

Link: https://datatracker.ietf.org/doc/html/rfc5280
Link: https://www.itu.int/ITU-T/studygroups/com17/languages/X.690-0207.pdf
Fixes: 30eae2b037af ("KEYS: X.509: Parse Basic Constraints for CA")
Signed-off-by: Fan Wu <wufan@kernel.org>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/x509_cert_parser.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 0a7049b470c18..5201f47e31d8b 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -618,11 +618,14 @@ int x509_process_extension(void *context, size_t hdrlen,
 		/*
 		 * Get hold of the basicConstraints
 		 * v[1] is the encoding size
-		 *	(Expect 0x2 or greater, making it 1 or more bytes)
+		 *	(Expect 0x00 for empty SEQUENCE with CA:FALSE, or
+		 *	0x03 or greater for non-empty SEQUENCE)
 		 * v[2] is the encoding type
 		 *	(Expect an ASN1_BOOL for the CA)
-		 * v[3] is the contents of the ASN1_BOOL
-		 *      (Expect 1 if the CA is TRUE)
+		 * v[3] is the length of the ASN1_BOOL
+		 *	(Expect 1 for a single byte boolean)
+		 * v[4] is the contents of the ASN1_BOOL
+		 *	(Expect 0xFF if the CA is TRUE)
 		 * vlen should match the entire extension size
 		 */
 		if (v[0] != (ASN1_CONS_BIT | ASN1_SEQ))
@@ -631,8 +634,13 @@ int x509_process_extension(void *context, size_t hdrlen,
 			return -EBADMSG;
 		if (v[1] != vlen - 2)
 			return -EBADMSG;
-		if (vlen >= 4 && v[1] != 0 && v[2] == ASN1_BOOL && v[3] == 1)
+		/* Empty SEQUENCE means CA:FALSE (default value omitted per DER) */
+		if (v[1] == 0)
+			return 0;
+		if (vlen >= 5 && v[2] == ASN1_BOOL && v[3] == 1 && v[4] == 0xFF)
 			ctx->cert->pub->key_eflags |= 1 << KEY_EFLAG_CA;
+		else
+			return -EBADMSG;
 		return 0;
 	}
 
-- 
2.51.0



