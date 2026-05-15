Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6733FF1D5;
	Fri, 15 May 2026 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860766; cv=none; b=Y23q+u73ZL4F0kdkIWaXkq6INMmJKE1DBFsa0VkigU5DA6TrGXQIfjovZ3aSLbJe2qhp7U/rRunqzJqXvZdmcFZoHRaaNcXl14ChXXe2GjIFFfaftwNfzeTWeKWUaG0ZIdKDd/AZ+qFXZkg7KPx+ldFF3Vlfp8T/qNFkRGZQD+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860766; c=relaxed/simple;
	bh=pF+ed7oH6pV/N31G98E6yFMHYON6ldfOKgPdj1bpbcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXi2SrFzmtBTPVVJLdtLkRKVdD27DlAVL1y9dDcG35Q3oVfghaORyd5XyYQsFexD0oiywqw/zIQ4KenphtrcLjqOSnE3iEsTK3jkKjvDIoSh3tSmXoAM6cfEJuHetqQNUlavt2FfJMZd0Rsdzex8W5MkMFL7HPGgI/0vgd/EC2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HU2vnFUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HU2vnFUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459C6C2BCB3;
	Fri, 15 May 2026 15:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860766;
	bh=pF+ed7oH6pV/N31G98E6yFMHYON6ldfOKgPdj1bpbcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HU2vnFUINmhREGtVb1Cb/OJfBGRusUOvH197Zb1X6TnWk+tVKWeLzEh5yczKIWwXE
	 LyrV2xyau8Qa8S77tISpl4fDgf9f4RpktwwSWF7UeQfcAEur7QeRRzjPY9Amq1mE6f
	 LcL6ogHh1h6IqBm2SfVpKPLk+xSEhMos8hodpvBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.6 029/474] crypto: pcrypt - Fix handling of MAY_BACKLOG requests
Date: Fri, 15 May 2026 17:42:18 +0200
Message-ID: <20260515154715.681019214@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 915b692e6cb723aac658c25eb82c58fd81235110 upstream.

MAY_BACKLOG requests can return EBUSY.  Handle them by checking
for that value and filtering out EINPROGRESS notifications.

Reported-by: Yiming Qian <yimingqian591@gmail.com>
Fixes: 5a1436beec57 ("crypto: pcrypt - call the complete function on error")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/pcrypt.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -69,6 +69,9 @@ static void pcrypt_aead_done(void *data,
 	struct pcrypt_request *preq = aead_request_ctx(req);
 	struct padata_priv *padata = pcrypt_request_padata(preq);
 
+	if (err == -EINPROGRESS)
+		return;
+
 	padata->info = err;
 
 	padata_do_serial(padata);
@@ -82,7 +85,7 @@ static void pcrypt_aead_enc(struct padat
 
 	ret = crypto_aead_encrypt(req);
 
-	if (ret == -EINPROGRESS)
+	if (ret == -EINPROGRESS || ret == -EBUSY)
 		return;
 
 	padata->info = ret;
@@ -133,7 +136,7 @@ static void pcrypt_aead_dec(struct padat
 
 	ret = crypto_aead_decrypt(req);
 
-	if (ret == -EINPROGRESS)
+	if (ret == -EINPROGRESS || ret == -EBUSY)
 		return;
 
 	padata->info = ret;


