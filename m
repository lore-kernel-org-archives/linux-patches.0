Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463CA3502A4;
	Tue, 16 Dec 2025 11:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886190; cv=none; b=AOv3zz5dljbsljVVewA93UmR0djI+kIPPXaEFtWQ8dTeY67ijcmxGOEiYFJM7cON6yxoro/mWV3S2No7GIbdux7qfIw+eFNLyes68WDzF+cJw/6UrKZnhhL0yIC6+Tzx15TfawsV+F302LU7fPUKplB8dNk3sWvVEXN9yGaOTZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886190; c=relaxed/simple;
	bh=vzTv4DixdcYit6bVUJhHvsADrPGzq/fhPj1ZXcQcURE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qewo/TWYCU/gBjhH6qBrmDRbPADeu9MOcJpw7q+PJuOkB5bpfVyqwwOWdT7QZ+ydVqA/aEV8XRuGGGpW16nXj8IWYyuaQwPHrx3BAnRw3OXNpAh2Gn61MfCB+WxrewTT7BQwx9rgVCxkUDFfa0gFKHiY7CoAwFUUcySRBhpwYGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLsDPSMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLsDPSMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23DEC4CEF1;
	Tue, 16 Dec 2025 11:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886190;
	bh=vzTv4DixdcYit6bVUJhHvsADrPGzq/fhPj1ZXcQcURE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLsDPSMlT7E3kD4TpKKMwrEy4Op2rIX8rR9KibQz5RY18Zk1MzdiXgRxqY3a8vizZ
	 5YH721spem9KAA7fE0FybzSJynfP2AGAqVtmH2Xle7n+HY79uR262qQl+jpVp7xZQn
	 x59UPY3udia45AhrE6Tvgug4PVIQRS+cjdQBCMVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 365/507] greybus: gb-beagleplay: Fix timeout handling in bootloader functions
Date: Tue, 16 Dec 2025 12:13:26 +0100
Message-ID: <20251216111358.682387018@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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



