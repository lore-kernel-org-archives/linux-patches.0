Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB80402444;
	Tue, 21 Jul 2026 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654228; cv=none; b=RKzovKxgO7FCc/h0PdfUCZOZc8thfsHJ2JXh8peyEk6bUaz1OFAEoBxr1gh9V6FUQIYCWsI9BgdNSdGbJLK6Be7bvczS/RmxMKYW7wuYajO+hJl+AQBrbYkltwdA08w5aCptwE5qqX0wFNrpIIrYDq9JwXHNDOGPlVBlfI6QzPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654228; c=relaxed/simple;
	bh=6ppqjV1BrbVt+/57AvpFOMEIXHnDm2YhcGs9eY4V5fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpIw6fdNiYGmfzaHpU+Qtfb37fAFcXPIl+WsEKiVyq/x/ZtjLGFPJosBLtJE66M6J+POEUP+MBlOOhkBTp+ESckorjUgIqeKeuhv2q5IVGXv7gfWDRgjlto3WCK1qk3//C0oInOrSAWff+ETxLKfp3cDaTp4aOhyoxfdA3lOgqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZz13TuX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZz13TuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34D61F000E9;
	Tue, 21 Jul 2026 17:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654227;
	bh=/hm72ovExVORQYufqzCTbp+OeZqe7L1WB5Ndygethek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZz13TuXFCn2WT9sbYWezytQoc0dM1qwGDP1QnspLQsSracyCMNlwDQO638joYZRT
	 ZGTBX3A24ffII1RO/E6Qf4VRy/VFsczZbfBvALtCqJlhxZCD8DTmBI7V23ZlNKY65p
	 GQAmwsPio9OzxTpKAhHfUJ6gF8u9L76jT7/ORzYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 7.1 1626/2077] leds: uleds: Fix potential buffer overread
Date: Tue, 21 Jul 2026 17:21:39 +0200
Message-ID: <20260721152631.109305112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Armin Wolf <W_Armin@gmx.de>

commit c19fe864f667afc49d1391d764e20b66555bcf7a upstream.

The name string supplied by userspace is not guaranteed to be
null-terminated, so using strchr() on it might result in a buffer
overread. The same thing will happen when said string is used by
the LED class device.

Fix this by using strnchr() instead and explicitly check that
the name string is properly null-terminated.

Cc: stable@vger.kernel.org
Fixes: e381322b0190 ("leds: Introduce userspace LED class driver")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260524235553.189134-1-W_Armin@gmx.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/uleds.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/leds/uleds.c
+++ b/drivers/leds/uleds.c
@@ -102,7 +102,8 @@ static ssize_t uleds_write(struct file *
 
 	name = udev->user_dev.name;
 	if (!name[0] || !strcmp(name, ".") || !strcmp(name, "..") ||
-	    strchr(name, '/')) {
+	    strnchr(name, sizeof(udev->user_dev.name), '/') ||
+	    !strnchr(name, sizeof(udev->user_dev.name), '\0')) {
 		ret = -EINVAL;
 		goto out;
 	}


