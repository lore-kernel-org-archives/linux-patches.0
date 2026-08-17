Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D7C3F12C6;
	Mon, 17 Aug 2026 15:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979686; cv=none; b=O4MGP+vbA3nsejUIkt9bv1mSgm5SS/VjBbqCp8Ow/hBEuyWSL10XilOnse5juf+Z7sUM5p5s0Q3Dcw/25uWWC6Vr/rSIRimYbHyqxFL1TMpGT7RcoYY43Pu4DaeJITU9xMvLkldJ7ZuD2i9LRIjB+V6GvcdZ/IVfQRD09as4k50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979686; c=relaxed/simple;
	bh=r32Xv01icalASG7EY+4FU0BglpHc9DSlpLlhthbCHCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3r+j709ZakET2h+xo+8hwRMTWbtpOEQ6Q0jTTR0ZDN8T0awdctPsAVBfpo61tPJvcqTYPTXR1BPPji98x8KvVxseVO9KYhzguI3FXBOpJYqvdcQNc6weoNbfqLDKR0vZ3gVM8oOObJ+F1Cs/vBpKf3W6ESsl8HFWbNJOwtoWvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7T0gwI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7T0gwI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6EA1F000E9;
	Mon, 17 Aug 2026 15:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979685;
	bh=LbZXl+bRZ4+8UuOzjqAM/D+iiup9vdyOUetA1wG0CTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7T0gwI+Nc/CBQuTpQ0OPbHDzBWYD7clVU4sTrJmJgOJTzbIvvBt5m0ufZlCtWNUP
	 h+zWaIcTl5PeaeYcqI6QmN37ziIIPLeoT67ELULOtaFRYlSPNzsarFAUXVfKAlQydk
	 Tj8YNcwE06CuEGLg+lwtWwbaMjI8m9WABO5FsUNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 311/609] ata: sata_mv: accept 1 or 2 resources in platform probe
Date: Mon, 17 Aug 2026 15:30:07 +0200
Message-ID: <20260817132554.659070003@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit ef19a9cf037957fe3a35df8355c76ff0a63a0436 ]

Board files in arch/arm/plat-orion, arch/arm/mach-dove,
arch/arm/mach-mv78xx0 and arch/arm/mach-orion5x still register the
"sata_mv" device with two resources (IORESOURCE_MEM plus IORESOURCE_IRQ).
Those devices are rejected with -EINVAL, so SATA no longer probes on
legacy Marvell Orion/Kirkwood-style boards.

Accept both 1 resource (DT, IRQ fetched via platform_get_irq()) and 2
resources (legacy, IRQ supplied as a second resource) so both probing
paths work.

Fixes: b3b2bec9646e ("ata: sata_mv: Fixes expected number of resources now IRQs are gone")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_mv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 9cf540017a5e5..298bf6330de57 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4026,7 +4026,7 @@ static int mv_platform_probe(struct platform_device *pdev)
 	/*
 	 * Simple resource validation ..
 	 */
-	if (unlikely(pdev->num_resources != 1)) {
+	if (unlikely(pdev->num_resources != 1 && pdev->num_resources != 2)) {
 		dev_err(&pdev->dev, "invalid number of resources\n");
 		return -EINVAL;
 	}
-- 
2.53.0



