Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7574D43BDA4;
	Mon, 17 Aug 2026 13:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974226; cv=none; b=c1lFAWHaP7ciibmhjjIEYSNhckZfmSE1btULgNDiIliBQmM0qfNM9NmecxrXFSF3LepS3R8p1k3PrYsIysqE5eFM3SbN7ENyFSdgm9xBXmIgrxoQk5j/Xe1JLK62EVvN7rMMA5AuG5BQA2Dma/d6W4RKoQyJZ9xkAUlfMQCrMRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974226; c=relaxed/simple;
	bh=lvBJMlf8jF3mCdFuFe67SFkVwlaTZ4JHTDfFYS7i6eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0PqKnlnS/tNmodzMrzrbN6bOhwQm3lcNtSSooXGlJtcCOjEn55HAN1HLrWMApVJZVx+oY+Rm/n/DRRdSxQPW6JOhDJ+eb/HgbGj6hX8ClIgmBFAW9YeZLWm0sFiykLhpE6PM0Ohrm+yLai1iylxyOLm1c5aukvU+cCPMCQXhTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpFXsMI8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpFXsMI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8EA1F00A3A;
	Mon, 17 Aug 2026 13:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974224;
	bh=mQbgmC14ieDvbWx/T/GZQuca97WLt/lCffVbiVJtfuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpFXsMI8Y7DjlIllzewLEGYR4Ov3boax1WAJCncXlFrAX+CcPk0tZ0Bn/3Z9Xk8fI
	 ODwDLK0ODa6TIp8me12OGOH72CLGnZAsyiybkIVRcWQGeh0sFvRhpsQXDIxiCITJZM
	 USixVF9dwS/iGuFsqMu99MBL/8ISzrTSGCBCW4Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	stable <stable@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 7.1 133/271] usb: cdnsp: fix incorrect endian conversions for APB timeout register
Date: Mon, 17 Aug 2026 15:30:58 +0200
Message-ID: <20260817132542.325566034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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


