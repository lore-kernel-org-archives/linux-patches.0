Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19EE4071DD;
	Sun,  7 Jun 2026 10:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829530; cv=none; b=XdL2Ve8wUTvjntTpU831V+Mk4WPSc3hJ0rZGTnRHtTYnUHTYy8S4SzqFuE/CFSl/PsZjg3G9G2tgfzixNj9UFjLoH2wvL2UZ0iOuFvBeuYncPiyzXcywYWaLNcHGfzoUIngpmHFV0ayjRhxFQONJ1pakPKN+ZcD8IliFCCbqp2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829530; c=relaxed/simple;
	bh=xr1eMB/eolo9Kwsb3Grbr3YZElv+dW07NFQylb23mvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlQ1FY4OnVKPL1agepk50rsDobVuQ8twA9mVkJiJu3Nqo6yotYfkEnTgxRlz6u11wQEgqEKi3cHoYzq78DN1bGDCIGuIbPzI74d7JLlwKjxhFtV1zPBXTcYCB5eqatP08JIUq2c7upbVKsEYdyl7HXZLThvytX9TsRVTvIZJteI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyIMmier; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyIMmier"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B881F00893;
	Sun,  7 Jun 2026 10:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829529;
	bh=7YAn+5pPq2WBfJKQCDiyHIpRqKCHE8ww0wFOTKSutoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyIMmier9M+ukopBHjZj9dbWqsqjXCGzQxVfYR8lJm4lrqfBw4BGW0GIBgvH90gwh
	 XIQqMv8qtr0TueRPfzegTuqJ7ITGsRVnMXY47cN2T7wjgAkb8LriaQMxpqZZ5Y4xe7
	 fcuWhqspA3qH+2oBBWVGhXXCNPuJqHR3U89zW0RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	David Disseldorp <ddiss@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7.0 287/332] scsi: target: iscsi: Validate CHAP_R length before base64 decode
Date: Sun,  7 Jun 2026 12:00:56 +0200
Message-ID: <20260607095738.587083033@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -340,13 +340,22 @@ static int chap_server_compute_hash(
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
@@ -473,6 +482,14 @@ static int chap_server_compute_hash(
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


