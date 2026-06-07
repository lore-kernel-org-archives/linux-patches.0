Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005F14071CE;
	Sun,  7 Jun 2026 10:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827728; cv=none; b=PQfwF5k/lVAVPEIgxwKRiZ3K/jGUDPRpT5qHWr/BghBShawvZkQwdcukw00iXb0aTrJdLs0cEr9dOejUyEAX2VppQLe3KA7tgzli3M/fENO+/28DJq+0IGbqe9SfyW/NUG/gkKPRZFHk0Vrenawchb7R9scwxPn61FnGQ5XF/tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827728; c=relaxed/simple;
	bh=he2VtMMgWDa6gMhv5Sz94+wuHOwKYx5mdDrzgWxDYgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oovysYtjyVdWX8ficle4Jw7e11dgLaX9YHUEtgmlbwGdU34wz1Vgo9JTTMEpdEdpCwhWmqmDiaM8FBzS9s6VYZbssBGlOkMLgr70rGVVOXy15eolTmga6zV0Wmp7hle4OU4Vigojn3lV+A1Ft8mY05OepB40cyyt4+bqEal3pMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Grgx2Aqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Grgx2Aqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBFF1F00893;
	Sun,  7 Jun 2026 10:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827727;
	bh=qWNEnJUsQbQmgFVbr54+bOPd26MsDY+P3neezdvQaiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Grgx2AqzzY/UkiPC/oGs3FGIEMD+lu/eHZx+9B/ajDPN/O882hoBofmBeFrJktRRT
	 GktZy0ouybDRNDKLyznHjhgEXR8Ssm8ZPSQc3LaLtVH7vo7qCHFpc8Eef9gNvlinDo
	 HxlU+NRssbR5cPlArE6kjOetxun9o7Qb3c0FFoqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 102/332] gpio: virtuser: Fix uninitialized data bug in gpio_virtuser_direction_do_write()
Date: Sun,  7 Jun 2026 11:57:51 +0200
Message-ID: <20260607095731.880491623@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 8a122b5e72cc0043705f0d524bcd15f0c0b3ec15 ]

If *ppos is non-zero (user-space write split over multiple calls to
write()) then simple_write_to_buffer() won't initialize the start of the
buffer. Really, non-zero values for *ppos aren't going to work at all.
Check for that and return -EINVAL at the start of the function.

Fixes: 91581c4b3f29 ("gpio: virtuser: new virtual testing driver for the GPIO API")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/ahP3BJWWy-m_qI0X@stanley.mountain
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-virtuser.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-virtuser.c b/drivers/gpio/gpio-virtuser.c
index 955b5efc283ef5..c6f16cb02bf6b8 100644
--- a/drivers/gpio/gpio-virtuser.c
+++ b/drivers/gpio/gpio-virtuser.c
@@ -399,7 +399,7 @@ static ssize_t gpio_virtuser_direction_do_write(struct file *file,
 	char buf[32], *trimmed;
 	int ret, dir, val = 0;
 
-	if (count >= sizeof(buf))
+	if (*ppos != 0 || count >= sizeof(buf))
 		return -EINVAL;
 
 	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
@@ -624,7 +624,7 @@ static ssize_t gpio_virtuser_consumer_write(struct file *file,
 	char buf[GPIO_VIRTUSER_NAME_BUF_LEN + 2];
 	int ret;
 
-	if (count >= sizeof(buf))
+	if (*ppos != 0 || count >= sizeof(buf))
 		return -EINVAL;
 
 	ret = simple_write_to_buffer(buf, GPIO_VIRTUSER_NAME_BUF_LEN, ppos,
-- 
2.53.0



