Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6133C50EC0F;
	Wed, 30 Sep 2026 16:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784603; cv=none; b=FTFeh65Mzw1VxMvXGyQtvVbaureSV1fRubdqY9KJK6wT5Yge0Emgy2iPwg8HHrGiD2GETqkW5nGL18orc7BzpeTGy6DZzZhKVhTBz6571/hGVAfxtQQrz8mcPtiJPGCofjIQxaNsOepNEY+brH5Wn0jYCUI4a/yBtA4CL64fxJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784603; c=relaxed/simple;
	bh=rCrVWCL7C6BpSc+DT1qUl5pngCdbau7J68iKA5MKd9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5REJwze8iaLsvhTfiklt8s6xwNSgoCIpofyYJpDrfVREkH7vEBEuKU47vEJE9+Eoc31hFb221aFWNPL1ei2i3qwmIV6zL1np7hhQZlV6XVmAN0S42D4RtbPHuE/2050y5TWu6LZTr4kF9iwF4tSPXX1o2DyncSPATX/6TF0qSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFKx4RXn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFKx4RXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90111F000FF;
	Wed, 30 Sep 2026 16:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784598;
	bh=vCjcXQpGpwjW3tttdKWbiNUIrbwatIcETvPb443+aQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFKx4RXnx2OZWNrfkRiZm4yEsPC31VDuT6jW528mELZlTHthUUn4ikLEh/duRv3th
	 rQP6Sx7Y6N8GU/vmKnCDPkc1x6eyW4WU9bZoG9+f0xUiAmDNcO3JlYPU3W1hZf0kyC
	 /RA0USf3NS1Y+7w1Wy5JDlJsA/4PIswO4mGuPTV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/982] leds: uleds: Return -EFAULT on copy_to_user() failure
Date: Wed, 30 Sep 2026 17:15:41 +0200
Message-ID: <20260930152421.214523156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



