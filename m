Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2B525742E;
	Thu, 17 Apr 2025 18:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913086; cv=none; b=kM+Kh4LUhb6KnY7D6/y8UhkmitEEymaSJWHUSn049/Wu3kA0dpxr7pXid2nJyJktbV4kljPS18IUsJpyyIzWFJv0CHGHTvdcoAO5PaLUMAWyhgLeGNXQcKFQJ7rGzf7DZkECLNzCjyaULdP5dKy4dm7BFiGp28SUhJeSpN5ioJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913086; c=relaxed/simple;
	bh=vD7Gkv5EOvhTgXX1LFgHUGc9E3HgFdVk2IL71MTZO4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ggMao/QLAjtWUCpor5wGt9knGiKm0rOt70Kvbavf6Kid+aHZgV11L1GT6sro6Hdvb6Ykvdn3n76MH7swJCtrfP0q7Nh2xaizwn4v5U4G/PoWbaJI4sIJXIknmjs6sx/ETg1Ice/8eRs3Tf8bCkhsKmYL5nDHT6Ia66jgWxyXNN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsniFzqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsniFzqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00FAC4CEE4;
	Thu, 17 Apr 2025 18:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913086;
	bh=vD7Gkv5EOvhTgXX1LFgHUGc9E3HgFdVk2IL71MTZO4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsniFzqDUzOJI2HUlsJq6rxuzOj35d6tHaApNfguTqYscYhH5kLZ0VORjGe0yQQWc
	 n99WohGRE2+x2gPIfc75mJyK6qPsBbCGXjo7Rx1Wop1QzquEqENu9Pjd4AkiuK9rML
	 /TrlhABLU7TT87hPaT37+5JDaYX5JfUPkM8FD8Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20T=C5=AFma?= <martin.tuma@digiteqautomotive.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 222/449] media: mgb4: Fix CMT registers update logic
Date: Thu, 17 Apr 2025 19:48:30 +0200
Message-ID: <20250417175126.907334328@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


