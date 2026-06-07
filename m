Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E1F308F38;
	Sun,  7 Jun 2026 10:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829513; cv=none; b=ERumj7wjP7evJaxMCOCwqnzuNy+iHvM0BJeCFEv6Kejv/aVY1Q+hgdipidi+EweNCA72W3Gj/0Z88Rp4br39/02gw4RxBnVzMne6hxOjeXS3LKHCi6BQvt2ZdgOLNqDtsrTXE9N/B9evsSdcFYWOrGhcNHZgd+NhdZhgiw/r19s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829513; c=relaxed/simple;
	bh=tcJMvRwGXB3K+fYgOC7yhxCX36UEuN7j7XzRPuHcnSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdJtz4zQ6t9q/jWltlxMO/NeFjNwr+L43DUG2Pl44g/7FbWzpqGgoNaMg79Iw2imStmOEx2XC30sVWQTpYM8vA1WapvFREc2gKsYQLCHAz6Qcb042imw8Prwir4Lz+pE6HhKBzY94oyIimcsqvRtfW1T+oA/nt0b0MZZzXhx5RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jR/L8KZq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jR/L8KZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313351F00893;
	Sun,  7 Jun 2026 10:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829512;
	bh=eATmb3JAXdpdPIDWkWPwIy0VlAvej8ZQ7WzfHGhsG+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jR/L8KZqzAIFEIIXz9FZoE3s94xFxTbVpitfOE8eKRWPt2Z1tYNPFzi4ngbCDIeKc
	 M1St82d7/JBlXyz0hdG5qGBKQsIQ93n3PD7LrEL7HDJCYmqq30J8OunfqjFH/bPldq
	 irzBZEI54TTxs6+1mksvteJlknMQ4rQJ9XFdkS3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	David Disseldorp <ddiss@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.18 254/315] scsi: target: iscsi: Validate CHAP_R length before base64 decode
Date: Sun,  7 Jun 2026 12:00:41 +0200
Message-ID: <20260607095736.885408938@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Alexandru Hossu <hossu.alexandru@gmail.com>

commit 85db7391310b1304d2dc8ae3b0b12105a9567147 upstream.

chap_server_compute_hash() allocates client_digest as
kzalloc(chap->digest_size) and then, for BASE64-encoded responses,
passes chap_r directly to chap_base64_decode() without checking whether
the input length could produce more than digest_size bytes of output.

chap_base64_decode() writes to the destination unconditionally as long
as there is input to consume. With MAX_RESPONSE_LENGTH set to 128 and
the "0b" prefix stripped by extract_param(), up to 127 base64 characters
can reach the decoder. 127 characters decode to 95 bytes. For SHA-256
(digest_size=32) this overflows client_digest by 63 bytes; for MD5
(digest_size=16) the overflow is 79 bytes.

The length check at line 344 fires after the write has already happened.

The HEX branch in the same switch statement already validates the length
up front. Apply the same approach to the BASE64 branch: strip trailing
base64 padding characters, then reject any input whose data length
exceeds DIV_ROUND_UP(digest_size * 4, 3) before calling the decoder.

Stripping trailing '=' before the comparison handles both padded and
unpadded encodings. chap_base64_decode() already returns early on '=',
so the full original string is still passed to the decoder unchanged.

The mutual CHAP path decodes CHAP_C into initiatorchg_binhex, which is
kzalloc(CHAP_CHALLENGE_STR_LEN). extract_param() caps initiatorchg at
CHAP_CHALLENGE_STR_LEN characters, so at most CHAP_CHALLENGE_STR_LEN-1
base64 characters reach the decoder. The maximum decoded size,
DIV_ROUND_UP((CHAP_CHALLENGE_STR_LEN-1) * 3, 4), is less than
CHAP_CHALLENGE_STR_LEN, so no overflow is possible there. A comment is
added at the call site to document this.

Fixes: 1e5733883421 ("scsi: target: iscsi: Support base64 in CHAP")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Reviewed-by: David Disseldorp <ddiss@suse.de>
Link: https://patch.msgid.link/20260521151121.808477-1-hossu.alexandru@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/iscsi/iscsi_target_auth.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -339,13 +339,22 @@ static int chap_server_compute_hash(
 			goto out;
 		}
 		break;
-	case BASE64:
+	case BASE64: {
+		size_t r_len = strlen(chap_r);
+
+		while (r_len > 0 && chap_r[r_len - 1] == '=')
+			r_len--;
+		if (r_len > DIV_ROUND_UP(chap->digest_size * 4, 3)) {
+			pr_err("Malformed CHAP_R: base64 payload too long\n");
+			goto out;
+		}
 		if (chap_base64_decode(client_digest, chap_r, strlen(chap_r)) !=
 		    chap->digest_size) {
 			pr_err("Malformed CHAP_R: invalid BASE64\n");
 			goto out;
 		}
 		break;
+	}
 	default:
 		pr_err("Could not find CHAP_R\n");
 		goto out;
@@ -472,6 +481,14 @@ static int chap_server_compute_hash(
 		}
 		break;
 	case BASE64:
+		/*
+		 * No overflow check needed: initiatorchg_binhex is
+		 * CHAP_CHALLENGE_STR_LEN bytes and extract_param() caps
+		 * initiatorchg at CHAP_CHALLENGE_STR_LEN characters, so
+		 * the decoded output is at most DIV_ROUND_UP(
+		 * (CHAP_CHALLENGE_STR_LEN - 1) * 3, 4) bytes, which is
+		 * less than CHAP_CHALLENGE_STR_LEN.
+		 */
 		initiatorchg_len = chap_base64_decode(initiatorchg_binhex,
 						      initiatorchg,
 						      strlen(initiatorchg));


