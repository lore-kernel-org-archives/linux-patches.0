Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EA8334366;
	Thu, 27 Nov 2025 14:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255500; cv=none; b=dYt/yYyDjKiOEbAEgQ+YzRhXSlfXGXU5BUjqKwhtYg7gKwlQMRrB7RKxXUMtC0dCVS1kGzH5tjxOvx51DXKOinHJbvofqA6GPpAw+AqMC3uneuILnV2VwD9gyllekxIQQIVdcXr7lZBa0BFVcHh5F9sHHcxIvHySn0Nt6lm3MCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255500; c=relaxed/simple;
	bh=Vpq3DPvF1LG5rhiuMlcclu8PWkuHmX/ico/utn77G8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1iyP84BDSXvFCHngD5eq0RNUsydKIpidUaE1F5XN7rLQzH8LBQ018zPJh2l6zzBuaSg9LsKi1tAaWqTOMOTO1xccWQ5EcxjEM4xgkOcpX8t1DIgRrG/c3FIB+vk/wj+X0mOJAGBeybiAzFQmixgjr/3v0sr5U2djMxYfVKBYm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRjr3nsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRjr3nsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94761C4CEF8;
	Thu, 27 Nov 2025 14:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255499;
	bh=Vpq3DPvF1LG5rhiuMlcclu8PWkuHmX/ico/utn77G8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRjr3nsf57K8l17XudqBWQrPuQQ/Pb8dXhuGmruHoG+AVF/Lu1IBPc703bYWRr51z
	 Q2InqZCrpqsYawhdha18bQWVW2DFRvheOdulsEmxE5CxGCj5otxoF5rEfgww7z8Vnt
	 bb18eMdvLQvGqDRYKBSXCDQB9phpboJcc/UHWtOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.17 015/175] mtdchar: fix integer overflow in read/write ioctls
Date: Thu, 27 Nov 2025 15:44:28 +0100
Message-ID: <20251127144043.513616289@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit e4185bed738da755b191aa3f2e16e8b48450e1b8 upstream.

The "req.start" and "req.len" variables are u64 values that come from the
user at the start of the function.  We mask away the high 32 bits of
"req.len" so that's capped at U32_MAX but the "req.start" variable can go
up to U64_MAX which means that the addition can still integer overflow.

Use check_add_overflow() to fix this bug.

Fixes: 095bb6e44eb1 ("mtdchar: add MEMREAD ioctl")
Fixes: 6420ac0af95d ("mtdchar: prevent unbounded allocation in MEMWRITE ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdchar.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -599,6 +599,7 @@ mtdchar_write_ioctl(struct mtd_info *mtd
 	uint8_t *datbuf = NULL, *oobbuf = NULL;
 	size_t datbuf_len, oobbuf_len;
 	int ret = 0;
+	u64 end;
 
 	if (copy_from_user(&req, argp, sizeof(req)))
 		return -EFAULT;
@@ -618,7 +619,7 @@ mtdchar_write_ioctl(struct mtd_info *mtd
 	req.len &= 0xffffffff;
 	req.ooblen &= 0xffffffff;
 
-	if (req.start + req.len > mtd->size)
+	if (check_add_overflow(req.start, req.len, &end) || end > mtd->size)
 		return -EINVAL;
 
 	datbuf_len = min_t(size_t, req.len, mtd->erasesize);
@@ -698,6 +699,7 @@ mtdchar_read_ioctl(struct mtd_info *mtd,
 	size_t datbuf_len, oobbuf_len;
 	size_t orig_len, orig_ooblen;
 	int ret = 0;
+	u64 end;
 
 	if (copy_from_user(&req, argp, sizeof(req)))
 		return -EFAULT;
@@ -724,7 +726,7 @@ mtdchar_read_ioctl(struct mtd_info *mtd,
 	req.len &= 0xffffffff;
 	req.ooblen &= 0xffffffff;
 
-	if (req.start + req.len > mtd->size) {
+	if (check_add_overflow(req.start, req.len, &end) || end > mtd->size) {
 		ret = -EINVAL;
 		goto out;
 	}


