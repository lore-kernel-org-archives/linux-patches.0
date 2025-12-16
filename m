Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF2233A019;
	Tue, 16 Dec 2025 11:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884593; cv=none; b=JyU08PZ2lnvWB+6vt6jTAsd/eQdkZ8l9jPReqCrD8JRRwpHFj5XRiRIVplczFfVJKCEunBXx12tlS9K0s5W7BSde7DmicPPvzrBXXCnNktRXREFInllfSzXBItY1Iq9KgRgpHc/02Gi1yEUA5zCzlB1ZkY5jKHBTY1Za2y+EEjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884593; c=relaxed/simple;
	bh=ZQlon/xVCcUik2LEBu9EN8Irfpl2/h9YzEWGfB4v+VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epG8vCE1zByG0qQMDW11LCkGoS+B0w6jb91/JcL8O91qbRKzVMKWeBATI324eftWtkoMwlS6/GEiRXC4xn0dfw8ZiPajfdTHHTpppwvgf9dhuassa/AACsvrmcKresE7zIwibiWN1iE2h1j4TWVWKh0bWpAlkh/lIKcanfR63NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LY20gW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LY20gW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162CAC4CEF1;
	Tue, 16 Dec 2025 11:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884592;
	bh=ZQlon/xVCcUik2LEBu9EN8Irfpl2/h9YzEWGfB4v+VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LY20gW0braOXLOiPFtSUgxBeqw2AIR0oIHLoYTZBUv2WBPXY9Qlstm1dgZSD0ASe
	 j7DUhA+d4eqpIsIOnvFV92OekJJwWrClPtHlU+e0R7Co/ObmYhqtHMjnoWDh4ic/qB
	 8NMBbaOjjqaA1sn/ZVI/IlavPl3iW6INvn5Vlrm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/354] greybus: gb-beagleplay: Fix timeout handling in bootloader functions
Date: Tue, 16 Dec 2025 12:13:26 +0100
Message-ID: <20251216111329.573551562@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index da31f1131afca..2a207eab40452 100644
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



