Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704588;
	b=G69EnhamZReCCZer1WrAYUPum0XBCfV8W7sinJhakBTzoV7VaEldgDklIx/otxPMo7CS
	 HbIajaNIwI2XDtoweKmpTU23a/7qxCXIQbvdZ8jcJMglsyPJYAlAN18584JVhE6Yi8SDU
	 L47hma3GKXNZ2MnxliuwwnpG96DLtTSeSgVjpJLj0E50D4jy6SKGDOLc5Zg5SP/d4iW81
	 0wZAKi7k4YI4iu+SEpoD6pG53WK2vXCcMTHAC896zpaa2C933ZGRroF/qIgvzjptra2IK
	 GqrPsMSZXiVSzRpvMjniFpnmwH/Z0bYuLWuz3tqaFZLccoKLiG9rN+6tr9zlIktkrLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PCG7dlQVMwsuGTbJDDZyO9Vf6kvMtZO+lgwlNYlNj9I=;
	b=Ag3uROPPWqwZ5z46mZBl81wvcqSrGS24Q0FQzfhqKfZ6xRBgoCKMWupLwBlaQ/9Z+jWe
	 vcmriQzDthmBd5fg2QbAxU4Nt/+Z1+6ndXVB7zkgU/816s2cFRRb9zUYideOPlvziR56a
	 fNveNgyFDhJYtVEAlELvNKxvxm6siW/IZnXSW7ranppgEXnEmQda4WVazmkMfsfgEWgFN
	 HKxuKW1Gam4T1e5fwvvnY5IigIDvUKUyfRV01/wWN54yxqCy9SvoJUd+I1W2UUJg0TNHn
	 6YwQhxXGqbpYYMEqF3eFoUp5BLIokWbZHGHG+v7n1Pz88bdvMEbhq0b10Hqrk0tnwHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpnKJ3BL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F08C606A31C;
	Thu, 26 Nov 2026 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QpnKJ3BL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866571F000D4;
	Thu, 26 Nov 2026 14:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704588;
	bh=PCG7dlQVMwsuGTbJDDZyO9Vf6kvMtZO+lgwlNYlNj9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpnKJ3BLcSzHiTRMbncT6tf6Fo0ecI4ScB3rUrfOn6JFGz1hlnFVBb7a3ilnHCMDM
	 Z7gYaWPGN6GnlLVpcy7/mU7v7SMq0xdn1ML8LojQGsIttZAmUxZkWxgV3194fPuHkq
	 8A+G6xvIWA8SQXMkgMAGoFgq0/kDqMAYIClQMtpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 175/265] tpm: acpi: Fix memory leak at tpm_read_log_acpi() error path
Date: Thu, 26 Nov 2026 15:38:25 +0100
Message-ID: <20261126143617.402681643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -168,10 +168,8 @@ int tpm_read_log_acpi(struct tpm_chip *c
 	}
 
 	ret = devm_add_action(&chip->dev, tpm_bios_log_free, log->bios_event_log);
-	if (ret) {
-		log->bios_event_log = NULL;
+	if (ret)
 		goto err;
-	}
 
 	return format;
 


