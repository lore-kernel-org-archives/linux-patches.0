Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1A63BC4C9;
	Thu, 15 Jan 2026 17:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498015; cv=none; b=R+V95V4j6cqlzVYa0HAuYxO1EjySF0aLozVMDM9LaF+JGf/14LZEMJqebRm9sDbVqhNzjTnqKk58bT/n1i8DkF+AAziIcl8NG0gbKV9JhkrmCtXzlFsmhVdGPknAjfucMhsBG6/jJ6KpV6em30WBN5syl+q6Dt3BcZGGTuPWPpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498015; c=relaxed/simple;
	bh=iYwawdWP3+K9UgRyYvF+AgDyU/IBSDKEwAriTemrCfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASCzzSCDUTrb3pXOiVt/uZf7OABcXX0nMLZK3cve3FyviJkpuueGEQHyg+C7cakFJZtuYOk/2j5IjlBNtIyq6QLlyPCGWOluG5E59N3uDL/8I8lfpDa+lf2GfEs8UM0stwedINcUQGtvdhZvrAglkG5/1f+uPmI1eNxzMkSAqq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZAWUMyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZAWUMyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E05C116D0;
	Thu, 15 Jan 2026 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498015;
	bh=iYwawdWP3+K9UgRyYvF+AgDyU/IBSDKEwAriTemrCfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZAWUMyOAS7mqHNtNRTYJhaxpgVB7sIdWXxpi8WqUUnZjniAIve7OuFlfFF8L8r+l
	 u3HjjQkNevfp+hdaE7VFog50gQvl1avfssLkGfj/kEfhEaKtwB4DFReYBQLIx+n409
	 JU3ycljKkFVnNrNk4BxeE/oUGyZD4vAmsqbdGKZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 276/554] KEYS: trusted: Fix a memory leak in tpm2_load_cmd
Date: Thu, 15 Jan 2026 17:45:42 +0100
Message-ID: <20260115164256.218267749@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 62cd5d480b9762ce70d720a81fa5b373052ae05f upstream.

'tpm2_load_cmd' allocates a tempoary blob indirectly via 'tpm2_key_decode'
but it is not freed in the failure paths. Address this by wrapping the blob
into with a cleanup helper.

Cc: stable@vger.kernel.org # v5.13+
Fixes: f2219745250f ("security: keys: trusted: use ASN.1 TPM2 key format for the blobs")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted-keys/trusted_tpm2.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -375,6 +375,7 @@ static int tpm2_load_cmd(struct tpm_chip
 			 struct trusted_key_options *options,
 			 u32 *blob_handle)
 {
+	u8 *blob_ref __free(kfree) = NULL;
 	struct tpm_buf buf;
 	unsigned int private_len;
 	unsigned int public_len;
@@ -388,6 +389,9 @@ static int tpm2_load_cmd(struct tpm_chip
 		/* old form */
 		blob = payload->blob;
 		payload->old_format = 1;
+	} else {
+		/* Bind for cleanup: */
+		blob_ref = blob;
 	}
 
 	/* new format carries keyhandle but old format doesn't */
@@ -446,8 +450,6 @@ static int tpm2_load_cmd(struct tpm_chip
 			(__be32 *) &buf.data[TPM_HEADER_SIZE]);
 
 out:
-	if (blob != payload->blob)
-		kfree(blob);
 	tpm_buf_destroy(&buf);
 
 	if (rc > 0)


