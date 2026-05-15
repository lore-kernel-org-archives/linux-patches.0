Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99620192D8A;
	Fri, 15 May 2026 16:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862601; cv=none; b=KqHj00tZuT4vfa60mkhrhXrsIYZVPmNnWwDQ2fhKm8nEXm6IPn4EyRM+vJbVYmPS3a/uJmJfseI10OsuptUWxv4J3wkjTFMF4yLPHLbmAdgXGLit/LSJSdRJSaYRpu4EdxdKLo5GJxjV+bgDIlfEY4g1kJ6HjF5SET7T29FLw9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862601; c=relaxed/simple;
	bh=1mAp52+GIjL38/eyEkLcsIzEb+jNa3sP7jztDCdHmlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgXxUD210dWNOeJ0vNZZEiLmdvQ5iJmBhR94tDuFmGBhLBqP6TaDY61xbyNPNwBr+t0+Nfpe+AmYF1EuFbMdlnhh6HNhP6sj0t5acEWMxW+0uE6AVVFNVmFgVnBBFW1Dt3rfN6m9MFxpeqReLj8W7oRbzp0XQw/sdxnv3kf/HhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHtWIS63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHtWIS63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05157C2BCB0;
	Fri, 15 May 2026 16:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862601;
	bh=1mAp52+GIjL38/eyEkLcsIzEb+jNa3sP7jztDCdHmlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHtWIS63wZUyhRTKhzQqSteVHneHyv/r+3T7ofxqzku7WoNOQng1V5gOCWJjT6p/+
	 L7OFwM6+9/Tq6esTRIQCZ4GY8tMpHw4iGXw84tMy9pB7/+stX3fB0IVIIEiLuPimuN
	 JP6qJz/33tOZpbOcUEFGQYl7UYfz6byt4nPv2/0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 111/201] spi: orion: fix runtime pm leak on unbind
Date: Fri, 15 May 2026 17:48:49 +0200
Message-ID: <20260515154700.956729724@linuxfoundation.org>
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

commit 97b17dd8266d2e26d9ee3c75a0fa34ecde6944f0 upstream.

Make sure to balance the runtime PM usage count on driver unbind so that
the controller can be suspended when a driver is rebound.

Also restore the autosuspend setting.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: 5c6786945b4e ("spi: spi-orion: add runtime PM support")
Cc: stable@vger.kernel.org	# 3.17
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Link: https://sashiko.dev/#/patchset/20260414134319.978196-1-johan%40kernel.org?part=6
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421130211.1537628-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-orion.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -811,6 +811,9 @@ static void orion_spi_remove(struct plat
 	spi_controller_put(host);
 
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 }
 
 MODULE_ALIAS("platform:" DRIVER_NAME);


