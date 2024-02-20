Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9773514AD12;
	Tue, 20 Feb 2024 21:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463552; cv=none; b=GZNW22zGTPjUyTHkle16AS0Xvk6b4FPOQ/ojqprdz1ObmWf0EavCst85Zn6YJSKzBx4HNy4wsJsYHhHzzLFN/tZIIBA6S35Xjepl1Ax7q6coy2EGWwRKNUIpNLmkEtR60vYGXUtAaHyij1rpjiPxIoZZSJ0+hALkewaYgNnnC8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463552; c=relaxed/simple;
	bh=uoSvSWiDzoJF2zXlTmWejboKYUcXYiHEOZ7ZSNd70dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZHgi3gBxJf7PgQMaT8Gm3Wl6dYnCv7qQL4+CBtJPEQv9SRCIE0h2pFX9Ux4MBe41L5a2i00cTk/Ey1bVy4b4jxgD/Kw9RlhgWDG2A3XsGw3j325TcpGckWXlyKz3qbK0JPn/daVnxfNu2QXb5aKfrBYG/Xb4OeCsR/DpnaftkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnupGEae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnupGEae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D6AC433F1;
	Tue, 20 Feb 2024 21:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463552;
	bh=uoSvSWiDzoJF2zXlTmWejboKYUcXYiHEOZ7ZSNd70dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnupGEaevcCHs4k9Kp/419cXD6FGigMM6yYRGVevqnqxNhDpNB9cKKlGYTftr7Rap
	 zRpXxh1I9MCTwG5y4K8Idm/Ay4+LoMYiu4QsVV1CecvSRo0/o7v1TuJwFHdy05LGwY
	 0Z5jwkgn4x5F4ATW+XOfvsM7+///qlf6uttcmgQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 6.6 078/331] usb: ulpi: Fix debugfs directory leak
Date: Tue, 20 Feb 2024 21:53:14 +0100
Message-ID: <20240220205640.032023939@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@seco.com>

commit 3caf2b2ad7334ef35f55b95f3e1b138c6f77b368 upstream.

The ULPI per-device debugfs root is named after the ulpi device's
parent, but ulpi_unregister_interface tries to remove a debugfs
directory named after the ulpi device itself. This results in the
directory sticking around and preventing subsequent (deferred) probes
from succeeding. Change the directory name to match the ulpi device.

Fixes: bd0a0a024f2a ("usb: ulpi: Add debugfs support")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20240126223800.2864613-1-sean.anderson@seco.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -301,7 +301,7 @@ static int ulpi_register(struct device *
 		return ret;
 	}
 
-	root = debugfs_create_dir(dev_name(dev), ulpi_root);
+	root = debugfs_create_dir(dev_name(&ulpi->dev), ulpi_root);
 	debugfs_create_file("regs", 0444, root, ulpi, &ulpi_regs_fops);
 
 	dev_dbg(&ulpi->dev, "registered ULPI PHY: vendor %04x, product %04x\n",


