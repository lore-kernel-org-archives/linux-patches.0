Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAB22E2F0E;
	Mon,  4 May 2026 13:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903195; cv=none; b=bxUoBg1LiDTpZwrZGpIQ3Tvc/Qg2XyHFRkwFIAk70Z+9SYO4WxBS9yBWufoU9DPggwCSRzHN9F3aDcnYNs8VuNAy6RiKugLVkaIFLYNKft7dBoocPTtG2V/0AW7vMvAW1j+J8Al2TQwTca6E/wcd5fn1P4fUaTW8GHJOf28sbe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903195; c=relaxed/simple;
	bh=Fl2S9k8quxJRnaqSYO0PL5vPIRdUvp4iIqBNcNh6w08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=haKl50XY34mE9yfGBunnuUnnrj9tSxi9eRNOTP+H5s00ZE/CKVXmkLMuSFcAdtUn4NmhxsfZQG0c52D9WXsFkcAsbLZGXoyR2rdnj7oQZs9tIexrCQ7WDcFB6FGyCv/UBlz65bFrojJAWd/+0/2SY1AvFrJPcRkqycWhdNVs4SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBMerDLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBMerDLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD71C2BCB8;
	Mon,  4 May 2026 13:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903195;
	bh=Fl2S9k8quxJRnaqSYO0PL5vPIRdUvp4iIqBNcNh6w08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBMerDLfC/RKioxkkgo6JCmc5ufF7ZWgtsTXFqakLEHbVvDuL0LDEk3UIxrW2Ec4r
	 oi8C0+G9e3Zt7bHpIyUsTmKn1djRhpXEPqv21CSjQNKBAtn7HpNxm9xAO9PWpDr8Io
	 66NzCqvfj5wOqu3Pj/R7rN0roEMKe8W74fWqappI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 7.0 133/307] EDAC/versalnet: Fix memory leak in remove and probe error paths
Date: Mon,  4 May 2026 15:50:18 +0200
Message-ID: <20260504135147.792466003@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>

commit 1b6f292cb94d95c9bc22e1efe592daf62c60bc2e upstream.

The mcdi object allocated using kzalloc() in the setup_mcdi() is not freed in
the remove path or in probe's error handling path leading to a memory leak.
Fix it by freeing the allocated memory.

Fixes: d5fe2fec6c40d ("EDAC: Add a driver for the AMD Versal NET DDR controller")
Signed-off-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260322131139.1684716-1-ptsm@linux.microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/versalnet_edac.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/edac/versalnet_edac.c
+++ b/drivers/edac/versalnet_edac.c
@@ -917,6 +917,7 @@ static int mc_probe(struct platform_devi
 
 err_init:
 	cdx_mcdi_finish(priv->mcdi);
+	kfree(priv->mcdi);
 
 err_unreg:
 	unregister_rpmsg_driver(&amd_rpmsg_driver);
@@ -938,6 +939,7 @@ static void mc_remove(struct platform_de
 	remove_versalnet(priv);
 	rproc_shutdown(priv->mcdi->r5_rproc);
 	cdx_mcdi_finish(priv->mcdi);
+	kfree(priv->mcdi);
 }
 
 static const struct of_device_id amd_edac_match[] = {


