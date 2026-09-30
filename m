Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435B63B05A4;
	Wed, 30 Sep 2026 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794638; cv=none; b=HZ7NVh/W3MGD2kBwRLEXjZsxQd7YjUZcB60k2rz2YMg/XZ1JfXM7Yq7gj5TGLt328CuIi7i5abmsM7fbAe/aILvNov2VeO/pCNCiVbtINw1aEt9bAxlF0KNrfvGhg3F+DGXH3IDL6tNNe69iML26ecAQK15zGzmvJ+GKNX0qU8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794638; c=relaxed/simple;
	bh=sG/tgHSyx+L8DUEXu6SpJ1jw88v4iSk6Op0yOO/yuFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJJAcDpOqQWUUW+IoiMBAP9OAvgSqa85p5WfHquHbC//ticVuUZ+ER9dx5tOg8Nq4fIJRnLp3/4g0cJNzQPMJBGo/dBH10sTJigfTUc4T+AY2Plc6J6tDuOm9fjhsXk1uf84x2wrF0ywRe4npA9zN5gMH6orXRoprPTr+VOFO40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXPzzRv7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXPzzRv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF961F000FF;
	Wed, 30 Sep 2026 18:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794637;
	bh=VDoUIMTOIb9nTkOv8qqLaX01ERdFdn/oJpkoeNu2R8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXPzzRv7RQptrKRRlAqELRM4I3uNm48lMVhDIajS1Oy0RnRBRgTJZHzaLkyMfKaKX
	 ifoI1swGHm8qr0W8VOoF7HAr2U6sg0vBgN5BkhxtPuTmw+TuhupTg1nPUd7mNfuWgB
	 buUG4Xbo/F+7nE/0iybi6KKClItBTOT8DBgijNv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0236/1193] leds: uleds: Return -EFAULT on copy_to_user() failure
Date: Wed, 30 Sep 2026 17:15:20 +0200
Message-ID: <20260930152439.435733902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d69e1febc79fa..d0b7d8c1fcf55 100644
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



