Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BD92620C3;
	Thu, 17 Apr 2025 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914393; cv=none; b=Q+t/ML8rmUzQVCXTADhyCrU5EoUN5q2McPaBePDwAqTQj89/SV8FAysF/Z57/Y3Y691I/X5zPCAS8ioIhgDVBOVpHSbTkNGHFcbPXzyf57RRuy5Ho1p0tzYQ7MTf13RPujaaR+nlghBGTTCAnx5mqkFeboQS0HX8kTqG6Pf8stw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914393; c=relaxed/simple;
	bh=y8QZjQ2bUrK27WG1FkUkYy4TrKUfntWSJnUjuSTauFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hQ3+VpiCxGdHe/Wzzyk8ORTsDss2zdiz3pFQfO8oXOdsBjEO8KslQuI5+XhdIuy5SCTjJMQ29yt1f1HpEts1Ly55oy5oFcT+n1hLQ2IbQbXPABSLY7CW4j5cjLZHXzikCmZE9YbXHmH0C0rLF2X04v6eSg6khRT1FlbHU9EAmOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3QmjUpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3QmjUpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C824C4CEE4;
	Thu, 17 Apr 2025 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914393;
	bh=y8QZjQ2bUrK27WG1FkUkYy4TrKUfntWSJnUjuSTauFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3QmjUpxkHERWqBVa/d8kcr7bo5N5OSHpj7+P/lFXsMrqrNTZBRF398ztNLD5ETqj
	 sxf7muJaGHyMkYr+PqpKR5uZuImvxx+HD216v0qm4VsfrfU6eIgTdr0mFmEPwASsgm
	 Ujk8Ssgv2G65/TOheD7ko4PEPXVpHJ82waJxrwcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20T=C5=AFma?= <martin.tuma@digiteqautomotive.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 200/414] media: mgb4: Fix CMT registers update logic
Date: Thu, 17 Apr 2025 19:49:18 +0200
Message-ID: <20250417175119.487146430@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


