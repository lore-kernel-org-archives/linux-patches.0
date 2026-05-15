Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CE639734B;
	Fri, 15 May 2026 16:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862567; cv=none; b=VUDNcDwQN2GPTCJvl98h6YwLu5mnNYCopgJ6Nhd6vMSSHjvxSjN2hzgBB6uiKuzKiFEHeM7OsG27r5c4LcpSXHYAjW0wRcP+mcvMgfz9Tj8qixwh8Nnvu2kfE2rVvXQfU3SjY8pipxafiQt75eaGcplp0RgP+NaCEy7JNA+WjsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862567; c=relaxed/simple;
	bh=d2EMt2NBd+34zvSecM5WtxvqKhnq/jx9IcwJl6O9xTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/9dxVFal1XrWR5yiRlZckUj7YjAD4dplQWG42GXsO1lO4MbwE4W96Rgc9oD49K6A4v18zMpeFQpydFairTYh2oio25YYKJQIHjBtAAJ+6/LfbDhxgpjRVQLq6sTXfqgPZjUbAVy6bc/T5eNMWhKb6hK3JkxLBnj1MYKQKeYGSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5VG21cH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5VG21cH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D95BC2BCB0;
	Fri, 15 May 2026 16:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862567;
	bh=d2EMt2NBd+34zvSecM5WtxvqKhnq/jx9IcwJl6O9xTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5VG21cH5cPTltRsqQxAB82OnGlTiqIADG/V4ArzLTjHqGoLTWF0iyIg5zrbtYQSG
	 NXrJjzgdLD06IaSQs30F6Na1+gUM+hsw+FgEFecmnW0AZ792QoUEDj4UxpDmvyRllt
	 Dk4h/uajlHWcj7zMq93nRSJpEwO3EXDDnocHXWeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Glauber <jan.glauber@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 099/201] spi: cavium-thunderx: fix controller deregistration
Date: Fri, 15 May 2026 17:48:37 +0200
Message-ID: <20260515154700.680118619@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit dbb6b01267c0c866eaac4019cec19f414beec61d upstream.

Make sure to deregister the controller before disabling it to avoid
hanging or leaking resources associated with the queue when the queue
non-empty.

Fixes: 7347a6c7af8d ("spi: octeon: Add ThunderX driver")
Cc: stable@vger.kernel.org	# 4.9
Cc: Jan Glauber <jan.glauber@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-10-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cavium-thunderx.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-cavium-thunderx.c
+++ b/drivers/spi/spi-cavium-thunderx.c
@@ -70,7 +70,7 @@ static int thunderx_spi_probe(struct pci
 
 	pci_set_drvdata(pdev, host);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto error;
 
@@ -90,8 +90,14 @@ static void thunderx_spi_remove(struct p
 	if (!p)
 		return;
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	/* Put everything in a known state. */
 	writeq(0, p->register_base + OCTEON_SPI_CFG(p));
+
+	spi_controller_put(host);
 }
 
 static const struct pci_device_id thunderx_spi_pci_id_table[] = {


