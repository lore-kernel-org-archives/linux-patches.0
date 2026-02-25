Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA6A26561A;
	Wed, 25 Feb 2026 01:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983636; cv=none; b=NompVm3SFE8HydSFqWF1PwbiJKSgAodjzoin/Jk2mAeWcQKu3lRDyqT8XMEG1WX0TrhA4N9cT7ohrytdzxogLLzZWayzZxP64R0TwBDsnvqTo7LgR5cTCPgdbFwZl/VM/azHdS0PqmLRjUwQ/r9J08Q4YsPmaqB37cq6m6TFPhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983636; c=relaxed/simple;
	bh=FJuxeQCfd+7vFdDV6P2iDyHrSp881HHMjsdG4bUhcrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbKdM5d40ZME2EZzkAWx6pp7cochmgdW/FJlcgcusMC5fu+AuD0Og7XW42PtLsxQVcoAciyTVQD9kiEhJoJuAkRgUbtoGG41vrdWiyBuxl0O1kIpgJvu1HFfwFCgeDynIIHqB7jzN3vbF9yGQUx3F4y8vP2pW4JFs8PKILkgC88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nD7un8ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nD7un8ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDF9C116D0;
	Wed, 25 Feb 2026 01:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983636;
	bh=FJuxeQCfd+7vFdDV6P2iDyHrSp881HHMjsdG4bUhcrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nD7un8obfwsrPL2QM5iuLTZnMdF8xiAqqh3B2+pqDCKWuln5fv0xUBW0SXiczI5En
	 xwbk/+Z0G/FVn4TpgjZ0QbK6xr0j89NM1S+sjb1Grf8u2f5MZCjc+mBHXGrW8PcFjl
	 Bxx4T5c9MEm6idS1m4DdoRRYGJJ033gdU/EL6YHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 725/781] gpio: cdev: Avoid NULL dereference in linehandle_create()
Date: Tue, 24 Feb 2026 17:23:54 -0800
Message-ID: <20260225012417.517467655@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 6af6be278e3ba2ffb6af5b796c89dfb3f5d9063e ]

In linehandle_create(), there is a statement like this:
  retain_and_null_ptr(lh);

Soon after, there is a debug printout that dereferences "lh", which
will crash things.

Avoid the crash by using handlereq.lines, which is the same value.

Fixes: da7e394bf58f ("gpio: convert linehandle_create() to FD_PREPARE()")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260215120555.v2.1.I77c3eb563271c21870379eefd16ebbc4e09635bb@changeid
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-cdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 2adc3c0709082..189127721e383 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -388,7 +388,7 @@ static int linehandle_create(struct gpio_device *gdev, void __user *ip)
 	fd_publish(fdf);
 
 	dev_dbg(&gdev->dev, "registered chardev handle for %d lines\n",
-		lh->num_descs);
+		handlereq.lines);
 
 	return 0;
 }
-- 
2.51.0



