Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6975533290F;
	Fri, 17 Oct 2025 15:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715393; cv=none; b=ur+9+p1VXQawbFVHwTdOBMXd2tOMXfOd/Lu26EoDy/l7mfalHOBrAZ0124r7JZ0zf0+2tUZKL5XccUX55sFbw+OU9BtUPLzqLcFydc/zWTtB7V2ORHTnvm++/F7FCNre0lhHqBqHYISCgdfBRsmJ4av+ZspInHThwuvBGyoLWo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715393; c=relaxed/simple;
	bh=5dkni71eDFhpG5ubnTEZmtj1jzIGrduSX1eknOCvjx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2o8ZWsk5GmSaBfnsD9zmF3WNzrwU7i15/KElXX7CJtbmS/LtHauVIwbKa7wA5ETSQatdkCsMLDHM433zKz6H/WIBNPcKiRB+tvoP5RV3j4t808uklSqDNCouvbpVlZgHoQKHLEzgMga8BWN0v1VQz/GAnU6lC5RU7xXfccZaXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwJADT7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwJADT7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CCFC4CEE7;
	Fri, 17 Oct 2025 15:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715392;
	bh=5dkni71eDFhpG5ubnTEZmtj1jzIGrduSX1eknOCvjx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwJADT7vLd5keZVD3a1XNNKcKhmKy/IOgTtHSg2SLqzpREXCyzYoVkJ1dERAxPP4Q
	 xRjvhedRdTwVbupMUOaJWSy08H4ul2VPafkErPvqBUk3ynM6+YP3ACitzOgl7MnUP1
	 lD/ji5muhqD/4957DmHjiRL7uvv4mnyWfgnyd6ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlo Caione <ccaione@baylibre.com>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.17 167/371] firmware: meson_sm: fix device leak at probe
Date: Fri, 17 Oct 2025 16:52:22 +0200
Message-ID: <20251017145207.973007285@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 8ece3173f87df03935906d0c612c2aeda9db92ca upstream.

Make sure to drop the reference to the secure monitor device taken by
of_find_device_by_node() when looking up its driver data on behalf of
other drivers (e.g. during probe).

Note that holding a reference to the platform device does not prevent
its driver data from going away so there is no point in keeping the
reference after the helper returns.

Fixes: 8cde3c2153e8 ("firmware: meson_sm: Rework driver as a proper platform driver")
Cc: stable@vger.kernel.org	# 5.5
Cc: Carlo Caione <ccaione@baylibre.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20250725074019.8765-1-johan@kernel.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/meson/meson_sm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/firmware/meson/meson_sm.c
+++ b/drivers/firmware/meson/meson_sm.c
@@ -232,11 +232,16 @@ EXPORT_SYMBOL(meson_sm_call_write);
 struct meson_sm_firmware *meson_sm_get(struct device_node *sm_node)
 {
 	struct platform_device *pdev = of_find_device_by_node(sm_node);
+	struct meson_sm_firmware *fw;
 
 	if (!pdev)
 		return NULL;
 
-	return platform_get_drvdata(pdev);
+	fw = platform_get_drvdata(pdev);
+
+	put_device(&pdev->dev);
+
+	return fw;
 }
 EXPORT_SYMBOL_GPL(meson_sm_get);
 


