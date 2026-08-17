Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB805443E52;
	Mon, 17 Aug 2026 15:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979413; cv=none; b=dbqrGdQQCwdOGPeiigl8U+lqHncPbwH7qmwkqg5IrorOSnQa3lm+hXSO6H7C1aX89+tVA8tOYWFz2zAOl4XUCgE5p1IBauV6lOf3uGkQzZpi3gdMIVSHLoywWnjfyno/Ec9vKmulb/ESxCYTSqUK4uwEPP0YyVKMzhPLiyiUOrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979413; c=relaxed/simple;
	bh=aJokAcryZmbMdKyYQeppeJLhb8sXIuV3a45peVrgMJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJEHhVxJbzyg1UhXgt1yTBlsaJIw86QytoSOKkYxCll09ZsF980O1TKCFIYkj+p83fKZVjS+jGWdZSx/VOdMg4ZRAt0aRSRc7kwlClEcUfD2YoPug5K/p7dPv0I1kzz0o72koCfSE4zuDw+UUfe6i4MmrJyOu+O9fCXlgG9sQUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iA/Eq+Qs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iA/Eq+Qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6E51F000E9;
	Mon, 17 Aug 2026 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979412;
	bh=Tf2xgo4BHE3zdRQs3aA9kv+isX5LS42mwOVU1jWTCCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iA/Eq+Qswj8BuaNgmiAvnnwOeKC1PZvcF72VH+7FFqBbSMXsL4eoHcNSHvF0snQqg
	 4lkGfah8H/obZ6WSm81xwvYc2CFkNPZCfbBIV4WOjF7MCOzxYy0e67VE78Zlw0Iazt
	 Exj3BZQE9GjdSxTO56lox/vB0luSgIYJmk/fvz4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hilman <khilman@baylibre.com>,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 217/609] media: vpif_capture: fix OF node reference imbalance
Date: Mon, 17 Aug 2026 15:28:33 +0200
Message-ID: <20260817132551.350293114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1499,7 +1499,7 @@ vpif_capture_get_pdata(struct platform_d
 	 * video ports & endpoints data.
 	 */
 	if (pdev->dev.parent && pdev->dev.parent->of_node)
-		pdev->dev.of_node = pdev->dev.parent->of_node;
+		device_set_of_node_from_dev(&pdev->dev, pdev->dev.parent);
 	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
 		return pdev->dev.platform_data;
 


