Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E487286416;
	Thu, 27 Nov 2025 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255106; cv=none; b=FPocP0aJ/Ab34W/ArLf3dSWpFGrYQ1snC13X85Twi7gJUPsSnFdaWIovqg9QNoK9T2GVZqErCe3NZEse+88hFXikbExj3e8Joo14qcX1k+qHkZcQ5LE3HxBF06rYyX1D1mfwOJMXWBaCZS9eR7plDmgD8CF4dJWwLLKBp55/VHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255106; c=relaxed/simple;
	bh=feQzvKItjb5S8KuK6lLKBG85C0NdMJTePvJIjEmTaCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYgO7RU/cuX5VO2AnVbpeIwiRD+mkEevMb4d3IeeM6TIn7JEY0Ug4WhCg44X9FG9D8E5jjIWBDr0k34cn67d9cVKgQhnR0sfMP/Rs4gZu7SyCVb3SxZduQw7lenwej2E+zWoxRtRhFwRyf58qtUNldEhaLowBMfP5qFbA+oOr5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5/1H21V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5/1H21V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8619CC4CEF8;
	Thu, 27 Nov 2025 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255105;
	bh=feQzvKItjb5S8KuK6lLKBG85C0NdMJTePvJIjEmTaCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5/1H21VnsmK+7pGCfXom8Z3RHQlqcvs39/h8t0acylzlEjA3ir9p4doI27zKpZZc
	 flzUzLS5t/7/R6nYHiTmoqqQfEMOdp9HcV+eCAQDkpJoXEBtX0CA5lRHZZ27qbCoMk
	 A7heSVheCDKcFT/PwmMdPkyt++N2bwsuLleYwSOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 010/112] mtdchar: fix integer overflow in read/write ioctls
Date: Thu, 27 Nov 2025 15:45:12 +0100
Message-ID: <20251127144033.105256551@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


