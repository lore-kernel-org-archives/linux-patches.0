Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BBB3976BA;
	Sat, 17 Oct 2026 16:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255679; cv=none; b=nFUytaMOWTaMq5znvig7+P8oWLw1WGA4fsYWgM/E91JihUOCIrI9pz8OpZAxFDm2pp71lRqs3APa/xxFFkeaMM+3NcLdNM3cC+9qSrc4VMLGXuNZCIZZXh+IVIgD9fw3qSaWFYW7BgNATlQvTR4kWm4+TTpFJDXIL9w20nR0PDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255679; c=relaxed/simple;
	bh=YzAv3prsHpz9K5AymJEJcaA/m7PUxKGaMmukrK6wrhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiXHI8tHY3YPMLE2jHCt0wAl7whitMZRVOkmIJ+5Czjbvt7vSbRz+4UwxZ0BkvtkJwuIDafghkVfI2mMaez18EmTWdJAr6QGbC0WoqNOK6HgazPtjlhcp0FJnQgaw+Y1wC2bG5hkZqY9MTRnkBan1Ya50Mo/IIF+14eFPRxy1XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5REyJr5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5REyJr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BD31F000C4;
	Sat, 17 Oct 2026 16:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255677;
	bh=COI/llH+Cmj28+0TZggU9NW3KZH/L9uY00lcLVsQz1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C5REyJr5G6G8hWpNFZX2C8t4TwtbEXzqQpI167HcUrecjYXYZGagSAaBRbuGBz5LW
	 79NjX1gzP48uLJAWVW3K2Y884Ft+J5K1DCzJCLAjL6IyUw5A9XlXKApsUqhYS2oKrD
	 rVj7+sw6EalT8pT5nJMqprev52rSV0YfHO+XinX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 856/869] gpiolib: Allow to use setters with return value for output-only gpios
Date: Sat, 17 Oct 2026 18:01:37 +0200
Message-ID: <20261017160058.807469126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>

[ Upstream commit b424bb88afb6719b30340f059bf50953424cdd9d ]

The gpiod_direction_output_raw_commit() function checks if any setter
callback is present before doing anything. As the new GPIO setters with
return values were introduced, make this check also succeed if one is
present.

Fixes: 98ce1eb1fd87 ("gpiolib: introduce gpio_chip setters that return values")
Signed-off-by: Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
Link: https://lore.kernel.org/r/20250411-mdb-gpiolib-setters-fix-v2-1-9611280d8822@bootlin.com
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 5f73f0c29cf6a..1e012d5a575e5 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2761,7 +2761,7 @@ static int gpiod_direction_output_raw_commit(struct gpio_desc *desc, int value)
 	 * output-only, but if there is then not even a .set() operation it
 	 * is pretty tricky to drive the output line.
 	 */
-	if (!guard.gc->set && !guard.gc->direction_output) {
+	if (!guard.gc->set && !guard.gc->set_rv && !guard.gc->direction_output) {
 		gpiod_warn(desc,
 			   "%s: missing set() and direction_output() operations\n",
 			   __func__);
-- 
2.53.0



