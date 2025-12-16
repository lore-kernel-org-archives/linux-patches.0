Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21AE347BCB;
	Tue, 16 Dec 2025 12:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888137; cv=none; b=ZBLuHXA0jJLfPy97xrcSOk8oYasrQ0o9GMFcIVskx5eti2aYTuBH4YmByr/daDOsk7Trb/QmCipRIPw/uh8KwRb4AG/fEzq9/jNa3NZ1y2KDs0yNEptTM8MmQya8SIX557OOtPwV5B4h1wmtVMlY6EWm8883EdeUcoYWhI/Smoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888137; c=relaxed/simple;
	bh=g0JsWLz/N9MXoN8hAq/k3JdS59Qe2ewRqJYLFs72Vo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ra6SaAJ3rN8GzU3kYcvtOJpB/8HYxbKgyNt2uplXIChnsdS/N10tyApIYbS/bUfBj1aIsuAxyEvU3TmYztCs1apHKGLoY4dD1sNlHpTbVXHQNHx4jt8WKyOdgzR9mr3ewcqLicV0yQ+tPjVTgV50hGoi5qWXdtTSj11JkDvqp1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKj2KAQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKj2KAQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EACDC4CEF1;
	Tue, 16 Dec 2025 12:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888137;
	bh=g0JsWLz/N9MXoN8hAq/k3JdS59Qe2ewRqJYLFs72Vo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKj2KAQCOgodcKZ3OTpibvLlm5sAH7TsQMrwZ4Oaq/884oFZxasCaXempRHI9nRZ9
	 rf3phABbCYjOpXZqN6YuPMiGqvyQtueUg1xt7EqU1EqVnkcNDc3lbmAOLUSEMp5mQP
	 zaZvZVtHnRGz/dcsFo9hAEtpauOv0zenK5ijbkAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 443/614] greybus: gb-beagleplay: Fix timeout handling in bootloader functions
Date: Tue, 16 Dec 2025 12:13:30 +0100
Message-ID: <20251216111417.423761905@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit e6df0f649cff08da7a2feb6d963b39076ca129f9 ]

wait_for_completion_timeout() returns the remaining jiffies
(at least 1) on success or 0 on timeout, but never negative
error codes. The current code incorrectly checks for negative
values, causing timeouts to be ignored and treated as success.

Check for a zero return value to correctly identify and
handle timeout events.

Fixes: 0cf7befa3ea2 ("greybus: gb-beagleplay: Add firmware upload API")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251121064027.571-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/greybus/gb-beagleplay.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/greybus/gb-beagleplay.c b/drivers/greybus/gb-beagleplay.c
index 9610f878da1b6..87186f891a6ac 100644
--- a/drivers/greybus/gb-beagleplay.c
+++ b/drivers/greybus/gb-beagleplay.c
@@ -644,8 +644,8 @@ static int cc1352_bootloader_wait_for_ack(struct gb_beagleplay *bg)
 
 	ret = wait_for_completion_timeout(
 		&bg->fwl_ack_com, msecs_to_jiffies(CC1352_BOOTLOADER_TIMEOUT));
-	if (ret < 0)
-		return dev_err_probe(&bg->sd->dev, ret,
+	if (!ret)
+		return dev_err_probe(&bg->sd->dev, -ETIMEDOUT,
 				     "Failed to acquire ack semaphore");
 
 	switch (READ_ONCE(bg->fwl_ack)) {
@@ -683,8 +683,8 @@ static int cc1352_bootloader_get_status(struct gb_beagleplay *bg)
 	ret = wait_for_completion_timeout(
 		&bg->fwl_cmd_response_com,
 		msecs_to_jiffies(CC1352_BOOTLOADER_TIMEOUT));
-	if (ret < 0)
-		return dev_err_probe(&bg->sd->dev, ret,
+	if (!ret)
+		return dev_err_probe(&bg->sd->dev, -ETIMEDOUT,
 				     "Failed to acquire last status semaphore");
 
 	switch (READ_ONCE(bg->fwl_cmd_response)) {
@@ -768,8 +768,8 @@ static int cc1352_bootloader_crc32(struct gb_beagleplay *bg, u32 *crc32)
 	ret = wait_for_completion_timeout(
 		&bg->fwl_cmd_response_com,
 		msecs_to_jiffies(CC1352_BOOTLOADER_TIMEOUT));
-	if (ret < 0)
-		return dev_err_probe(&bg->sd->dev, ret,
+	if (!ret)
+		return dev_err_probe(&bg->sd->dev, -ETIMEDOUT,
 				     "Failed to acquire last status semaphore");
 
 	*crc32 = READ_ONCE(bg->fwl_cmd_response);
-- 
2.51.0



