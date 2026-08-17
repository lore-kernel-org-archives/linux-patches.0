Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D153E3ABD99;
	Mon, 17 Aug 2026 13:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975091; cv=none; b=SHHif7eJMsvcmdHulOiDftE2DdBzfo+OvljyJ36vA88sls/iIopFZRTT2brmVVbgSU4pE92rnnGPdVvJz1/BQAquteKJfash9jd8E5EH4oDvjqQOLeH4P8AUovCegAh6czghjI3mOQvyt3CCR0Ad4LTd6hbeOEGMlqvelgKdO+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975091; c=relaxed/simple;
	bh=botk9OrkF7NIW/R+uatihY05uxpH4vB5jIMpwiOHvT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHiUtHkF/3ReurYrEWmTCtL25x2hcsRyo+SbtUs/6TLWZP6fO1JFGRLCn0anCPNAQsIGJ4PlSmkaoWi6Orx4l1qOS+O12YubbyVkRvcBn1NLmiEaZWA95VYTnocHCpRxgRLTLVdAP898J9AzVYlnwgv+vMJcAhNsc5DQHcMERWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzeUnG6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzeUnG6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FED1F000E9;
	Mon, 17 Aug 2026 13:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975090;
	bh=arn8bNhI8iYqNOU7eUfWMNuINUZro4RXrT3NO6+hT2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AzeUnG6Is/CJaXzsiVVMJNdz9QPJXU1naz8qMbNBWeTx3fHpZfFFd5hzBa70I7ooZ
	 rOSktzqctPveir4J5fIPFGKiP9tr1VqnBM+s3YYTx38fTYkgNlkQ1xLex0gXILBJtC
	 7Bymb//Yri1fsYzFiZgPbkUIMh3chwaL8XK1iFC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	stable <stable@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.18 119/250] usb: cdnsp: fix incorrect endian conversions for APB timeout register
Date: Mon, 17 Aug 2026 15:31:20 +0200
Message-ID: <20260817132541.452012685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Pawel Laszczak <pawell@cadence.com>

commit 50b303f3d0f7de543ee90d50879970783d06da33 upstream.

readl() already returns a CPU-endian value. Passing its return value to
le32_to_cpu() is therefore redundant and causes an incorrect double byte
swap on big-endian systems.

Similarly, writel() expects a CPU-endian value, so passing the result of
cpu_to_le32() is incorrect.

Remove the unnecessary conversions and operate on the MMIO register value
as a CPU-endian u32.

Fixes: 241e2ce88e5a ("usb: cdnsp: Fix issue with resuming from L1")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable <stable@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260720-endian-fix-v1-v1-1-b5681fa1ea9f@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -155,9 +155,9 @@ static void cdnsp_set_apb_timeout_value(
 	offset = cdnsp_find_next_ext_cap(base, offset, D_XEC_PRE_REGS_CAP);
 	reg = base + offset + REG_CHICKEN_BITS_3_OFFSET;
 
-	val  = le32_to_cpu(readl(reg));
+	val  = readl(reg);
 	val = CHICKEN_APB_TIMEOUT_SET(val, cdns->override_apb_timeout);
-	writel(cpu_to_le32(val), reg);
+	writel(val, reg);
 }
 
 static void cdnsp_set_chicken_bits_2(struct cdnsp_device *pdev, u32 bit)


