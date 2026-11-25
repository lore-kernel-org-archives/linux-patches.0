Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625773;
	b=lBJU+rfP+X5W0vn5kiXiqLnsACVxxUpbB70dtQ2K7a/j9OdhW0uEHtekxFJamWntpLdH
	 MAgHwDMPaKE1rHBktFO8Op8oDrOlEBKgMPQm57Dg92QJOmYsX48dCuhbXg5vqfdZaq+3Q
	 uydDSYXXYJqoUaO0tlgZ2mfS6zoPIbusVfcyhJeygJJOj+kjNLsJfLCpoNr3dgTo2dpKl
	 qEvVvucnuKPL3tF3VKq9TwfyNwa+IsoaaLOlXa1KhcwPD/bJXp0Cequ/c1eJj4fXd+65R
	 Mmzhwks4U3Coih/0FKuhoLequd+dDeEDhWCw1SEr+2KnV7AcUZGvKuJ5SQ2J+J4GofA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EJxqfW0js4hW+EG6wt0lDbzVsuOorTMU9UpsBz0Wbr0=;
	b=R0+dEoqWv7ktzW1dBmkA+xSuG8vRMoX96XcsdNUjbRrCBeHbeaQa2zGHMh9S3Vy7ufot
	 yIynYaUgibqWiTkYGW2GBf1Z3c3xdNQrXwhSn2BhifxV4XGjYFWFRmKdIWuKwDPNkDqJi
	 0iCFva3t1KH03Pf01dJL5Ra5W25Sd6wDZiOQbLQWKCY/aTjj5dkqPwrl5F713O07nrLe5
	 nd5tOaQb6mybHKoQW4AHu2xz2Tr7ux4wsMLzKTTXGtV17/EIZ2z93C6inI0SJp+cJ8e3K
	 bC4xquY5TxXc8tWAKZTlb6jz6pSDKh2il+e095YjvjvY0Yfu6FXWZA+M9gx9DYgs5kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEaXXfu5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F974606A68B;
	Wed, 25 Nov 2026 16:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEaXXfu5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6BE1F000D3;
	Wed, 25 Nov 2026 16:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625772;
	bh=EJxqfW0js4hW+EG6wt0lDbzVsuOorTMU9UpsBz0Wbr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEaXXfu50FXwFS3wE4LrLxdUUxbJReKCv53Ssii9Kg5HKcNtf9J0kJMTRiV/fT10y
	 RutExRn66TjfX4sq6+sy8NPYc3MfgsHR7DtWzndKdqkrAKXRwCsyVmMvml2e06re3B
	 BZM4oui7zIys1FbCfcxlFlQgdkVUlhY7LQSwaeIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 627/816] tpm: acpi: Fix memory leak at tpm_read_log_acpi() error path
Date: Wed, 25 Nov 2026 15:36:15 +0100
Message-ID: <20261125143903.697680958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


