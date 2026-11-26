Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705488;
	b=uOpmI5zT0da3wUioKnVGYZrrsyKcqsrTuGwm7fZKazqw8mRDGl4Alfc88rtCI8/ZF5Lb
	 GGndjmPUjvpBCiOUgF3zY60njhkpnLLEQfyzZBF/woMbXIwUgA/4kWFpekf5CYt7JBM0U
	 gmoHYpH45cLdYq5zRl9amwJbZmT+7504cg9IiygSZ6v6mPDFqhOmYNPgxBJmQ381uO0WY
	 /RGrrgtQXpyFGDOjDLsz6/gHvc0bOzfloGkJmuVMP7nWKeByrauZ0ZoXQJisBomJ8o64o
	 jAWIqYJMeOq9EP3bbeTp/v4uzwAhbAGb+wuJdpXt97wsIZXYNbKTcMs6fdKYKVUX9TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ic8xSqJkrg8kH1EaCv1qNOf40QehsyMR8CkURDBLUus=;
	b=ZuKiGOSH3wmB472wzvNiSFb3oYVfoWnj39vqVcNZ/9d4MIJZaPCOt9/lInRQ8Uxbx2Tt
	 d2tqT5lrq1LpfGvi/saaFmVJ4GKVsqrclid03X+6HkrtnoHZOjUWHcqusOpNo5VXbVc6x
	 xwMvVqOcovYK2OkfMHN9W8iOREKTmk8l7ls/04TBqozHvaPMYAwAsBl7h5vhb8xawkSdt
	 us4zhVnEZpoUH/5KbXhnzh96NW5BgaA5GSCe1KFvY75S8VYdAKOa0R4FovqLpe5MT2aWO
	 9EKVmIZ9jAZ0h6je9TGn2Puh5hJwzcnaweK19MiikdGoRhiV0MkozISTBsh6I3cgPgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhKkHsdt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AFE606A31C;
	Thu, 26 Nov 2026 15:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhKkHsdt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CD11F000C0;
	Thu, 26 Nov 2026 15:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705487;
	bh=ic8xSqJkrg8kH1EaCv1qNOf40QehsyMR8CkURDBLUus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhKkHsdtRP7HuDL3cDtHDki1pju8vs0m/bKH0Fj+FY1mVd4aC/tbiwyKGGpRJR0Za
	 AtXo2NQk8Uzr17hUyN8/A4L7VM59z4XLsuICTWzDuCgOLnmY7Yxc1wyC5pH9moEpRM
	 q4FuVv9Xe+Y/4DkeAGX3gPfnrUfFzAMO6nqxlDKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 213/319] tpm: acpi: Fix memory leak at tpm_read_log_acpi() error path
Date: Thu, 26 Nov 2026 15:39:41 +0100
Message-ID: <20261126144011.553574406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


