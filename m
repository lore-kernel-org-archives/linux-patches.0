Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD69D1F75BB;
	Tue,  3 Dec 2024 15:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238249; cv=none; b=kRUPGtFy5Q0x1SuxMUmaTqVf9gFLIl30GPmU3zPjR4pW35sxvPSfK+ksfGBCLUSO/rggZLb/WUVXpVDl+HSV+9z+JHkLqGAvflAG3Jr1nNfJ8h/ZOuES/+l1d/GGDq6RaBqNPBB6kKczhHddxKCzXfUQJxfaklGRCJiH1s1O1/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238249; c=relaxed/simple;
	bh=6kmSni5xYFEN17AAU6rw2Btl+a0XVi5JfocRLgrn0lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEsWRok4sHIzV4U9/fUF9z+J2kqzTT7w5lcK1Pe1MxnTo9QBPLnrXZd1TjYDPqg6YKkwEx1afWX6dl6we/FE34x2sG2PtajTjeBSseLLZVQSwjbdAl496Qo2bHxHMXUrBAFy5a+VYmzZEjjjomOqgxTuq1koluFM6TmB5S1+oCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pO1fmL8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pO1fmL8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD05C4CECF;
	Tue,  3 Dec 2024 15:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238249;
	bh=6kmSni5xYFEN17AAU6rw2Btl+a0XVi5JfocRLgrn0lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pO1fmL8owmeEolyVpQlN6OQTx3ZQJ5JQ1XkNtDP8KW1p9D3W7k4o07oBc1EFjW2ni
	 AIewe+eiH3lZX1p//jbMvvOUppbR79Q/7CBwCgMVDtp0f6npoe4t+2CSE5DQCAw9x6
	 KjUkv8npnGpx8oHXw74koD1d7MG8bHKoyuvsOXNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufan <chenyufan@vivo.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 214/817] drm/imagination: Convert to use time_before macro
Date: Tue,  3 Dec 2024 15:36:26 +0100
Message-ID: <20241203144004.103947404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yufan <chenyufan@vivo.com>

[ Upstream commit 7a5115ba1d691bd14db91d2fcc3ce0b056574ce9 ]

Use time_*() macros instead of using jiffies directly to handle overflow
issues.

Fixes: cc1aeedb98ad ("drm/imagination: Implement firmware infrastructure and META FW support")
Signed-off-by: Chen Yufan <chenyufan@vivo.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240823093925.9599-1-chenyufan@vivo.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_ccb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imagination/pvr_ccb.c b/drivers/gpu/drm/imagination/pvr_ccb.c
index 4deeac7ed40a4..2bbdc05a3b977 100644
--- a/drivers/gpu/drm/imagination/pvr_ccb.c
+++ b/drivers/gpu/drm/imagination/pvr_ccb.c
@@ -321,7 +321,7 @@ static int pvr_kccb_reserve_slot_sync(struct pvr_device *pvr_dev)
 	bool reserved = false;
 	u32 retries = 0;
 
-	while ((jiffies - start_timestamp) < (u32)RESERVE_SLOT_TIMEOUT ||
+	while (time_before(jiffies, start_timestamp + RESERVE_SLOT_TIMEOUT) ||
 	       retries < RESERVE_SLOT_MIN_RETRIES) {
 		reserved = pvr_kccb_try_reserve_slot(pvr_dev);
 		if (reserved)
-- 
2.43.0



