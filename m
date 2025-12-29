Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4768627E077;
	Mon, 29 Dec 2025 16:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025478; cv=none; b=PbhIPWPv/h1w4M9St0Nap6FIseF9N+xkF5QQKjDpDNHveOUy6CZjObzBwc2Xgk0at2Cv85Ngi9irwmCKZr/BPT+y7TFARGJa4I6Whk3Js1Gqz8cjs643GOWVuG0R5F+AsIo3Jn8obaAL+F3cMQEgH6huh83P89vQF0ngHNMFWXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025478; c=relaxed/simple;
	bh=6Gfx2id8o969U4EBTdQDIcMMwP5UdHZc/Z9D041EbQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rssmUduQoswRb8/h+CuvyHO8sseEE3K0aMuItCOJo7pYguNcJWwHfok+zgS5ObllqgzRyfhErEnexH1FEDrBVzUcSNrUyy1R8103bh1+4DAtZvLI7t2MiB1rmdVU+1X457jwIvRaxTyVo6aAotgDs7cf38YId8sbcIKKmXj1P5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAq+EHw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAq+EHw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1EEC4CEF7;
	Mon, 29 Dec 2025 16:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025477;
	bh=6Gfx2id8o969U4EBTdQDIcMMwP5UdHZc/Z9D041EbQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAq+EHw66meQhpazB1EQUgVYhmURkKlpkQl8UB3020BxiYMBI4VlvPHYAD2vPMats
	 NZ6Puy7RyvD9I3ahH0GNGJd8R+sHO83pkHhPGLt9RO1RPdoQ0AwLP1sqv2fYsSRmoW
	 QswtY9tq45fHS3GkVPyoWoycvP0fUhA3GDZ0Og28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 227/430] KEYS: trusted: Fix a memory leak in tpm2_load_cmd
Date: Mon, 29 Dec 2025 17:10:29 +0100
Message-ID: <20251229160732.707894119@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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


