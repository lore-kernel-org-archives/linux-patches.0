Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619849;
	b=phMFHSgYC21qLtvDFsadZpIbfCILxzg5oPODAOPTE0S27+IZ/rLm/OBJm4znyYyvINza
	 ZiBkdRoeYrGnVOL7XFEMgfM+n+hNcND+xK5fPfJZv9qGZNOLTXW+hLMyXe1/2MaNcXBwn
	 n8tvQ9lFa4PaMZyxdVx1yopFdDysT4Cn0ONJH4IDsxJH016nkEDJpsVsELGE4rlF3ljbZ
	 X6rIx2TRBDtibmc+9BfyyntgNRU5Lw2LwXNbYK+EwJLdLkhfLJXi0si+Lsj3nGGD2APES
	 FXwFl/f8RJPMSJt0TnQJBiLIyJjcasDDUPDmhyOCS61Du/oIItCPDRjPiykIrDR0L9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GuEJeBaPLumKB2L+TGbkbSPv0+sSU7xm+yavF/MNaZ0=;
	b=0WedVwkR9YuvdjbKqC8Gg9yTFFfkp2rqMcwYT8hDOnBXHyM+ZAY8rSHzN1XGlzAFzZiF
	 CgP8qec58aIL9w3iCAZvyPez0MMJJpazQ3D0qwq5pNnwk47uJO2+sd5XLAnYZ9tzND96V
	 InpDWiQjEsOK0XxpuHngeqE+TDBXoXbomihSgM7/I+JAsMZXck1G0biYz+uUo3CyQRjou
	 /Np63f1/HWwPR1vauyMQdPqvfYhRsTgUskDsUAUcp3h54mx4iGwmAmGGXZ8nIUH2WBGg1
	 sSF7jXTOy+9XNYQ1gmvYEumtFSPWW+156HD1yQCfk8EdqfbCl3uac597jT4Gy3toPYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYgmbdAp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5F4606A31E;
	Wed, 25 Nov 2026 15:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qYgmbdAp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08281F000D0;
	Wed, 25 Nov 2026 15:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619849;
	bh=GuEJeBaPLumKB2L+TGbkbSPv0+sSU7xm+yavF/MNaZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qYgmbdApc4enmSWZ1aypMO4mIOZjAu3PlBz7ebDn9Ujm3IoVRqU+bsd9IbPmb5YBU
	 uwaC69aPZQOzBpsJjFCkIyJ0VPCtJWIekkH8/3cVlYzOm0WVbxhtaXmWb1COplRem9
	 8C4ATEjWtfqrXx1obymiuuLwEDrEr36HcMviD2IQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.3 0726/1005] tpm: acpi: Fix memory leak at tpm_read_log_acpi() error path
Date: Wed, 25 Nov 2026 15:34:24 +0100
Message-ID: <20261125143838.768236697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 


