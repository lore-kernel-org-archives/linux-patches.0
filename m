Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E8D151CD2;
	Tue, 20 Feb 2024 21:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462826; cv=none; b=b0KuDnnX5PdjIRg57cDAmqHPsijbQ2np9PsP+1cwkD/I0xX2CAlP/t7PMFbZrqYyA3Q6l1nK95rLDztPcnd09vM27aJKMJwm0wAYIOaVMQbKGxpL/LgyYL5SU7VOqOhTnS60Yq4mUU67R4pQ2TSBqzIfNBfAYYoavdG9W9fm+eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462826; c=relaxed/simple;
	bh=EhqBVLb55wHU4Ji7bm8iewQK/bUacepUBvJDMf/AKCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCwluxA2rIGWiA3VGJG9yIzjnO/6NSLyQra9/wG5hObnJLgNqUnrxLahaJyJP84bmT7uq9Cy/QDE5vRzT64GnVgVtQtrBz/+Xp1UJn1Y1/z5RlmG/yRv9qRDxhaphD40l185Uejcv+ZUlS3LlK8kTUpTEbOuQ26EY8HY6v68gok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mPE1Ahc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mPE1Ahc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8DCC43390;
	Tue, 20 Feb 2024 21:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462826;
	bh=EhqBVLb55wHU4Ji7bm8iewQK/bUacepUBvJDMf/AKCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mPE1AhcJlL65gPIXzTf2bTSyW2hI2cE7pMgz60wPB7gnANaQHjkgEQA53EV/74Nt
	 1vJ4bC+ddeVPGGzEPBrwoaFXfu0rqCpNWvOm+POeVyNhSZ7wXoyKd27TQwy3bfy6dy
	 dkltITTGOs9n4noCkCRl1iQ09khrS75/FML5BFug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 6.1 049/197] usb: ulpi: Fix debugfs directory leak
Date: Tue, 20 Feb 2024 21:50:08 +0100
Message-ID: <20240220204842.549279718@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


