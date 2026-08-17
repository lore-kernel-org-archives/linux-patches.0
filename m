Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEF144237F;
	Mon, 17 Aug 2026 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980032; cv=none; b=eyy+fZCLL4lpqKMaaj1PsPjJVwfcD6VUg5nKWeQ7meOoNGQlY55s9lHmzzulcdRjyWSaohAdid+9bV+4OfCSZhuROC4bHFVCvSn6PwfcDREy6gyBvEuEKjQmRBqACszYT6Ly2zZ1X/+q1QELvL8giX2HW1Y+dz+3Ca8n0gYzpng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980032; c=relaxed/simple;
	bh=dvRDeb+5x/cu9x4YGYonv/r/9rSEcAvDjNZEbfrSNqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGUmv6jjNXtuAIfWA3C4CDSkzljzsDgtW8gxRlMz/a9eqWsrYtQElDJbx0V7oq0uWDGF6bp8iSsoajas+FXSg1BbWHl/hpVLOBDvKN2UUDbQeOPfO/R/a8pDYocGSUNqWj62YTaQwMRdah1FOJQBDyenTKEd5NJqwDKRW54rrYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXzADrPl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXzADrPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CBA1F000E9;
	Mon, 17 Aug 2026 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980031;
	bh=3qrhhbPCJ4IgqePlDSlqCxUcL+WhYuk4f/20aodjW8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VXzADrPlmGWXjGI7sQ0kvdCDyFQIexd3IxzOcvxa425rYJ9gnH7b3p7+u1X7wcGx7
	 GR9OLjGba0xPSOXdCu4OMFhfdgAUIistEfs1DNcfTAyqCMT6p/4zwV/w/QnhiSPJaV
	 yoDlu+NJGYIVgwehNM2Ube4DSVXxzD/YM3C3ed9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 431/609] i2c: amd-mp2: Unregister callback on adapter add failure
Date: Mon, 17 Aug 2026 15:32:07 +0200
Message-ID: <20260817132558.508082914@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 82048795242f04275a3f49ffc66ad851b6120954 upstream.

amd_mp2_register_cb() stores the platform I2C context in the MP2 PCI
driver's callback table before the adapter is registered. If
i2c_add_adapter() fails, probe returns and devres frees the context,
but the PCI driver can still dereference the stale pointer from its IRQ
and system-sleep callbacks.

Unregister the callback before returning the adapter registration error.

Fixes: 529766e0a011 ("i2c: Add drivers for the AMD PCIe MP2 I2C controller")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260721144147.31150-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-amd-mp2-plat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-amd-mp2-plat.c
+++ b/drivers/i2c/busses/i2c-amd-mp2-plat.c
@@ -316,8 +316,10 @@ static int i2c_amd_probe(struct platform
 
 	amd_mp2_pm_runtime_put(mp2_dev);
 
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&pdev->dev, "i2c add adapter failed = %d\n", ret);
+		amd_mp2_unregister_cb(&i2c_dev->common);
+	}
 
 	return ret;
 }


