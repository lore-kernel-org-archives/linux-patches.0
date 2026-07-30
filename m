Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8037F374A0E;
	Thu, 30 Jul 2026 15:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424590; cv=none; b=PdV6Ce3GFVI0Xs9SZhzETEOGEdS0NHLCetFPinTdkycqnV+j38knxJUc4F5LCrRQuimvWTvHo0ouOQO0H4cg601IauyzGZy7ETL5rd8r3ydpLothGagsblM7pjrrlsvlP7EC7ayw5iuwuesMGSa7Po/Qv/QuSbQs0sKPZupRMYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424590; c=relaxed/simple;
	bh=33WcEeS5Y4DcNmMxXizzqerQ5oW2OLKGG+eSkk1kW/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y66BVrdMYuSe06soQ7ve/P9L2qa5h4A8pQMPC/PwLX+8i8wF//cVsz0WOpr+pSDVfgHj8MEbD98OCGrUZkrHg/BGJZs+ykt8Ue5rDiZ/xGiZIAQjhEG729gmGmU5jBACrOlJKH2wnhAH7sMKcdEut4iwzV7CcmLlppFe48fO+s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZL2okJZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZL2okJZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50381F000E9;
	Thu, 30 Jul 2026 15:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424589;
	bh=YcXUkIjDQjMtPdye74Cbwg+bQWWEvfePv5eY0h1+0V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZL2okJZBUyEQ8GZAJMc98lI2HWYUDGapC660GuXBE5GIuWt66OicEndBOZS/uX9Rb
	 1HiotI4bMw8oqMOFRNBteaiJ4maxwdfknN7RUCPDdzZ2QWqCQ29wGICgStAH+clrtr
	 E2/4gK4RISKApSQv6i6/TB/o4iyi0tdcZYh4D9J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hilman <khilman@baylibre.com>,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 446/675] media: vpif_capture: fix OF node reference imbalance
Date: Thu, 30 Jul 2026 16:12:56 +0200
Message-ID: <20260730141454.618236540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
 


