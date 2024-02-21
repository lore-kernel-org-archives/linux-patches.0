Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93DD4C62;
	Wed, 21 Feb 2024 14:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525794; cv=none; b=ZgBwGazGNUqGKt87a1SjqoGBly5oJp+4Q9t8XUBX8wSnT0qcL68eMz0f6UC/UL+3ZQ//XmiEml5EMaw7DXTY77ijU7uguB10pa9yzXXcP6hve6pmYeHhmy+0jSxvHnAzO0Zcnbpxyx/q0otPpWfZ+NZrD+QaVLVSsw+itx4j6FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525794; c=relaxed/simple;
	bh=vLjKBMqazLvWg2I4+LippGSxyuEUBV0W6MX64I3piBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZvcRrKoI+M0+jY4nEnIs0iwrdMzgA71CvsPwKyYCVnBMpHXvADCMtYsUbTokxmv11FDnKvwCfRpMNxvBpShiyb0dZKu0yQKH3VlZ0IolrTVcqHk3PUSpWJkOB+nu6oh4d3emQ4SQZcyDT0eICLSjfjqsGuDs6IyNQvh0Y6AQho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WWNT8v6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WWNT8v6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F01C433F1;
	Wed, 21 Feb 2024 14:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525794;
	bh=vLjKBMqazLvWg2I4+LippGSxyuEUBV0W6MX64I3piBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WWNT8v66gpo65h2MJ/PnhTmdyHvMgZz2AaKbAWQwv+qb8baKsW92IY/LOu6i4FQp
	 XNzDoDlBNoc8gkiFEuUTEZocG+jU5cnqRglZSwDq72LGcYxCPb0Kk0gyIFX+Vbrj+r
	 RhKS7/B32phZiY5aK1ebDksZCgzXvCJUrDCEkv9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Frank Rowand <frank.rowand@sony.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 5.4 267/267] of: gpio unittest kfree() wrong object
Date: Wed, 21 Feb 2024 14:10:08 +0100
Message-ID: <20240221125948.616298826@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Rowand <frank.rowand@sony.com>

commit fb227f597d612c6660888d1947e68a25fed7b9cc upstream.

kernel test robot reported "WARNING: held lock freed!" triggered by
unittest_gpio_remove().  unittest_gpio_remove() was unexpectedly
called due to an error in overlay tracking.  The remove had not
been tested because the gpio overlay removal tests have not been
implemented.

kfree() gdev instead of pdev.

Fixes: f4056e705b2e ("of: unittest: add overlay gpio test to catch gpio hog problem")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/unittest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -124,7 +124,7 @@ static int unittest_gpio_remove(struct p
 		gpiochip_remove(&gdev->chip);
 
 	platform_set_drvdata(pdev, NULL);
-	kfree(pdev);
+	kfree(gdev);
 
 	return 0;
 }


