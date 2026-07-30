Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4525737883C;
	Thu, 30 Jul 2026 14:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422734; cv=none; b=qGxPtEOTJjwYd3BeWsGHu8bzpC0s/iUjpvAomFrSo7tuVsEASj1R6lv+tCv1kI06/PnzRqgbs0TH9RG9lZAyXNED1QLtM0OhcqMwm4K8htTfFyAjrozWQ3FJEMBQj87+VAhGbgTjUxomGPyqkpgQmrtKCjQoD0b9vmh5f9sWB8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422734; c=relaxed/simple;
	bh=WtHu4l459Ufsz/3hrZ+bemTd9ch/hIBqeg9BAwxcEv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAv8O6gg/xL1WnzDeFr/mW+nfdsbcJhTCRyq7emTY1Pqoenl7OBOpZvUM/ISuIiRanyv5z/+xGyCj1ThKBcgpyoZQmjRF0tZyoQZqazKqRDqLTHrT8sWyyM9HRMMLq4B9ferGRgPHC1yPEollkCs5dvHkiMQ33wVUNO/mEA52PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MipyFrkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MipyFrkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913F81F00A3A;
	Thu, 30 Jul 2026 14:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422733;
	bh=CpfnJFVcEtG8WhC45kfjCLIFBauc4xHVxx0olLhEhsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MipyFrkO+brtgaZ7liL0EOvh3OJzx3z2HZKnD1Vc1rpBsyP2m3YZxGdbscUegvCBo
	 q6D6PHGKmYUizZZy+wMPtpT6uLSTFseHSMQ5vlW9ZCejMaN7nYjyGSo4tjy4LIsbku
	 DvwZnlRk6aTywLn73FPk21fetAFyvX0Z/YWUbS+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hilman <khilman@baylibre.com>,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 537/744] media: vpif_capture: fix OF node reference imbalance
Date: Thu, 30 Jul 2026 16:13:30 +0200
Message-ID: <20260730141455.690348821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 2282f979560af6bbc8ee2c1ee8663197312cee5b upstream.

The driver reuses the OF node of the parent device but fails to take
another reference to balance the one dropped by the platform bus code
when unbinding the parent and releasing the child devices.

Fix this by using the intended helper for reusing OF nodes.

Fixes: 4a5f8ae50b66 ("[media] davinci: vpif_capture: get subdevs from DT when available")
Cc: stable@vger.kernel.org	# 4.13
Cc: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/davinci/vpif_capture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/ti/davinci/vpif_capture.c
+++ b/drivers/media/platform/ti/davinci/vpif_capture.c
@@ -1498,7 +1498,7 @@ vpif_capture_get_pdata(struct platform_d
 	 * video ports & endpoints data.
 	 */
 	if (pdev->dev.parent && pdev->dev.parent->of_node)
-		pdev->dev.of_node = pdev->dev.parent->of_node;
+		device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
 		return pdev->dev.platform_data;
 


