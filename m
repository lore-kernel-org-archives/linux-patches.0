Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786C9253333;
	Thu, 17 Apr 2025 18:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914634; cv=none; b=SPt6BC1+JzwRKA8PhxLqoZeKweQWioOneyf/gEjDChOyEeD/rCs/4jK0HaZxYvmnLAZWBnEynE0PTgW/Ev5TPEufhsnvAMEvzMLhwJ+D3+ycwi+Kl9fz39O4jhoMvh9iiU4r8yJU11VwvHRgy3ZCXaUx48JeFX3/KW+JbaE7ys0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914634; c=relaxed/simple;
	bh=bdOSsFAk9Z+6LIfofYlRggDgF1Au7ZCHAo12hFoHLko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGDOB4pTR3/tLAhd4BJZ/v9S6Hkuma0XV7cirAdlHirZyKHh7e+KRxA1DZPbDc8Q3xSbs87ALJHvGHmStx9uMkFcT86g01fHSGJmf0GFR3nBEoiAtxz013jBqXtn28NcxyBo34fDZGj3DDGo6xvh3zyxhAUZR06xUC1INbUWZa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPPICO1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPPICO1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA698C4CEE4;
	Thu, 17 Apr 2025 18:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914634;
	bh=bdOSsFAk9Z+6LIfofYlRggDgF1Au7ZCHAo12hFoHLko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPPICO1sV5VZIvp4Wp70HyPu7ygI4eOWnGTpJMHYiQWWrrF+pkp/k4x1eCOr2c0SP
	 XAE6n/6bS7HEy+QFUxjAsIHJMVyI4LIdmBAwwGvB5WCaGAbE02sYLAmooKBCDZy/lR
	 0hQm2BNeWtd9/oLNnuRIiVdPa7cZMmaSex+FbfQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.13 250/414] mtd: Add check for devm_kcalloc()
Date: Thu, 17 Apr 2025 19:50:08 +0200
Message-ID: <20250417175121.475046227@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

commit 2aee30bb10d7bad0a60255059c9ce1b84cf0130e upstream.

Add a check for devm_kcalloc() to ensure successful allocation.

Fixes: 78c08247b9d3 ("mtd: Support kmsg dumper based on pstore/blk")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdpstore.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/mtdpstore.c
+++ b/drivers/mtd/mtdpstore.c
@@ -423,6 +423,9 @@ static void mtdpstore_notify_add(struct
 	longcnt = BITS_TO_LONGS(div_u64(mtd->size, mtd->erasesize));
 	cxt->badmap = kcalloc(longcnt, sizeof(long), GFP_KERNEL);
 
+	if (!cxt->rmmap || !cxt->usedmap || !cxt->badmap)
+		return;
+
 	/* just support dmesg right now */
 	cxt->dev.flags = PSTORE_FLAGS_DMESG;
 	cxt->dev.zone.read = mtdpstore_read;


