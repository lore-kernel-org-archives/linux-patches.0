Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EF52D8DA8;
	Mon, 13 Apr 2026 16:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096287; cv=none; b=dGW05EjXO8nUE7i0DC5+6xUffcMboPQgaPV+TMBXYa6n6nXU18sfsk24T5+fYEKKhdCy9QwkZwne+hM5KSW4iZ27ppmzNFMT/Js/a7UJhlhI4K3r1ymrQnGFyKxtz8HSgMgwM3ddDId425G1ybwhK4b6fxzxi8sNqTsO++oNbuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096287; c=relaxed/simple;
	bh=Xa8UWovBZNrn6OW9yUaPTGDgofxmFyWUOpiy8dJLOoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpnSPD13Y+tXJuS9rEsFh/HPtzNygza1bvNs7auGb77zAbLPYmFgDyVWIowqG0bfL1saWVcqrs1ripeBj0KibxEx10HoqVul2scS7ms/P20Kh2ENRuYgahEUI2J+fU4CO1ZXRPVVPoHWLV5o+jRRj3NezqiN+wuj7c49yHkHaL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uo+EjlMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uo+EjlMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09581C2BCC4;
	Mon, 13 Apr 2026 16:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096287;
	bh=Xa8UWovBZNrn6OW9yUaPTGDgofxmFyWUOpiy8dJLOoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uo+EjlMvECnYPBRntN0hIn+cx2WrbtB8L1lbvrW33GGX/7HWlg7uHmfJNYHy2FKnt
	 gpIhYtQD2kTP9KlkvOjZQHiB9H7wrz/vzRRU3loKrPstY32DiPis3YWcS6m6IrU7TN
	 LXu1Gf1aq/GhNL4h22caU3tKgRfdjLzNddYEQQV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Leo Lin <leo@depthfirst.com>
Subject: [PATCH 6.19 40/86] X.509: Fix out-of-bounds access when parsing extensions
Date: Mon, 13 Apr 2026 17:59:47 +0200
Message-ID: <20260413155733.064120240@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit d702c3408213bb12bd570bb97204d8340d141c51 upstream.

Leo reports an out-of-bounds access when parsing a certificate with
empty Basic Constraints or Key Usage extension because the first byte of
the extension is read before checking its length.  Fix it.

The bug can be triggered by an unprivileged user by submitting a
specially crafted certificate to the kernel through the keyrings(7) API.
Leo has demonstrated this with a proof-of-concept program responsibly
disclosed off-list.

Fixes: 30eae2b037af ("KEYS: X.509: Parse Basic Constraints for CA")
Fixes: 567671281a75 ("KEYS: X.509: Parse Key Usage")
Reported-by: Leo Lin <leo@depthfirst.com> # off-list
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Ignat Korchagin <ignat@linux.win>
Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/asymmetric_keys/x509_cert_parser.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -584,10 +584,10 @@ int x509_process_extension(void *context
 		 *   0x04 is where keyCertSign lands in this bit string
 		 *   0x80 is where digitalSignature lands in this bit string
 		 */
-		if (v[0] != ASN1_BTS)
-			return -EBADMSG;
 		if (vlen < 4)
 			return -EBADMSG;
+		if (v[0] != ASN1_BTS)
+			return -EBADMSG;
 		if (v[2] >= 8)
 			return -EBADMSG;
 		if (v[3] & 0x80)
@@ -620,10 +620,10 @@ int x509_process_extension(void *context
 		 *	(Expect 0xFF if the CA is TRUE)
 		 * vlen should match the entire extension size
 		 */
-		if (v[0] != (ASN1_CONS_BIT | ASN1_SEQ))
-			return -EBADMSG;
 		if (vlen < 2)
 			return -EBADMSG;
+		if (v[0] != (ASN1_CONS_BIT | ASN1_SEQ))
+			return -EBADMSG;
 		if (v[1] != vlen - 2)
 			return -EBADMSG;
 		/* Empty SEQUENCE means CA:FALSE (default value omitted per DER) */


