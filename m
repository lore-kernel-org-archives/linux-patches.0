Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2130733EC;
	Tue,  6 Jan 2026 17:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720696; cv=none; b=qkLgHupGKGsdI9G4x7UXxYoDGnOVr0bZGzecrC/uxILGe7xM2ye/qX++hbE7+OlUJaILHFpJqiUZCHZ4kRe/1CEx0Cc6Azl6SodhxH5+uDsu43EAjECgeRVuRovfzYjQOXEetP0Bwv5Jgwl06VHe5kmRQQhNdXJyDyjgcBUhp28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720696; c=relaxed/simple;
	bh=wzdgaHNZUYT996mbrW0HEUlI832hVgGva3uuXwK4qBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTbM0Y+8m3GIHbrz/WFlpPjoccLJ7VWA6fC6J5YkjQ1MJIUXnbyedY7hEtsCWN+0wF/NlntYJmRr8x2eTSB/qlW4r8hAzJGHwSNvM/UzzvpqprVS7XAnrMVYxLgn5LEHlJ6rRerVGAhGle4jHUiS3HLVHkhI/c84J4ADJVxX59I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMUW859m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMUW859m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1A2C116C6;
	Tue,  6 Jan 2026 17:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720696;
	bh=wzdgaHNZUYT996mbrW0HEUlI832hVgGva3uuXwK4qBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wMUW859mOcR9QKpjZuR80GBuNgNX6VRreQT75TY1ipgqayLMgZQABW06DZ+qwzehf
	 yx0A47sKUohl6Yk2GDlqQEH1IZe9sBJQDOHmpI6FV1EQ4xBzGleSj8BaubpgyCSaVk
	 0t+sIQZSQdcQOAwMVTpCG6PgXz8TcZ/dawuyS590=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Johan Hovold <johan@kernel.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.12 281/567] soc: amlogic: canvas: fix device leak on lookup
Date: Tue,  6 Jan 2026 18:01:03 +0100
Message-ID: <20260106170501.725993078@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 32200f4828de9d7e6db379909898e718747f4e18 upstream.

Make sure to drop the reference taken to the canvas platform device when
looking up its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Also note that commit 28f851e6afa8 ("soc: amlogic: canvas: add missing
put_device() call in meson_canvas_get()") fixed the leak in a lookup
error path, but the reference is still leaking on success.

Fixes: d4983983d987 ("soc: amlogic: add meson-canvas driver")
Cc: stable@vger.kernel.org	# 4.20: 28f851e6afa8
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patch.msgid.link/20250926142454.5929-2-johan@kernel.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/amlogic/meson-canvas.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/soc/amlogic/meson-canvas.c
+++ b/drivers/soc/amlogic/meson-canvas.c
@@ -73,10 +73,9 @@ struct meson_canvas *meson_canvas_get(st
 	 * current state, this driver probe cannot return -EPROBE_DEFER
 	 */
 	canvas = dev_get_drvdata(&canvas_pdev->dev);
-	if (!canvas) {
-		put_device(&canvas_pdev->dev);
+	put_device(&canvas_pdev->dev);
+	if (!canvas)
 		return ERR_PTR(-EINVAL);
-	}
 
 	return canvas;
 }


