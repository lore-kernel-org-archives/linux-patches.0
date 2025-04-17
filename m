Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941B9185920;
	Thu, 17 Apr 2025 18:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915733; cv=none; b=JioUPFggEN+JJC/lOl0S0v4Mb9jfyV+91hoHmj6MGIq9MC+ScKf1/fqRODdMZ3+q1bTOia0JfT78uHxB5645NnmNeiUo1+T5WrM13w1gpEY7tvSJ3mZCJyFX64PZ/Et3KGnhcnkvxHEc8QnCmjkl6p1h0H6/b+Rrz34+7qwuTkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915733; c=relaxed/simple;
	bh=CO49+a9ZG4PcAVYYJX5o2KFmTl9olFM+zBxS/PSW/2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cp521kCQWuRh61o+AVgc1xB4PJhbBRsTxAPrTLKnJ9PMs46gpTwIQICAM0PGZT6pQspTV6u4ko5hwHrC5s6VGihgRUe+roitDfydIoBImLJcpQu90h6hTGhdXpGis3iHlwC3IxOfTIBcbK73724QKrVeTRLrHqKhmgAuuPIc2FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJFArCz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJFArCz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A23FC4CEE4;
	Thu, 17 Apr 2025 18:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915733;
	bh=CO49+a9ZG4PcAVYYJX5o2KFmTl9olFM+zBxS/PSW/2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJFArCz7S5U5vr1RhI49Z8AEygHW/PfipYFhImDwn+okfxZNSAnc/ZaqrZkWMqLf/
	 WF76C9qiYRD38X9L2FiNePcJBh9saI2Oe6OuwepJdvm4IPBBQFrDX5z6kl007Q9ktB
	 LnN/+m8jqhjV6c+uSyDYnGVJ2TA4OBpH4jUVr3Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20T=C5=AFma?= <martin.tuma@digiteqautomotive.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 192/393] media: mgb4: Fix CMT registers update logic
Date: Thu, 17 Apr 2025 19:50:01 +0200
Message-ID: <20250417175115.309016614@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Tůma <martin.tuma@digiteqautomotive.com>

commit dd05443189f9ae175dd806594b67bf55ddb6539e upstream.

The CMT "magic values" registers must be updated while the CMT reset
registers are active.

Fixes: 0ab13674a9bd ("media: pci: mgb4: Added Digiteq Automotive MGB4 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Tůma <martin.tuma@digiteqautomotive.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/mgb4/mgb4_cmt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/pci/mgb4/mgb4_cmt.c
+++ b/drivers/media/pci/mgb4/mgb4_cmt.c
@@ -206,10 +206,11 @@ u32 mgb4_cmt_set_vout_freq(struct mgb4_v
 
 	mgb4_write_reg(video, regs->config, 0x1 | (config & ~0x3));
 
+	mgb4_mask_reg(video, regs->config, 0x100, 0x100);
+
 	for (i = 0; i < ARRAY_SIZE(cmt_addrs_out[0]); i++)
 		mgb4_write_reg(&voutdev->mgbdev->cmt, addr[i], reg_set[i]);
 
-	mgb4_mask_reg(video, regs->config, 0x100, 0x100);
 	mgb4_mask_reg(video, regs->config, 0x100, 0x0);
 
 	mgb4_write_reg(video, regs->config, config & ~0x1);
@@ -236,10 +237,11 @@ void mgb4_cmt_set_vin_freq_range(struct
 
 	mgb4_write_reg(video, regs->config, 0x1 | (config & ~0x3));
 
+	mgb4_mask_reg(video, regs->config, 0x1000, 0x1000);
+
 	for (i = 0; i < ARRAY_SIZE(cmt_addrs_in[0]); i++)
 		mgb4_write_reg(&vindev->mgbdev->cmt, addr[i], reg_set[i]);
 
-	mgb4_mask_reg(video, regs->config, 0x1000, 0x1000);
 	mgb4_mask_reg(video, regs->config, 0x1000, 0x0);
 
 	mgb4_write_reg(video, regs->config, config & ~0x1);


