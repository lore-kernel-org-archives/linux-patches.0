Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A434827BF6C;
	Mon, 13 Apr 2026 16:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096511; cv=none; b=jDhWf1skrbSzwM6oeWneCgmJdVNMQWTwmwDvVGI5Jw3AXPTBNHMuU1yynRnzH+mvDpxWLrW3wKWIwKHiXVtXs87vFL7gO9rFiJPuTcq07PxNmQKhtN0NTaLlVJMhx52uEV3C+83hX/pyl5yZ6rEhg/DhucrULTEkqEHd5TLLai0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096511; c=relaxed/simple;
	bh=D4mCvZrE4scGYcAY87BFkFRw4jdLUhYMWW2oUA6wglY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXrpkibL4po5CxqyOuqOe6/BQVXPUKZCXJ5DUHFF4BvtMsNf1aSsPqk8i0Se6NM5M6e5PpUC6uGTUjjMwoTxSASaU+6O+CNFelyRmP38K/az9HWheq3Lax3rWo0baWnFkb3dxqSw8+pdTzMPW07OxuCBoCEWQfRZF4zJkdy6UUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nux94Tgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nux94Tgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B8FC2BCB0;
	Mon, 13 Apr 2026 16:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096511;
	bh=D4mCvZrE4scGYcAY87BFkFRw4jdLUhYMWW2oUA6wglY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nux94Tgilm9psT/JlSgoW4KNxUuJh4BGY/fF4NR8yq1WRq/wRawKjf4eBlyVEA6VJ
	 D0IDBmBreFxPHtYgMHSRmgC1umQj3bPbvml5+iauSuj1Xa0NWBmaUuDQm2ED7r3Tce
	 f867Hicp0Y03DyuXyUIuG4rdZ9xiJJryKrJoA138=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Leo Lin <leo@depthfirst.com>
Subject: [PATCH 6.18 38/83] X.509: Fix out-of-bounds access when parsing extensions
Date: Mon, 13 Apr 2026 18:00:06 +0200
Message-ID: <20260413155732.438121981@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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


