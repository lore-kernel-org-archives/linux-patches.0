Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E3F17D8BB;
	Tue, 30 Jul 2024 16:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358789; cv=none; b=N+bAvRlSnKoRC10KBG3JiErlzp1QZ0pglsFQZetBSBIZV/fVubEFe/wtKu+rLdrfn3hwOYfoqXR/l0WNdhXoAJ0Lh05hNIPJAyMDxcZihnJCb2iXmXyHWjw0Me0gel+IcwzCekfyE4sEFz+KI6pq0thm9YADq4gaucGLxXLJ/pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358789; c=relaxed/simple;
	bh=Z4mONt4DyZCf83QxqKIU9hYeUgn5zZs18lmPTMKNZZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYyCtno7ZC5CKyZfXionaURDRbt9EZUzSF8kF6P/8Svh1uDvJfuf0ZmMcFvb6PiR/YcZw+pfBk9VS9n0OZkINI3+8zCXZ5t3BpfFVhx3bIio4iwlm1KCGeQ2U+GGJrTDvNz3njKzp1L+QvXOdRSgg4jTCuVx0t37LLVVFLBSr3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AILUkYwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AILUkYwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0C0C32782;
	Tue, 30 Jul 2024 16:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358789;
	bh=Z4mONt4DyZCf83QxqKIU9hYeUgn5zZs18lmPTMKNZZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AILUkYwjGG9IhEwAutHSSBG7JwIUiypvXa8/leeLIa3ceuSZqFTSZ5sxqL6CoHjE9
	 q7oYfjFkPZZ2kY7xAUK4kcfxq75e0/xKy5+kaWwAI5KOunwpT7etDntJXlSrOe0gVA
	 rk0mQaDexGvLgr9d9jGlSNiHNKqqG8DBQekd66ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 422/440] auxdisplay: ht16k33: Drop reference after LED registration
Date: Tue, 30 Jul 2024 17:50:55 +0200
Message-ID: <20240730151632.267149633@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 2ccfe94bc3ac980d2d1df9f7a0b2c6d2137abe55 ]

The reference count is bumped by device_get_named_child_node()
and never dropped. Since LED APIs do not require it to be
bumped by the user, drop the reference after LED registration.

[andy: rewritten the commit message and amended the change]

Fixes: c223d9c636ed ("auxdisplay: ht16k33: Add LED support")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/ht16k33.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/auxdisplay/ht16k33.c b/drivers/auxdisplay/ht16k33.c
index 02425991c1590..57b4efff344e3 100644
--- a/drivers/auxdisplay/ht16k33.c
+++ b/drivers/auxdisplay/ht16k33.c
@@ -507,6 +507,7 @@ static int ht16k33_led_probe(struct device *dev, struct led_classdev *led,
 	led->max_brightness = MAX_BRIGHTNESS;
 
 	err = devm_led_classdev_register_ext(dev, led, &init_data);
+	fwnode_handle_put(init_data.fwnode);
 	if (err)
 		dev_err(dev, "Failed to register LED\n");
 
-- 
2.43.0



