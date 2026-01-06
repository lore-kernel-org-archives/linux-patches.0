Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D45352F9F;
	Tue,  6 Jan 2026 17:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720162; cv=none; b=EOXiZBiYfCe0r+WO2Sn93rGaiaV8N1UFex1mfIikTnPddIF0YOklTufBd4RftAP0GuGUrma2d+zW9Mx8UnEEIWdPdMoM432UEP81d2bM3AIAw+CYvWybIbuhWj7W8pdRM9vcnk5BVlPW4wohvBAfTPC1MiJPP3Z3FxrF340I+Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720162; c=relaxed/simple;
	bh=IbUiwtpKbFwPUacDT8Hgveuuoxj2AXtiv51/jyHU7xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTqFwwNY+eDPyCenWKtXUYKB00x47PV++1k0Jner2/13ykboo3GkK6qGkRLCUUFgDzjnB/5s2fqMXmHtz7AeE4yEvaH/QNjuupUypPGFhgWTT6sjrStn6MLlmy9Wf+Lr23MYdoVHJOB5umt305g2OiLo0zxoETK8vWlekI1w8bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8XvCr3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8XvCr3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A5DC116C6;
	Tue,  6 Jan 2026 17:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720162;
	bh=IbUiwtpKbFwPUacDT8Hgveuuoxj2AXtiv51/jyHU7xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8XvCr3TFF33YGYXLLki2hThOxrbKautZmAq9NPrMp9wNX59nNnS8urGlq3S/FbH+
	 LMCgSeTV6v1JDO0kGiJze2YSy4UJDbUUGsfKN9ttm6NKX2Yd3535m4LFyHyAU63xYo
	 W+i6JTto2f7qQSouGUKy8mnKpmxIeRpIoO911ZT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 153/567] KEYS: trusted: Fix a memory leak in tpm2_load_cmd
Date: Tue,  6 Jan 2026 17:58:55 +0100
Message-ID: <20260106170456.986501772@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -387,6 +387,7 @@ static int tpm2_load_cmd(struct tpm_chip
 			 struct trusted_key_options *options,
 			 u32 *blob_handle)
 {
+	u8 *blob_ref __free(kfree) = NULL;
 	struct tpm_buf buf;
 	unsigned int private_len;
 	unsigned int public_len;
@@ -400,6 +401,9 @@ static int tpm2_load_cmd(struct tpm_chip
 		/* old form */
 		blob = payload->blob;
 		payload->old_format = 1;
+	} else {
+		/* Bind for cleanup: */
+		blob_ref = blob;
 	}
 
 	/* new format carries keyhandle but old format doesn't */
@@ -464,8 +468,6 @@ static int tpm2_load_cmd(struct tpm_chip
 			(__be32 *) &buf.data[TPM_HEADER_SIZE]);
 
 out:
-	if (blob != payload->blob)
-		kfree(blob);
 	tpm_buf_destroy(&buf);
 
 	if (rc > 0)


