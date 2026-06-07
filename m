Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481E84071DA;
	Sun,  7 Jun 2026 10:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827585; cv=none; b=E3dwfUR2tRFGGKvfCvDcQCt2UznMDahj65riwYpbxC76b2lSLGoQKtPzRt655bs9IxEcI2D+j8tO4AwQBKlqiOD/abqET5Dl7ov/9EsBXooFgESwHDBxKz3xDUieh8npEwm1jgQcytmnl3aJWp/lqZa+WnVwpzEKhVmjbGCMpOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827585; c=relaxed/simple;
	bh=xhqZtVV+KL0UDPz0LeqnBVbQgd9FhvYb3ERRyzayNio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdYvYFryZFzbZEfkR/6Ia7X301qSh/rPoqD3TGXdd4dARSlEUnA6XJva9r1f4Kd/krWTxAFqOoFpiZdJL29huKhyLFA7Q8qiJ4oIbrQ+KxLzsQRhUumxI1pjE72M0KlRC9gfFxYIHeejpH54LLDpyZnk3+N3qAx1lLKXj5djVmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyC6X3YI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyC6X3YI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654FE1F00893;
	Sun,  7 Jun 2026 10:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827584;
	bh=yFTN0JRk5cG3ePiCXpAP9gXCI5jPZ0e7R4hx/pducVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EyC6X3YIj/IrkVO/OrjUCsVIMBfGoREErbRqs4/vemOimOZq8xKNIgO92zEuzxOzh
	 iQ64udc/XBeKyeicn2e/7kDBpU4uEaVG1KrbzJ9IWn1PH/U2LXG/gHzWWdikdzbGPJ
	 E388iYeU3oB7iLXWHzbSb/CkrNsezSWUugxQ6Rl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/315] gpio: virtuser: Fix uninitialized data bug in gpio_virtuser_direction_do_write()
Date: Sun,  7 Jun 2026 11:57:52 +0200
Message-ID: <20260607095730.744582241@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
index 252fec5ea38354..1901b4ba558f0c 100644
--- a/drivers/gpio/gpio-virtuser.c
+++ b/drivers/gpio/gpio-virtuser.c
@@ -399,7 +399,7 @@ static ssize_t gpio_virtuser_direction_do_write(struct file *file,
 	char buf[32], *trimmed;
 	int ret, dir, val = 0;
 
-	if (count >= sizeof(buf))
+	if (*ppos != 0 || count >= sizeof(buf))
 		return -EINVAL;
 
 	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
@@ -626,7 +626,7 @@ static ssize_t gpio_virtuser_consumer_write(struct file *file,
 	char buf[GPIO_VIRTUSER_NAME_BUF_LEN + 2];
 	int ret;
 
-	if (count >= sizeof(buf))
+	if (*ppos != 0 || count >= sizeof(buf))
 		return -EINVAL;
 
 	ret = simple_write_to_buffer(buf, GPIO_VIRTUSER_NAME_BUF_LEN, ppos,
-- 
2.53.0



