Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7F33D6481;
	Mon,  4 May 2026 13:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902963; cv=none; b=GaPz5O51goglOcx4CFZmQJSofsiFms/EL3muwEZF3DJr7FmpjgjTXjnPDYbmpU5l7nVXEqve/ofZRBfLGVRiSK44dlozhi8zS635rZ6Y/0MoJhBI+06/axOf7BZSC3XDqfYr1B8XOwfYtX5o57zw0ssxr9lr1lG8KDNap1ZVRi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902963; c=relaxed/simple;
	bh=QELb7y1PoFTv1gu8Z9ialszseNxY72UikhzHyTXombs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bv7wmpjTfWlH9ZNm+mcRyh/Gfw0v6pGMkMnY7VYwgeis+xMqgZ8YJnxC6mvqUUAwNSYK1mrbAO6ZRBQL+LqY6YdWEsKKk86r+AsMkrwNInKvRjMVaBlTTliCOsimxiQbfZ8x8JLEdWzLr34UW/UvsAG9XkohF92kjVXzkeZu9ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCCObK4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCCObK4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4379BC2BCB8;
	Mon,  4 May 2026 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902963;
	bh=QELb7y1PoFTv1gu8Z9ialszseNxY72UikhzHyTXombs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCCObK4MA5CVAo134Y+i8MErmezF6jq8AMJS0zhicns5h7K9z7eeiroUMF2BYxpQI
	 Xw7AcZlu9XxR4cvhMIygmimNCfIP4bV9GaVX8HJ+z1pgpSW5pXuH0oeJx0QZ+nIgp7
	 Y4l+2FEAhDz9YL27Kp5ld/rYrD6kxb6UsYVsT9rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	stable@kernel.org
Subject: [PATCH 7.0 050/307] EDAC/versalnet: Fix device_node leak in mc_probe()
Date: Mon,  4 May 2026 15:48:55 +0200
Message-ID: <20260504135144.713902641@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit 5c709b376460ff322580c41600e31c02f7cc0307 upstream.

of_parse_phandle() returns a device_node reference that must be released with
of_node_put(). The original code never freed r5_core_node on any exit path,
causing a memory leak.

Fix this by using the automatic cleanup attribute __free(device_node) which
ensures of_node_put() is called when the variable goes out of scope.

Fixes: d5fe2fec6c40 ("EDAC: Add a driver for the AMD Versal NET DDR controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/20260323-versalnet-v1-1-4ab3012635ef@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/versalnet_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/edac/versalnet_edac.c
+++ b/drivers/edac/versalnet_edac.c
@@ -868,12 +868,12 @@ static void remove_versalnet(struct mc_p
 
 static int mc_probe(struct platform_device *pdev)
 {
-	struct device_node *r5_core_node;
 	struct mc_priv *priv;
 	struct rproc *rp;
 	int rc;
 
-	r5_core_node = of_parse_phandle(pdev->dev.of_node, "amd,rproc", 0);
+	struct device_node *r5_core_node __free(device_node) =
+		of_parse_phandle(pdev->dev.of_node, "amd,rproc", 0);
 	if (!r5_core_node) {
 		dev_err(&pdev->dev, "amd,rproc: invalid phandle\n");
 		return -EINVAL;


