Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5E4367B70;
	Thu, 20 Aug 2026 15:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238503; cv=none; b=Ez4sS4oKB7VthpIkaLblrZnyWS+yolgsI8x0MUW4MqdepuyF7j2HIOA7oVzc5sQkjVFNQdGNd/7AmrLBuBYZAB3GD9ZTMRSBw+cL6iVw4/9IkdljJCRBh1mZlhAKbd3R9yP6ac6MkkG98NKjkEdxf4gWIDNahTPfadINfRPBXvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238503; c=relaxed/simple;
	bh=1sBc8MVrheHvICRmUOkBr4192HLWjbv7fAJh+uMbGNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqR5oIkGpJZaNiTX4HiCIRqJtpsqA0Wt3xAh2YKovYrADYFXPc8/+m4Il6RU92W//r3DxGS+W73XxfZNbJXmSaVLa7U9To366VamwnNFK6hDgvoe/fxXtyTI2cRwRlDtA90ehU02UqHHVvPHs3f1yWWKUef0a/henSnv4Wuna/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHsa64KO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHsa64KO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D101F00A3A;
	Thu, 20 Aug 2026 15:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238502;
	bh=F1tuLUTvQ/3Hz7hpSFgFPeuQ5Og/+si3xcnsgexLIEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHsa64KO6DRMXcs7/HXG6OmWL8RpkBhUobQZKM7SN6hP/bxZji2Hw1boOADGKjHxI
	 2cWwKhp2WKrhMTuDJyL6ETDk36RHJthx5lH8gIwSYP4Qwcj53+kC9g5dDnXVXsnj9W
	 J/HoTfrQO8WN1kZ+QFBSMZSLkhxLqtMZE9NDd5U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 170/228] gpiolib: Check gc->get_direction() before calling gpiod_get_direction()
Date: Thu, 20 Aug 2026 16:55:12 +0200
Message-ID: <20260820145249.855511359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

[ Upstream commit d761c7e38a000603a9d16270a1af770a0e8efb5e ]

According to 'struct gpio_chip' documentation in linux/gpio/driver.h,
implementing .get_direction() is recommended but not mandatory.
Most places verify that gc->get_direction() exists before calling
gpiod_get_direction(), but gpiolib_dbg_show() doesn't.

Until commit 471e998c0e31 ("gpiolib: remove redundant callback check")
it was also verified by gpiod_get_direction() itself so calling it at
all time from gpiolib_dbg_show() was not an issue. But after the check
in gpiod_get_direction() has been removed, calling it inconditionaly
leads to a big fat warning in gpiochip_get_direction().

In gpiod_get_direction(), verify that gc->get_direction() exists
before calling gpiod_get_direction().

Fixes: 471e998c0e31 ("gpiolib: remove redundant callback check")
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Link: https://patch.msgid.link/ad89f92f91d004e63dd5599bb58e9581f373a601.1785318183.git.chleroy@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f5be133c5c3fa..c865f2b3a9948 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -5408,7 +5408,8 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *gc)
 		flags = READ_ONCE(desc->flags);
 		is_irq = test_bit(GPIOD_FLAG_USED_AS_IRQ, &flags);
 		if (is_irq || test_bit(GPIOD_FLAG_REQUESTED, &flags)) {
-			gpiod_get_direction(desc);
+			if (gc->get_direction)
+				gpiod_get_direction(desc);
 			is_out = test_bit(GPIOD_FLAG_IS_OUT, &flags);
 			value = gpio_chip_get_value(gc, desc);
 			active_low = test_bit(GPIOD_FLAG_ACTIVE_LOW, &flags);
-- 
2.53.0



