Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623138;
	b=cxibazj4gc33l6Qfhb3LPEmwO58BUNUdqVg8dr8tdw0FXHJAqdnmiRxyOCvOGD069Xu/
	 cUaFo0WNKsJe9+Xy7YhNFQ4RDdh5vw8UX0b1zxGdbyvebL1yUzcnfHDLsrkxmZHlMFkSt
	 a3I21BIS49Em9ggKe4ajIxvSubIQdbl0L6hsbR/hcxiP1I4KouoTef8dl619DH9fbrEeJ
	 Pto/JycpF1uGAA7ytfgQidG0kIMBXYE2pb2yqeARD/cr+m3to1GXCppU9691No4BemVFn
	 iklJ7MnDG00q3wraWSOZIQ53cTK9QEmyaD+yXi2F4H2ik2y6jfmzVKqKpMsxh+WBycQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y2/K4sOjsL6Rd6S7I4ve+kyUzCYG3CzVMKB4DvUGDPk=;
	b=5Crq3T9NrrA6krBwsCaogA0LJdnPNpenFaF1rqmhbWXdIxAKy+jYIxKjSurilfw7FCsM
	 EcKOXWhpgj69WegDPSkuMwRRaienF8myVD1/Gcdorl/x5vpI5AJ+pJcmX88njZf9N9XGq
	 MQfIt+DSLn7d+xRWt6qEM5NrzznSXwstxs85FcGt9vB5S2cfqw1CQx4HuZobv00jn04iY
	 fXs2p0L8SPXdsJoavhSio4gkNWxbAgiHbOGTtcjYvuugOCxLOlOTU7cFsci3smSpBafSF
	 P5ohtUQ6IP+zXaFhRpi0t95+gmj4FrO+sGxJvtZLqgErV3NZnHVqz4LprpDRnT1Vp4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqV3TCib;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAC6606A31E;
	Wed, 25 Nov 2026 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqV3TCib
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23091F000D2;
	Wed, 25 Nov 2026 16:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623137;
	bh=Y2/K4sOjsL6Rd6S7I4ve+kyUzCYG3CzVMKB4DvUGDPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eqV3TCibTSXxIwB+rYj7gEkYG4GwdiphGa2+Ho4mPKyiE7gP7r9Qm5DJBCs620qSR
	 K8dRrxNQepAZqOrF/tqr193DXbiwU7jHYhZ+2Qr6NGxebjXesFtW8xV/etuWDIKdRC
	 /om324mmTMNATYf2BJiVHzyvThMrBSaKc77h9QCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 763/990] tpm: acpi: Fix memory leak at tpm_read_log_acpi() error path
Date: Wed, 25 Nov 2026 15:35:30 +0100
Message-ID: <20261125143839.927626052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 03fcb358249dc715124b3616f814ea0ecc6ec36c upstream.

When devm_add_action() returns an error, tpm_read_log_acpi() clears
log->bios_event_log unnecessarily to NULL before calling
tpm_bios_log_free(), and it would lead to a memory leak of the
allocated log buffer.

Fix it by simply jumping to the err.

Cc: stable@vger.kernel.org # v6.18+
Fixes: a3a860bc0fd6 ("tpm: Change to kvalloc() in eventlog/acpi.c")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20261109173756.742248-1-tiwai@suse.de
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/eventlog/acpi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/char/tpm/eventlog/acpi.c
+++ b/drivers/char/tpm/eventlog/acpi.c
@@ -167,10 +167,8 @@ int tpm_read_log_acpi(struct tpm_chip *c
 	}
 
 	ret = devm_add_action(&chip->dev, tpm_bios_log_free, log->bios_event_log);
-	if (ret) {
-		log->bios_event_log = NULL;
+	if (ret)
 		goto err;
-	}
 
 	return format;
 


