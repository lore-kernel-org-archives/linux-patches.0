Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB424E36F1;
	Wed, 30 Sep 2026 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791032; cv=none; b=lNSBdP2YhhPSXQAskEfLVmruHu1LaNYjPTjRBsUmB0mY2AT66xojY56UFgM3w8ENyywNLYEk0D+1wvJRAEq3ZgBpijs3E51gDXCo3Qa0iahFT7KN3CGd4PS+rFPkFQEf/krdTsmDYSIUfyzrR2xWkdnO4agH8jTen9rWDlr2qpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791032; c=relaxed/simple;
	bh=jfGZjhsf3Tlvgh9401itWE8H5Wno8Ist2g8QXv5+4cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCNYaRdhu3K2fh5yGCuITtM2zYCMTu/rQ73tBXPcd/G9qMOocDF/SoP9hXGehT9pHwv9etMK79ROL1iOwrwkXmXmkOYOh+7LAGPv8cbieffbuzwpKBEE6SVEwBLrpKgP1pJZgvfP26X3h0iqISccYb1iHFmeBWUikn4dGaSK7CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hXr3Fgi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hXr3Fgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8491F000FF;
	Wed, 30 Sep 2026 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791031;
	bh=etE6yHQLNalEzGFPVv4jTBoAPKxPHop3hUAG83rurK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hXr3FgiRg+gTiugRIcuROZ/MPDszyVZbfdD4iNC/iZY6D1Z4U2c/t0+g4BBkxlaK
	 NXx6NHGNqAEY87nzRB/ibHickcHXMY/os4/DIFG+7aw/a/NVtZE4UiDrgReWxH6xZF
	 21dAwtJtcc1jvFXJMRcjnAG6SUFC64P5k2KomHog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 159/752] leds: uleds: Return -EFAULT on copy_to_user() failure
Date: Wed, 30 Sep 2026 17:20:29 +0200
Message-ID: <20260930152401.632973850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 61ed78f55a46e12afd4b464c4ba736f55ff33c5e ]

uleds_read() copies the current brightness value to userspace but
ignores copy_to_user() failures. It then clears the pending update and
reports a successful full read even when no data was copied.

Return -EFAULT when the copy fails and leave the update pending so a
later read can retry.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Link: https://patch.msgid.link/20260521181205.15130-1-alhouseenyousef@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/uleds.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/uleds.c b/drivers/leds/uleds.c
index 90e54370fe7ea..3e47cb74f49ab 100644
--- a/drivers/leds/uleds.c
+++ b/drivers/leds/uleds.c
@@ -148,10 +148,13 @@ static ssize_t uleds_read(struct file *file, char __user *buffer, size_t count,
 		} else if (!udev->new_data && (file->f_flags & O_NONBLOCK)) {
 			retval = -EAGAIN;
 		} else if (udev->new_data) {
-			retval = copy_to_user(buffer, &udev->brightness,
-					      sizeof(udev->brightness));
-			udev->new_data = false;
-			retval = sizeof(udev->brightness);
+			if (copy_to_user(buffer, &udev->brightness,
+					 sizeof(udev->brightness))) {
+				retval = -EFAULT;
+			} else {
+				udev->new_data = false;
+				retval = sizeof(udev->brightness);
+			}
 		}
 
 		mutex_unlock(&udev->mutex);
-- 
2.53.0



