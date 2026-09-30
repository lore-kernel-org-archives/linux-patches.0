Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A2D50C2A4;
	Wed, 30 Sep 2026 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788763; cv=none; b=T5u3rmOsrIZU8A9eikMCK0783YHkysfhZ4wa/lRIVZDO0hhwoIoxEBhbdoT9sWReqqCeKXN1jF/3acmVULlOh1C9/ae2FMpk8H6wm40XJ3mHROQGOoe6qEl2e9Pk3fG9kpQt9f2OHe9GjTG/8hZz84I2IhuKHHim/OfkwBb3DZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788763; c=relaxed/simple;
	bh=ygE4g48R62HjAXqAMB1EPQcanIrNxQLsxktglj33J2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JnRq0uycQnL0VK/PDzO7tRPJu9e5FVgYTh8xeq81xADExIicmaW30J+Hy466k9jGyQ+tqi/X9R6BkMwKA0cX0KC0beBZy0h4AqzWh6YVuzELGWsvbGZXZkTjphWHE0k3RQNkm7ly8RCqKbWSQkx52F9B/4yzRSDREyC2SvZhnlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trx68sMC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trx68sMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9BE1F000FF;
	Wed, 30 Sep 2026 17:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788761;
	bh=1D1ktqBTe5W6MbQsuUKkfAELS2H8/qy0kNJbRQgK8Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trx68sMC7+WfjEORWWqId6Nc/xKLi34eoselEcYfgQcQ/hWDp+mJI95pJsnQ8FqPe
	 cpW9UChQH+yHWy8I0ptwoZ/gJyUw0g7uS5GbmCXtNjZvNstotZ0J8YuCgR9QWoeCKN
	 kGtV4e4Bx8sOzJNSWd8soYPrclOsAJ/sbe4fz9O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 238/877] Input: evdev - zero absinfo before partial copy in EVIOCSABS
Date: Wed, 30 Sep 2026 17:19:09 +0200
Message-ID: <20260930152419.862006714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

commit 8b852965b8eaf910c314dc346967ed82c8d4f235 upstream.

The EVIOCSABS handler copies at most the user supplied ioctl size into
an uninitialized on-stack struct input_absinfo:

	if (copy_from_user(&abs, p, min_t(size_t,
			size, sizeof(struct input_absinfo))))

The size comes from _IOC_SIZE() of the ioctl command and is therefore
fully controlled by userspace. A short size leaves the trailing part of
the structure holding whatever was on the kernel stack, and the whole
structure is then stored into the device:

	dev->absinfo[t] = abs;

EVIOCGABS hands that back to userspace, disclosing the stale stack
bytes. Only the resolution field is currently cleared, which covers the
legacy struct layout but not an arbitrarily short size.

Zero the structure before the copy so any part not supplied by the
caller reads back as zero. The existing resolution fixup is kept, since
it also handles a size that partially overlaps that field.

Fixes: 448cd1664a57 ("Input: evdev - rearrange ioctl handling")
Cc: stable@vger.kernel.org
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Link: https://patch.msgid.link/20260901130629.24078-2-ivanrwcm25@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/evdev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -1229,6 +1229,8 @@ static long evdev_do_ioctl(struct file *
 
 			t = _IOC_NR(cmd) & ABS_MAX;
 
+			memset(&abs, 0, sizeof(abs));
+
 			if (copy_from_user(&abs, p, min_t(size_t,
 					size, sizeof(struct input_absinfo))))
 				return -EFAULT;


