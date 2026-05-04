Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E293D5645;
	Mon,  4 May 2026 14:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903926; cv=none; b=fLghdGMi1E6VIzo1qq3kkf4UeBzOg/C1kT/kDln/29vKKpohS+aKePLDJ9VNYjRwH4OBI6ny21Ff3gtCNANEX6ejyOB4+vHBQGbkj7LwJaLR5Wli8JQoWZMPVhz7ra9NgPyYKynCbi5eRaJxl3eMTGxU1qA1uIUcU2puv4xSOf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903926; c=relaxed/simple;
	bh=xCoJ0XT4XH+vjMfB2N9RKug1BDhzTl2e2ecPyYciu58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQf3SaWhqkD/5YSEVNYIXV+4d4HvPXbwNiWQuY92g+Bfl4wI99ol6wQ/m/ub6TQSM3rfHe5FGeAP6E2///eU5Fx6umf67gZ7cwXKy9QY44jin9Chx65Z6y+yhxPAinCrLWmbZwYMESoyuTUwzOawqVYEoB9TnJT3ketIFkAncj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mk4bAIZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mk4bAIZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F43EC2BCB8;
	Mon,  4 May 2026 14:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903925;
	bh=xCoJ0XT4XH+vjMfB2N9RKug1BDhzTl2e2ecPyYciu58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mk4bAIZhSY/KpWkBQitkzX2BeHUGfEoMWLLCnXnF/BH4krQ4A1BIEsxRw7LqzdkFJ
	 b0bO5JUdKLhJHAS9Ldn/3Bd/ACzdwu9ye8igkY91/K2ZfZXphSjD3ZsnGaUzjsR384
	 zXSy9hRDokZPvVsxhBjSL6k02JEE/FhF+l2NkaAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.18 115/275] EDAC/versalnet: Fix memory leak in remove and probe error paths
Date: Mon,  4 May 2026 15:50:55 +0200
Message-ID: <20260504135147.182039423@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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


