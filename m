Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CEE35C19A;
	Fri,  9 Jan 2026 12:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962397; cv=none; b=HF4KkZdw8evubBQ4kjk7EZ4rqnQhrDAUg6ngd3ifX8o1ZyBSR8zHxKBh4Gawqc2B3nbzSf+L5l/nzzjmCP1Qh+moGX5QCYK4vpH9WwksJV9e7n24q6eGnSKmKMMKgpdQY+mEWV8Jo2gbNCFkrN06Z+OKIPAAOG8rgFANkYlXGMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962397; c=relaxed/simple;
	bh=hf0LNchjxqQLinro2e6hFZbfjNSY9RgWCHzdu3JPvC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGqDNLOJygfxcw2cAvYaAj+4K02ZxwITJvk1YPmljlsiSaJY56fwgky+JjQuauZ1XYcapwJ/o27PJcGcCsssIGaS7yU0lIwkrSJ53GrF0y2iITKZIlfGk18tZhpB5bjJoA5mLoRfr80auFo6eV2Wkk0zMCtXZ0QA+D9Uyqg8pi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9wedXlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9wedXlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729C4C4CEF1;
	Fri,  9 Jan 2026 12:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962396;
	bh=hf0LNchjxqQLinro2e6hFZbfjNSY9RgWCHzdu3JPvC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9wedXlYA3hB/DPZpjDb6JWytjXlFomIX/Btmm8nxNTGutf79cKHWAJQ9ynetqmhK
	 +6hUTZe8yCCrugNPUd7RtssFQPvnq6lXFDQDmFNNY5FTjFn6BhjwgIrwaQqWwBA6AR
	 mmpL0c8RfVhf36qDUp5luQ7YcAYGBpZGd11j2GXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 318/634] KEYS: trusted: Fix a memory leak in tpm2_load_cmd
Date: Fri,  9 Jan 2026 12:39:56 +0100
Message-ID: <20260109112129.497410072@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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


